`timescale 1ns / 1ps

// 流水线级联控制
module pipeline_ctrl #(
    parameter integer unsigned PIPELINE_REG_WIDTH = 9
) (
    input logic clk,
    input logic rst_n,

    input logic [PIPELINE_REG_WIDTH-1:0] last_bus,
    input logic                          last_to_this_valid,
    input logic                          next_allow_in,
    input logic                          ready_go,

    output logic                          this_allow_in,
    output logic                          this_to_next_valid,
    output logic [PIPELINE_REG_WIDTH-1:0] this_reg

);

  logic this_valid;

  assign this_allow_in = !this_valid || (ready_go && next_allow_in);
  assign this_to_next_valid = this_valid && ready_go;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      this_valid <= 1'b0;
    end else if (this_allow_in) begin
      this_valid <= last_to_this_valid;
    end
  end

  always_ff @(posedge clk) begin
    if (this_allow_in && last_to_this_valid) begin
      this_reg <= last_bus;
    end
  end
endmodule

