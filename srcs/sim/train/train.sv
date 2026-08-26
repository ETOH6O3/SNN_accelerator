`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/30 20:54:47
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// import "DPI-C" function int test();

module train;
  import data_types_pkg::*;
  import logger_pkg::*;

  // Logger 实例
  logger lg;
  initial begin
    lg = new(logger::INFO);
  end

  logic rst_n;
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end
  logic clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  aer_if aer_r ();
  aer_if aer_t ();

  poisson::PoissonImg #(
      ._T(250),
      ._H(16),
      ._W(16)
  ) sender;
  initial begin
    // 恢复到上次训练终止处
    // poisson::resume_breakpoint(70);
    poisson::report_queue();

    sender = new(aer_r);
    /***************************************************************************************************
    label 0 has 9 cached indices.
      they are: [88, 95, 108, 114, 118, 119, 121, 156, 169, ]
    label 1 has 13 cached indices.
      they are: [77, 78, 99, 102, 104, 105, 112, 113, 124, 128, 134, 152, 174, ]
    label 2 has 3 cached indices.
      they are: [159, 161, 171, ]
    label 3 has 7 cached indices.
      they are: [107, 111, 130, 135, 136, 149, 157, ]
    label 4 has 9 cached indices.
      they are: [115, 127, 131, 139, 142, 150, 163, 164, 166, ]
    label 5 has 0 cached indices.
      they are: []
    label 6 has 7 cached indices.
      they are: [106, 126, 129, 147, 151, 155, 165, ]
    label 7 has 7 cached indices.
      they are: [103, 123, 140, 141, 148, 158, 168, ]
    label 8 has 1 cached indices.
      they are: [160, ]
    label 9 has 8 cached indices.
      they are: [116, 133, 153, 154, 162, 167, 170, 172, ]
    ****************************************************************************************************/

    wait (rst_n);
    #10;
    lg.info("[tb_top] Starting to send images");
    sender.send_imgs(5us);
  end

  SNN_Accelerater #(
    .NeuronConst('{v_thr: 16'd4000, t_ref: 4'd1}),
    .LearnConst('{
        xtar: 4'd11,
        theta_m: 16'd2000,
        ca_theta_1: 4'd2,
        ca_theta_2: 4'd9,
        ca_theta_3: 4'd15
    }),
    .SrcSpikePerStepMaxExp(128),
    .SpikePerStepMaxExp(8)
    ) SNN_Accelerater_inst  (
      .clk(clk),
      .rst_n(rst_n),
      .aer_r(aer_r),
      .aer_t(aer_t),
      .enable_learn(1'b1),
      .learn_mode(LEARN_MODE_SDSP)
  );

  always #1 aer_t.ack = aer_t.req;

endmodule
