`timescale 1ns / 1ps
module Time_Gen (
    input logic clk,
    input logic rst_n,
    input logic [17:0] interval, // TODO: 位宽有疑惑，据计算，18 位即足够，然而论文表 4-1 给出的是 20 位，图 4-4 给出的是 16 位
    output logic timestep0
);

  logic [17:0] counter;
  always_ff @(posedge clk or negedge rst_n) begin : cnt
    if (!rst_n) begin
      counter   <= '0;
      timestep0 <= 1'b0;
    end else begin
      if (counter + 1 == interval) begin
        counter   <= '0;
        timestep0 <= !timestep0;
      end else begin
        counter <= counter + 1;
      end
    end
  end

endmodule
