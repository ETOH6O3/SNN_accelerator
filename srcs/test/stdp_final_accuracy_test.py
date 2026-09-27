
# -*- coding: utf-8 -*-
"""
【FINAL】STDP 训练权重 — MNIST 准确率测试
=========================================
依据论文：
  Diehl & Cook, "Unsupervised learning of digit recognition using
  spike-timing-dependent plasticity", Front. Comput. Neurosci. 9:99 (2015)
  第 2.6 节 "Training and Classification"（训练与分类）的方法实现。

被测对象：
  srcs/sim/train/coe_and_weight/STDP/【FINAL】ram_data_451_vthr1w_tref15_xtar11_hp5us.txt
  （FPGA 在线 STDP 训练导出的 65536 个 12bit 突触字，低 8 位为有符号定点权重，
    每个突触 = 256 神经元 x 256 像素 = 16x16 输入图像 x 16x16 神经元阵列）

方法要点（论文 2.6）：
  1) 训练完成后，学习率置零、固定发放阈值；
  2) 类别指派：将训练集完整呈现一次，统计每个神经元对 10 个数字类别的
     平均响应（平均发放数），取响应最高的类别作为该神经元的类别标签
     —— 这是整个流程中唯一使用标签的一步；
  3) 分类：测试样本按类内所有神经元的平均发放率求均值，
     取平均发放率最高的类别作为预测数字。

硬件一致性说明（FPGA SNN_accelerator 实现）：
  - LIF 膜电位/权重均为定点：v_mem 16bit（低 7 位小数，0~512），
    权重 8bit 有符号（-1~1）；阈值 v_thr = 10000 (定点) = 78.125；
  - 泄漏：每时间步 v -= round(v/32)（shr_and_round(v,5)）；
  - 发放：v >= v_thr 时发放，膜电位复位为 0，进入不应期 t_ref=15；
  - 竞争（WTA）：任一神经元发放后，下一时间步所有神经元膜电位与不应期
    被复位（控制器 cpt_rst 信号），等效软赢者通吃；
  - 输入：16x16 最大池化 MNIST，250 时间步泊松脉冲编码，
    每步发放概率 = 像素强度（与项目 input_gen.py / 硬件训练输入一致）。

运行方式:
  python -E stdp_final_accuracy_test.py [--weights ...]
"""

# %%
import argparse
import os
import sys
import time
from pathlib import Path

import numpy as np
import torch
import h5py

from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay   # 混淆矩阵计算与绘图（标准库实时生成）

import snntorch.spikegen as spikegen          # 泊松脉冲编码（与 input_gen.py 同 API）

# %%

# ----------------------------------------------------------------------------
# 全局参数（硬件一致）
# ----------------------------------------------------------------------------
N_NEURONS = 256        # 兴奋性神经元数 = 16x16
N_PIXELS = 256         # 输入像素数 = 16x16
N_STEPS = 250          # 每个样本呈现的时间步数
V_THR =35900.0        # 膜电位阈值
T_REF = 0             # 不应期（竞争复位下等效 1 步，保留以与硬件一致）
LEAK_SHIFT = 4        # 膜电位衰减速率：每步 v -= shr_and_round(v, LEAK_SHIFT)（硬件为 5，即约 /32）
NUM_CLASSES = 10

HERE = Path(__file__).resolve().parent
DEFAULT_WEIGHTS = HERE / "【FINAL】ram_data_451_vthr1w_tref15_xtar11_hp5us.txt"
ORIG_WEIGHTS = Path(
    r"C:\MARTIN\verilog\Xilinx\projects_vivado\SNN_accelerator"
    r"\srcs\sim\train\coe_and_weight\STDP\【FINAL】ram_data_451_vthr1w_tref15_xtar11_hp5us.txt"
)
DATASET_DIR = HERE.parent / "dataset" / "mnist_16x16"
H5_TRAIN = DATASET_DIR / "train_mnist_poisson_250_NT.h5"
H5_TEST = DATASET_DIR / "test_mnist_poisson_250_NT.h5"
PT_TEST = DATASET_DIR / "test_16x16.pt"
PT_TRAIN = DATASET_DIR / "train_16x16.pt"


class Tee:
    """同时输出到 stdout 与日志文件"""

    def __init__(self, path):
        self.f = open(path, "w", encoding="utf-8")
        self.stdout = sys.stdout

    def write(self, text):
        self.stdout.write(text)
        self.f.write(text)

    def flush(self):
        self.stdout.flush()
        self.f.flush()


