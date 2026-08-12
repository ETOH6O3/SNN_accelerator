
# Neuron_Update_II 模块 README

模块所属文件：[srcs\modules\Neuron_Update_II.sv](../Neuron_Update_II.sv)
仿真文档：[srcs\sim\sim_upd_2\README.md](../../sim/sim_upd_2/README.md)

## 模块概述

`Neuron_Update_II` 执行脉冲神经网络加速器中 **LIF 神经元更新流水线的第二阶段**运算，为纯组合逻辑模块。它负责在每个时间步内，对**收到突触前脉冲**的目标神经元执行 **膜电位累加**、**脉冲发放判断与复位**、**不应期设定**，同时为学习算法**预计算学习变量**。

*参见论文[《基于FPGA的高能效脉冲神经网络硬件加速器设计》](../../../吴宗繁%20基于FPGA的高能效脉冲神经网络硬件加速器设计.pdf)第 3.2.2 节*

---

## 接口概览

![接口](./images/Neuron_Update_II.svg "Diagram")

| Port name      | Direction | Type           | Description |
| -------------- | --------- | -------------- | ----------- |
| enable_learn   | input     | logic          | 是否启用在线学习    |
| learn_const    | input     | learn_const_t  | 学习常数        |
| learn_mode     | input     | learn_mode_e   | 学习模式        |
| neuron_const   | input     | neuron_const_t | 神经元常数       |
| neuron_data_i  | input     | neuron_data_t  | 输入的神经元数据    |
| synapse_data_i | input     | synapse_data_t | 输入的突触数据     |
| neuron_data_o  | output    | neuron_data_t  | 输出的神经元数据    |
| spike          | output    | logic          | 脉冲发放标志      |
| synapse_data_o | output    | synapse_data_t | 输出的突触数据     |

数据类型的定义以及**编码方式**见：

- [data_types_pkg.md](./data_types_pkg.md)
- [《基于FPGA的高能效脉冲神经网络硬件加速器设计》](../../../吴宗繁%20基于FPGA的高能效脉冲神经网络硬件加速器设计.pdf) 表 3-2

---

## 时序

全组合逻辑，输出当周期内有效。

---

## 功能描述

### 1. 膜电位累加

- 仅当目标神经元 **不在不应期**（`t_ref == 0`）时，才累加输入电流（等于当前突触权重）。
- 运算（*式 3-1 3-3*）：  
  \[
  V_{\text{mem}}[t] = V_{\text{mem}}[t-1] + w_{i,j}
  \]
- **溢出处理**：
  - 下溢：钳位为 0
  - 上溢：真实场景下，膜电位最大值与发放阈值的差不会小于权重值，故上溢不会发生

### 2. 脉冲发放

- 若累加后的膜电位达到 `neuron_const.v_thr`，则：
  - 发放脉冲（`spike = 1`）
  - 膜电位重置为静息电位 `VRest`
  - 不应期计数器设为 `neuron_const.t_ref`
- *在后续的 UPDATE I 阶段，不应期会逐时间步递减，期间不进行任何泄漏和累加。*

### 3. 在线学习参数预计算

仅在 `enable_learn = 1` 时启用。

#### STDP 模式

- 钙变量：清零
- 突触前迹：对当前突触的 `learn_var.x_pre` 递增 1（**最大 15**）

#### SDSP 模式

- 钙变量：若当前神经元发放脉冲（`spike == 1`），则钙变量增加 `Jc`（常数 2），**最大 15**
- 突触变化方向（*式 2-9*）： \[ \begin{cases} W \to W + a  \text{ if } V_{mem} \ge \theta_m \text{ and } \theta_1 \le Ca \le \theta_3 \\ W \to W - b  \text{ if } V_{mem} < \theta_m \text{ and } \theta_1 \le Ca \le \theta_2 \end{cases} \]

---

*其它链接*：

- *[顶层模块文档、包和模块文档导航](../README.md)*
