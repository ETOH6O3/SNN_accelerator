import os
with open(os.path.dirname(__file__) + "/neuron_mem.coe", "w") as f:
    print("memory_initialization_radix = 16;", file=f)
    print("memory_initialization_vector =", file=f)
    print(*("000000" for _ in range(256)), sep = ",\n", end = ";" ,file=f)