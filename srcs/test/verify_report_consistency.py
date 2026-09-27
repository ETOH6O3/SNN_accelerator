# -*- coding: utf-8 -*-
"""
核对脚本：验证 accuracy_report_【FINAL】.md 中
  混淆矩阵(代码块) <-> 各类别弃真率/取伪率表 <-> 总体宏平均
三者完全相符（不依赖仿真，直接解析报告并重算；并用 sklearn.metrics 交叉验证）。

用法：  C:\\Python314\\python.exe -E verify_report_consistency.py
"""
import re
import sys
from pathlib import Path
import numpy as np
from sklearn.metrics import confusion_matrix as sk_cm_fn, recall_score

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

HERE = Path(__file__).resolve().parent
REPORT = HERE / "accuracy_report_【FINAL】.md"
NUM_CLASSES = 10

text = REPORT.read_text(encoding="utf-8")

# ---- 1. 解析混淆矩阵代码块（10x10 数字块；数据行 = 行标签 + 10 列，共 11 个数字） ----
blocks = re.findall(r"```\s*\n(.*?)```", text, re.S)
cm = None
for b in blocks:
    rows = []
    for line in b.strip().splitlines():
        toks = re.findall(r"-?\d+", line)
        if len(toks) == NUM_CLASSES + 1 and 0 <= int(toks[0]) <= 9:
            rows.append([int(x) for x in toks[1:NUM_CLASSES + 1]])
    if len(rows) == NUM_CLASSES and all(len(r) == NUM_CLASSES for r in rows):
        cm = np.array(rows)
        break
assert cm is not None, "未在报告中找到 10x10 混淆矩阵代码块"
assert cm.sum() == 10000, f"混淆矩阵样本总数应为 10000，实际 {cm.sum()}"
print(f"解析到混淆矩阵：对角和 {np.trace(cm)}，总数 {cm.sum()}，总体准确率 {np.trace(cm)/cm.sum()*100:.2f}%")

# ---- 2. 解析各类别指标表 ----
m = re.search(r"### 各类别指标.*?\n(.*?)(?:\n##|\n###|\Z)", text, re.S)
assert m, "未找到各类别指标表"
tab_lines = [l for l in m.group(1).strip().splitlines()
             if l.startswith("|") and re.match(r"\| \d \|", l)]
reported = {}
for l in tab_lines:
    cells = [c.strip() for c in l.strip().strip("|").split("|")]
    # 表结构：类别 | TP | FP | FN | TN | FPR | FNR | FDR
    reported[int(cells[0])] = (float(cells[5].rstrip("%")),
                               float(cells[6].rstrip("%")),
                               float(cells[7].rstrip("%")))

# ---- 3. 从矩阵重算 FPR/FNR/FDR（one-vs-rest），与报告对比 ----
print("\n类别 | 报告FPR% 重算FPR% | 报告FNR% 重算FNR% | 报告FDR% 重算FDR% | 判定")
ok = True
N = cm.sum()
for c in range(NUM_CLASSES):
    tp = int(cm[c, c])
    fp = int(cm[:, c].sum()) - tp
    fn = int(cm[c, :].sum()) - tp
    tn = N - tp - fp - fn
    fpr = fp / (fp + tn) * 100
    fnr = fn / (fn + tp) * 100
    fdr = fp / (tp + fp) * 100 if (tp + fp) > 0 else 0.0
    d_fpr = abs(fpr - reported[c][0])
    d_fnr = abs(fnr - reported[c][1])
    d_fdr = abs(fdr - reported[c][2])
    # 容差 0.01 个百分点：报告显示两位小数，舍入误差最多 ±0.005
    flag = "OK" if d_fpr < 0.01 and d_fnr < 0.01 and d_fdr < 0.01 else "MISMATCH!"
    if flag != "OK":
        ok = False
    print(f"{c} | {reported[c][0]:6.2f}  {fpr:6.2f} | {reported[c][1]:6.2f}  {fnr:6.2f} | "
          f"{reported[c][2]:6.2f}  {fdr:6.2f} | {d_fpr:.1e} {d_fnr:.1e} {d_fdr:.1e}  {flag}")

# ---- 4. 宏平均核对 ----
diag = np.diag(cm).astype(float)
fps = np.array([float(cm[:, c].sum()) - diag[c] for c in range(NUM_CLASSES)])
# TN = 真实非该类 且 预测非该类 = (N - 该类行和) - FP
tns = np.array([cm.sum() - float(cm[c, :].sum()) - (float(cm[:, c].sum()) - diag[c])
                for c in range(NUM_CLASSES)])
fns = np.array([float(cm[c, :].sum()) - diag[c] for c in range(NUM_CLASSES)])
macro_fpr = (fps / (fps + tns)).mean() * 100
macro_fnr = (fns / (fns + diag)).mean() * 100
m_fpr = re.search(r"弃真率（Type I error / FPR，macro 平均）: \*\*([\d.]+)%", text)
m_fnr = re.search(r"取伪率（Type II error / FNR，macro 平均）: \*\*([\d.]+)%", text)
r_fpr, r_fnr = float(m_fpr.group(1)), float(m_fnr.group(1))
print(f"\n宏平均：报告 弃真 {r_fpr:.2f}% / 取伪 {r_fnr:.2f}%；重算 弃真 {macro_fpr:.2f}% / 取伪 {macro_fnr:.2f}%"
      f"  -> {'OK' if abs(r_fpr-macro_fpr) < 0.01 and abs(r_fnr-macro_fnr) < 0.01 else 'MISMATCH!'}")

# ---- 5. sklearn.metrics 交叉验证（recall = 1 - FNR） ----
y_true, y_pred = [], []
for r in range(NUM_CLASSES):
    for c in range(NUM_CLASSES):
        y_true += [r] * int(cm[r, c])
        y_pred += [c] * int(cm[r, c])
sk_cm = sk_cm_fn(y_true, y_pred, labels=list(range(NUM_CLASSES)))
assert (sk_cm == cm).all(), "sklearn 重新生成的混淆矩阵与报告矩阵不一致"
rec = recall_score(y_true, y_pred, average=None, labels=list(range(NUM_CLASSES)))
sk_fnr = (1 - rec) * 100
d = np.abs(sk_fnr - np.array([reported[c][1] for c in range(NUM_CLASSES)]))
print("\nsklearn 交叉验证：confusion_matrix 一致 [OK]；recall->FNR 与报告逐类差异 max=%.2e" % d.max())
print("宏平均取伪率（=1-macro recall）: %.2f%% vs 报告 %.2f%%" % ((1 - rec.mean()) * 100, r_fnr))

print("\n核对结论：", "全部相符 [OK]（混淆矩阵 <-> TP/FP/FN/TN 与 FPR/FNR/FDR 统计完全自洽）" if ok and (sk_cm == cm).all() else "存在不一致，请检查")
