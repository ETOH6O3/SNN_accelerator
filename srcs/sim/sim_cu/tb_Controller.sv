// Filename: tb_Controller.sv
`timescale 1ns / 1ps

module tb_Controller;

  reg clk, clk_async;
  reg rst_n;
  aer_if aer_r ();
  aer_if aer_t ();

  initial begin
    clk = 1'b0;
    clk_async = 1'b0;
    rst_n = 1'b0;
    #20 rst_n = 1'b1;
  end
  always #20 clk = !clk;
  always #100 clk_async = !clk_async;

  logic timestep0;
  Time_Gen Time_Gen_inst (
      .clk(clk_async),
      .rst_n(rst_n),
      .interval($urandom_range({18{1'b1}} / 2, {18{1'b1}})),
      .timestep0(timestep0)
  );

  logic          s_axis_tready;
  logic          s_axis_tvalid;
  logic [10-1:0] s_axis_tdata;
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
  initial begin
    s_axis_tvalid = 1'b0;
    s_axis_tdata  = '0;

    wait (rst_n);
    forever begin
      @(negedge clk_async);
      s_axis_tvalid = 1'b1;
      s_axis_tdata[9:8] = {1'b1, timestep0};
      s_axis_tdata[7:0] = $urandom_range(0, 255);

      wait (s_axis_tready);
      @(negedge clk_async);
      s_axis_tvalid = 1'b0;

      // @(negedge clk_async);
    end
  end

  data_types_pkg::learn_mode_e learn_mode;
  logic enable_learn;
  SNN_Accelerater #(
      .SrcNum(32),
      .TarNum(32),
      .NeuronConst('{v_thr: 16'd500, t_ref: 4'd1})
  ) SNN_Accelerater_inst (
      .clk(clk),
      .rst_n(rst_n),
      .aer_r(aer_r),
      .aer_t(aer_t),
      .enable_learn(enable_learn),
      .learn_mode(learn_mode)
  );

  initial begin
    enable_learn = 1'b1;
    learn_mode = data_types_pkg::LEARN_MODE_STDP;
    wait(!rst_n);
    forever begin
      repeat(1000)@(posedge clk);
      learn_mode = $urandom_range(0, 1) ? data_types_pkg::LEARN_MODE_STDP : data_types_pkg::LEARN_MODE_SDSP;
    end 
  end

  always #1 aer_t.ack = aer_t.req;


endmodule
