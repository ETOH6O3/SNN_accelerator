RED = '\033[91m'
GREEN = '\033[92m'
BOLD = '\033[1m'
UNDERLINE = '\033[4m'
END = '\033[0m'
BRIGHT_CYAN = '\033[96m'

import os
import re
import argparse

def main():
    """
    主函数：统计仿真日志文件的错误信息并生成汇总报告。

    该函数搜索当前目录下所有 .log 文件，读取每个文件末尾的数字（错误计数），
    统计总错误数，并将所有日志内容合并到 summary.log 文件中。

    Returns:
        int: 错误总数作为程序退出码（最大255），0 表示无错误。
    """

    parser = argparse.ArgumentParser(description="统计仿真日志文件的错误信息并生成汇总报告。")
    parser.add_argument('-l','-log','--log', type=str, default='summary.log', help='指定 sv 仿真平台日志汇总文件名。默认值是 summary.log。')
    args = parser.parse_args()

    # 搜索当前目录下所有 .log 文件，读取末尾数字并统计

    script_dir = os.path.dirname(os.path.abspath(__file__))

    # 预先删除 summary.log 文件，如果存在的话
    summary_log_path = os.path.join(script_dir, 'summary.log')
    if os.path.exists(summary_log_path):
        os.remove(summary_log_path)

    log_files = [f for f in os.listdir(script_dir) if f.endswith('.log')]
    if not log_files:
        print("[error] No log files found in the directory.")
        return(-1) 

    err_cnt = 0

    print(f"{BOLD}Report simulation summary:{END}")
    for log_file in log_files:
        with open(os.path.join(script_dir, log_file), 'r') as f:
            content = f.read().strip()
            numbers = re.search(r'\d+$', content)
            if numbers:
                int_num = int(numbers.group())
                err_cnt += int_num
                if int_num:
                    print(f"{BOLD}{RED}Found {numbers.group()} errors in {log_file}{END}")
                else:
                    print(f"{BOLD}{GREEN}No errors found in {log_file}{END}")
            else:
                print(f"{BOLD}{RED}[error] No numbers found in {log_file}{END}")
                print(f"{BOLD}{RED}PLEASE CHECK IF FATAL ERROR INTERRUPTED THE SIMULATION{END}")
                return(-1)

    print(f"{BOLD}{UNDERLINE}{GREEN if err_cnt == 0 else RED}Simulation total error count: {err_cnt}{END}")

    # 拼接所有 .log 文件的内容到一个新的文件中

    combined_log_path = os.path.join(script_dir, args.log)
    with open(combined_log_path, 'w') as f:
        for log_file in log_files:
            with open(os.path.join(script_dir, log_file), 'r') as lf:
                f.write(f"\n\n==================== {log_file} ==================== \n\n")
                f.write(lf.read())
        print(f"\n\nSimulation total error count: {err_cnt}",end="", file=f)

    print(f"{BRIGHT_CYAN}Combined log file created at: {combined_log_path}{END}")
    return(err_cnt if err_cnt <= 255 else 255)

if __name__ == "__main__":
    exit(main())