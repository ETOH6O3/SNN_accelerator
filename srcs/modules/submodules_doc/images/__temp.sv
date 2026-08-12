//! {reg: [
//!    { "name": "calcium",   "bits": 4,"type": 3 },
//!     { "name": "t_ref",   "bits": 4,"type": 4 },
//!     { "name": "v_mem", "bits": 16,"type": 5 },
//!]}


module __temp
(
    input  logic              clk,
    input  logic              enable_learn,
    input  logic              inputFIFO_empty,
    input  logic              outputFIFO_empty,
    input  logic              rst_n,
    input  logic       [ 7:0] source_addr,
    input  logic              spike,             // W 级
    input  logic       [ 7:0] src_number,
    input  logic       [ 7:0] tar_number,
    input  logic       [ 7:0] target_addr,
    input  logic              timestep0,
    output logic              cpt_rst,           // U 级
    output work_mode_e        ctrl_step,         // U 级
    output logic              inputFIFO_pop,
    output logic              neuron_W,
    output logic       [ 7:0] neuron_addr_R,
    output logic       [ 7:0] neuron_addr_W,
    output logic              outputFIFO_pop,
    output logic              synapse_W,
    output logic       [15:0] synapse_addr_R,
    output logic       [15:0] synapse_addr_W
);
  logic timestep_changed;
  logic timestep0_d;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      timestep0_d <= 1'b0;
    end else begin
      timestep0_d <= timestep0;
    end
  end

  work_mode_t state;
  work_mode_t nextstate;

  // 状态机
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= UPDATE_I;
    end else begin
      state <= nextstate;
    end
  end

  always_comb begin
    nextstate = state;
    unique case (state)
      IDLE: begin
        if (timestep_changed) begin
          nextstate = UPDATE_I;
        end
      end
      UPDATE_I : begin
        if ((neuron_addr_R == tar_number)) begin
          // nextstate = inputFIFO_empty ? IDLE : UPDATE_II;
          if (inputFIFO_empty) begin
            nextstate = IDLE;
          end else begin
            nextstate = UPDATE_II;
          end
        end
      end
      UPDATE_II : begin
        if (inputFIFO_empty && (neuron_addr_R == tar_number)) begin
          // nextstate = enable_learn ? (outputFIFO_empty ? IDLE : LEARN) : IDLE;
          if (enable_learn) begin
            if (outputFIFO_empty) begin
              nextstate = IDLE;
            end else begin
              nextstate = LEARN;
            end
          end else begin
            nextstate = IDLE;
          end
        end
      end
      LEARN : begin
        if (outputFIFO_empty && (synapse_addr_R[15:8] == src_number)) begin
          nextstate = IDLE;
        end
      end
    endcase
  end





endmodule
