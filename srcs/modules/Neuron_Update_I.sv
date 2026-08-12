`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/07/15 22:37:49
// Design Name:
// Module Name: Neuron_Update_I
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

/**
执行膜电位泄漏的更新计算, 纯组合逻辑
*/
module Neuron_Update_I
  import data_types_pkg::*;
(
    input logic cpt_rst, //! 竞争学习重置标志
    input neuron_data_t neuron_data_i, //! 输入神经元数据
    output neuron_data_t neuron_data_o //! 输出神经元数据
);

  function automatic integer unsigned shr_and_round(input integer unsigned a,
                                                    input integer unsigned b);
    shr_and_round = (a >> b) + a[b-1];
  endfunction

  always_comb begin
    neuron_data_o = neuron_data_i;

    if (cpt_rst == 1'b1) begin
      /***************************************************************************************************
    当在线学习启用时，如果上一时间步有目标神经元发放，cpt_rst 信号会被置为高电平，
    更新模块 I 会重置所有输入的目标神经元的膜电位和不应期，以达到竞争学习的目的。
    ****************************************************************************************************/
      neuron_data_o.v_mem = consts_pkg::VRest;
      neuron_data_o.t_ref = 4'd0;
      // neuron_data_o.calcium = 4'd0; // 不重置钙变量
    end else begin
      if (neuron_data_i.t_ref != 4'd0) begin
        /***************************************************************************************************
      如果信号 t_ref_i 大于零，则说明神经元正处在不应期内，
      更新模块 I 会在将该信号的值减 1，在 t_ref_o 端口输出。
      ****************************************************************************************************/
        neuron_data_o.t_ref = neuron_data_i.t_ref - 1;
      end else begin
        // 执行衰减
        neuron_data_o.v_mem = neuron_data_i.v_mem -
            shr_and_round(consts_pkg::DeltaT * (neuron_data_i.v_mem - consts_pkg::VRest), 5);
        neuron_data_o.calcium = neuron_data_i.calcium -
            shr_and_round(consts_pkg::DeltaT * neuron_data_i.calcium, 3);
      end
    end
  end

endmodule
