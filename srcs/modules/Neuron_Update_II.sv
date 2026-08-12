`timescale 1ns / 1ps

/**
突触被刺激时的各项参数更新，以及相关的学习参数预计算；纯组合逻辑
*/
module Neuron_Update_II
  import data_types_pkg::*;
(
    input logic enable_learn, //! 是否启用在线学习
    input learn_const_t learn_const, //! 学习常数
    input learn_mode_e learn_mode, //! 学习模式
    input neuron_const_t neuron_const, //! 神经元常数
    input neuron_data_t neuron_data_i, //! 输入的神经元数据
    input synapse_data_t synapse_data_i, //! 输入的突触数据

    output neuron_data_t neuron_data_o, //! 输出的神经元数据
    output logic spike, //! 脉冲发放标志
    output synapse_data_t synapse_data_o //! 输出的突触数据
);

  logic __sum_overflow_temp_1, __sum_overflow_temp_2;

  // 计算神经元数据
  always_comb begin : neuron_data_calc
    __sum_overflow_temp_1 = 1'bx;
    __sum_overflow_temp_2 = 1'bx;

    neuron_data_o = neuron_data_i;
    spike = 1'b0;

    if (neuron_data_i.t_ref == 4'b0) begin
      /***************************************************************************************************
        当目标神经元处于不应期外时，神经元的膜电位会累加输入电流的值。
        如果更新后的神经元膜电位大于阈值，则会触发复位机制，将膜电位置为静息电位，并拉高脉冲发放标志信号 spike。
        此时，神经元进入设置好的不应期，而在不应期内，神经元的膜电位会一直保持在静息电位。
        ****************************************************************************************************/

      // 只有突出前有脉冲时才启用本模块，故冲激函数可视为 1
      // 这里是无符号数 + 有符号数，全部转成有符号数再相加；注意处理溢出
      {__sum_overflow_temp_1, neuron_data_o.v_mem}  /*扩展为 17 位*/ = $unsigned(
          $signed({1'b0, neuron_data_i.v_mem})  /*扩展为 17 位有符号数*/ +
          synapse_data_i.weight  /*8 位有符号数*/  // * 1'b1
      );
      if (__sum_overflow_temp_1) begin
        // ```discard
        // // 由于被加数是正数，可以简化逻辑
        // if(synapse_data_i.weight < 0) neuron_data_o.v_mem = '0; // 下溢
        // else neuron_data_o.v_mem = '1; // 上溢
        // ```

        // weight 是一个很小的数，v_mem 的最大值 - weight 远高于 v_thr ，故必然是下溢
        neuron_data_o.v_mem = '0;  // 下溢
      end

      if (neuron_data_o.v_mem >= neuron_const.v_thr) begin
        neuron_data_o.v_mem = consts_pkg::VRest;
        neuron_data_o.t_ref = neuron_const.t_ref;
        spike = 1'b1;
      end
    end else begin
      ;  // 无响应
    end

    if (enable_learn) begin
      unique case (learn_mode)
        LEARN_MODE_STDP: begin
          // 当启用 STDP 在线学习时，神经元的钙变量会一直保持为零
          neuron_data_o.calcium = '0;
        end
        LEARN_MODE_SDSP: begin
          // 当启用 SDSP 在线学习时，如果有目标神经元发放脉冲，则其钙变量会增加 2 (Jc)
          if (spike) begin
            {__sum_overflow_temp_2, neuron_data_o.calcium} = neuron_data_i.calcium + consts_pkg::Jc; // * 1'b1;
            if (__sum_overflow_temp_2) neuron_data_o.calcium = '1;
          end
        end
      endcase
    end

  end

  always_comb begin : learn_data_calc
    synapse_data_o = synapse_data_i;

    if (enable_learn) begin

      unique case (learn_mode)
        LEARN_MODE_STDP: begin
          // 当启用 STDP 在线学习时，突触的学习变量用于表示 STDP 算法中的𝑥𝑝𝑟𝑒参数，
          // 更新模块 II 会将输入的𝑥𝑝𝑟𝑒值加一，放在输出端口。
          synapse_data_o.learn_var.x_pre = (synapse_data_i.learn_var.x_pre == 4'b1111) ? synapse_data_i.learn_var.x_pre : synapse_data_i.learn_var.x_pre + 1;
        end
        LEARN_MODE_SDSP: begin
          /***************************************************************************************************
            当启用 STDP 在线学习时，突触的学习变量用于表示 STDP 算法中的𝑥𝑝𝑟𝑒参数，
            更新模块 II 会将输入的𝑥𝑝𝑟𝑒值加一，放在输出端口。

            当启用 SDSP 在线学习时，突触的学习变量用于表示突触变化的方向，
            更新模块 II 会根据公式（2-9），满足正向变化时该参数会被设置为 4’b0001，
            负向变化设置为 4’b0010，除此之外 4’b0000 和 4’b0011 均为双稳态变化。
            权重更新模块会根据参数的值与学习算法对突触权重进行更新。
            ****************************************************************************************************/
          synapse_data_o.learn_var.synapse_change_dir [0] = (
                    neuron_data_i.v_mem >= learn_const.theta_m
                    && learn_const.ca_theta_1 <= neuron_data_i.calcium
                    && neuron_data_i.calcium <= learn_const.ca_theta_3
                    );
          synapse_data_o.learn_var.synapse_change_dir [1] = (
                    neuron_data_i.v_mem < learn_const.theta_m
                    && learn_const.ca_theta_1 <= neuron_data_i.calcium
                    && neuron_data_i.calcium <= learn_const.ca_theta_2
                    );
          synapse_data_o.learn_var.synapse_change_dir[3:2] = '0;
        end
      endcase

    end
  end

endmodule
