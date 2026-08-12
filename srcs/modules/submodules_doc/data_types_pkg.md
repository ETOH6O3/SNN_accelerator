
# Package: data_types_pkg

包所属文件: [srcs/modules/data_types_pkg.sv](../data_types_pkg.sv)

## 打包结构体

### neuron_data_t

神经元数据

![neuron_data_t 的位域](./images/neuron_data_t.svg)

| 成员 | 类型 | 描述 | 编码 / 数据类型 |
| - | - | - | - |
| v_mem | logic [15:0] | 神经元的膜电位 | U9.7 定点数 |
| t_ref | logic [3:0] | 神经元的不应期时间 | 无符号整型 |
| calcium | logic [3:0] | 神经元的钙变量 | 无符号整型 |

> [!NOTE] 相关函数
>
> ```verilog
> // 将 neuron_data_t 格式化为可读字符串，方便控制台输出
> function automatic string neuron_data_to_string(input neuron_data_t nd);
> ```

### neuron_const_t

神经元超参数

![neuron_const_t 的位域](./images/neuron_const_t.svg)

| 成员 | 类型 | 描述 | 编码 / 数据类型 |
| - | - | - | - |
| v_thr | logic [15:0] | 神经元的阈值电位 | U9.7 定点数 |
| t_ref | logic [3:0] | 神经元激发后不应期时间 | 无符号整型 |

### synapse_data_t

突触数据

![synapse_data_t 的位域](./images/synapse_data_t.svg)

| 成员 | 类型 | 描述 | 编码 / 数据类型 |
| - | - | - | - |
| weight | logic signed [7:0] | 突触权重值 | Q7 定点数 |
| learn_var | [learn_var_u](#learn_var_u) | 突触学习变量 | 四位联合体 |

> [!NOTE] 相关函数
>
> ```verilog
> // 将 synapse_data_t 格式化为可读字符串，方便控制台输出
> function automatic string synapse_data_to_string(input synapse_data_t sd);
> ```

### learn_const_t

学习算法超参数

![learn_const_t 的位域](./images/learn_const_t.svg)

| 成员 | 类型 | 描述 | 编码 / 数据类型 |
| - | - | - | - |
| xtar | logic [3:0] | STDP 参数 xtar | 无符号整型 |
| theta_m | logic [15:0] | SDSP 参数 theta_m | U9.7 定点数 |
| ca_theta_1 | logic [3:0] | SDSP 参数 theta_1 | 无符号整型 |
| ca_theta_2 | logic [3:0] | SDSP 参数 theta_2 | 无符号整型 |
| ca_theta_3 | logic [3:0] | SDSP 参数 theta_3 | 无符号整型 |

## 枚举类

### synapse_change_dir_e

标识 SDSP 算法中突触权重的变化方向。

**基类**： `logic [3:0]`

| 枚举名        | 枚举值 | 含义                       |
|---------------|--------|----------------------------|
| `STEADY_ZERO` | 4'b0000| 双稳态（不变化）           |
| `CHANGE_INCR` | 4'b0001| 正向变化（权重增加）       |
| `CHANGE_DECR` | 4'b0010| 负向变化（权重减小）       |
| `STEADY_ONE`  | 4'b0011| 双稳态（不变化）           |

### learn_mode_e

标识学习算法模式，用于选择 STDP 或 SDSP。

**基类**： `logic`

| 枚举名        | 枚举值 | 含义                       |
|---------------|--------|----------------------------|
| `LEARN_MODE_STDP` | 1'b0 | 启用 STDP |
| `LEARN_MODE_SDSP` | 1'b1 | 启用 SDSP |

<!-- - `LEARN_MODE_STDP`：`1'b0`，启用 STDP。
- `LEARN_MODE_SDSP`：`1'b1`，启用 SDSP。 -->

### work_mode_e

[Controller 模块](../Controller.sv) 状态机编码、 [ctrl_step](./Controller.md#接口概览) 信号编码

**基类**： `logic [1:0]`

| 枚举名       | 枚举值  | 含义                         |
|--------------|---------|------------------------------|
| `IDLE`       | 2'b00   | 空闲                         |
| `UPDATE_I`   | 2'b01   | 更新阶段 I                   |
| `UPDATE_II`  | 2'b10   | 更新阶段 II                  |
| `LEARN`      | 2'b11   | 学习阶段                     |

## 打包联合体

### learn_var_u

根据学习模式复用同一存储空间

| 成员 | 类型 | 描述 | 算法 | 编码 / 数据类型 |
| - | - | - | - | - |
| synapse_change_dir | [synapse_change_dir_e](#synapse_change_dir_e) | 突触变化方向 | SDSP | 四位枚举类 |
| x_pre | logic [3:0] | 突触前迹计数 | STDP | 无符号整型 |

---

*其它链接*：

- *[顶层模块文档、包和模块文档导航](../README.md)*
