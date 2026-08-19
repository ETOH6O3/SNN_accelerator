# IP 核配置说明

<!-- ## 工程信息

- Vivado 版本：**2025.1**
- 器件：**Kintex-7 xc7k70tfbv676-1**
- 所有 IP 均为 **Managed IP**，综合流程为 **OUT_OF_CONTEXT (OOC)**
- HDL 语言：Verilog；仿真语言：Mixed -->

## IP 总览

| 生成 IP 名 | 目录 | IP 核（VLNV） |
| --- | --- | --- |
| AERFifo | [sources_1/ip/AERFifo/AERFifo.xci](../../SNN_accelerator.srcs/sources_1/ip/AERFifo/AERFifo.xci) | xilinx.com:ip:axis_data_fifo:2.0 |
| AERTestFifo | [sources_1/ip/AERTestFifo/AERTestFifo.xci](../../SNN_accelerator.srcs/sources_1/ip/AERTestFifo/AERTestFifo.xci) | xilinx.com:ip:axis_data_fifo:2.0 |
| BRAM_12X65536_2 | [sources_1/ip/BRAM_12X65536_2/BRAM_12X65536.xci](../../SNN_accelerator.srcs/sources_1/ip/BRAM_12X65536_2/BRAM_12X65536.xci) | xilinx.com:ip:blk_mem_gen:8.4 |
| BRAM_24X256 | [sources_1/ip/BRAM_24X256/BRAM_24X256.xci](../../SNN_accelerator.srcs/sources_1/ip/BRAM_24X256/BRAM_24X256.xci) | xilinx.com:ip:blk_mem_gen:8.4 |

---

## AERFifo

用作输入 / 输出 FIFO

**IP 核：** xilinx.com:ip:axis_data_fifo **2.0**（ip_revision 17）

**配置文件** [sources_1/ip/AERFifo/AERFifo.xci](../../SNN_accelerator.srcs/sources_1/ip/AERFifo/AERFifo.xci)

**配置**：

| 配置项 | 具体配置 |
| - | - |
| **数据宽度** | 8 位 |
| **FIFO 深度** | 256 |
| **工作模式** | FWFT |
| **同步 / 异步** | 同步 |
| 时钟使能信号 | 无 |
| ECC | 不启用 |
| 存储器类型 | 自动选择 |
| 整包发送模式 | 关 |
| 启用 TSTRB / TKEEP / TLAST | 否 |
| TID / TDEST / TUSER 位宽 | 全 0 |
| 写端口标志 | 全部不启用 |
| 读端口标志 | 全部不启用 |

**端口**：

| Port name | Direction | Type | Description |
| --------- | --------- | ---- | ----------- |
| s_axis_aresetn | input | wire | 低有效复位 |
| s_axis_aclk | input | wire | 写时钟 |
| s_axis_tvalid | input | wire | 写数据有效 |
| s_axis_tready | output | wire | 写就绪 |
| s_axis_tdata | input | wire [7:0] | 写入数据 |
| m_axis_tvalid | output | wire | 读数据有效 |
| m_axis_tready | input | wire | 读就绪 |
| m_axis_tdata | output | wire [7:0] | 读出数据 |

---

## AERTestFifo

在 aer_loop 测试模块中用于跨时钟域传输 AXIS 数据

**IP 核：** xilinx.com:ip:axis_data_fifo **2.0**（ip_revision 17）

**配置文件** [sources_1/ip/AERTestFifo/AERTestFifo.xci](../../SNN_accelerator.srcs/sources_1/ip/AERTestFifo/AERTestFifo.xci)

**配置**：

| 配置项 | 具体配置 |
| - | - |
| **数据宽度** | 16 位 |
| **FIFO 深度** | 64 |
| **工作模式** | FWFT |
| **同步 / 异步** | 异步 |
| **CDC** | 2 级同步 |
| 时钟使能信号 | 无 |
| ECC | 不启用 |
| 存储器类型 | 自动选择 |
| 整包发送模式 | 关 |
| 启用 TSTRB / TKEEP / TLAST | 否 |
| TID / TDEST / TUSER 位宽 | 全 0 |
| 写端口标志 | 全部不启用 |
| 读端口标志 | 全部不启用 |

