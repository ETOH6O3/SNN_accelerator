`timescale 1ns / 1ps
module AEROutput (
    input  logic               clk,
    input  logic               rst_n,
           aer_if.source       AER_tx,
    input  logic         [7:0] target_addr,
    input  logic               timestep0,
    input  logic               valid,
    output logic               FIFO_pop
);

  /***************************************************************************************************
  关于输出 fifo 仲裁：

  论文使用的是单竞争层的网络，训练时不需要输出脉冲，故而：

  1. 训练时，输出 fifo 由 Controller 控制和使用
  2. 非训练状态，输出 fifo 由本模块控制

  与输入模块不同的是，输出缓存 FIFO **并没有位于输出模块内部**，
  这是因为在线学习启用时，LIF 神经元模块也需要从输出缓存 FIFO 中取出达到发放的目标神经元地址，进行突触权重的更新。

  // TODO: 改进思路：若未来希望在同一块板卡上部署多个加速器搭建多层脉冲神经网络，由于 SDSP 支持端到端训练，
          同时 FPGA 内部各层之间的同步传输也完全不需要搞异步握手，
          内部各层之间传输时可不要 AER 传输模块，改为直接用 axis
  ****************************************************************************************************/
  logic timestep0_reg;
  always_ff @( posedge clk or negedge rst_n ) begin
    if (!rst_n) begin
      timestep0_reg <= 1'b0;
    end else if (FIFO_pop) begin // 传输中途不能变化
      timestep0_reg <= timestep0;
    end
  end

  aer_tx #(
      .ADDR_WIDTH(10),
      .CDC_DEPTH(2),
      .FILTER_DEPTH(2)
  ) aer_tx_inst (
      .clk(clk),
      .rst_n(rst_n),
      .aer(AER_tx),
      .s_axis_tready(FIFO_pop),
      .s_axis_tvalid(valid),
      .s_axis_tdata({1'b1, timestep0_reg, target_addr})
  );

endmodule