# ----------------------------------------------------------------------------
# 1) 权重读取（与 draw_weight.py 的 extract_weight 完全一致）
# ----------------------------------------------------------------------------
def extract_weight(line: str) -> float:
    """12bit 突触字 -> 有符号 8bit 权重 -> [-1,1)"""
    data = int(line.strip(), 16) & 0xFF
    if data & 0x80:
        data = data - 256
    return data / 128.0


def load_weights(path):
    """返回 (W, w_file)

    - W: [neuron, pixel] float32 定点尺度（x128）。仿真用。
      硬件/文件布局：第 X 个输入与第 Y 个神经元的连接权重位于文件
      bin_to_dec({X,Y}) = X*256 + Y 行（与 draw_weight.py 的
      inner_idx=k//256(输入)、block_idx=k%256(神经元) 一致），
      故 W[neuron=Y, pixel=X] = txt[X*256+Y] = txt.reshape(256,256).T。
    - w_file: 按文件行号顺序的 [-1,1] 权重（用于绘制权重图，与
      draw_weight.py 的 create_grayscale_image 输入顺序完全一致）。
    """
    with open(path, "r", encoding="utf-8") as f:
        lines = f.readlines()
    assert len(lines) == 65536, f"权重行数应为 65536，实际 {len(lines)}"
    w_file = np.array([extract_weight(l) for l in lines], dtype=np.float32)   # [65536] 文件顺序
    W = w_file.reshape(N_PIXELS, N_NEURONS).T.astype(np.float32)              # [neuron, pixel]
    return W * 128.0, w_file


# ----------------------------------------------------------------------------
# 2) 权重图（与 draw_weight.py 的 create_grayscale_image 布局完全一致）
# ----------------------------------------------------------------------------
def render_weight_image(data, save_path):
    """将 65536 个 [-1,1] 值按 draw_weight.py 布局绘制为 256x256 灰度图"""
    data = np.asarray(data, dtype=np.float64).flatten()
    gray = 255 - (data + 1.0) / 2.0 * 255.0
    gray = np.clip(gray, 0, 255).astype(np.uint8)
    k = np.arange(65536)
    inner_idx = k // 256
    inner_row = inner_idx // 16
    inner_col = inner_idx % 16
    block_idx = k % 256
    block_row = block_idx // 16
    block_col = block_idx % 16
    y = block_row * 16 + inner_row
    x = block_col * 16 + inner_col
    img = np.zeros((256, 256), dtype=np.uint8)
    img[y, x] = gray
    from PIL import Image
    Image.fromarray(img, mode="L").save(save_path)
    return img


def show_weights(w_real, save_path):
    img = render_weight_image(w_real, save_path)
    print(f"[1/4] 权重图已保存: {save_path}")
    try:
        import matplotlib.pyplot as plt
        fig, ax = plt.subplots(figsize=(6, 6))
        ax.imshow(img, cmap="gray", vmin=0, vmax=255)
        ax.set_title("【FINAL】STDP trained weights (256x256, 16x16 neuron grid)")
        ax.axis("off")
        fig.canvas.manager.set_window_title("【FINAL】 weights")
        plt.show(block=False)
        plt.pause(3.0)
        plt.close(fig)
    except Exception as e:                      # 无 GUI 环境时仅保存
        print(f"    (GUI 展示不可用: {e})")


