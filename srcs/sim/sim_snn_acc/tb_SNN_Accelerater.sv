`timescale 1ns / 1ps

module tb_SNN_Accelerater;
  import data_types_pkg::*;
  import consts_pkg::*;
  import logger_pkg::*;

  // Logger 实例
  logger lg;
  initial begin
    lg = new(.logger_file_name("sim_snn_acc.log"));
  end

  localparam int EventCount = 10000;
  localparam int DrainTimeNs = 20_000_000;
  localparam logic [15:0] NeuronThreshold = 16'd0;

  logic clk = 1'b0;
  logic clk_async = 1'b0;
  logic rst_n = 1'b0;
  aer_if aer_r ();
  aer_if aer_t ();

  always #12.5 clk = !clk;
  always #50 clk_async = !clk_async;

  logic timestep0;
  Time_Gen Time_Gen_inst (
      .clk(clk_async),
      .rst_n(rst_n),
      .interval(18'd72),
      .timestep0(timestep0)
  );

  logic s_axis_tready;
  logic s_axis_tvalid;
  logic [9:0] s_axis_tdata;
  aer_tx #(
      .ADDR_WIDTH(10),
      .CDC_DEPTH(0),
      .FILTER_DEPTH(1)
  ) aer_tx_inst (
      .clk(clk_async),
      .rst_n(rst_n),
      .aer(aer_r),
      .s_axis_tready(s_axis_tready),
      .s_axis_tvalid(s_axis_tvalid),
      .s_axis_tdata(s_axis_tdata)
  );

  logic enable_learn;
  learn_mode_e learn_mode;
  SNN_Accelerater #(
      .SrcNum(8),
      .TarNum(8),
      .NeuronConst('{v_thr: NeuronThreshold, t_ref: 4'd1}),
      .SrcSpikePerStepMaxExp(300)
  ) SNN_Accelerater_inst (
      .clk(clk),
      .rst_n(rst_n),
      .aer_r(aer_r),
      .aer_t(aer_t),
      .enable_learn(enable_learn),
      .learn_mode(learn_mode)
  );

  `define DUT_NEURON_MEMORY \
  SNN_Accelerater_inst.neuron_mem.inst.native_mem_module.blk_mem_gen_v8_4_11_inst.memory

  `define DUT_SYNAPSE_MEMORY \
  SNN_Accelerater_inst.synapse_mem.inst.native_mem_module.blk_mem_gen_v8_4_11_inst.memory


  int error_count = 0;
  int checked_read_count = 0;
  int checked_write_count = 0;
  int checked_output_count = 0;
  neuron_data_t golden_neuron[256];
  synapse_data_t golden_synapse[65536];

  function automatic integer round_real(input real x);
    if (x >= 0.0)
      return $rtoi(x + 0.5);
    else
      return $rtoi(x - 0.5);
  endfunction

  function automatic neuron_data_t expected_update_i(input neuron_data_t current,
                                                     input logic current_cpt_rst);
    neuron_data_t expected;
    int unsigned  v_decay;
    int unsigned  c_decay;
    begin
      expected = current;
      if (current_cpt_rst) begin
        expected.v_mem = VRest;
        expected.t_ref = '0;
      end else if (current.t_ref != '0) begin
        expected.t_ref = current.t_ref - 1'b1;
      end else begin
        v_decay = (current.v_mem - VRest) >> 5;
        v_decay = v_decay + ((current.v_mem - VRest) & 16'h0010 ? 1 : 0);
        c_decay = current.calcium >> 3;
        c_decay = c_decay + (current.calcium[2:0] >= 3'd4);
        expected.v_mem = current.v_mem - v_decay[15:0];
        expected.calcium = current.calcium - c_decay[3:0];
      end
      return expected;
    end
  endfunction

  function automatic void expected_update_ii(
      input neuron_data_t current_neuron, input synapse_data_t current_synapse,
      input logic current_enable_learn, input learn_mode_e current_learn_mode,
      output neuron_data_t expected_neuron, output logic expected_spike,
      output synapse_data_t expected_synapse);
    logic signed [16:0] sum;
    logic [4:0] calcium_sum;
    begin
      expected_neuron  = current_neuron;
      expected_spike   = 1'b0;
      expected_synapse = current_synapse;
      if (current_neuron.t_ref == '0) begin
        sum = $signed({1'b0, current_neuron.v_mem}) + current_synapse.weight;
        expected_neuron.v_mem = sum < 0 ? '0 : sum[15:0];
        if (expected_neuron.v_mem >= NeuronThreshold) begin
          expected_neuron.v_mem = VRest;
          expected_neuron.t_ref = 4'd1;
          expected_spike = 1'b1;
        end
      end
      if (current_enable_learn) begin
        case (current_learn_mode)
          LEARN_MODE_STDP: begin
            expected_neuron.calcium = '0;
            expected_synapse.learn_var.x_pre = current_synapse.learn_var.x_pre == 4'hf ?
                4'hf : current_synapse.learn_var.x_pre + 1'b1;
          end
          LEARN_MODE_SDSP: begin
            if (expected_spike) begin
              calcium_sum = {1'b0, current_neuron.calcium} + Jc;
              expected_neuron.calcium = calcium_sum > 5'd15 ? 4'hf : calcium_sum[3:0];
            end
            expected_synapse.learn_var.synapse_change_dir =
                (current_neuron.v_mem >= 16'd256 && current_neuron.calcium >= 4'd3 &&
                 current_neuron.calcium <= 4'd13) ? CHANGE_INCR :
                (current_neuron.v_mem < 16'd256 && current_neuron.calcium >= 4'd3 &&
                 current_neuron.calcium <= 4'd8) ? CHANGE_DECR : STEADY_ZERO;
          end
          default: begin
          end
        endcase
      end
    end
  endfunction

  function automatic synapse_data_t expected_weight_update(input synapse_data_t current,
                                                           input learn_mode_e current_learn_mode);
    synapse_data_t expected;
    logic signed [8:0] weight_sum;
    begin
      expected = current;
      case (current_learn_mode)
        LEARN_MODE_STDP: begin
          weight_sum = current.weight + current.learn_var.x_pre - 4'd8;
          expected.weight = weight_sum > 9'sd127 ? 8'sd127 :
              weight_sum < -9'sd128 ? -8'sd128 : weight_sum[7:0];
          expected.learn_var.x_pre = round_real(real'(current.learn_var.x_pre) * real'(7 / 8));
        end
        LEARN_MODE_SDSP: begin
          case (current.learn_var.synapse_change_dir)
            CHANGE_INCR:
            expected.weight = current.weight == 8'sd127 ? current.weight : current.weight + 1'b1;
            CHANGE_DECR:
            expected.weight = current.weight == -8'sd128 ? current.weight : current.weight - 1'b1;
            default: expected.weight = current.weight;
          endcase
        end
        default: begin
        end
      endcase
      return expected;
    end
  endfunction

  task automatic report_error(input string message);
    error_count++;
    lg.error($sformatf("[SNN_Accelerater] %s", message));
  endtask

  task automatic send_events(input int count);
    for (int index = 0; index < count; index++) begin
      lg.trace($sformatf("[tb_top] Sending event %0d", index));
      @(negedge clk_async);
      s_axis_tdata  = {1'b1, timestep0, byte'($urandom_range(0, 7))};
      s_axis_tvalid = 1'b1;
      wait(s_axis_tready);
      s_axis_tvalid = 1'b0;
    end
  endtask

  task automatic wait_and_drain;
  set_ansi_style(PendingStyle);
  lg.display("Waiting for FIFO to drain...");
  reset_style();
  #(DrainTimeNs);
  lg.info($sformatf("Steped for %0d ns to drain the FIFO", DrainTimeNs));
  endtask

  initial begin
    s_axis_tvalid = 1'b0;
    s_axis_tdata = '0;
    enable_learn = 1'b0;
    learn_mode = LEARN_MODE_STDP;
    #20 rst_n = 1'b1;
  end

  always #1 begin
    #1 aer_t.ack <= aer_t.req;
  end

  initial begin
    wait (rst_n);
    repeat (256) begin
      golden_neuron[checked_read_count] = `DUT_NEURON_MEMORY[checked_read_count];
      checked_read_count++;
    end
    checked_read_count = 0;
    repeat (65536) begin
      golden_synapse[checked_read_count] = `DUT_SYNAPSE_MEMORY[checked_read_count];
      checked_read_count++;
    end
    checked_read_count = 0;

    lg.display("===== SNN_Accelerater self-checking test =====");
    lg.info($sformatf("Sending %0d events without learning", EventCount));
    send_events(EventCount);
    enable_learn = 1'b1;
    learn_mode   = LEARN_MODE_STDP;
    @(posedge timestep0);
    lg.info($sformatf("Sending %0d events with STDP learning", EventCount));
    send_events(EventCount);
    wait_and_drain();
    learn_mode = LEARN_MODE_SDSP;
    @(negedge timestep0);
    lg.info($sformatf("Sending %0d events with SDSP learning", EventCount));
    send_events(EventCount);
    wait_and_drain();
    lg.info($sformatf("Checked reads=%0d writes=%0d outputs=%0d", checked_read_count,
                      checked_write_count, checked_output_count));
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

  logic step_q, enable_q, cpt_rst_q;
  work_mode_e ctrl_step_q;
  logic [7:0] neuron_addr_r_q, neuron_addr_w_q;
  logic [15:0] synapse_addr_r_q, synapse_addr_w_q;
  neuron_data_t  neuron_data_i_q;
  synapse_data_t synapse_data_i_q;
  logic neuron_w_q, synapse_w_q;
  logic [7:0] neuron_read_addr_d1, neuron_read_addr_d2;
  logic [15:0] synapse_read_addr_d1, synapse_read_addr_d2;

  always @(negedge clk) begin : scoreboard
    neuron_data_t expected_neuron;
    synapse_data_t expected_synapse;
    logic expected_spike;
    synapse_data_t expected_weight;

    if (rst_n) begin
      if (ctrl_step_q == UPDATE_I) begin
        if (neuron_addr_r_q >= 8)
          report_error($sformatf("UPDATE_I neuron read address out of range: %0d", neuron_addr_r_q
                       ));
        expected_neuron = expected_update_i(neuron_data_i_q, cpt_rst_q);
        if (SNN_Accelerater_inst.neuron_data_o !== expected_neuron)
          report_error($sformatf("UPDATE_I addr=%0d data mismatch", neuron_addr_r_q));
        checked_read_count++;
      end else if (ctrl_step_q == UPDATE_II) begin
        if (neuron_addr_r_q >= 8 || synapse_addr_r_q[15:8] >= 8 || synapse_addr_r_q[7:0] >= 8)
          report_error($sformatf(
                       "UPDATE_II address out of range: neuron=%0d synapse=%0d",
                       neuron_addr_r_q,
                       synapse_addr_r_q
                       ));
        expected_update_ii(neuron_data_i_q, synapse_data_i_q, enable_q,
                           SNN_Accelerater_inst.learn_mode_reg, expected_neuron, expected_spike,
                           expected_synapse);
        if (SNN_Accelerater_inst.neuron_data_o !== expected_neuron ||
            SNN_Accelerater_inst.spike !== expected_spike ||
            SNN_Accelerater_inst.update_synapse_data_o !== expected_synapse)
          report_error($sformatf(
                       "UPDATE_II target=%0d source=%0d data mismatch",
                       neuron_addr_r_q,
                       synapse_addr_r_q[15:8]
                       ));
        checked_read_count++;
      end else if (SNN_Accelerater_inst.ctrl_step == LEARN) begin
        if (SNN_Accelerater_inst.synapse_addr_R[15:8] >= 8 ||
            SNN_Accelerater_inst.synapse_addr_R[7:0] >= 8)
            report_error(
              $sformatf(
                "LEARN synapse read address out of range: %0d",
                SNN_Accelerater_inst.synapse_addr_R));
        checked_read_count++;
      end

      if (neuron_w_q) begin
        if (neuron_addr_w_q >= 8)
          report_error($sformatf("neuron write address out of range: %0d", neuron_addr_w_q));
        golden_neuron[neuron_addr_w_q] = SNN_Accelerater_inst.neuron_data_o;
        checked_write_count++;
      end
      if (synapse_w_q) begin
        if (synapse_addr_w_q[15:8] >= 8 || synapse_addr_w_q[7:0] >= 8)
          report_error($sformatf("synapse write address out of range: %0d", synapse_addr_w_q));
        golden_synapse[synapse_addr_w_q] = SNN_Accelerater_inst.synapse_data_o;
        checked_write_count++;
      end
    end

    step_q = SNN_Accelerater_inst.ctrl_step;
    enable_q = SNN_Accelerater_inst.enable_learn_reg;
    cpt_rst_q = SNN_Accelerater_inst.cpt_rst;
    ctrl_step_q = SNN_Accelerater_inst.ctrl_step;
    neuron_addr_r_q = SNN_Accelerater_inst.neuron_addr_R;
    neuron_addr_w_q = SNN_Accelerater_inst.neuron_addr_W;
    synapse_addr_r_q = SNN_Accelerater_inst.synapse_addr_R;
    synapse_addr_w_q = SNN_Accelerater_inst.synapse_addr_W;
    neuron_data_i_q = SNN_Accelerater_inst.neuron_data_i;
    synapse_data_i_q = SNN_Accelerater_inst.synapse_data_i;
    neuron_w_q = SNN_Accelerater_inst.neuron_W;
    synapse_w_q = SNN_Accelerater_inst.synapse_W;
    neuron_read_addr_d2 = neuron_read_addr_d1;
    neuron_read_addr_d1 = SNN_Accelerater_inst.neuron_addr_R;
    synapse_read_addr_d2 = synapse_read_addr_d1;
    synapse_read_addr_d1 = SNN_Accelerater_inst.synapse_addr_R;
  end

  always @(posedge aer_t.req) begin
    if (rst_n) begin
      checked_output_count++;
      if (aer_t.addr[7:0] >= 8)
        report_error($sformatf("output target out of range: %0d", aer_t.addr[7:0]));
    end
  end
endmodule
