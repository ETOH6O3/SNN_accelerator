`timescale 1ns / 1ps

module Weight_Update
  import data_types_pkg::*;
(
    input logic clk, //! 时钟信号
    input logic learn_mode, //! 学习模式选择
    input synapse_data_t synapse_data_i, //! 输入的突触数据
    input learn_const_t learn_const,//! 学习常数

    output synapse_data_t synapse_data_o //! 输出的突触数据
);

  // 饱和加法预运算
  logic signed [8:0] __add_temp_1;
  assign __add_temp_1 = {synapse_data_i.weight[7], synapse_data_i.weight}
             + {5'b00000, synapse_data_i.learn_var.x_pre}
             - {5'b00000, learn_const.xtar};

  always_ff @(posedge clk) begin : weight_upt
    unique case (learn_mode)
      LEARN_MODE_STDP: begin
        /***************************************************************************************************
            当启用 STDP 学习时，学习变量用于表示算法中的𝑥𝑝𝑟𝑒。
            在基于突触痕迹的 STDP 学习算法 (∆𝑤 = 𝜂(𝑥_𝑝𝑟𝑒 − 𝑥_𝑡𝑎𝑟)(𝑤_𝑚𝑎𝑥 − 𝑤)^μ) 中，权重变化量的计算公式包含乘法和指数，
            这对于电路实现来说会消耗许多资源，所以我们在设计电路时取𝜇 = 0，
            并且由于规定了 LIF 神经元内部信号的低 7 位为小数位，
            所以取𝜂 = 1/128，这样可以省去对𝜂乘法电路的设计，以精度的略微下降换取电路资源的更少消耗，
            这样公式（2-6）就简化为：∆𝑤 = 𝑥_𝑝𝑟𝑒 − 𝑥_𝑡𝑎𝑟 （3-4）
            ****************************************************************************************************/
        if (__add_temp_1 > 9'sd127) synapse_data_o.weight <= 8'sd127;
        else if (__add_temp_1 < -9'sd128) synapse_data_o.weight <= -8'sd128;
        else synapse_data_o.weight <= __add_temp_1[7:0];
        /***************************************************************************************************
            在∆𝑤计算完成之后，还会对𝑥𝑝𝑟𝑒进行衰减操作，基于𝑥𝑝𝑟𝑒的位宽，设置其时间常数为 8，与膜电位的衰减一样，
            电路使用右移代替除法，同时小数部分大于 5 则会进位，小于等于 5 则会被舍去 // TODO: 为什么是 5 ？
            ****************************************************************************************************/
        synapse_data_o.learn_var.x_pre <= synapse_data_i.learn_var.x_pre - (synapse_data_i.learn_var.x_pre >> 3) - (synapse_data_i.learn_var.x_pre[2:0] >= 4);
      end
      LEARN_MODE_SDSP: begin
        /***************************************************************************************************
        当启用 SDSP 学习时，学习变量表示权重更新的方向，模块会根据参数的不同使权
        重增加或减小。如果输入权重为权重的最大值或最小值，则不会产生变化。
        ****************************************************************************************************/
        synapse_data_o.learn_var <= synapse_data_i.learn_var;
        unique case (synapse_data_i.learn_var.synapse_change_dir)
          STEADY_ZERO, STEADY_ONE: begin
            synapse_data_o.weight <= synapse_data_i.weight;
          end
          CHANGE_INCR: begin
            synapse_data_o.weight <= (synapse_data_i.weight == 8'sd127) ? synapse_data_i.weight : (synapse_data_i.weight + 1);
          end
          CHANGE_DECR: begin
            synapse_data_o.weight <= (synapse_data_i.weight == -8'sd128) ? synapse_data_i.weight : (synapse_data_i.weight - 1);
          end
        endcase
      end
    endcase
  end

endmodule
