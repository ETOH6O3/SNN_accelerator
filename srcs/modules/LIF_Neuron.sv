`timescale 1ns / 1ps
module LIF_Neuron
  import data_types_pkg::*;
(
    input logic clk, //! 时钟信号
    input logic rst_n, //! 复位信号
    input logic cpt_rst, //! 竞争重置信号
    input work_mode_e ctrl_step, //! 当前运算阶段状态码
    input logic enable_learn, //! 学习使能
    input learn_mode_e learn_mode, //! 学习模式
    input neuron_const_t neuron_const, //! 神经元超参数
    input learn_const_t learn_const, //! 学习超参数
    input neuron_data_t neuron_data_i, //! 神经元数据输入
    input synapse_data_t synapse_data_i, //! 突触数据输入

    output neuron_data_t neuron_data_o, //! 神经元数据输出
    output logic spike, //! 神经元发放脉冲输出
    output synapse_data_t synapse_data_o //! 突触数据输出
);

  // 操作数隔离（降低功耗）
  logic _1_enable, _2_enable;
  assign _1_enable = (ctrl_step == UPDATE_I);
  assign _2_enable = (ctrl_step == UPDATE_II);

  // 计算
  neuron_data_t neuron_data_o_1, neuron_data_o_2;
  synapse_data_t synapse_data_o_2;
  logic spike_2;

  Neuron_Update_I Neuron_Update_I_inst (
      .cpt_rst(cpt_rst),
      .neuron_data_i(_1_enable ? neuron_data_i : '0),
      .neuron_data_o(neuron_data_o_1)
  );

  Neuron_Update_II Neuron_Update_II_inst (
      .enable_learn(enable_learn),
      .learn_const(learn_const),
      .learn_mode(learn_mode),
      .neuron_const(neuron_const),
      .neuron_data_i(_2_enable ? neuron_data_i : '0),
      .synapse_data_i(_2_enable ? synapse_data_i : '0),
      .neuron_data_o(neuron_data_o_2),
      .spike(spike_2),
      .synapse_data_o(synapse_data_o_2)
  );

  // 输出
  always_ff @(posedge clk) begin : gen_out
    case (ctrl_step)
      UPDATE_I: begin
        neuron_data_o <= neuron_data_o_1;
        spike <= 1'b0;
      end
      UPDATE_II: begin
        neuron_data_o <= neuron_data_o_2;
        spike <= spike_2;
        synapse_data_o <= synapse_data_o_2;
      end
      default: begin
        spike <= 1'b0;
      end
    endcase
  end

endmodule
