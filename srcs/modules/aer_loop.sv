`timescale 1ns / 1ps

// 把 aer_tx 和 aer_rx 连接起来，形成一个回环，用于验证二者正确性
module aer_loop (
    input logic clk1,
    input logic clk2,
    input logic rst_n,

    // 向回环中注入数据
    input logic injection_en,
    input logic inj_vld,
    input logic [9:0] inj_data,
    output logic inj_ready,
    input logic open_loop_allow_out,

    output logic dbg_aer_req,
    output logic dbg_aer_ack,
    output logic [9:0] dbg_aer_addr,
    output logic dbg_s_axis_tvalid,
    output logic dbg_s_axis_tready,
    output logic [9:0] dbg_s_axis_tdata,
    output logic dbg_m_axis_tvalid,
    output logic dbg_m_axis_tready,
    output logic [9:0] dbg_m_axis_tdata,

    output logic dbg_init_over
);

  localparam integer unsigned ADDR_WIDTH = 10;

  aer_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .INSTABILITY_WIDTH_PS_EXPECT(0)
  ) aer ();
  logic s_axis_tvalid, s_axis_tready, m_axis_tvalid, m_axis_tready;
  logic [9:0] s_axis_tdata, m_axis_tdata;

  aer_tx #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .CDC_DEPTH(2),
      .FILTER_DEPTH(2)
  ) aer_tx_inst (
      .clk(clk1),
      .rst_n(rst_n),
      .aer(aer),
      .s_axis_tready(s_axis_tready),
      .s_axis_tvalid(s_axis_tvalid),
      .s_axis_tdata(s_axis_tdata)
  );

  logic m_axis_tready_1;
  aer_rx #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .CDC_DEPTH(2),
      .FILTER_DEPTH(2)
  ) aer_rx_inst (
      .clk(clk2),
      .rst_n(rst_n),
      .aer(aer),
      .m_axis_tready(m_axis_tready_1),
      .m_axis_tvalid(m_axis_tvalid),
      .m_axis_tdata(m_axis_tdata)
  );

  logic [7:0] cnt;
  always_ff @(posedge clk2 or negedge rst_n) begin
    if (!rst_n) begin
      cnt <= '0;
    end else if (cnt <= 8'd200) begin
      cnt <= cnt + 1;
    end
  end

  logic fifo_ready_d, fifo_ready_rise;
  always_ff @(posedge clk2 or negedge rst_n) begin
    if (!rst_n) begin
      fifo_ready_d <= '0;
    end else begin
      fifo_ready_d <= m_axis_tready;
    end
  end
  assign fifo_ready_rise = m_axis_tready & ~fifo_ready_d;

  logic [9:0] init_cnt;
  always_ff @( posedge clk2 or negedge rst_n ) begin
    if (!rst_n) begin
      init_cnt <= '0;
    end else if (injection_en) begin
      init_cnt <= '0;
    end else if(init_cnt != 800) begin
      init_cnt <= init_cnt + 1;
    end
  end

  logic init_over;
  always_ff @(posedge clk2 or negedge rst_n) begin
    if (!rst_n) begin
      init_over <= '0;
    end else if (injection_en) begin
      init_over <= '0;
    end else if (m_axis_tready && init_cnt >= 20) begin
      init_over <= '1;
    end
  end

  logic m_axis_tvalid_1;
  logic [9:0] m_axis_tdata_1;
  always_ff @(posedge clk2 or negedge rst_n) begin
    if (!rst_n) begin
      m_axis_tdata_1  <= '0;
      m_axis_tvalid_1 <= '1;
    end else if (fifo_ready_rise && init_cnt >= 20) begin
      m_axis_tvalid_1 <= 1'b0;
    end else if (init_over) begin
        m_axis_tdata_1  <= m_axis_tdata + 1;
        m_axis_tvalid_1 <= m_axis_tvalid;
    end else begin
      m_axis_tdata_1  <= '0;
      m_axis_tvalid_1 <= '1;
    end
  end
  assign inj_ready = m_axis_tready && injection_en;
  assign m_axis_tready_1 = injection_en ? open_loop_allow_out : m_axis_tready;

  logic m_axis_tvalid_2;
  logic [9:0] m_axis_tdata_2;
  assign m_axis_tvalid_2 = injection_en ? inj_vld : m_axis_tvalid_1 ;
  assign m_axis_tdata_2  = injection_en ? inj_data : m_axis_tdata_1;

  AERTestFifo your_instance_name (
      .s_axis_aresetn(rst_n),  // input wire s_axis_aresetn
      .s_axis_aclk   (clk2),     // input wire s_axis_aclk
      .s_axis_tvalid (m_axis_tvalid_2),   // input wire s_axis_tvalid
      .s_axis_tready (m_axis_tready),   // output wire s_axis_tready
      .s_axis_tdata  ({6'd0, m_axis_tdata_2}),    // input wire [15 : 0] s_axis_tdata
      .m_axis_aclk   (clk1),     // input wire m_axis_aclk
      .m_axis_tvalid (s_axis_tvalid),   // output wire m_axis_tvalid
      .m_axis_tready (s_axis_tready),   // input wire m_axis_tready
      .m_axis_tdata  (s_axis_tdata)     // output wire [15 : 0] m_axis_tdata
  );

  assign dbg_aer_req = aer.req;
  assign dbg_aer_ack = aer.ack;
  assign dbg_aer_addr = aer.addr;
  assign dbg_s_axis_tvalid = s_axis_tvalid;
  assign dbg_s_axis_tready = s_axis_tready;
  assign dbg_s_axis_tdata = s_axis_tdata;
  assign dbg_m_axis_tvalid = m_axis_tvalid;
  assign dbg_m_axis_tready = m_axis_tready;
  assign dbg_m_axis_tdata = m_axis_tdata;

  assign dbg_init_over = init_over;


endmodule
