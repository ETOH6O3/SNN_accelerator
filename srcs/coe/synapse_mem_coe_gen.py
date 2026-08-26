import random
import os

def transform_neg(int8_num: int):
    if int8_num < 0:
        return 256 + int8_num
    else:
        return int8_num

with open(os.path.dirname(__file__) + "/synapse_mem.coe", "w") as f:
    print("memory_initialization_radix = 16;", file=f)
    print("memory_initialization_vector =", file=f)
    print(*( f"0{transform_neg(random.randint(0,96)):02x}" for _ in range(65536)), sep = ",\n", end = ";" ,file=f)