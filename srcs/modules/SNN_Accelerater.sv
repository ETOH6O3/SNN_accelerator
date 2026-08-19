`timescale 1ns / 1ps
module SNN_Accelerater
  import data_types_pkg::*;
#(
    parameter integer unsigned SrcNum = 256,
    parameter integer unsigned TarNum = 256,
    parameter neuron_const_t NeuronConst = '{v_thr: 16'd22768, t_ref: 4'd7},
    parameter learn_const_t LearnConst = '{
        xtar: 4'd8,
        theta_m: 16'd256,
        ca_theta_1: 4'd3,
        ca_theta_2: 4'd8,
        ca_theta_3: 4'd13
    },
    parameter integer unsigned SrcSpikePerStepMaxExp = SrcNum,
    parameter integer unsigned SpikePerStepMaxExp = TarNum
) (
    input logic         clk,           //! 时钟信号
    input logic         rst_n,         //! 复位信号
          aer_if.sink   aer_r,         //! AER输入接口
          aer_if.source aer_t,         //! AER输出接口
    input logic         enable_learn,  //! 学习使能
    input learn_mode_e  learn_mode     //! 学习模式选择
);
  // 导出参数
  localparam integer unsigned IntervalLearnDE = (SrcSpikePerStepMaxExp + 1) * TarNum;
  localparam integer unsigned Interval = IntervalLearnDE + SpikePerStepMaxExp * SrcNum;

  localparam integer unsigned SynapseNum = SrcNum * TarNum;
  // ------------------------------------------信号声明--------------------------------------------------
  // TIME
  logic timestep0;
  // IO
  logic in_fifo_pop, in_fifo_empty;
  logic [7:0] source_addr;
  logic [7:0] target_addr;
  logic aer_out_fifo_vld, aer_pop_out_fifo;
  logic out_fifo_vld, out_fifo_pop;
  // UPDATE
  logic spike, cpt_rst, enable_learn_reg;
  learn_mode_e learn_mode_reg;
  work_mode_e  ctrl_step;
  // RAM
  logic neuron_W, synapse_W;
  logic [ 7:0] neuron_addr_R;
  logic [ 7:0] neuron_addr_W;
  logic [15:0] synapse_addr_R;
  logic [15:0] synapse_addr_W;
  // CU
  logic cu_out_fifo_vld, cu_pop_out_fifo;
  neuron_data_t neuron_data_i, neuron_data_o;
  synapse_data_t synapse_data_i, synapse_data_o;

  // ------------------------------------------时间产生模块--------------------------------------------------
  Time_Gen Time_Gen_inst (
      .clk(clk),
      .rst_n(rst_n),
      .interval(enable_learn_reg ? Interval : IntervalLearnDE),
      .timestep0(timestep0)
  );
  logic timestep0_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      timestep0_d <= 1'b0;
    end else begin
      timestep0_d <= timestep0;
    end
  end

  // ------------------------------------------ CU --------------------------------------------------

  Controller Controller_inst (
      .clk(clk),
      .enable_learn(enable_learn_reg),
      .inputFIFO_empty(in_fifo_empty),
      .outputFIFO_empty(!cu_out_fifo_vld),
      .rst_n(rst_n),
      .source_addr(source_addr),
      .spike(spike),
      .src_number(SrcNum - 1'b1  /*转为移一码*/),
      .tar_number(TarNum - 1'b1  /*转为移一码*/),
      .target_addr(target_addr),
      .timestep0(timestep0),
      .cpt_rst(cpt_rst),
      .ctrl_step(ctrl_step),
      .inputFIFO_pop(in_fifo_pop),
      .neuron_W(neuron_W),
      .neuron_addr_R(neuron_addr_R),
      .neuron_addr_W(neuron_addr_W),
      .outputFIFO_pop(cu_pop_out_fifo),
      .synapse_W(synapse_W),
      .synapse_addr_R(synapse_addr_R),
      .synapse_addr_W(synapse_addr_W)
  );

  // ------------------------------------------ AER 输入输出--------------------------------------------------

  AERInput AERInput_inst (
      .clk(clk),
      .rst_n(rst_n),
      .AER_rx(aer_r),
      .timestep0(timestep0),
      .FIFO_pop(in_fifo_pop),
      .FIFO_empty(in_fifo_empty),
      .source_addr(source_addr)
  );

  AEROutput AEROutput_inst (
      .clk(clk),
      .rst_n(rst_n),
      .AER_tx(aer_t),
      .target_addr(target_addr),
      .timestep0(timestep0),
      .valid(aer_out_fifo_vld),
      .FIFO_pop(aer_pop_out_fifo)
  );
  logic out_fifo_ready;
  AERFifo out_fifo (
      .s_axis_aresetn(rst_n),                        //input wire s_axis_aresetn
      .s_axis_aclk   (clk),                          //input wire s_axis_aclk
      .s_axis_tvalid (spike),                        //input wire s_axis_tvalid
      .s_axis_tready (out_fifo_ready),  //output wire s_axis_tready
      .s_axis_tdata  (neuron_addr_W),                //input wire [7 : 0] s_axis_tdata
      .m_axis_tvalid (out_fifo_vld),                 //output wire m_axis_tvalid
      .m_axis_tready (out_fifo_pop),                 //input wire m_axis_tready
      .m_axis_tdata  (target_addr)                   //output wire [7 : 0] m_axis_tdata
  );
  // 输出仲裁
  assign aer_out_fifo_vld = enable_learn_reg ? 1'b0 : out_fifo_vld;
  assign cu_out_fifo_vld = enable_learn_reg ? out_fifo_vld : 1'bx /*控制模块此时用不到此信号*/;
  assign out_fifo_pop = enable_learn_reg ? cu_pop_out_fifo : aer_pop_out_fifo;
  // 仿真断言
  initial begin
    wait(rst_n === 1'b1);
    forever begin
      @(posedge clk);
      assert (out_fifo_ready || (ctrl_step !== UPDATE_II)) else begin
        $fatal(1, "[SNN_Accelerater] @%0t: ERROR: out_fifo not ready", $time);
      end
    end
  end

  // ------------------------------------------内存--------------------------------------------------
  BRAM_24X256 neuron_mem (
      .clka (clk),            // input wire clka
      .wea  (neuron_W),       // input wire [0 : 0] wea
      .addra(neuron_addr_W),  // input wire [7 : 0] addra
      .dina (neuron_data_o),  // input wire [23 : 0] dina
      .clkb (clk),            // input wire clkb
      .addrb(neuron_addr_R),  // input wire [7 : 0] addrb
      .doutb(neuron_data_i)   // output wire [23 : 0] doutb
  );
  BRAM_12X65536 synapse_mem (
      .clka (clk),             // input wire clka
      .wea  (synapse_W),       // input wire [0 : 0] wea
      .addra(synapse_addr_W),  // input wire [15 : 0] addra
      .dina (synapse_data_o),  // input wire [11 : 0] dina
      .clkb (clk),             // input wire clkb
      .addrb(synapse_addr_R),  // input wire [15 : 0] addrb
      .doutb(synapse_data_i)   // output wire [11 : 0] doutb
  );

  // ------------------------------------------运算--------------------------------------------------

  // 流水线 RAW 冲突解决 - 旁路
  neuron_data_t neuron_data_i_confilct_free;
  typedef integer unsigned __ui;
  generate
    case (TarNum)
      __ui'(1): begin : gen_neuron_bypass_distance_1
        assign neuron_data_i_confilct_free = (ctrl_step == UPDATE_I) ? neuron_data_i : neuron_data_o;
      end
      // NOTE: RAM IP 核配置位写优先，已解决距离为 2 的冲突
      default:
      begin : gen_neuron_bypass_default
        assign neuron_data_i_confilct_free = neuron_data_i;
      end
    endcase
  endgenerate
  synapse_data_t synapse_data_i_conflict_free;
  generate
    case (SynapseNum)
      __ui'(1): begin : gen_synapse_bypass_distance_1
        assign synapse_data_i_conflict_free = (ctrl_step == UPDATE_II) ? synapse_data_i : synapse_data_o;
      end
      default:
      begin : gen_synapse_bypass_default
        assign synapse_data_i_conflict_free = synapse_data_i;
      end
    endcase
  endgenerate

  logic weight_update_en;
  synapse_data_t update_synapse_data_o, learn_synapse_data_o;
  LIF_Neuron LIF_Neuron_inst (
      .clk(clk),
      .cpt_rst(cpt_rst),
      .ctrl_step(ctrl_step),
      .enable_learn(enable_learn_reg),
      .learn_mode(learn_mode_reg),
      .neuron_const(NeuronConst),
      .learn_const(LearnConst),
      .neuron_data_i(neuron_data_i_confilct_free),
      .synapse_data_i(synapse_data_i_conflict_free),
      .neuron_data_o(neuron_data_o),
      .spike(spike),
      .synapse_data_o(update_synapse_data_o)
  );
  Weight_Update Weight_Update_inst (
      .clk(clk),
      .learn_mode(learn_mode_reg),
      .synapse_data_i(weight_update_en ? synapse_data_i_conflict_free : '0  /*操作数隔离*/),
      .learn_const(LearnConst),
      .synapse_data_o(learn_synapse_data_o)
  );
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      enable_learn_reg <= enable_learn;
      learn_mode_reg   <= learn_mode;
    end else if (timestep0_d != timestep0) begin
      enable_learn_reg <= enable_learn;
      learn_mode_reg   <= learn_mode;
    end
  end
  assign weight_update_en = (ctrl_step == LEARN);
  assign synapse_data_o   = (!neuron_W) /*w_state != LEARN*/ ? learn_synapse_data_o : update_synapse_data_o;



endmodule
