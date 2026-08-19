`timescale 1ns / 1ps
// AER 接收（转最简 AXI-4 stream ）
module aer_rx #(
    parameter integer unsigned ADDR_WIDTH = 10,
    /***************************************************************************************************
    推荐配置：
    异步输入，外部输入：启用 CDC, 视情况启用滤波
    异步输入，FPGA 内部传输：启用 CDC, 不启用滤波
    同步输入，FPGA 内部传输：不启用 CDC, 不启用滤波
    ****************************************************************************************************/
    parameter integer unsigned CDC_DEPTH = 2, // 0 表示无 CDC
    parameter integer unsigned FILTER_DEPTH = 1 // 滤波窗口，最小为 1 ， 即不启用滤波
) (
    input  logic                        clk,
    input  logic                        rst_n,
           aer_if.sink                  aer,
    (* mark_debug = "true" *) input  logic                        m_axis_tready,
    (* mark_debug = "true" *) output logic                        m_axis_tvalid,
    (* mark_debug = "true" *) output logic       [ADDR_WIDTH-1:0] m_axis_tdata
);

  //------------------------------------------ req 同步 & 滤波 --------------------------------------------------

  logic req_cdc;
  cdc_sync #(
      .WIDTH (1),
      .STAGES(CDC_DEPTH)
  ) cdc_sync_inst (
      .clk_dst  (clk),
      .rst_n_dst(rst_n),
      .data_in  (aer.req),
      .data_out (req_cdc)
  );

  logic [FILTER_DEPTH:1] reqr;
  assign reqr[1] = req_cdc;
  generate
    for (genvar i = 2; i <= FILTER_DEPTH; i++) begin : gen_reqr
      always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          reqr[i] <= 1'b0;
        end else begin
          reqr[i] <= reqr[i-1];
        end
      end
    end
  endgenerate

  logic req_sync;
  assign req_sync = &reqr[FILTER_DEPTH:1];

  //------------------------------------------ 协议转换 --------------------------------------------------

  (* mark_debug = "true" *) logic req_sync_d, req_rise, req_down;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) req_sync_d <= 1'b0;
    else req_sync_d <= req_sync;
  end
  assign req_rise = req_sync && !req_sync_d;
  assign req_down = !req_sync && req_sync_d;

  (* mark_debug = "true" *) logic begin_next_trans;
  assign begin_next_trans = req_sync && !m_axis_tvalid && !aer.ack;

  (* mark_debug = "true" *) logic mtvld_next;
  always_comb begin
    unique if (begin_next_trans) begin
      mtvld_next = 1'b1;
    end else if (m_axis_tvalid && m_axis_tready) begin
      mtvld_next = 1'b0;
    end else begin
      mtvld_next = m_axis_tvalid;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) m_axis_tvalid <= 1'b0;
    else begin
      // if (begin_next_trans) m_axis_tvalid <= 1'b1;
      // else if (m_axis_tvalid && m_axis_tready) m_axis_tvalid <= 1'b0;
      // else m_axis_tvalid <= m_axis_tvalid;
      m_axis_tvalid <= mtvld_next;
    end
  end

  always_ff @( posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      aer.ack <= 1'b0;
    end else begin
      if(begin_next_trans) begin
        aer.ack <= 1'b1;
      end else if (!req_sync) begin
        aer.ack <= 1'b0;
      end
    end
  end

  // type(aer.addr) m_axis_tdata_sync;

  always_ff @(posedge clk) begin
    if (mtvld_next) m_axis_tdata <= aer.addr;
  end

endmodule
