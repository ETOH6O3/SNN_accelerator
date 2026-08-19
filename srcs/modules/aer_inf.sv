`timescale 1ns / 1ps
// AER 接口
interface aer_if #(
    parameter integer unsigned ADDR_WIDTH = 10,
    parameter integer unsigned INSTABILITY_WIDTH_PS_EXPECT = 0 // 仿真不稳定窗口长度期望值
) ();
  logic req;
  logic ack;
  logic [ADDR_WIDTH-1:0] addr;

  // 主设备（发送事件）方向
  modport source(output req, addr, input ack);

  // 从设备（接收事件）方向
  modport sink(input req, addr, output ack);

  // ------------------------------------------仿真毛刺--------------------------------------------------
`ifdef XILINX_SIMULATOR
  initial
    forever begin
      @(posedge req or negedge req);
      repeat (10)
      if ($urandom_range(1, 2) == 1) begin
        #($urandom_range(0, INSTABILITY_WIDTH_PS_EXPECT / 5) * 1ps);
        force req = !req;
        #($urandom_range(0, INSTABILITY_WIDTH_PS_EXPECT / 5) * 1ps);
        release req;
        req = !req;
      end
    end

  initial
    forever begin
      @(posedge ack or negedge ack);
      repeat (10)
      if ($urandom_range(1, 2) == 1) begin
        #($urandom_range(0, INSTABILITY_WIDTH_PS_EXPECT / 5) * 1ps);
        force ack = !ack;
        #($urandom_range(0, INSTABILITY_WIDTH_PS_EXPECT / 5) * 1ps);
        release ack;
        ack = !ack;
      end
    end

  generate
    for (genvar i = 0; i < ADDR_WIDTH; i++) begin
      initial
        forever begin
          @(posedge addr[i] or negedge addr[i]);
          repeat (10)
          if ($urandom_range(1, 5) == 1) begin
            #($urandom_range(
                0,
                INSTABILITY_WIDTH_PS_EXPECT / 4 * (ADDR_WIDTH + 1) / ADDR_WIDTH
            ) * 1ps);
            force addr[i] = !addr[i];
            #($urandom_range(
                0,
                INSTABILITY_WIDTH_PS_EXPECT / 4 * (ADDR_WIDTH + 1) / ADDR_WIDTH
            ) * 1ps);
            release addr[i];
            addr[i] = !addr[i];
          end
        end
    end
  endgenerate
`endif

endinterface
