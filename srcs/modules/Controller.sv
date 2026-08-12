`timescale 1ns / 1ps
module Controller
  import data_types_pkg::*;
(
    input  logic              clk,               //! 时钟信号
    input  logic              enable_learn,      //! 启用在线学习
    input  logic              inputFIFO_empty,   //! 输入缓存 FIFO 空标志
    input  logic              outputFIFO_empty,  //! 输出缓存 FIFO 空标志
    input  logic              rst_n,             //! 复位
    input  logic       [ 7:0] source_addr,       //! 源神经元地址
    input  logic              spike,             //! 脉冲信号// W 级   
    input  logic       [ 7:0] src_number,        //! 源神经元启用数量
    input  logic       [ 7:0] tar_number,        //! 目标神经元启用数量
    input  logic       [ 7:0] target_addr,       //! 目标神经元地址
    input  logic              timestep0,         //! 时间步信号
    output logic              cpt_rst,           //! 竞争复位// U 级
    output work_mode_e        ctrl_step,         //! 计算任务// U 级
    output logic              inputFIFO_pop,     //! 输入缓存 FIFO 弹出
    output logic              neuron_W,          //! 神经元 RAM 写使能
    output logic       [ 7:0] neuron_addr_R,     //! 神经元 RAM 读地址
    output logic       [ 7:0] neuron_addr_W,     //! 神经元 RAM 写地址
    output logic              outputFIFO_pop,    //! 输出缓存 FIFO 弹出
    output logic              synapse_W,         //! 突触 RAM 写使能
    output logic       [15:0] synapse_addr_R,    //! 突触 RAM 读地址
    output logic       [15:0] synapse_addr_W     //! 突触 RAM 写地址
);
  // TODO: 根据论文对 src_number 、 tar_number 的使用的描述，推断为二者为移 1 码
  // TODO: 优化思路 interval 改为由内部动态生成，每个新时间步最初设置为 (𝑚 + 1)(𝑛 + 2) ，并在运行中监控目标神经元中的脉冲，每次脉冲给 interval 加上 (𝑚 + 2)

  // typedef enum logic [1:0] {
  //   IDLE = 2'b00,
  //   UPDATE_I = 2'b01,
  //   UPDATE_II = 2'b10,
  //   LEARN = 2'b11
  // } work_mode_e;
  work_mode_e state, next_state;

  // 状态机
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= UPDATE_I;  // 系统开始时直接进 UPDATE_I
    end else begin
      state <= next_state;
    end
  end

  //------------------------------------------ 状态转移 --------------------------------------------------
  logic timestep_changed;
  logic timestep0_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      timestep0_d <= 1'b0;
    end else begin
      timestep0_d <= timestep0;
    end
  end
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      timestep_changed <= 1'b0;
    end else begin
      // 契约： interval 足够长，确保以下分支互斥
      unique if (timestep0_d != timestep0) begin
        timestep_changed <= 1'b1;
        // 若处于 IDLE , 下一刻进入 UPDATE_I 
      end else if (state == UPDATE_I) begin
        timestep_changed <= 1'b0;  // 复位
      end else begin
        timestep_changed <= timestep_changed;
      end
    end
  end

  always_comb begin : fsm_transition
    next_state = state;
    unique case (state)
      IDLE: begin
        // 当系统开始信号有效（在复位逻辑中）或新的时间步开始时，控制模块状态由 IDLE 转为 UPDATE I
        if (timestep_changed) begin
          next_state = UPDATE_I;
        end
      end
      UPDATE_I: begin
        if ((neuron_addr_R == tar_number)) begin
          next_state = inputFIFO_empty ? IDLE : UPDATE_II;
        end
      end
      UPDATE_II: begin
        if (inputFIFO_empty/* 本刻上级输出全部读取 */ && (neuron_addr_R == tar_number)/* 最后一个突触处理完 */) begin
          next_state = enable_learn ? (outputFIFO_empty ? IDLE : LEARN) : IDLE;
        end
      end
      LEARN: begin
        if (outputFIFO_empty/* 本刻本级脉冲全部处理 */ && (synapse_addr_R [15:8] == src_number)/* 最后一个突触处理完 */) begin
          next_state = IDLE;
        end
      end
    endcase
  end

  //------------------------------------------ 控制信号输出 --------------------------------------------------

  /***************************************************************************************************
  三级流水状态

  在 SNN 加速器对目标神经元的膜电位的更新过程中，采用了流水线设计，以求最大限度利用所例化的一个物理神经元。

  下面是将一个物理神经元通过流水线的方法分时复用为 256 个目标神经元的例子：
  在时钟周期 𝑡 读取目标神经元 𝑡 的状态信息和对应的源 - 目突触权重信息。
  在时钟周期𝑡 + 1 的时候更更新目标神经元 𝑡 的状态，同时将神经元 𝑡 + 1 的状态信息和对应的源 - 目突触权重信息从存储模块中取出。
  在时钟周期𝑡 + 2 的时候更回写目标神经元 𝑡 的状态，更新目标神经元𝑡 + 1 的状态，同时将神经元𝑡 + 2 的状态信息和对应的源 - 目突触权重信息从存储模块中取出。

  R Read 读取阶段
  U Update 计算阶段
  W Write 写回阶段
  ****************************************************************************************************/
  work_mode_e u_state, w_state;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      u_state <= IDLE;
      w_state <= IDLE;
    end else begin
      u_state <= state;
      w_state <= u_state;
    end
  end
  assign ctrl_step = u_state;
  logic [ 7:0] neuron_addr_U;
  logic [15:0] synapse_addr_U;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      neuron_addr_U  <= 8'b0;
      neuron_addr_W  <= 8'b0;
      synapse_addr_U <= 16'b0;
      synapse_addr_W <= 16'b0;
    end else begin
      neuron_addr_U  <= neuron_addr_R;
      neuron_addr_W  <= neuron_addr_U;
      synapse_addr_U <= synapse_addr_R;
      synapse_addr_W <= synapse_addr_U;
    end
  end
  /***************************************************************************************************
  //cpt_rst
  当在线学习启用时，如果上一时间步有目标神经元发放，cpt_rst 信号会被置为高电平，
  更新模块 I 会重置所有输入的目标神经元的膜电位和不应期，以达到竞争学习的目的。
  ****************************************************************************************************/
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cpt_rst <= 1'b0;
    end else begin
      unique if ((w_state == UPDATE_II) && spike) begin
        cpt_rst <= 1'b1;
      end else if ((u_state == UPDATE_I) && (neuron_addr_U == tar_number)) begin
        // TODO: 可以直接把 R 级的 UPDATE_I 结束标志延迟一拍过来用
        cpt_rst <= 1'b0;
      end else begin
        cpt_rst <= cpt_rst;
      end
    end
  end

  /***************************************************************************************************
  addr_cnt 复用：
  1. UPDATE_I UPDATE_II 时，计数目标神经元的地址
  2. LEARN 时，计数源神经元的地址
  ****************************************************************************************************/
  logic [7:0] addr_cnt;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      addr_cnt <= 8'b0;
    end else begin
      unique
      //if (state != UPDATE_I && next_state == UPDATE_I) begin
      //   // 进入 UPDATE_I
      //   addr_cnt <= 8'b0;
      //end  
      //else if (state != UPDATE_II && next_state == UPDATE_II) begin
      //        // 进入 UPDATE_II
      //        addr_cnt <= 8'b0;
      //      end
      //else 
      if ((state == UPDATE_II || state == UPDATE_I) && (neuron_addr_R == tar_number)) begin
        // UPDATE_I UPDATE_II  处理最后一个目标神经元 （含进入 UPDATE_II）
        addr_cnt <= 8'b0;
      end else if (state == LEARN && (synapse_addr_R[15:8] == src_number)) begin
        // LEARN 处理最后一个源神经元 （含退出 LEARN ， 即进入 UPDATE_I 时必已经复位）
        addr_cnt <= 8'b0;
      end else if (state == IDLE) begin
        addr_cnt <= addr_cnt;
      end else begin
        addr_cnt <= addr_cnt + 1'b1;
      end
    end
  end
  assign neuron_addr_R = (state == UPDATE_I || state == UPDATE_II) ? addr_cnt : 8'b0;  // 即为神经元更新时的目标神经元地址
  logic [7:0] source_addr_reg, target_addr_reg;
  pipeline_ctrl #(
      .PIPELINE_REG_WIDTH(8)
  ) pipeline_ctrl_in (
      .clk(clk),
      .rst_n(rst_n),
      .last_bus(source_addr),
      .last_to_this_valid(!inputFIFO_empty),
      .next_allow_in(1'b1),
      .ready_go(1'b1),
      .this_reg(source_addr_reg)
  );
  pipeline_ctrl #(
      .PIPELINE_REG_WIDTH(8)
  ) pipeline_ctrl_out (
      .clk(clk),
      .rst_n(rst_n),
      .last_bus(target_addr),
      .last_to_this_valid(!outputFIFO_empty),
      .next_allow_in(1'b1),
      .ready_go(1'b1),
      .this_reg(target_addr_reg)
  );
  always_comb begin
    unique case (state)
      // 根据读取的源神经元地址 𝑖 和目标神经元地址 𝑗 得到突触权重地址
      UPDATE_II: synapse_addr_R = {source_addr_reg, addr_cnt};
      LEARN: synapse_addr_R = {addr_cnt, target_addr_reg};
      default: synapse_addr_R = '0;
    endcase
  end

  /***************************************************************************************************
  UPDATE_II 对目标神经元地址递增后，判断 j 与 N 的关系。
  如果此时 j = N 说明已经对所有激活的目标神经元完成更新，
  控制模块会通知对应的输入缓存 FIFO 弹出数据。
  // 注：pop 发生在 pop 信号拉高的下一个上升沿
  ****************************************************************************************************/
  // assign inputFIFO_pop = (state == UPDATE_II) && (neuron_addr_R == tar_number - 1);
  always_comb begin
    unique if (tar_number == 8'd0) begin
      // 只有一个目标神经元
      inputFIFO_pop = (next_state == UPDATE_II);
    end else begin
      inputFIFO_pop = (state == UPDATE_II) && (neuron_addr_R == tar_number - 1);
    end
  end
  /***************************************************************************************************
  LEARN 对源神经元地址递增后，判断 𝑖 与 𝑀 的关系。
  如果此时𝑖 = 𝑀 ，说明所有突触更新完，
  控制模块会通知对应的输出缓存 FIFO 弹出数据。
  // 注：pop 发生在 pop 信号拉高的下一个上升沿
  ****************************************************************************************************/
  // assign outputFIFO_pop = (state == LEARN) && (synapse_addr_R[15:8] == src_number - 1);
  always_comb begin
    unique if (src_number == 8'd0) begin
      // 只有一个源神经元
      outputFIFO_pop = (next_state == LEARN);
    end else begin
      outputFIFO_pop = (state == LEARN) && (synapse_addr_R[15:8] == src_number - 1);
    end
  end
  /***************************************************************************************************
  UPDATE_I：从存储模块中依次取出目标神经元的神经元数据对其进行更新，并在下一个时钟周期写回存储模块
  UPDATE_II：经 LIF 神经元模块更新后的神经元数据和突触数据会被回写到存储模块中。
  如果启用了在线学习则神经元数据和突触数据均会被回写，反则则仅会回写神经元数据。
  LEARN: 更新后的突触信息会回写到突触存储模块中
  ****************************************************************************************************/
  assign neuron_W  = (w_state == UPDATE_II) || (w_state == UPDATE_I);
  assign synapse_W = (w_state == LEARN) || ((w_state == UPDATE_II) && enable_learn);

  /***************************************************************************************************
  其它说明：
  1. 
  ****************************************************************************************************/

  // TODO: 找学长要源码

endmodule
