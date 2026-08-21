# 仿真文档

本目录下存放仿真测试平台的源码。除了在 vivado gui 中逐个运行仿真测试平台外，本项目还未所有含有自动验证功能的平台提供了一键启动的功能。

## 一键自动验证

控制台运行：

```bash
srcs\sim\one_click_run_all.ps1
```

启动所有含有自动验证功能的仿真。

从此处启动仿真时，会在最后自动汇总仿真过程中的错误数，且测试平台的输出会汇总到 `srcs\sim\summary.log`。

```log

......

Report simulation summary:
No errors found in sim_aer.log
No errors found in sim_snn_acc.log
No errors found in sim_upd_1.log
No errors found in sim_upd_2.log
No errors found in sim_weight_upd.log
Simulation total error count: 0
Combined log file created at: xxx\SNN_accelerator\srcs\sim\summary.log
```

允许指定汇总文件名和日志详细模式。

```bash
srcs\sim\one_click_run_all.ps1 -log run_all.log --log_mode DEBUG
```

若只希望运行部分仿真集：

```bash
srcs\sim\one_click_run_all.ps1 -simsets "sim_aer sim_udp_1"
```

*运行以查看帮助*：

```bash
Get-Help srcs\sim\one_click_run_all.ps1 -Full
```

## 仿真集文档导航

| 文档链接 | 是否包含自动验证 | 备注 |
| :-: | :-: | :-: |
| [sim_upd_1](./sim_upd_1/README.md) | 是 | \ |
| [sim_upd_2](./sim_upd_2/README.md) | 是 | \ |
| [sim_aer](./sim_aer/README.md) | 是 | \ |
| [sim_snn_acc](./sim_snn_acc/README.md) | 是 | 依照论文第 5.2 节 |
| [sim_weight_upd](./sim_weight_upd/README.md) | 是 | 部分依照论文第 5.1.2 节 |
| [sim_cu](./sim_cu/README.md) | 否 | 依照论文第 5.1.4 节 |
| [sim_LIF](./sim_LIF/README.md) | 否 | 部分依照论文第 5.1.1 节 |
| [train](./train/README.md) | 否 | 仿真训练，部分依照论文第 5.3 节 |
