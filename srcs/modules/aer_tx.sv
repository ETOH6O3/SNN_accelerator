`timescale 1ns / 1ps
module aer_tx #(
    parameter integer unsigned ADDR_WIDTH = 10,
    /***************************************************************************************************
    推荐配置：
    异步输出，外部输出：启用 CDC, 视情况启用滤波
    异步输出，FPGA 内部传输：启用 CDC, 不启用滤波
    同步输出，FPGA 内部传输：不启用 CDC, 不启用滤波
    ****************************************************************************************************/
    parameter integer unsigned CDC_DEPTH = 2,  // 0 表示无 CDC
    parameter integer unsigned FILTER_DEPTH = 1 // 滤波窗口，最小为 1 ， 即不启用滤波
) (
    input  logic                          clk,
    input  logic                          rst_n,
           aer_if.source                  aer,
    output logic                          s_axis_tready,
    input  logic                          s_axis_tvalid,
    input  logic         [ADDR_WIDTH-1:0] s_axis_tdata
);

  //------------------------------------------ ack 同步 & 滤波 --------------------------------------------------

  logic ack_cdc;
  cdc_sync #(
      .WIDTH (1),
      .STAGES(CDC_DEPTH)
  ) cdc_sync_inst (
      .clk_dst  (clk),
      .rst_n_dst(rst_n),
      .data_in  (aer.ack),
      .data_out (ack_cdc)
  );

  logic [FILTER_DEPTH:1] ackr;
  assign ackr[1] = ack_cdc;
  generate
    for (genvar i = 2; i <= FILTER_DEPTH; i++) begin : gen_ackr
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          ackr[i] <= 1'b0;
        end else begin
          ackr[i] <= ackr[i-1];
        end
      end
    end
  endgenerate

  logic ack_sync;
  assign ack_sync = &ackr[FILTER_DEPTH:1];

  //------------------------------------------ 协议转换 --------------------------------------------------
  logic ack_sync_d, ack_rise, ack_down;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ack_sync_d <= 1'b0;
    end else begin
      ack_sync_d <= ack_sync;
    end
  end
  assign ack_rise = ack_sync && !ack_sync_d;
  assign ack_down = !ack_sync && ack_sync_d;

  assign s_axis_tready = ack_down; // 指示 axis 主机更换下一个数据

  logic busy_flag;
  always_ff @( posedge clk  or negedge rst_n) begin
    if (!rst_n) begin
      busy_flag <= 1'b0;
    end else if (aer.req) begin
      busy_flag <= 1'b1;
    end else if (ack_down) begin
      busy_flag <= 1'b0;
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        aer.req <= 1'b0;
    end else begin
        if ((ack_sync == 1'b0) && s_axis_tvalid && !busy_flag) begin
            aer.req <= 1'b1;
        end else if (ack_rise) begin
            aer.req <= 1'b0;
        end
    end
  end
  always_ff @( posedge clk ) begin
    if (s_axis_tvalid) begin
        aer.addr <= s_axis_tdata;
    end
  end


endmodule
