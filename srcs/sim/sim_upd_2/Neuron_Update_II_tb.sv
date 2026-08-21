// ====================================================================
// Testbench: tb_Neuron_Update_II (Self-Checking Version)
// 功能：全面验证 Neuron_Update_II 模块：
//   1. 膜电位累加（正/负权重）与溢出处理
//   2. 阈值发放与复位
//   3. 不应期抑制
//   4. STDP 模式：钙清零、学习变量（x_pre）递增与饱和
//   5. SDSP 模式：钙变量增加、学习变量方向编码
// 特性：内置 Golden Reference Model，自动比对 DUT 输出。
// ====================================================================

`timescale 1ns / 1ps

module Neuron_Update_II_tb;

  import data_types_pkg::*;
  import consts_pkg::*;
  import logger_pkg::*;

  // Logger 实例
  logger lg;
  initial begin
    lg = new(.logger_file_name("sim_upd_2.log"));
  end

  // ---- 信号声明 ----
  logic               clk;
  logic               rst_n;
  logic               enable_learn;
  learn_const_t       LearnConst;
  learn_mode_e        learn_mode;
  neuron_const_t      NeuronConst;
  neuron_data_t       neuron_data_i;
  synapse_data_t      synapse_data_i;

  wire neuron_data_t  neuron_data_o;
  logic               spike;
  wire synapse_data_t synapse_data_o;

  // ---- DUT 实例化 ----
  Neuron_Update_II dut (
      .enable_learn  (enable_learn),
      .learn_const   (LearnConst),
      .learn_mode    (learn_mode),
      .neuron_const  (NeuronConst),
      .neuron_data_i (neuron_data_i),
      .synapse_data_i(synapse_data_i),
      .neuron_data_o (neuron_data_o),
      .spike         (spike),
      .synapse_data_o(synapse_data_o)
  );

  // ---- 时钟生成 ----
  always #10 clk = ~clk;  // 50 MHz

  // ---- 测试统计 ----
  int test_count = 0;
  int pass_count = 0;
  int error_count = 0;

  // ====================================================================
  // Golden Reference Model
  // 根据论文与 RTL 代码，纯行为级描述期望输出
  // ====================================================================
  function automatic void golden_neuron_update_ii(
      input logic enable_learn, input learn_mode_e learn_mode, input learn_const_t learn_const,
      input neuron_const_t neuron_const, input neuron_data_t neuron_data_i,
      input synapse_data_t synapse_data_i, output neuron_data_t exp_neuron, output logic exp_spike,
      output synapse_data_t exp_synapse);
    // 默认值：无变化
    exp_neuron  = neuron_data_i;
    exp_spike   = 1'b0;
    exp_synapse = synapse_data_i;

    // ---- 膜电位更新（仅在不应期外） ----
    if (neuron_data_i.t_ref == 4'b0) begin
      // 无符号 v_mem 与有符号 weight 相加，检测下溢
      logic signed [16:0] v_mem_ext = {1'b0, neuron_data_i.v_mem};  // 17-bit 正数
      logic signed [16:0] weight_ext = {{9{synapse_data_i.weight[7]}}, synapse_data_i.weight};
      logic signed [16:0] sum = v_mem_ext + weight_ext;

      if (sum < 0) begin
        exp_neuron.v_mem = '0;  // 下溢钳位到 0
      end else begin
        exp_neuron.v_mem = unsigned'(sum[15:0]);
      end

      // 阈值发放与复位
      if (exp_neuron.v_mem >= neuron_const.v_thr) begin
        exp_neuron.v_mem = consts_pkg::VRest;
        exp_neuron.t_ref = neuron_const.t_ref;
        exp_spike = 1'b1;
      end
    end

    // ---- 在线学习逻辑（与 t_ref 无关，独立执行） ----
    if (enable_learn) begin
      unique case (learn_mode)
        LEARN_MODE_STDP: begin
          // 钙变量清零
          exp_neuron.calcium = '0;
          // x_pre 递增，饱和在 15
          if (synapse_data_i.learn_var.x_pre == 4'b1111) exp_synapse.learn_var.x_pre = 4'b1111;
          else exp_synapse.learn_var.x_pre = synapse_data_i.learn_var.x_pre + 1;
        end

        LEARN_MODE_SDSP: begin
          // 发放时钙变量增加 Jc，上溢饱和
          if (exp_spike) begin
            logic [4:0] ca_sum = {1'b0, neuron_data_i.calcium} + consts_pkg::Jc;
            if (ca_sum > 15) exp_neuron.calcium = 4'b1111;
            else exp_neuron.calcium = ca_sum[3:0];
          end

          // 学习变量方向编码（基于原始 neuron_data_i，非更新后）
          // exp_synapse.learn_var.synapse_change_dir[0] = (
          //     neuron_data_i.v_mem >= learn_const.theta_m &&
          //     learn_const.ca_theta_1 <= neuron_data_i.calcium &&
          //     neuron_data_i.calcium <= learn_const.ca_theta_3
          // );
          // exp_synapse.learn_var.synapse_change_dir[1] = (
          //     neuron_data_i.v_mem < learn_const.theta_m &&
          //     learn_const.ca_theta_1 <= neuron_data_i.calcium &&
          //     neuron_data_i.calcium <= learn_const.ca_theta_2
          // );
          // exp_synapse.learn_var.synapse_change_dir[3:2] = '0;
          if (neuron_data_i.v_mem >= learn_const.theta_m &&
                        learn_const.ca_theta_1 <= neuron_data_i.calcium &&
                        neuron_data_i.calcium <= learn_const.ca_theta_3) begin
            exp_synapse.learn_var.synapse_change_dir = CHANGE_INCR;
          end else if (neuron_data_i.v_mem < learn_const.theta_m &&
                                 learn_const.ca_theta_1 <= neuron_data_i.calcium &&
                                 neuron_data_i.calcium <= learn_const.ca_theta_2) begin
            exp_synapse.learn_var.synapse_change_dir = CHANGE_DECR;
          end else begin
            exp_synapse.learn_var.synapse_change_dir = STEADY_ZERO;
          end
        end
      endcase
    end
  endfunction

  // ====================================================================
  // 自动比对任务
  // ====================================================================
  task automatic check_dut(string test_name);
    neuron_data_t  exp_neuron;
    logic          exp_spike;
    synapse_data_t exp_synapse;
    logic          pass = 1'b1;

    print_state(test_name);

    golden_neuron_update_ii(enable_learn, learn_mode, LearnConst, NeuronConst, neuron_data_i,
                            synapse_data_i, exp_neuron, exp_spike, exp_synapse);

    if (neuron_data_o !== exp_neuron) begin
      // lg.error($sformatf("%s: neuron_data_o mismatch", test_name));
      // lg.info($sformatf("  Expected: %s", neuron_data_to_string(exp_neuron)));
      // lg.info($sformatf("  Actual  : %s", neuron_data_to_string(neuron_data_o)));
      lg.error($sformatf(
               "%s: neuron_data_o mismatch (exp=%s, got=%s)",
               test_name,
               neuron_data_to_string(
                   exp_neuron
               ),
               neuron_data_to_string(
                   neuron_data_o
               )
               ));
      pass = 1'b0;
    end
    if (spike !== exp_spike) begin
      lg.error($sformatf("%s: spike mismatch (exp=%b, got=%b)", test_name, exp_spike, spike));
      pass = 1'b0;
    end
    if (synapse_data_o !== exp_synapse) begin
      // lg.error($sformatf("%s: synapse_data_o mismatch", test_name));
      // lg.info($sformatf("  Expected: %s", synapse_data_to_string(exp_synapse)));
      // lg.info($sformatf("  Actual  : %s", synapse_data_to_string(synapse_data_o)));
      lg.error($sformatf(
               "%s: synapse_data_o mismatch (exp=%s, got=%s)",
               test_name,
               synapse_data_to_string(
                   exp_synapse
               ),
               synapse_data_to_string(
                   synapse_data_o
               )
               ));
      pass = 1'b0;
    end

    if (pass) begin
      lg.info($sformatf("[PASS]  %s", test_name));
      pass_count++;
    end else begin
      error_count++;
    end
    test_count++;


    #5;
    neuron_data_i  <= neuron_data_o;
    synapse_data_i <= synapse_data_o;
    @(posedge clk) #1;
  endtask

  // ====================================================================
  // 辅助打印任务（保留，便于调试）
  // ====================================================================
  task automatic print_state(string label);
    lg.info($sformatf(
            "%s:\n\tneuron_i=%s\n\t\tsynapse_i=%s\n\tneuron_o=%s\n\t\tsynapse_o=%s\n\tspike=%b",
            label,
            neuron_data_to_string(
                neuron_data_i
            ),
            synapse_data_to_string(
                synapse_data_i
            ),
            neuron_data_to_string(
                neuron_data_o
            ),
            synapse_data_to_string(
                synapse_data_o
            ),
            spike
            ));
  endtask

  // ====================================================================
  // 激励与验证过程
  // ====================================================================
  initial begin
    // ---- 初始化 ----
    clk = 0;
    rst_n = 0;
    enable_learn = 0;
    learn_mode = LEARN_MODE_STDP;
    LearnConst = '0;
    NeuronConst = '0;
    neuron_data_i = '0;
    synapse_data_i = '0;

    // 固定参数（与原文保持一致）
    NeuronConst = '{v_thr: 16'd22768, t_ref: 4'd7};
    LearnConst = '{
        xtar: 4'd8,
        theta_m: 16'd256,
        ca_theta_1: 4'd3,
        ca_theta_2: 4'd8,
        ca_theta_3: 4'd13
    };

    // 复位释放
    #30 rst_n = 1;
    @(posedge clk) #1;

    lg.display("\n========== START SELF-CHECKING TEST ==========\n");

    // ------------------------------------------------------------
    // Test 1：不应期抑制（t_ref > 0）
    // ------------------------------------------------------------
    lg.display("--- Test 1: Refractory period suppression ---");
    neuron_data_i.v_mem = 16'h0080;
    neuron_data_i.t_ref = 4'd2;
    neuron_data_i.calcium = 4'd5;
    synapse_data_i.weight = 8'sh10;  // +16
    synapse_data_i.learn_var.x_pre = 4'd0;
    enable_learn = 0;
    @(posedge clk) #1;
    check_dut("T1_Refractory");

    // ------------------------------------------------------------
    // Test 2：正常累加（正权重）与阈值发放
    // ------------------------------------------------------------
    lg.display("\n--- Test 2: Positive weight accumulation & fire ---");
    @(posedge clk) #1;
    // 2a: 简单累加
    neuron_data_i.t_ref   = 4'd0;
    neuron_data_i.v_mem   = NeuronConst.v_thr - 50;
    synapse_data_i.weight = 8'sh10;
    @(posedge clk) #1;
    repeat (5) check_dut("T2a_Pos_Accum");

    // ------------------------------------------------------------
    // Test 3：负权重（抑制）与下溢钳位
    // ------------------------------------------------------------
    lg.display("\n--- Test 3: Negative weight (inhibition) ---");
    // 3a: 正常减到正数
    neuron_data_i.v_mem   = 16'h0011;
    neuron_data_i.t_ref   = 4'd0;
    synapse_data_i.weight = -8'sh10;  // -16
    @(posedge clk) #1;
    repeat (2) check_dut("T3a_Neg_Accum");

    // 3b: 下溢到 0
    neuron_data_i.v_mem = 16'h0001;
    @(posedge clk) #1;
    check_dut("T3b_Neg_Underflow");

    // ------------------------------------------------------------
    // Test 4：STDP 学习模式
    // ------------------------------------------------------------
    lg.display("\n--- Test 4: STDP learning mode ---");
    enable_learn = 1;
    learn_mode = LEARN_MODE_STDP;

    // 4a: calcium 清零，x_pre 递增
    neuron_data_i.v_mem = 16'h0000;
    neuron_data_i.t_ref = 4'd0;
    neuron_data_i.calcium = 4'd7;
    synapse_data_i.weight = 8'sh10;
    synapse_data_i.learn_var.x_pre = 4'd5;
    @(posedge clk) #1;
    check_dut("T4a_STDP_Basic");

    // 4b: x_pre 饱和（15 保持 15）
    synapse_data_i.learn_var.x_pre = 4'd15;
    @(posedge clk) #1;
    check_dut("T4b_STDP_Saturation");

    // ------------------------------------------------------------
    // Test 5：SDSP 学习模式
    // ------------------------------------------------------------
    lg.display("\n--- Test 5: SDSP learning mode ---");
    learn_mode                     = LEARN_MODE_SDSP;

    // 5a: 正向条件（v_mem >= theta_m，钙在 [theta1, theta3]）
    neuron_data_i.v_mem            = 16'h0100;  // 256 == theta_m
    neuron_data_i.calcium          = 4'd5;  // in [3,13]
    neuron_data_i.t_ref            = 4'd0;
    synapse_data_i.weight          = 8'sh00;
    synapse_data_i.learn_var.x_pre = 4'd0;
    @(posedge clk) #1;
    check_dut("T5a_SDSP_Pos");

    // 5b: 负向条件（v_mem < theta_m，钙在 [theta1, theta2]）
    neuron_data_i.v_mem   = 16'h00FF;  // 255 < 256
    neuron_data_i.calcium = 4'd5;  // in [3,8]
    @(posedge clk) #1;
    check_dut("T5b_SDSP_Neg");

    // 5c: 钙不在范围内 -> 双稳态（00）
    neuron_data_i.calcium = 4'd1;  // < theta1
    @(posedge clk) #1;
    check_dut("T5c_SDSP_Steady");

    // 5d: 发放脉冲时钙变量增加 2（Jc）
    neuron_data_i.calcium = 4'd0;
    synapse_data_i.weight = 8'sh02;
    neuron_data_i.v_mem   = NeuronConst.v_thr - 16'(synapse_data_i.weight);
    @(posedge clk) #1;
    check_dut("T5d_SDSP_Ca_Inc");

    // ------------------------------------------------------------
    // Test 6：学习禁用
    // ------------------------------------------------------------
    lg.display("\n--- Test 6: Learning disabled ---");
    enable_learn = 0;
    neuron_data_i.calcium = 4'd3;
    neuron_data_i.v_mem = 16'h0100;  // 会发放
    neuron_data_i.t_ref = 4'd0;
    synapse_data_i.weight = 8'sh10;
    synapse_data_i.learn_var.x_pre = 4'd5;
    @(posedge clk) #1;
    check_dut("T6_Learn_Disabled");

    // ------------------------------------------------------------
    // Test 7：不应期内学习仍生效（边界验证）
    // ------------------------------------------------------------
    lg.display("\n--- Test 7: Learning during refractory (STDP) ---");
    enable_learn                   = 1;
    learn_mode                     = LEARN_MODE_STDP;
    neuron_data_i.v_mem            = 16'h0100;
    neuron_data_i.t_ref            = 4'd3;  // 处于不应期
    neuron_data_i.calcium          = 4'd9;
    synapse_data_i.weight          = 8'sh10;
    synapse_data_i.learn_var.x_pre = 4'd2;
    @(posedge clk) #1;
    check_dut("T7_Refractory_Learn");

    // ====================================================================
    // 测试结束，输出统计
    // ====================================================================
    if (error_count == 0) begin
      set_ansi_style(SuccessStyle);
      lg.display("Simulation completed: ALL CHECKS PASSED");
    end else begin
      set_ansi_style(ErrorStyle);
      lg.display($sformatf("Simulation completed: SOME CHECKS FAILED"));
    end
    set_ansi_style('{UNDERLINE});
    lg.write($sformatf("Total errors: %0d", error_count));
    reset_style();

    $display("");
    $finish(0);

  end

endmodule
