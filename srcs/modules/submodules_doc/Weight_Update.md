
# Weight_Update 模块 README

模块所属文件： [srcs\modules\Weight_Update.sv](../Weight_Update.sv)
仿真文档： [srcs\sim\sim_weight_upd\README.md](../../sim/sim_weight_upd/README.md)

## 模块概述

`Weight_Update`是脉冲神经网络加速器中的 **权重更新模块**，一级全流水设计。该模块实现突触的在线学习功能，根据当前学习算法和学习变量**更新突触权重**。

*参见论文[《基于FPGA的高能效脉冲神经网络硬件加速器设计》](../../../吴宗繁%20基于FPGA的高能效脉冲神经网络硬件加速器设计.pdf)第 3.3 节*

## 接口概览

![Diagram](./images/Weight_Update.svg "Diagram")

| Port name      | Direction | Type           | Description |
| -------------- | --------- | -------------- | ----------- |
| clk            | input     | logic          | 时钟信号        |
| learn_mode     | input     | logic          | 学习模式选择      |
| synapse_data_i | input     | synapse_data_t | 输入的突触数据     |
| learn_const    | input     | learn_const_t  | 学习常数        |
| synapse_data_o | output    | synapse_data_t | 输出的突触数据     |

数据类型的定义以及**编码方式**见：

- [data_types_pkg.md](./data_types_pkg.md)
- [《基于FPGA的高能效脉冲神经网络硬件加速器设计》](../../../吴宗繁%20基于FPGA的高能效脉冲神经网络硬件加速器设计.pdf) 表 3-2

---

## 时序

**一级全流水**，打一拍输出。

输入和运算处于顶层模块三级全流水设计中的 U （运算和更新）阶段，输出处于 W （写回）阶段。

---

## 功能描述

根据当前学习算法和学习变量更新突触权重。权重更新全部做防溢出处理。

### STDP 学习算法

- 权重更新：*（式 3-4）*
  \[\Delta w = x_{pre} - x_{tar}\]
- 以时间常数 8 对 \(x_{pre}\) 进行衰减。舍入规则为**运算后再四舍五入**。

### SDSP 学习算法

权重更新（*式 2-9*）：

\[ \begin{cases} W \to W + a  \text{ if } V_{mem} \ge \theta_m \text{ and } \theta_1 \le Ca \le \theta_3 \\ W \to W - b  \text{ if } V_{mem} < \theta_m \text{ and } \theta_1 \le Ca \le \theta_2 \end{cases} \]

其中，a 和 b 取 1 *（论文 5.1.2 章节）*

---

*其它链接*：

- *[顶层模块文档、包和模块文档导航](../README.md)*
