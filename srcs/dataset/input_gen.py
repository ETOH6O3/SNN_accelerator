# %%
import torch
import torch.nn as nn
from torchvision import datasets, transforms
from torch.utils.data import DataLoader
import matplotlib.pyplot as plt
import os
import random
import snntorch as snn
import snntorch.spikegen as spikegen
import h5py
import numpy as np

# %%
# 设定设备
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# 1. 定义转换：转为张量（0~1）
transform = transforms.Compose([
    transforms.ToTensor()  # 形状 [1, 28, 28]，像素值 0~1
])

# 2. 下载并加载 MNIST 原始数据集
train_dataset = datasets.MNIST(root='./data', train=True, download=True, transform=transform)
test_dataset  = datasets.MNIST(root='./data', train=False, download=True, transform=transform)

train_loader = DataLoader(train_dataset, batch_size=256, shuffle=False)
test_loader  = DataLoader(test_dataset, batch_size=256, shuffle=False)

# 3. 定义自适应最大池化层，输出尺寸 (16, 16)
pool = nn.AdaptiveMaxPool2d((16, 16)).to(device)

# 4. 池化函数：处理整个 DataLoader，返回池化后的图像和标签
def pool_dataset(loader, pool_layer, device):
    pooled_images = []
    labels = []
    with torch.no_grad():
        for imgs, lbls in loader:
            imgs = imgs.to(device)
            pooled = pool_layer(imgs)  # 形状 [B, 1, 16, 16]
            pooled_images.append(pooled.cpu())
            labels.append(lbls.cpu())
    pooled_images = torch.cat(pooled_images, dim=0)  # [N, 1, 16, 16]
    labels = torch.cat(labels, dim=0)                # [N]
    return pooled_images, labels

print("正在对训练集进行最大池化...")
train_pooled, train_labels = pool_dataset(train_loader, pool, device)
print("训练集池化完成，形状:", train_pooled.shape)

print("正在对测试集进行最大池化...")
test_pooled, test_labels = pool_dataset(test_loader, pool, device)
print("测试集池化完成，形状:", test_pooled.shape)

# 5. 保存结果
os.makedirs('./mnist_16x16', exist_ok=True)
torch.save({'images': train_pooled, 'labels': train_labels}, './mnist_16x16/train_16x16.pt')
torch.save({'images': test_pooled, 'labels': test_labels}, './mnist_16x16/test_16x16.pt')

print("池化后的 MNIST 数据集已保存至 ./mnist_16x16/ 文件夹")
# %%

# ====== 随机展示几张池化后的图像 ======

# 1. 加载保存的池化数据集（以训练集为例）
data = torch.load('./mnist_16x16/train_16x16.pt', map_location='cpu')
images = data['images']      # 形状 [N, 1, 16, 16]
labels = data['labels']      # 形状 [N]

# 2. 设置随机展示的数量
num_show = 8
total = images.shape[0]
indices = random.sample(range(total), num_show)   # 随机抽取不重复的索引

# 3. 绘制图像
fig, axes = plt.subplots(2, 4, figsize=(8, 4))    # 2行4列
axes = axes.flatten()

for i, idx in enumerate(indices):
    img = images[idx].squeeze()        # 去掉通道维度 -> [16, 16]
    label = labels[idx].item()
    axes[i].imshow(img, cmap='gray')
    axes[i].set_title(f'Label: {label}')
    axes[i].axis('off')

plt.tight_layout()
plt.show()

# %%
# 1. 加载 16x16 池化数据集
train_data = torch.load('./mnist_16x16/train_16x16.pt', map_location='cpu')
train_imgs = train_data['images']   # [60000, 1, 16, 16]
train_labels = train_data['labels']

test_data = torch.load('./mnist_16x16/test_16x16.pt', map_location='cpu')
test_imgs = test_data['images']     # [10000, 1, 16, 16]
test_labels = test_data['labels']