# ----------------------------------------------------------------------------
# 3) LIF 仿真（硬件一致：泄漏 1/32 + 阈值 + 竞争复位 WTA）
# ----------------------------------------------------------------------------
def simulate_responses(spikes, W, device="cpu"):
    """spikes: [B, T, 256] 0/1; W: [256,256] 定点尺度权重; 返回发放数 [B, 256]"""
    B = spikes.shape[0]
    v = torch.zeros(B, N_NEURONS, dtype=torch.float32, device=device)
    counts = torch.zeros(B, N_NEURONS, dtype=torch.float32, device=device)
    cpt = torch.zeros(B, dtype=torch.bool, device=device)
    Wt = W.to(device)
    S = spikes.to(device)
    for t in range(N_STEPS):
        # 竞争复位：上一时间步有发放 -> 本步所有神经元 v、不应期清零
        v = torch.where(cpt[:, None], torch.zeros_like(v), v)
        cpt[:] = False
        # 泄漏：v -= shr_and_round(v, LEAK_SHIFT) = floor(v/2^shift) + floor(v/2^(shift-1))%2
        leak = torch.floor(v / float(2 ** LEAK_SHIFT)) + (torch.floor(v / float(2 ** (LEAK_SHIFT - 1))) % 2)
        v = v - leak
        # 积分：本步所有发放像素的权重和（硬件逐像素累加，此处一步汇总）
        cur = S[:, t] @ Wt.t()                  # [B, 256]
        v = v + cur
        v = torch.clamp(v, min=0.0)             # 硬件：下溢(加负权重) -> 0
        spk = v >= V_THR
        v = torch.where(spk, torch.zeros_like(v), v)
        counts += spk.float()
        cpt[:] = spk.any(dim=1)
    return counts


def encode_poisson(images, seed=None):
    """16x16 图像 -> [B, T, 256] 泊松脉冲（snntorch，与 input_gen.py 相同编码）"""
    if seed is not None:
        torch.manual_seed(seed)
        np.random.seed(seed)
    spk = spikegen.rate(images, num_steps=N_STEPS)   # [T, B, 1, 16, 16]
    return spk[:, :, 0].flatten(2).permute(1, 0, 2).float()


# ----------------------------------------------------------------------------
# 4) 论文 2.6 的类别指派与分类
# ----------------------------------------------------------------------------
def assign_neuron_classes(counts_train, labels_train):
    """类别指派：神经元类别 = 训练集上平均响应最高的数字类别"""
    mean_resp = torch.stack(
        [counts_train[labels_train == c].mean(dim=0) for c in range(NUM_CLASSES)]
    )                                                    # [10, 256]
    mean_resp = torch.nan_to_num(mean_resp, nan=-float("inf"))
    neuron_class = mean_resp.argmax(dim=0).cpu().numpy() # [256]
    return neuron_class, mean_resp.cpu().numpy()


def predict(counts, neuron_class):
    """分类：类内神经元平均发放率最高的类别"""
    class_mean = torch.stack(
        [counts[:, neuron_class == c].mean(dim=1) for c in range(NUM_CLASSES)],
        dim=1,
    )                                                    # [B, 10]
    class_mean = torch.nan_to_num(class_mean, nan=-float("inf"))
    return class_mean.argmax(dim=1)


# ----------------------------------------------------------------------------
# 5) 数据加载
# ----------------------------------------------------------------------------
def load_h5_counts(h5_path, W, device, chunk=5000, ds_spikes="train_spikes"):
    """分块读取 h5 脉冲并累计每神经元发放数（用于类别指派 / 确定性测试呈现）"""
    counts_all = []
    labels_all = []
    t0 = time.time()
    with h5py.File(h5_path, "r") as f:
        n = f[ds_spikes].shape[0]
        for s in range(0, n, chunk):
            spk = f[ds_spikes][s:s + chunk, :, 0, :, :].astype(np.float32)
            lbl = f[ds_spikes.replace("spikes", "labels")][s:s + chunk].astype(np.int64)
            spk = torch.from_numpy(spk.reshape(-1, N_STEPS, N_PIXELS))
            counts_all.append(simulate_responses(spk, W, device).cpu())
            labels_all.append(torch.from_numpy(lbl))
            print(f"    ... 已处理 {min(s+chunk, n)}/{n} 样本 ({time.time()-t0:.0f}s)")
    return torch.cat(counts_all), torch.cat(labels_all)




def load_te_h5_spikes(h5_path, n):
    with h5py.File(h5_path, "r") as f:
        spk = f["test_spikes"][:n, :, 0, :, :].astype(np.float32)
    return spk.reshape(n, N_STEPS, N_PIXELS)


def confusion_stats(cm):
    """多分类 one-vs-rest 下每类 TP/FP/FN/TN 与三类错误率

    弃真率（Type I error / FPR）= FP / (FP + TN)：把“不是该类”误判成该类
    取伪率（Type II error / FNR）= FN / (FN + TP)：把该类漏判成其他类
    假发现率（FDR）= FP / (TP + FP)：在所有被判为该类的样本中误报的比例
    """
    N = cm.sum()
    stats = []
    for c in range(NUM_CLASSES):
        tp = int(cm[c, c])
        fp = int(cm[:, c].sum()) - tp
        fn = int(cm[c, :].sum()) - tp
        tn = int(N) - tp - fp - fn
        fpr = fp / (fp + tn) if (fp + tn) > 0 else 0.0
        fnr = fn / (fn + tp) if (fn + tp) > 0 else 0.0
        fdr = fp / (tp + fp) if (tp + fp) > 0 else 0.0
        stats.append((tp, fp, fn, tn, fpr, fnr, fdr))
    return stats


