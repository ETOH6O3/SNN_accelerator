`timescale 1ns / 1ps
module AERInput (
    input  logic             clk,
    input  logic             rst_n,
           aer_if.sink       AER_rx,
    input  logic             timestep0,
    input  logic             FIFO_pop,
    output logic             FIFO_empty,
    output logic       [7:0] source_addr
);

  logic event_allow_out;
  logic event_valid;
  logic [9:0] event_addr;
  aer_rx #(
      .ADDR_WIDTH(10),
      .CDC_DEPTH(2),
      .FILTER_DEPTH(2)
  ) aer_rx_inst (
      .clk(clk),
      .rst_n(rst_n),
      .aer(AER_rx),
      .m_axis_tready(event_allow_out),
      .m_axis_tvalid(event_valid),
      .m_axis_tdata(event_addr)
  );
  /***************************************************************************************************
    SNN 加速器在处理本时间步的数据时，还需要将下一个时间步要处理的数据缓存起来，
    因此需要 2 个 FIFO 来对数据进行缓存, 分别记为 0 号 FIFO 和 1 号 FIFO。
    数据包的最低位是源神经元发放脉冲的时间步，解码模块会根据此信息，
    将 0 时刻发放的源神经元脉冲存入 1 号输入缓存 FIFO，并在 1 时刻发送给控制模块和目标神经元；
    将 1 时刻的源神经元脉冲存入 0 号输入缓存 FIFO，并在 0 时刻发送给控制模块和目标神经元。
    两个数据缓存 FIFO 的容量均设计为 256*8bit，以满足输入的需求。

    // TODO: 论文描述可能有误, 数据包格式与表格有出入，此处按表格说明来
    数据包中的位置  位宽      描述
    7-0            8bit     发放脉冲的源神经元编号
    8              1bit     源神经元发放脉冲的时间步
    9              1bit     数据包有效标识位，1 有效
    ****************************************************************************************************/
  logic fifo_0_mtvld, fifo_1_mtvld;
  logic fifo_0_stvld, fifo_1_stvld;
  logic [7:0] fifo_0_tdata, fifo_1_tdata;
  assign event_allow_out = (!timestep0) ? fifo_0_stvld : fifo_1_stvld;

  AERFifo in_fifo_0 (
      .s_axis_aresetn(rst_n),  //input wire s_axis_aresetn
      .s_axis_aclk(clk),  //input wire s_axis_aclk
      .s_axis_tvalid (event_valid && event_addr [9] && event_addr [8] == 1'b1),    //input wire s_axis_tvalid
      .s_axis_tready(fifo_0_stvld),  //output wire s_axis_tready
      .s_axis_tdata(event_addr[7:0]),  //input wire [7 : 0] s_axis_tdata
      .m_axis_tvalid(fifo_0_mtvld),  //output wire m_axis_tvalid
      .m_axis_tready(FIFO_pop && timestep0 == 1'b0),  //input wire m_axis_tready
      .m_axis_tdata(fifo_0_tdata)  //output wire [7 : 0] m_axis_tdata
  );
  AERFifo in_fifo_1 (
      .s_axis_aresetn(rst_n),  //input wire s_axis_aresetn
      .s_axis_aclk(clk),  //input wire s_axis_aclk
      .s_axis_tvalid (event_valid && event_addr [9] && event_addr [8] == 1'b0),    //input wire s_axis_tvalid
      .s_axis_tready(fifo_1_stvld),  //output wire s_axis_tready
      .s_axis_tdata(event_addr[7:0]),  //input wire [7 : 0] s_axis_tdata
      .m_axis_tvalid(fifo_1_mtvld),  //output wire m_axis_tvalid
      .m_axis_tready(FIFO_pop && timestep0 == 1'b1),  //input wire m_axis_tready
      .m_axis_tdata(fifo_1_tdata)  //output wire [7 : 0] m_axis_tdata
  );

  always_comb begin : out
    if (!timestep0) begin
      FIFO_empty  = !fifo_0_mtvld;
      source_addr = fifo_0_tdata;
    end else begin
      FIFO_empty  = !fifo_1_mtvld;
      source_addr = fifo_1_tdata;
    end
  end


endmodule