**端口**：

| Port name | Direction | Type | Description |
| --------- | --------- | ---- | ----------- |
| s_axis_aresetn | input | wire | 低有效复位 |
| s_axis_aclk | input | wire | 写时钟 |
| s_axis_tvalid | input | wire | 写数据有效 |
| s_axis_tready | output | wire | 写就绪 |
| s_axis_tdata | input | wire [15:0] | 写入数据 |
| m_axis_aclk | input | wire | 读时钟 |
| m_axis_tvalid | output | wire | 读数据有效 |
| m_axis_tready | input | wire | 读就绪 |
| m_axis_tdata | output | wire [15:0] | 读出数据 |

---

## BRAM_12X65536

突触内存

**IP 核：** xilinx.com:ip:blk_mem_gen **8.4**（ip_revision 11）

**配置文件** [sources_1/ip/BRAM_12X65536_2/BRAM_12X65536.xci](../../SNN_accelerator.srcs/sources_1/ip/BRAM_12X65536_2/BRAM_12X65536.xci)

**配置**：

| 配置项 | 具体配置 |
| - | - |
| **接口** | 标准原生 |
| **存储器类型** | 简单双口 RAM |
| 公共时钟 | 是 |
| ECC | 无 |
| 字节写使能 | 无 |
| 综合实现算法 | 面积优先 |
| **写端口存储** | 12 bits * 65536 |
| **工作模式** | 写优先 |
| **读端口存储** | 12 bits *\* 65536* |
| 端口使能 | 始终 |
| 输出寄存器 | 不启用 |
| 输出复位 | 无 |
| **加载初始化文件** | 是 |
| 冲突告警 | 关闭 |
| 溢出告警 | 开 |

(*初始化文件视需改变*)
(*写优先以解决流水线冲突*)

**端口**：

| Port name | Direction | Type | Description |
| --------- | --------- | ---- | ----------- |
| clka | input | wire | 写时钟 |
| wea | input | wire | 写使能 |
| addra | input | wire [15:0] | 写地址 |
| dina | input | wire [11:0] | 写入数据 |
| clkb | input | wire | 读时钟 |
| addrb | input | wire [15:0] | 读地址 |
| doutb | output | wire [11:0] | 读出数据 |

---

## BRAM_24X256

神经元内存

**IP 核：** xilinx.com:ip:blk_mem_gen **8.4**（ip_revision 11）

**配置文件** [sources_1/ip/BRAM_24X256/BRAM_24X256.xci](../../SNN_accelerator.srcs/sources_1/ip/BRAM_24X256/BRAM_24X256.xci)

**配置**：

| 配置项 | 具体配置 |
| - | - |
| **接口** | 标准原生 |
| **存储器类型** | 简单双口 RAM |
| 公共时钟 | 是 |
| ECC | 无 |
| 字节写使能 | 无 |
| 综合实现算法 | 面积优先 |
| **写端口存储** | 24 bits * 256 |
| **工作模式** | 写优先 |
| **读端口存储** | 24 bits *\* 256* |
| 端口使能 | 始终 |
| 输出寄存器 | 不启用 |
| 输出复位 | 无 |
| **加载初始化文件** | 是 |
| **初始化文件** | [neuron_mem.coe](../coe/neuron_mem.coe) |
| 冲突告警 | 关闭 |
| 溢出告警 | 开 |

(*写优先以解决流水线冲突*)

**端口**：

| Port name | Direction | Type | Description |
| --------- | --------- | ---- | ----------- |
| clka | input | wire | 写时钟 |
| wea | input | wire | 写使能 |
| addra | input | wire [7:0] | 写地址 |
| dina | input | wire [23:0] | 写入数据 |
| clkb | input | wire | 读时钟 |
| addrb | input | wire [7:0] | 读地址 |
| doutb | output | wire [23:0] | 读出数据 |