def draw_neuron_class_map(neuron_class, save_path, weight_img_path):
    """运行时生成 16x16 类别分布 + 权重图 并排对比图（直接插入报告 md）

    左图：每个格子 = 一个神经元，颜色/数字 = 指派类别；
    右图：权重图，第 (i,j) 个 16x16 方块 = 神经元 (i,j) 的感受野。
    两图逐格一一对应，便于对照每个神经元学到的是哪个数字的原型。
    """
    import matplotlib.pyplot as plt
    from PIL import Image
    try:
        plt.rcParams["font.sans-serif"] = ["Microsoft YaHei", "SimHei", "SimSun"]
        plt.rcParams["axes.unicode_minus"] = False
    except Exception:
        pass
    grid = np.asarray(neuron_class).reshape(16, 16)
    wimg = np.asarray(Image.open(weight_img_path).convert("L"))   # 256x256 uint8
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11.5, 5.8),
                                   gridspec_kw={"width_ratios": [1, 1.7]})
    # (a) 神经元类别分布
    cmap = plt.get_cmap("tab10")
    im = ax1.imshow(grid, cmap=cmap, vmin=0, vmax=9)
    for i in range(16):
        for j in range(16):
            ax1.text(j, i, str(int(grid[i, j])), ha="center", va="center",
                     fontsize=8, color="white", fontweight="bold")
    ax1.set_xticks(range(16)); ax1.set_yticks(range(16))
    ax1.set_xlabel("神经元列"); ax1.set_ylabel("神经元行")
    ax1.set_title("(a) 神经元类别分布 16×16")
    ax1.grid(True, color="black", linewidth=0.4)
    cbar = fig.colorbar(im, ax=ax1, ticks=range(10), shrink=0.9)
    cbar.set_label("类别 0-9")
    # (b) 权重图
    ax2.imshow(wimg, cmap="gray", vmin=0, vmax=255)
    ax2.set_title("(b) 权重图 256×256（16×16 神经元感受野）")
    ax2.axis("off")
    fig.tight_layout()
    fig.savefig(save_path, dpi=150)
    plt.close(fig)
    return grid


