`timescale 1ns / 1ps
//==========================================================
// Module : cdc_sync
// Desc   : 多级触发器同步器 (Multi-FF Synchronizer)
//          - 将信号从源时钟域安全地传递到目标时钟域
//          - 参数化位宽 WIDTH，同步级数 STAGES（默认为 2）
//==========================================================
`ifndef VMARTIN_CDC_SYNC_SV
`define VMARTIN_CDC_SYNC_SV 

module cdc_sync #(
    parameter integer unsigned WIDTH = 1,  // 同步信号位宽
    parameter integer unsigned STAGES = 2   // 同步触发器级数（推荐 ≥ 2）；0 表示无同步
) (
    input  logic             clk_dst,    // 目标时钟域
    input  logic             rst_n_dst,  // 目标时钟域复位（异步复位，低有效）
    input  logic [WIDTH-1:0] data_in,    // 来自源时钟域的输入
    output logic [WIDTH-1:0] data_out    // 同步到目标时钟域的输出
);

(* ASYNC_REG = "TRUE" *) logic [WIDTH-1:0] sync_chain[STAGES-1:0];
generate
    if (STAGES > 0) begin: gen_cdc_sync
      // 异步复位，在目标时钟域采样
      int i;
      always_ff @(posedge clk_dst or negedge rst_n_dst) begin
        if (!rst_n_dst) begin
          // 复位时清空整个同步链
          for (i = 0; i < STAGES; i++) begin
            sync_chain[i] <= '0;
          end
        end else begin
          // 移位传递：第一级采样输入，后续逐级传递
          sync_chain[0] <= data_in;
          for (i = 1; i < STAGES; i++) begin
            sync_chain[i] <= sync_chain[i-1];
          end
        end
      end

      // 最终输出为最后一级触发器的值
      assign data_out = sync_chain[STAGES-1];
    end else begin: gen_no_sync
      // 无同步，直接输出输入
      assign data_out = data_in;
    end
  endgenerate

endmodule
`endif
