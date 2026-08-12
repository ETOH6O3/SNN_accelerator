
import os
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

def create_grayscale_image(data, save_path='output.png'):
    """
    将 65536 个 [-1, 1] 的数值，按方阵顺序绘制为 256x256 灰度图并保存。

    参数
    ----------
    data : array-like, shape (65536,)
        输入数值，范围建议在 [-1, 1]
    save_path : str
        输出图片路径
    """
    data = np.asarray(data, dtype=np.float64).flatten()
    if data.size != 65536:
        raise ValueError(f"数据长度必须为 65536，实际得到 {data.size}")

    # 1. 将 [-1, 1] 映射到 [0, 255] 灰度值
    gray = 255 - (data + 1.0) / 2.0 * 255.0
    gray = np.clip(gray, 0, 255).astype(np.uint8)

    # 2. 计算每个数值的像素坐标
    k = np.arange(65536)                # 原始顺序索引
    inner_idx = k // 256                # 位于第几个 16x16 方块 (0~255)
    inner_row = inner_idx // 16         # 方块所在行 (0~15)
    inner_col = inner_idx % 16          # 方块所在列 (0~15)

    block_idx = k % 256                 # 方块内部索引 (0~255)
    block_row = block_idx // 16         # 方块内行 (0~15)
    block_col = block_idx % 16          # 方块内列 (0~15)

    y = block_row * 16 + inner_row      # 图像中的行坐标
    x = block_col * 16 + inner_col      # 图像中的列坐标

    # 3. 创建全零图像，并按坐标填灰度值
    img = np.zeros((256, 256), dtype=np.uint8)
    img[y, x] = gray

    # 4. 保存为灰度 PNG
    Image.fromarray(img, mode='L').save(save_path)
    print(f"图像已保存至: {save_path}")

def extract_weight(line: str) -> float:
    data: int = int(line.strip(), 16) & 0xFF  # Extract the last 8 bits
    if data & 0x80:  # Check if the sign bit is set
        data = data - 256  # Convert to negative value
    return data / 128.0  # Normalize to [-1, 1)

with open(os.path.dirname(__file__) + "/ram_data.txt", "r") as f:
    lines = f.readlines()
    weights = [extract_weight(line) for line in lines]

    plt.hist(weights, bins=20, edgecolor='black')
    plt.xlabel("Weight Value")
    plt.ylabel("Frequency")
    plt.title("Distribution of Weights")
    plt.show()

    create_grayscale_image(weights, save_path=os.path.dirname(__file__) + "/weights_image.png")

    pass