def save_results(args, neuron_class, per_class_n, accs, cm, w_path, weight_img_path):
    import matplotlib.pyplot as plt
    # 中文字体（Windows 微软雅黑），避免图中中文显示为方块
    try:
        plt.rcParams["font.sans-serif"] = ["Microsoft YaHei", "SimHei", "SimSun"]
        plt.rcParams["axes.unicode_minus"] = False
    except Exception:
        pass
    report = HERE / "accuracy_report_【FINAL】.md"
    lines = []
    lines.append("# 【FINAL】STDP 权重 — MNIST 准确率测试报告\n")
    lines.append(f"- 被测权重: `{w_path.name}`\n")
    lines.append(f"- 测试日期: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
    lines.append(f"- 方法: 论文 Diehl & Cook (2015) 第 2.6 节 (Training and Classification)\n")
    lines.append("\n## 1. 网络与参数（与 FPGA 硬件一致）\n")
    lines.append("| 项目 | 取值 |")
    lines.append("|---|---|")
    lines.append("| 输入图像 | 16x16 最大池化 MNIST（项目数据集） |")
    lines.append("| 输入神经元 / 兴奋性神经元 | 256 / 256 |")
    lines.append("| 输入编码 | 泊松脉冲，250 时间步，每步发放概率=像素强度 |")
    lines.append("| 权重 | 8bit 有符号定点，范围 [-1,1)，存于 12bit 突触字低 8 位 |")
    lines.append("| 膜电位 | 16bit 定点（低 7 位小数），范围 [0,512) |")
    lines.append(f"| 阈值 v_thr | {V_THR} |")
    lines.append(f"| 泄漏（膜电位衰减速率） | 每步 v -= shr_and_round(v, LEAK_SHIFT={LEAK_SHIFT})（约 /{2 ** LEAK_SHIFT}，可调全局常数） |")
    lines.append("| 竞争(WTA) | 任一神经元发放后，下一时间步全部复位 |")
    lines.append(f"| 不应期 | t_ref={T_REF} |")
    lines.append("\n## 2. 分类流程\n")
    lines.append("1. 学习率置零、固定发放阈值；")
    lines.append("2. 训练集完整呈现一次，按每个神经元对 10 类的平均响应指派类别标签"
                 "（全流程唯一使用标签处）；")
    lines.append("3. 测试样本按类内神经元平均发放率取 argmax 作为预测。\n")
    lines.append(f"类别指派训练样本数: {args.assign_limit}；测试样本数: {args.test_limit}；"
                 f"测试呈现次数: {args.presentations}\n")
    lines.append("\n## 3. 结果\n")
    lines.append(f"- 单次呈现（h5 泊松脉冲，与硬件输入一致）: **{accs[0]*100:.2f}%**")
    if len(accs) > 1:
        lines.append(f"- {args.presentations} 次呈现平均: **{accs.mean()*100:.2f}% ± {accs.std()*100:.2f}%**")
        lines.append(f"- 每次呈现准确率: {['%.2f%%' % (a*100) for a in accs]}\n")
    else:
        lines.append("")

    # ---- 弃真 / 取伪（多分类 one-vs-rest） ----
    stats = confusion_stats(cm)
    macro_fpr = np.mean([s[4] for s in stats])      # 弃真率（Type I / FPR）
    macro_fnr = np.mean([s[5] for s in stats])      # 取伪率（Type II / FNR）
    lines.append(f"- 弃真率（Type I error / FPR，macro 平均）: **{macro_fpr*100:.2f}%**"
                 f"（把“不是该类”误判成该类）")
    lines.append(f"- 取伪率（Type II error / FNR，macro 平均）: **{macro_fnr*100:.2f}%**"
                 f"（把该类漏判成其他类）\n")

    lines.append("\n### 每个类别分配的神经元数\n")
    lines.append("| 类别 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |")
    lines.append("|---|---|---|---|---|---|---|---|---|---|---|")
    lines.append("| 神经元数 | " + " | ".join(str(int(x)) for x in per_class_n) + " |\n")
    cls_path = HERE / "neuron_class_vs_weights_【FINAL】.png"
    txt_path = HERE / "neuron_class_map_【FINAL】.txt"
    grid = draw_neuron_class_map(neuron_class, cls_path, weight_img_path)
    with open(txt_path, "w", encoding="utf-8") as f:
        f.write("# 每个神经元的类别标签（行 i、列 j -> 神经元 (i,j) 的类别）\n")
        for i in range(16):
            f.write(" ".join(f"{grid[i, j]:2d}" for j in range(16)) + "\n")
    lines.append("\n### 神经元类别分布（16×16）与权重图对比\n")
    lines.append("左图：每个格子 = 一个神经元，颜色/数字 = 该神经元被指派的数字类别；"
                 "右图：权重图中第 (i,j) 个 16×16 方块是神经元 (i,j) 的感受野，二者逐格一一对应，"
                 "可对照查看每个神经元学到的是哪个数字的原型。"
                 "（该对比图由脚本运行时生成并直接嵌入本报告）\n")
    lines.append("16×16 类别矩阵（txt 形式，同行号/列号即神经元坐标）：\n")
    lines.append("```")
    for i in range(16):
        lines.append("  " + " ".join(f"{grid[i, j]:2d}" for j in range(16)))
    lines.append("```\n")
    lines.append(f"![权重图]({weight_img_path.name})\n")
    lines.append("\n### 各类别指标（h5 单次呈现：TP / FP / FN / TN / FPR / FNR / FDR）\n")
    lines.append("> 口径：one-vs-rest；弃真率 FPR=FP/(FP+TN)，取伪率 FNR=FN/(FN+TP)，"
                 "假发现率 FDR=FP/(TP+FP)（被判为该类的样本中误报比例）。\n")
    lines.append("| 类别 | TP | FP | FN | TN | 弃真率(Type I/FPR) | 取伪率(Type II/FNR) | 假发现率(FDR) |")
    lines.append("|---|---|---|---|---|---|---|---|")
    for c in range(NUM_CLASSES):
        s = stats[c]
        lines.append(f"| {c} | {s[0]} | {s[1]} | {s[2]} | {s[3]} | "
                     f"{s[4]*100:.2f}% | {s[5]*100:.2f}% | {s[6]*100:.2f}% |")
    lines.append("\n")
    lines.append("\n### 混淆矩阵（h5 单次呈现，行=真实，列=预测）\n")
    lines.append("> 混淆矩阵由 `sklearn.metrics.confusion_matrix` 实时计算、"
                 "`ConfusionMatrixDisplay` 实时绘图；下方数字矩阵与图同源，"
                 "各类别弃真/取伪率均由该矩阵按 one-vs-rest 口径推导。\n")
    lines.append("```")
    lines.append("       " + "  ".join(f"{i:4d}" for i in range(NUM_CLASSES)))
    for r in range(NUM_CLASSES):
        lines.append(f"  {r}  " + "  ".join(f"{cm[r, c]:4d}" for c in range(NUM_CLASSES)))
    lines.append("```\n")
    cm_path = HERE / "confusion_matrix_【FINAL】.png"
    fig, ax = plt.subplots(figsize=(6.5, 5.5))
    disp = ConfusionMatrixDisplay(confusion_matrix=cm,
                                  display_labels=[str(i) for i in range(NUM_CLASSES)])
    disp.plot(cmap="Blues", values_format="d", ax=ax, colorbar=True)
    ax.set_xlabel("预测类别"); ax.set_ylabel("真实类别")
    ax.set_title("【FINAL】混淆矩阵（10000 测试样本，h5 单次呈现）")
    fig.tight_layout()
    fig.savefig(cm_path, dpi=150)
    plt.close(fig)
    lines.append("![混淆矩阵](confusion_matrix_【FINAL】.png)\n")

    lines.append("\n## 4. 结论与说明\n")
    lines.append("*该【FINAL】权重由 FPGA 在线 STDP 训练导出，导出命名表明训练约进行至第 451 个样本（远少于论文的 60000 样本），且仅 256 神经元、16x16 输入、8bit 定点权重，因此准确率显著低于论文在 6400 神经元/28x28/全量训练下的 95%。*\n")
    with open(report, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"报告: {report}")
    print(f"混淆矩阵图: {cm_path}")
    print(f"神经元类别分布与权重图对比: {cls_path}")
    print(f"神经元类别矩阵(txt): {txt_path}")

def is_jupyter():
    try:
        from IPython import get_ipython
    except ImportError:
        return False

    ip = get_ipython()
    if ip is None:
        return False

    return ip.__class__.__name__ == "ZMQInteractiveShell"

# %%
if not is_jupyter():
    parser = argparse.ArgumentParser(description="【FINAL】STDP 权重 MNIST 准确率测试")
    parser.add_argument("--weights", type=str, default=None,
                        help="权重 txt 路径（默认取本目录下同名文件，其次取工程原始路径）")
    parser.add_argument("--assign-limit", type=int, default=60000,
                        help="类别指派使用的训练样本数（默认全部 60000）")
    parser.add_argument("--test-limit", type=int, default=10000,
                        help="测试样本数（默认全部 10000）")
    parser.add_argument("--presentations", type=int, default=1,
                        help="测试集呈现次数（默认仅 h5 单次；>1 时用 snntorch 重新生成取平均）")
    parser.add_argument("--no-show", action="store_true", help="不弹出权重图窗口")
    parser.add_argument("--device", type=str, default="",
                        help="cuda/cpu（默认自动选择）")
    args = parser.parse_args()

else:
    class Args:
        weights = None
        assign_limit = 60000
        test_limit = 10000
        presentations = 1
        no_show = True
        device = "cuda" if torch.cuda.is_available() else "cpu"
    args = Args()

log_path = HERE / "test_log_【FINAL】.txt"
sys.stdout = Tee(log_path)
t_start = time.time()

if args.weights:
    w_path = Path(args.weights)
elif DEFAULT_WEIGHTS.exists():
    w_path = DEFAULT_WEIGHTS
elif ORIG_WEIGHTS.exists():
    w_path = ORIG_WEIGHTS
else:
    sys.exit("未找到权重文件，请用 --weights 指定")
print("=" * 78)
print("【FINAL】STDP 权重 — MNIST 准确率测试（论文 Diehl & Cook 2015, 2.6 节方法）")
print("=" * 78)
print(f"权重文件 : {w_path}")

# %%

# ---- 1. 读取权重 ----
W, w_file = load_weights(w_path)             # W: [256,256] 定点尺度；w_file: 文件顺序
w_real = w_file                              # 与 draw_weight.py 同序，用于绘制权重图
print(f"权重统计 : min={w_real.min():.3f} max={w_real.max():.3f} "
        f"mean={w_real.mean():.3f} 正值占比={(w_real>0).mean():.3f}")
# %%

# ---- 2. 展示权重图（测试开始前） ----
weight_img_path = HERE / "weights_image_【FINAL】.png"
if not args.no_show:
    show_weights(w_real, weight_img_path)
else:
    render_weight_image(w_real, weight_img_path)
    print(f"[1/4] 权重图已保存: {weight_img_path}")

device = args.device or ("cuda" if torch.cuda.is_available() else "cpu")
print(f"[2/4] 仿真设备: {device}  (torch {torch.__version__})")
torch.set_num_threads(max(1, os.cpu_count() // 2 or 1))
Wt = torch.from_numpy(W)
# %%

# ---- 3. 类别指派（论文 2.6：训练集完整呈现一次） ----
print("[3/4] 类别指派：呈现训练集（一次），统计各神经元平均响应 ...")
n_assign = min(args.assign_limit, 60000)
cnt_tr, lbl_tr = load_h5_counts(H5_TRAIN, Wt, device, chunk=5000)
cnt_tr = cnt_tr[:n_assign]
lbl_tr = lbl_tr[:n_assign]
neuron_class, mean_resp = assign_neuron_classes(cnt_tr, lbl_tr)
per_class_n = np.bincount(neuron_class, minlength=NUM_CLASSES)
print("  每个类别分配的神经元数:", per_class_n.tolist())
# %%

# ---- 4. 测试（论文 2.6：类内平均响应 -> argmax；多次呈现取均值） ----
print(f"[4/4] 测试：{args.test_limit} 个测试样本，{args.presentations} 次呈现 ...")
accs = []
cm_total = None
with h5py.File(H5_TEST, "r") as f:
    n_test = min(args.test_limit, f["test_spikes"].shape[0])
    te_lbl = torch.from_numpy(f["test_labels"][:n_test].astype(np.int64))

for pres in range(args.presentations):
    t0 = time.time()
    if pres == 0:
        # 呈现 0：硬件训练/测试使用的同一 h5 泊松脉冲（确定性）
        spk = torch.from_numpy(load_te_h5_spikes(H5_TEST, n_test))
        tag = "h5 泊松脉冲(与硬件一致)"
    else:
        # 呈现 1..N-1：重新用 snntorch 生成泊松脉冲（论文多次呈现取平均）
        data = torch.load(PT_TEST, map_location="cpu", weights_only=False)
        imgs = data["images"][:n_test, 0]      # [N,16,16] 0~1
        spk = encode_poisson(imgs[:, None, :, :], seed=100 + pres)
        tag = f"snntorch 重新生成(seed={100+pres})"
    cnt_te = simulate_responses(spk, Wt, device).cpu()
    pred = predict(cnt_te, neuron_class)
    acc = (pred == te_lbl).float().mean().item()
    accs.append(acc)
    # 混淆矩阵（以第一次呈现为准，可复现；由 sklearn.metrics 实时计算）
    if cm_total is None:
        cm_total = confusion_matrix(te_lbl.numpy(), pred.numpy(),
                                    labels=list(range(NUM_CLASSES)))
    print(f"  呈现 {pres+1}/{args.presentations}: 准确率 {acc:.4f}  ({tag}, {time.time()-t0:.0f}s)")

accs = np.array(accs)
print("-" * 78)
if len(accs) > 1:
    print(f"测试结果: 单次(h5) {accs[0]*100:.2f}% | {args.presentations} 次平均 "
          f"{accs.mean()*100:.2f}% ± {accs.std()*100:.2f}%")
else:
    print(f"测试结果: 单次(h5) {accs[0]*100:.2f}%")
# %%

# ---- 5. 保存结果 ----
save_results(args, neuron_class, per_class_n, accs, cm_total, w_path, weight_img_path)
print(f"总耗时 {time.time()-t_start:.0f}s；日志: {log_path}")
sys.stdout.flush()

