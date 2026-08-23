
module aer_loop_tb;
  import logger_pkg::*;

  // Logger 实例
  logger lg;
  initial begin
    lg = new(.logger_file_name("sim_aer.log"));
  end

  // Parameters

  //Ports
  reg clk1;
  reg clk2;
  reg rst_n;
  wire dbg_aer_req;
  wire dbg_aer_ack;
  wire [9:0] dbg_aer_addr;
  wire dbg_s_axis_tvalid;
  wire dbg_s_axis_tready;
  wire [9:0] dbg_s_axis_tdata;
  wire dbg_m_axis_tvalid;
  wire dbg_m_axis_tready;
  wire [9:0] dbg_m_axis_tdata;
  wire dbg_init_over;
  reg injection_en;
  reg inj_vld;
  reg [9:0] inj_data;
  wire inj_ready;

  aer_loop __aer_test_inst (
      .clk1(clk1),
      .clk2(clk2),
      .rst_n(rst_n),
      .dbg_aer_req(dbg_aer_req),
      .dbg_aer_ack(dbg_aer_ack),
      .dbg_aer_addr(dbg_aer_addr),
      .dbg_s_axis_tvalid(dbg_s_axis_tvalid),
      .dbg_s_axis_tready(dbg_s_axis_tready),
      .dbg_s_axis_tdata(dbg_s_axis_tdata),
      .dbg_m_axis_tvalid(dbg_m_axis_tvalid),
      .dbg_m_axis_tready(dbg_m_axis_tready),
      .dbg_m_axis_tdata(dbg_m_axis_tdata),

      .dbg_init_over(dbg_init_over),

      .injection_en(injection_en),
      .inj_vld(inj_vld),
      .inj_data(inj_data),
      .inj_ready(inj_ready),
      .open_loop_allow_out(1'b1)
  );

  initial begin
    clk1  = 0;
    clk2  = 0;
    rst_n = 0;
    #100;
    rst_n = 1;

  end

  reg  [7:0] hp1;
  reg  [7:0] hp2;
  wire [7:0] hp1_w = hp1;
  wire [7:0] hp2_w = hp2;

  always #(hp1_w * 1ns) clk1 = !clk1;
  always #(hp2_w * 1ns) clk2 = !clk2;

  string __temp;
  initial begin

    hp1 = 8;
    hp2 = 12;

    // 临时卡住不更改周期
    forever begin
      #1000us;
    end

    forever begin
      // 随机设置悬殊的周期

      repeat (100) begin
        @(posedge clk1);
        @(posedge clk2);
      end

      hp1 = $urandom_range(6, 10);
      hp2 = $urandom_range(60, 100);

      repeat (100) begin
        @(posedge clk1);
        @(posedge clk2);
      end

      hp2 = $urandom_range(6, 10);
      hp1 = $urandom_range(60, 100);

      // 随机设置相近的周期

      repeat (100) begin
        @(posedge clk1);
        @(posedge clk2);
      end

      hp2 = $urandom_range(10, 15);
      hp1 = $urandom_range(10, 15);
    end
  end

  initial begin

    automatic int error_count = 0;

    injection_en = 0;
    inj_vld = 0;
    inj_data = '0;

    wait (rst_n);
    wait (dbg_init_over);

    // TEST1: 累加循环
    lg.display("test 1: acc & loop");
    for (int i = 0; i != 10'h3ff; i++) begin
      @(posedge dbg_m_axis_tvalid);
      if (dbg_m_axis_tdata != i) begin
        lg.error($sformatf("Expected %d, got %d", i, dbg_m_axis_tdata));
        error_count++;
      end
      @(posedge clk2);
      #1ps;
    end

    // TEST2: 极高密度注入数据
    lg.display("test 2: high density injection");
    begin
      automatic logic [9:0] inj_datas[$];

      // force hp2 = 6;
      // force hp1 = 600;

      injection_en = 1;
      // 待回环清空
      repeat (100) begin
        @(posedge clk1);
        @(posedge clk2);
      end

      @(posedge clk2);
      #1ps;
      inj_vld = 1;
      fork
        for (int i = 0; i != 10'h3ff; i++) begin
          while (1) begin
            @(posedge clk2);
            #1ps;
            if (inj_ready) begin
              break;
            end
          end
          inj_datas.push_back(inj_data);
          #1ns inj_data = $urandom_range(0, 10'h3ff);
          __temp = {"report queue: "};
          foreach (inj_datas[i]) __temp = {__temp, $sformatf("%d ", inj_datas[i])};
          lg.trace(__temp);

          #1ps;

          // 恢复普通密度
          if (i == 10'd500) begin
            release hp2;
            release hp1;
          end
        end

        while (injection_en) begin
          @(posedge dbg_m_axis_tvalid);
          if (dbg_m_axis_tdata != inj_datas[0]) begin
            lg.error($sformatf("Expected %d, got %d", inj_datas[0], dbg_m_axis_tdata));
            error_count++;
          end
          inj_datas.pop_front();
          __temp = {"report queue: "};
          foreach (inj_datas[i]) __temp = {__temp, $sformatf("%d ", inj_datas[i])};
          lg.trace(__temp);
          #1ps;
        end

      join_any

      inj_vld = 0;
      // 待开环清空
      wait (inj_datas.size() == 0);
      injection_en = 0;

    end

    // over
    if (error_count == 0) begin
      set_ansi_style(SuccessStyle);
      lg.display("Simulation completed: ALL CHECKS PASSED");
    end else begin
      set_ansi_style(ErrorStyle);
      lg.display($sformatf("Simulation completed: SOME CHECKS FAILED"));
    end
    set_ansi_style('{UNDERLINE});
    lg.write($sformatf("Total errors: %0d", error_count));
    reset_style();

    $display("");
    $finish(0);

  end

endmodule
