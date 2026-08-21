`timescale 1ns / 1ps
module Time_Gen (
    input logic clk,
    input logic rst_n,
    input logic [17:0] interval,
    output logic timestep0
);

  initial begin
    forever begin
      @(negedge clk);
      if (interval == 0) begin
        $fatal(1, "[Time_Gen] @%0t: ERROR: interval must be greater than 0", $time);
      end
      // == 1 或 最大值 时能正确处理
    end
  end

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
