`timescale 1ns / 1ps
  // TODO: 仿真时应当思考：神经元各参数的位宽设置为何这样
package data_types_pkg;

  // ================================LIF 神经元 =======================================

  /***************************************************************************************************
  LIF 神经元模块内部的所有数据均为定点数。
  规定膜电位和权重的低七位为小数位，膜电位为无符号数，由 16bit 二进制数表示，对应脉冲神经网络中的膜电位取值范围：0≤w<512。
  权重为有符号数，由 8bit 二进制数表示，对应脉冲神经网络中的权重取值范围为：-1≤w<1。
  ****************************************************************************************************/

  //! 神经元数据
  typedef struct packed {
    logic [3:0]  calcium;  //! 神经元的钙变量
    logic [3:0]  t_ref;    //! 神经元的不应期时间
    logic [15:0] v_mem;    //! 神经元的膜电位
  } neuron_data_t;

  //! 将 neuron_data_t 转换为可读字符串
  function automatic string neuron_data_to_string(input neuron_data_t nd);
    real   v_mem_real;  //! 膜电位实际值（单位：mV 或任意，取决于模型）
    string str;

    //! 低 7 位为小数位，无符号整数转实数
    v_mem_real = real'(nd.v_mem) / 128.0;

    //! 格式化输出：十六进制显示原始值，并附带实际值
    str = $sformatf("v_mem=0x%04X (%.6f)(%0d), t_ref=%0d, calcium=%0d", nd.v_mem, v_mem_real, nd.v_mem, 
                      nd.t_ref,nd.calcium);
    return str;
  endfunction


  //! 神经元参数
  typedef struct packed {
    logic [3:0]  t_ref;  //! [19:16] 设置的不应期时间
    logic [15:0] v_thr;  //! [15:0]  设置的阈值电位
  } neuron_const_t;

  // ================================= 突触学习 =====================================

  /***************************************************************************************************
  当启用 STDP 在线学习时，突触的学习变量用于表示 STDP 算法中的𝑥𝑝𝑟𝑒参数，
  更新模块 II 会将输入的𝑥𝑝𝑟𝑒值加一，放在输出端口。

  当启用 SDSP 在线学习时，突触的学习变量用于表示突触变化的方向，
  更新模块 II 会根据公式（2-9），满足正向变化时该参数会被设置为 4’b0001，
  负向变化设置为 4’b0010，除此之外 4’b0000 和 4’b0011 均为双稳态变化。
  权重更新模块会根据参数的值与学习算法对突触权重进行更新。
  ****************************************************************************************************/

  //! SDSP 学习变量
  typedef enum logic [3:0] {
    STEADY_ZERO = 4'b0000,  //! 双稳态变化
    CHANGE_INCR = 4'b0001,  //! 正向变化
    CHANGE_DECR = 4'b0010,  //! 负向变化
    STEADY_ONE  = 4'b0011   //! 双稳态变化
  } synapse_change_dir_e;

  typedef union packed {
    synapse_change_dir_e synapse_change_dir;  //! 用作突触变化方向编码器
    logic [3:0] x_pre;  //! 用作计数器
  } learn_var_u;

  //! 突触数据
  typedef struct packed {
    learn_var_u learn_var;  //! 学习变量
    logic signed [7:0] weight;  //! 突触权重值
  } synapse_data_t;

  function automatic string synapse_data_to_string(input synapse_data_t sd);
    string str;
    real   weight_real;

    weight_real = real'(sd.weight) / 128.0;

    str =
        $sformatf("weight=0x%02x (%.6f)(%0d), learn_var=%d", sd.weight, weight_real, sd.weight, sd.learn_var.x_pre);

    return str;

  endfunction



  //! 学习算法参数
  typedef struct packed {
    logic [3:0]  xtar;        //! [3:0]   STDP 参数 xtar
    logic [15:0] theta_m;     //! [19:4]  SDSP 参数 theta_m
    logic [3:0]  ca_theta_1;  //! [23:20] SDSP 参数 theta_1
    logic [3:0]  ca_theta_2;  //! [27:24] SDSP 参数 theta_2
    logic [3:0]  ca_theta_3;  //! [31:28] SDSP 参数 theta_3
  } learn_const_t;

  //! 学习模式
  typedef enum logic {
    LEARN_MODE_STDP = 0,
    LEARN_MODE_SDSP = 1
  } learn_mode_e;


  // =============================控制中心=====================================

  //! 工作模式枚举

  typedef enum logic [1:0] {
    IDLE = 2'b00,
    UPDATE_I = 2'b01,
    UPDATE_II = 2'b10,
    LEARN = 2'b11
  } work_mode_e;

endpackage : data_types_pkg

