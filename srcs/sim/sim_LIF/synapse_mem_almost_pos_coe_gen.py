import random
import os

with open(os.path.dirname(__file__) + "/synapse_mem_almost_pos.coe", "w") as f:
    print("memory_initialization_radix = 16;", file=f)
    print("memory_initialization_vector =", file=f)
    print(
        *(
            f"0{random.randint(0,127) + (128 if random.randint(0,10) == 0 else 0):02x}"
            for _ in range(65536)
        ),
        sep=",\n",
        end=";",
        file=f,
    )
