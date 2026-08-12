// ====================================================================
// Testbench: tb_Weight_Update
// 功能：验证 Weight_Update 模块的 STDP 和 SDSP 更新逻辑，
//       包括 STDP 权重限幅、x_pre 衰减（正确四舍五入），
//       SDSP 方向增/减及饱和边界。
// ====================================================================

`timescale 1ns / 1ps

module tb_Weight_Update;

    import data_types_pkg::*;
    import consts_pkg::*;

    // ---------- 信号声明 ----------
    logic clk;
    logic learn_mode;
    synapse_data_t synapse_data_i;
    learn_const_t  learn_const;
    synapse_data_t synapse_data_o;

    // 错误计数器
    int error_count = 0;

    // ---------- 实例化待测模块 ----------
    Weight_Update uut (
        .clk            (clk),
        .learn_mode     (learn_mode),
        .synapse_data_i (synapse_data_i),
        .learn_const    (learn_const),
        .synapse_data_o (synapse_data_o)
    );

    // ---------- 时钟生成 ----------
    always #5 clk = ~clk;   // 100 MHz

    // ---------- 辅助函数：计算预期输出 ----------
    function automatic synapse_data_t compute_expected(
        input logic           mode,
        input synapse_data_t  in_data,
        input learn_const_t   consts
    );
        synapse_data_t exp;
        logic signed [8:0] temp;
        logic [3:0] x_pre_in, x_pre_out;
        logic [1:0] dir;

        exp = in_data;  // 默认保持不变

        unique case (mode)
            LEARN_MODE_STDP: begin
                // 计算权重更新（饱和加法）
                temp = {in_data.weight[7], in_data.weight}
                     + {5'b00000, in_data.learn_var.x_pre}
                     - {5'b00000, consts.xtar};
                if (temp > 9'sd127)      exp.weight = 8'sd127;
                else if (temp < -9'sd128) exp.weight = -8'sd128;
                else                     exp.weight = temp[7:0];

                // 计算 x_pre 衰减（按模块实际逻辑：>5 进位）
                x_pre_in = in_data.learn_var.x_pre;
                x_pre_out = x_pre_in - (x_pre_in >> 3) - (x_pre_in[2:0] >= 4 ? 1 : 0);
                exp.learn_var.x_pre = x_pre_out;
                // 其他 learn_var 字段在 STDP 下不使用，保持原值
            end

            LEARN_MODE_SDSP: begin
                exp.learn_var = in_data.learn_var;
                dir = in_data.learn_var.synapse_change_dir;
                unique case (dir)
                    STEADY_ZERO, STEADY_ONE: begin
                        exp.weight = in_data.weight;
                    end
                    CHANGE_INCR: begin
                        exp.weight = (in_data.weight == 8'sd127) ? in_data.weight : (in_data.weight + 1);
                    end
                    CHANGE_DECR: begin
                        exp.weight = (in_data.weight == -8'sd128) ? in_data.weight : (in_data.weight - 1);
                    end
                endcase
            end
        endcase
        return exp;
    endfunction

    // ---------- 测试激励 ----------
    initial begin
        // 初始化
        clk = 0;
        learn_mode = LEARN_MODE_STDP;   // 先测 STDP
        // 使用默认学习参数（xtar = 8）
        learn_const = '{
            xtar: 4'd8,
            theta_m: 16'd256,
            ca_theta_1: 4'd3,
            ca_theta_2: 4'd8,
            ca_theta_3: 4'd13
        };

        // 准备突触数据：权重初始值、学习变量
        synapse_data_i.weight = 8'sd0;
        synapse_data_i.learn_var.x_pre = 4'd0;

        // 复位等待
        #10;

        $display("\n========== Starting Weight_Update Testbench ==========\n");

        // ------------------------------------------------------------
        // 测试 1：STDP 模式 - 权重更新（∆w = x_pre - xtar）及限幅
        // ------------------------------------------------------------
        $display("=== Test 1: STDP weight update with saturation ===");
        learn_mode = LEARN_MODE_STDP;

        // 测试不同 x_pre 和 weight 组合
        // xtar 固定为 8，故 ∆w = x_pre - 8，范围 [-8, 7]
        // 权重初始设为 120，加上 7 → 127（饱和到最大）
        // 权重初始设为 -120，减去 8 → -128（饱和到最小）
        // 权重初始设为 50，加上 5 → 55（正常）
        // 权重初始设为 -50，减去 3 → -53（正常）

        // 情况 1: 上溢饱和 (120 + 7 = 127)
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = 8'sd120;
            synapse_data_i.learn_var.x_pre = 4'd15;   // ∆w = 7
            @(posedge clk);
            #1;
            // 保留原始打印
            $display("[STDP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[STDP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: 127 (saturated)\n");
            // 自动检查
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight || synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, x_pre=%0d; Got weight=%0d, x_pre=%0d",
                        exp.weight, exp.learn_var.x_pre, synapse_data_o.weight, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 情况 2: 下溢饱和 (-120 - 8 = -128)
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = -8'sd120;
            synapse_data_i.learn_var.x_pre = 4'd0;    // ∆w = -8
            @(posedge clk);
            #1;
            $display("[STDP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[STDP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: -128 (saturated)\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight || synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, x_pre=%0d; Got weight=%0d, x_pre=%0d",
                        exp.weight, exp.learn_var.x_pre, synapse_data_o.weight, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 情况 3: 正常范围 (50 + 5 = 55)
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = 8'sd50;
            synapse_data_i.learn_var.x_pre = 4'd13;   // ∆w = 5
            @(posedge clk);
            #1;
            $display("[STDP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[STDP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: 55\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight || synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, x_pre=%0d; Got weight=%0d, x_pre=%0d",
                        exp.weight, exp.learn_var.x_pre, synapse_data_o.weight, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 情况 4: 正常范围 (-50 - 3 = -53)
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = -8'sd50;
            synapse_data_i.learn_var.x_pre = 4'd5;    // ∆w = -3
            @(posedge clk);
            #1;
            $display("[STDP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[STDP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: -53\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight || synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, x_pre=%0d; Got weight=%0d, x_pre=%0d",
                        exp.weight, exp.learn_var.x_pre, synapse_data_o.weight, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // ------------------------------------------------------------
        // 测试 2：STDP 模式 - x_pre 衰减（四舍五入）
        // 正确公式：x_pre_new = x_pre - round(x_pre / 8)
        // 注意：当前模块使用条件 (x_pre[2:0] > 5) 是错误的，
        //       应改为 >= 4。此处按正确预期打印以便对比。
        // ------------------------------------------------------------
        $display("=== Test 2: STDP x_pre decay (rounding) ===");
        synapse_data_i.weight = 8'sd0;   // 不变权重，只观察学习变量
        for (int x = 0; x <= 15; x++) begin
            automatic synapse_data_t exp;
            synapse_data_i.learn_var.x_pre = x;
            @(posedge clk);
            #1;
            // 保留原始打印（注意原代码中打印了"correct expected"）
            $display("x_pre in=%2d, out=%2d (correct expected = %2d)",
                     x, synapse_data_o.learn_var.x_pre,
                     x - ( (x >> 3) + (x[2:0] >= 4 ) )); 
            // 自动检查（使用模块的实际逻辑）
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] x_pre mismatch! Expected out=%0d, Got out=%0d",
                        exp.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                // 这里不重复打印PASS，因为上面已经显示了实际值
            end
        end

        // ------------------------------------------------------------
        // 测试 3：SDSP 模式 - 方向控制与饱和边界
        // ------------------------------------------------------------
        $display("\n=== Test 3: SDSP direction and saturation ===");
        learn_mode = LEARN_MODE_SDSP;

        // 设置学习变量为各方向
        // CHANGE_INCR  → 权重 +1（饱和到 127）
        // CHANGE_DECR  → 权重 -1（饱和到 -128）
        // STEADY_ZERO / STEADY_ONE → 不变

        // 正向增加（未饱和）
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = 8'sd10;
            synapse_data_i.learn_var.synapse_change_dir = CHANGE_INCR;
            @(posedge clk);
            #1;
            $display("[SDSP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[SDSP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: 11\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight || synapse_data_o.learn_var !== exp.learn_var) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, dir=%0d; Got weight=%0d, dir=%0d",
                        exp.weight, exp.learn_var.synapse_change_dir,
                        synapse_data_o.weight, synapse_data_o.learn_var.synapse_change_dir);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 正向增加（饱和到 127）
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = 8'sd127;
            @(posedge clk);
            #1;
            $display("[SDSP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[SDSP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: 127 (saturated)\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, Got %0d", exp.weight, synapse_data_o.weight);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 负向减少（未饱和）
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = -8'sd10;
            synapse_data_i.learn_var.synapse_change_dir = CHANGE_DECR;
            @(posedge clk);
            #1;
            $display("[SDSP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[SDSP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: -11\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, Got %0d", exp.weight, synapse_data_o.weight);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 负向减少（饱和到 -128）
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = -8'sd128;
            @(posedge clk);
            #1;
            $display("[SDSP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[SDSP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: -128 (saturated)\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, Got %0d", exp.weight, synapse_data_o.weight);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // 稳态（不应变）
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = 8'sd42;
            synapse_data_i.learn_var.synapse_change_dir = STEADY_ZERO;
            @(posedge clk);
            #1;
            $display("[SDSP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[SDSP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: 42 (unchanged)\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, Got %0d", exp.weight, synapse_data_o.weight);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        begin
            automatic synapse_data_t exp;
            synapse_data_i.learn_var.synapse_change_dir = STEADY_ONE;
            @(posedge clk);
            #1;
            $display("[SDSP] Input:  %s", synapse_data_to_string(synapse_data_i));
            $display("[SDSP] Output: %s", synapse_data_to_string(synapse_data_o));
            $display("Expected weight: 42 (unchanged)\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.weight !== exp.weight) begin
                $error("  [AUTO-CHECK] Mismatch! Expected weight=%0d, Got %0d", exp.weight, synapse_data_o.weight);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // ------------------------------------------------------------
        // 测试 4：学习变量在 SDSP 模式下不应改变
        // ------------------------------------------------------------
        $display("=== Test 4: SDSP learn_var passthrough ===");
        begin
            automatic synapse_data_t exp;
            synapse_data_i.weight = 8'sd0;
            synapse_data_i.learn_var.synapse_change_dir = CHANGE_INCR;
            @(posedge clk);
            #1;
            $display("Input learn_var = %d, Output learn_var = %d",
                     synapse_data_i.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
            $display("Expected: learn_var unchanged (passthrough)\n");
            exp = compute_expected(learn_mode, synapse_data_i, learn_const);
            if (synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected x_pre=%0d, Got %0d",
                        exp.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end

        // test 5 论文一致性

        $display("=== Test 5: Consistency with paper  ===");
        begin
            automatic synapse_data_t exp;
            learn_mode = LEARN_MODE_STDP;
            synapse_data_i.learn_var = 4'd0;
            synapse_data_i.weight = -8'sd122;
            @(posedge clk);
            #1;
            $display("Input learn_var = %d, Output learn_var = %d",
                     synapse_data_i.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
            exp = '{learn_var: 4'd0, weight: -8'sd128};
            if (synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected x_pre=%0d, Got %0d",
                        exp.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end
        begin
            automatic synapse_data_t exp;
            learn_mode = LEARN_MODE_STDP;
            synapse_data_i.learn_var = 4'd10;
            synapse_data_i.weight = -8'sd76;
            @(posedge clk);
            #1;
            $display("Input learn_var = %d, Output learn_var = %d",
                     synapse_data_i.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
            exp = '{learn_var: 4'd9, weight: -8'sd74};
            if (synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected x_pre=%0d, Got %0d",
                        exp.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end
        begin
            automatic synapse_data_t exp;
            learn_mode = LEARN_MODE_STDP;
            synapse_data_i.learn_var = 4'd4;
            synapse_data_i.weight = -8'sd14;
            @(posedge clk);
            #1;
            $display("Input learn_var = %d, Output learn_var = %d",
                     synapse_data_i.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
            exp = '{learn_var: 4'd3, weight: -8'sd18};
            if (synapse_data_o.learn_var.x_pre !== exp.learn_var.x_pre) begin
                $error("  [AUTO-CHECK] Mismatch! Expected x_pre=%0d, Got %0d",
                        exp.learn_var.x_pre, synapse_data_o.learn_var.x_pre);
                error_count++;
            end else begin
                $display("  [AUTO-CHECK] PASS");
            end
        end
        // ------------------------------------------------------------
        // 最终报告
        // ------------------------------------------------------------
        $display("\n========== Testbench completed ==========");
        if (error_count == 0) begin
            $display("All tests PASSED (auto-check).");
        end else begin
            $display("ERROR: %0d test(s) FAILED (auto-check).", error_count);
        end
        $finish;
    end

endmodule