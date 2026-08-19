// ====================================================================
// Testbench: tb_Neuron_Update_I
// 功能：验证 Neuron_Update_I 模块的膜电位泄漏、钙衰减、
//       不应期递减、竞争重置（cpt_rst）功能。
// 测试流程：
//   1. 初始化 v_mem 和 calcium 为较大值，t_ref=0；
//   2. 连续观察 10 个时间步的衰减；
//   3. 在第 5 步之后施加 cpt_rst=1 验证清零；
//   4. 重新设置 v_mem、calcium，并设置 t_ref=2，观察不应期递减。
// 注：模块为纯组合逻辑，此处用时钟采样以模拟时间步。
// ====================================================================

`timescale 1ns / 1ps

module Neuron_Update_I_tb;

  // ---------- 信号声明 ----------
  logic                         clk;
  logic                         rst_n;
  logic                         cpt_rst;
  data_types_pkg::neuron_data_t nd_i;
  data_types_pkg::neuron_data_t nd_o;
  int                           error_count = 0;

  function automatic int unsigned round_shift(input int unsigned value, input int unsigned shift);
    round_shift = (value >> shift) + value[shift-1];
  endfunction

  function automatic data_types_pkg::neuron_data_t expected_update_i(
      input data_types_pkg::neuron_data_t current, input logic current_cpt_rst);
    data_types_pkg::neuron_data_t expected;
    int unsigned v_decay;
    int unsigned c_decay;
    begin
      expected = current;

      if (current_cpt_rst == 1'b1) begin
        expected.v_mem = consts_pkg::VRest;
        expected.t_ref = 4'd0;
      end else if (current.t_ref != 4'd0) begin
        expected.t_ref = current.t_ref - 1;
      end else begin
        v_decay = round_shift(current.v_mem, 5);
        c_decay = round_shift(current.calcium, 3);
        expected.v_mem = current.v_mem - v_decay[15:0];
        expected.calcium = current.calcium - c_decay[3:0];
      end

      return expected;
    end
  endfunction

  task automatic check_neuron_data(input string phase, input data_types_pkg::neuron_data_t actual,
                                   input data_types_pkg::neuron_data_t expected);
    if ((actual.v_mem !== expected.v_mem) ||
            (actual.t_ref !== expected.t_ref) ||
            (actual.calcium !== expected.calcium)) begin
      error_count++;
      $error("\t\t\tFAIL\n  expected: %s\n  actual  : %s",
             data_types_pkg::neuron_data_to_string(expected),
             data_types_pkg::neuron_data_to_string(actual));
    end else begin
      $display("\t\t\tPASS: %s", data_types_pkg::neuron_data_to_string(actual));
    end
  endtask

  task automatic step_and_check(input string phase, input logic manual_exp = 1'b0, input data_types_pkg::neuron_data_t _expected = '0);
    data_types_pkg::neuron_data_t expected;
    begin
      #1;
      $display("[%0t] %s: nd_i=%s", $time, phase, data_types_pkg::neuron_data_to_string(nd_i));
      if (manual_exp) begin
        expected = _expected;
      end else begin
        expected = expected_update_i(nd_i, cpt_rst);
      end
      check_neuron_data(phase, nd_o, expected);
      nd_i = nd_o;
    end
  endtask

  // ---------- 实例化待测模块 ----------
  Neuron_Update_I dut (
      .cpt_rst      (cpt_rst),
      .neuron_data_i(nd_i),
      .neuron_data_o(nd_o)
  );

  // ---------- 时钟生成 ----------
  always #10 clk = ~clk;  // 50 MHz 时钟

  // ---------- 激励过程 ----------
  initial begin
    // 初始化
    clk          = 0;
    rst_n        = 0;
    cpt_rst      = 0;
    nd_i         = '0;
    nd_o         = '0;
    nd_i.v_mem   = 16'hf000;
    nd_i.calcium = 4'hF;  // 15
    nd_i.t_ref   = 4'd0;

    // 复位释放
    #20 rst_n = 1;
    #10;

    // ------------------------------------------------------------
    // 测试 1：膜电位和钙衰减（无不应期，无复位）
    // ------------------------------------------------------------
    $display("\n===== Test 1: Leakage and Calcium decay =====");
    repeat (30) begin
      step_and_check("Test 1");
    end

    // ------------------------------------------------------------
    // 测试 2：竞争重置（cpt_rst = 1）
    // ------------------------------------------------------------
    $display("\n===== Test 2: Competitive reset (cpt_rst=1) =====");
    cpt_rst = 1;
    nd_i.t_ref = 5;
    step_and_check("Test 2");

    cpt_rst = 0;

    // ------------------------------------------------------------
    // 测试 3：不应期功能（t_ref > 0）
    // ------------------------------------------------------------
    $display("\n===== Test 3: Refractory period decrement =====");
    // 重新加载初始值，但设置 t_ref = 2
    nd_i.v_mem   = 16'h3000;  // 新值
    nd_i.calcium = 4'hA;
    nd_i.t_ref   = 4'd10;
    repeat (15) begin
      step_and_check("Test 3");
    end

    // ------------------------------------------------------------
    // 测试 4：衰减到接近 0 后循环第一步（测试四舍五入稳定）
    // ------------------------------------------------------------
    $display("\n===== Test 4: Stabilization near zero =====");
    nd_i.v_mem   = 16'h0012;  // 最小值（非零）
    nd_i.calcium = 4'd1;
    nd_i.t_ref   = 4'd0;
    repeat (8) begin
      step_and_check("Test 4");
    end
    // ------------------------------------------------------------
    // 测试 5：论文一致性
    // ------------------------------------------------------------
    $display("\n===== Test 5: Consistency with paper =====");
    nd_i.v_mem   = 16'd744;
    nd_i.calcium = 4'd7; // NOTE: 论文中错标成了“输入膜电位为 7”
    nd_i.t_ref   = 4'd0;
    step_and_check("Test 5", 1'b1, '{v_mem: 16'd721, calcium: 4'd6, t_ref: 4'd0});

    // TEST 6 边界舍入
    $display("\n===== Test 6: Boundary rounding =====");
    nd_i.calcium = 4'd0;
    nd_i.t_ref   = 4'd0;
    nd_i.v_mem   = 32 + 15;
    step_and_check("Test 6a i");
    nd_i.v_mem   = 32 + 16;
    step_and_check("Test 6a ii");
    nd_i.v_mem   = 32 + 17;
    step_and_check("Test 6a iii");
    nd_i.v_mem   = 1;
    step_and_check("Test 6a i");
    nd_i.v_mem   = 31;
    step_and_check("Test 6a v");
    nd_i.v_mem   = 32;
    step_and_check("Test 6a vi");
    nd_i.v_mem   = 33;
    step_and_check("Test 6a vii");
    nd_i.v_mem   = 63;
    step_and_check("Test 6a viii");
    nd_i.v_mem   = 64;
    step_and_check("Test 6a ix");
    
    nd_i.calcium = 3;
    repeat(10) begin
      step_and_check("Test 6b i"); 
    end
    nd_i.calcium = 4;
    repeat(10) begin
      step_and_check("Test 6b ii");
    end
    nd_i.calcium = 5;
    repeat(10) begin
      step_and_check("Test 6b iii");
    end
    nd_i.calcium = 11;
    repeat(10) begin
      step_and_check("Test 6b iv");
    end
    nd_i.calcium = 12;
    repeat(10) begin
      step_and_check("Test 6b v");
    end
    nd_i.calcium = 13;
    repeat(10) begin
      step_and_check("Test 6b vi");
    end



    if (error_count == 0) begin
      $display("\n===== Simulation completed: ALL CHECKS PASSED =====");
    end else begin
      $display("\n===== Simulation completed: %0d CHECK(S) FAILED =====", error_count);
    end

    $finish(error_count);
  end


endmodule
