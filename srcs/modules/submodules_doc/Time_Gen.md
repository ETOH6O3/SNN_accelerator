# Time\_Gen 模块 README

模块所属文件：[srcs\modules\Time\_Gen.sv](../Time_Gen.sv)

## 模块概述

`Time_Gen` 是脉冲神经网络加速器中的 **时间产生模块**。它使用一个计数器产生时间步信号 `timestep0`，用于标识当前当前时间步的奇偶。

_参见论文[《基于 FPGA 的高能效脉冲神经网络硬件加速器设计》](../../../吴宗繁%20基于FPGA的高能效脉冲神经网络硬件加速器设计.pdf)第 4.3 节_

---

## 接口概览

| Port name | Direction | Type          | Description    |
| --------- | --------- | ------------- | -------------- |
| clk       | input     | logic         | 时钟信号           |
| rst\_n    | input     | logic         | 复位信号           |
| interval  | input     | logic [17:0] | 时间步长度 (/ticks) |
| timestep0 | output    | logic         | 时间步信号最低位       |

---

## 功能描述

内部维护一个计数器，从 0 累加至 `interval - 1`，计满后归零并翻转 `timestep0`，如此循环往复

---

_其它链接_：

- _[顶层模块文档、包和模块文档导航](../README.md)_
