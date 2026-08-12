import os

with open(
    os.path.dirname(__file__) + "/ram_data_vthr_22768_tref_15_hp_5us_17_1_105.txt", "r"
) as f, open(
    os.path.dirname(__file__) + "/ram_data_vthr_22768_tref_15_hp_5us_17_1_105.coe", "w"
) as fw:
    lines = f.readlines()
    print("memory_initialization_radix = 16;", file=fw)
    print("memory_initialization_vector =", file=fw)
    print(*( ("0" + line[1:-1:]) for line in lines), sep = ",\n", end = ";" ,file=fw)