# 2. 参数设置
num_steps = 250
batch_size = 128

# 3. 预分配布尔张量（内存：训练集约 3.84 GB，测试集约 0.64 GB）
train_spikes = torch.zeros(num_steps, train_imgs.size(0), 1, 16, 16, dtype=torch.bool)
test_spikes  = torch.zeros(num_steps, test_imgs.size(0),  1, 16, 16, dtype=torch.bool)

# 4. 逐批编码训练集
print("生成训练集脉冲 (250 时间步)...")
for start in range(0, train_imgs.size(0), batch_size):
    end = min(start + batch_size, train_imgs.size(0))
    batch = train_imgs[start:end]
    with torch.no_grad():
        spikes = snn.spikegen.rate(batch, num_steps=num_steps)  # [T, B, 1, 16, 16]
        train_spikes[:, start:end] = spikes.bool()
    if (start // batch_size) % 50 == 0:
        print(f"  训练集 {start}/{train_imgs.size(0)}")

# 5. 逐批编码测试集
print("生成测试集脉冲...")
for start in range(0, test_imgs.size(0), batch_size):
    end = min(start + batch_size, test_imgs.size(0))
    batch = test_imgs[start:end]
    with torch.no_grad():
        spikes = snn.spikegen.rate(batch, num_steps=num_steps)
        test_spikes[:, start:end] = spikes.bool()
    if (start // batch_size) % 50 == 0:
        print(f"  测试集 {start}/{test_imgs.size(0)}")
# %%
# 6. 保存为一个文件
save_path = './mnist_16x16/train_mnist_poisson_250.h5'
print("正在保存为 HDF5 文件...")
with h5py.File(save_path, 'w') as f:
    f.create_dataset('train_spikes', data=train_spikes.numpy(), compression="gzip", chunks=True)
    f.create_dataset('train_labels', data=train_labels.numpy())
save_path = './mnist_16x16/test_mnist_poisson_250.h5'
with h5py.File(save_path, 'w') as f:
    f.create_dataset('test_spikes', data=test_spikes.numpy(), compression="gzip", chunks=True)
    f.create_dataset('test_labels', data=test_labels.numpy())
print(f"保存完成：{save_path}")
# # %%
# # 打开文件，但不全部加载到内存
# with h5py.File('./mnist_16x16/mnist_poisson_250.h5', 'r') as f:
#     train_spikes = f['train_spikes']   # 这只是个索引，没读数据
#     train_labels = f['train_labels']
#     total_samples = train_spikes.shape[1]   # 样本数

#     idx = random.randint(0, total_samples - 1)
#     # 仅取出我们需要的那个样本的脉冲数据
#     sample_spikes = train_spikes[:, idx, 0, :, :]  # 形状 [250, 16, 16]
#     label = train_labels[idx]

#     # 同时读取原始池化图像做对比（还是从之前的 pt 文件读，很小）
#     pooled_data = torch.load('./mnist_16x16/train_16x16.pt', map_location='cpu')
#     original_img = pooled_data['images'][idx, 0].numpy()

# # 绘图
# fig, axes = plt.subplots(2, 3, figsize=(8, 5))
# axes = axes.flatten()
# axes[0].imshow(original_img, cmap='gray')
# axes[0].set_title(f'Original (label={label})')
# axes[0].axis('off')

# time_steps_to_show = [0, 50, 100, 150, 200]
# for i, t in enumerate(time_steps_to_show):
#     axes[i+1].imshow(sample_spikes[t], cmap='gray', vmin=0, vmax=1)
#     axes[i+1].set_title(f'Spike t={t}')
#     axes[i+1].axis('off')
# plt.tight_layout()
# plt.show()
# %%

# ======================== [T,N,1,16,16] → [N,T,1,16,16] =================================

chunk_size = 1000  # 一次处理多少个样本，根据内存调整

# 文件路径
train_old = './mnist_16x16/train_mnist_poisson_250.h5'
train_new = './mnist_16x16/train_mnist_poisson_250_NT.h5'
test_old  = './mnist_16x16/test_mnist_poisson_250.h5'
test_new  = './mnist_16x16/test_mnist_poisson_250_NT.h5'

# ---- 转换训练集 ----
print("转换训练集...")
with h5py.File(train_old, 'r') as f_old, h5py.File(train_new, 'w') as f_new:
    spikes_old = f_old['train_spikes']   # (T, N, 1, 16, 16)
    labels_old = f_old['train_labels']   # (N,)
    T, N, C, H, W = spikes_old.shape

    # 创建新数据集，形状为 (N, T, C, H, W)
    spikes_new = f_new.create_dataset(
        'train_spikes', shape=(N, T, C, H, W), dtype='bool',
        compression="gzip", chunks=True
    )
    f_new.create_dataset('train_labels', data=labels_old[:], compression="gzip")

    for start in range(0, N, chunk_size):
        end = min(start + chunk_size, N)
        data = spikes_old[:, start:end, :, :, :]          # (T, chunk, C, H, W)
        data = np.transpose(data, (1, 0, 2, 3, 4))       # (chunk, T, C, H, W)
        spikes_new[start:end] = data
        print(f"  训练样本 {start}~{end-1} 转换完成")

print("训练集转换完毕。")

# ---- 转换测试集 ----
print("转换测试集...")
with h5py.File(test_old, 'r') as f_old, h5py.File(test_new, 'w') as f_new:
    spikes_old = f_old['test_spikes']   # (T, N, 1, 16, 16)
    labels_old = f_old['test_labels']
    T, N, C, H, W = spikes_old.shape

    spikes_new = f_new.create_dataset(
        'test_spikes', shape=(N, T, C, H, W), dtype='bool',
        compression="gzip", chunks=True
    )
    f_new.create_dataset('test_labels', data=labels_old[:], compression="gzip")

    for start in range(0, N, chunk_size):
        end = min(start + chunk_size, N)
        data = spikes_old[:, start:end, :, :, :]
        data = np.transpose(data, (1, 0, 2, 3, 4))
        spikes_new[start:end] = data
        print(f"  测试样本 {start}~{end-1} 转换完成")

print("测试集转换完毕。")
print(f"新文件已保存：\n{train_new}\n{test_new}")
# %%
# 读取训练集转换后的文件
file_path = './mnist_16x16/train_mnist_poisson_250_NT.h5'

with h5py.File(file_path, 'r') as f:
    spikes = f['train_spikes']   # (N, T, 1, 16, 16) – 只建立索引，未加载全部数据
    labels = f['train_labels']
    total = spikes.shape[0]

    idx = random.randint(0, total - 1)
    sample_spikes = spikes[idx]  # 取出一个样本的全部脉冲: (T, 1, 16, 16)
    label = labels[idx]

    # 读取原始 16x16 池化图像作为对照（仍从之前的 .pt 文件读取）
    pooled = torch.load('./mnist_16x16/train_16x16.pt', map_location='cpu')
    original_img = pooled['images'][idx, 0].numpy()

# 绘制：原始图像 + 5 个时间步的脉冲图
fig, axes = plt.subplots(2, 3, figsize=(8, 5))
axes = axes.flatten()

axes[0].imshow(original_img, cmap='gray')
axes[0].set_title(f'Original (label={label})')
axes[0].axis('off')

time_steps_to_show = [0, 50, 100, 150, 200]
for i, t in enumerate(time_steps_to_show):
    # sample_spikes[t] 形状为 (1, 16, 16)，取第 0 通道
    spike_img = sample_spikes[t, 0]  # (16, 16)
    axes[i+1].imshow(spike_img, cmap='gray', vmin=0, vmax=1)
    axes[i+1].set_title(f'Spike t={t}')
    axes[i+1].axis('off')

plt.tight_layout()
plt.show()
# %%
