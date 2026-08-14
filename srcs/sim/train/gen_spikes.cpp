
#include <windows.h>
#include <iostream>
#include <cstdint>
#include <vector>

#include "svdpi.h"

using namespace std;

static void *get_func_ptr(const char *dll_path, const char *func_name)
{
    HMODULE hDll = LoadLibraryA(dll_path);
    if (!hDll)
    {
        std::cerr << "Failed to load DLL: " << dll_path << ". Error: " << GetLastError() << std::endl;
        return nullptr;
    }

    auto func_ptr = (void *)GetProcAddress(hDll, func_name);
    if (!func_ptr)
    {
        std::cerr << "Failed to find function '" << func_name << "' in DLL: " << dll_path << std::endl;
        FreeLibrary(hDll);
        return nullptr;
    }

    return func_ptr;
}

// 注： \SNN_accelerator.sim\train\behav\xsim 下已经放置所需 dll

using PoissonImage = unsigned char[250][16][16];
// void* get_hdf5_file_ptr(const char* filename)
using get_hdf5_file_ptr_t = void *(*)(const char *);
// void getSampleSpikes(PoissonImage* output, uint64_t sample_index, void* hdf5_file_ptr, const char* dataset_name);
using getSampleSpikes_t = void (*)(PoissonImage *, uint64_t, void *, const char *);
// unsigned char read_nth_label(uint64_t n, void* hdf5_file_ptr, const char* data_set_name);
using read_nth_label_t = unsigned char (*)(uint64_t, void *, const char *);

static get_hdf5_file_ptr_t get_hdf5_file_ptr = get_hdf5_file_ptr_t(get_func_ptr("hdf5_poisson_code_reader_for_dpic.dll", "get_hdf5_file_ptr"));
static getSampleSpikes_t getSampleSpikes = getSampleSpikes_t(get_func_ptr("hdf5_poisson_code_reader_for_dpic.dll", "getSampleSpikes"));
static read_nth_label_t read_nth_label = read_nth_label_t(get_func_ptr("hdf5_poisson_code_reader_for_dpic.dll", "read_nth_label"));

const char train_spikes_dsname[] = "train_spikes";
const char train_labels_dsname[] = "train_labels";
const char test_spikes_dsname[] = "test_spikes";
const char test_labels_dsname[] = "test_labels";

auto train_file_ptr = get_hdf5_file_ptr("..\\..\\..\\..\\srcs\\dataset\\mnist_16x16\\train_mnist_poisson_250_NT.h5");

constexpr int INIT_LABEL = 8;
extern "C"
{
    static int current_label = INIT_LABEL;
    static size_t current_index = 0;
    static int round = 0;
    vector<size_t> label_found[10]; // 搜索到的标签索引，下标为标签值，值为索引列表

    /**
     * @brief 向控制台输出缓存队列数据
     *
     */
    void report_queue()
    {
        cout << "================================" << endl;
        cout << "Reporting queue: " << endl;
        for (int i = 0; i < 10; ++i)
        {
            cout << "label " << i << ": ";
            for (auto idx : label_found[i])
            {
                cout << idx << " ";
            }
            cout << endl;
        }
        cout << "================================" << endl;
    }

    /**
     * 查找下一个匹配当前标签的样本索引
     *
     * 该函数优先从缓存中获取已找到的匹配索引。若缓存为空，
     * 则从训练数据集顺序读取样本标签，直到找到与当前标签匹配的样本。
     * 不匹配的样本索引会被缓存以供后续使用。
     *
     * @return 匹配当前标签的样本索引
     */
    size_t find_next_index()
    {
        // 依次查找索引

        cout << "================================" << endl;
        cout << "Round " << ::round << " || Searching for next index matching label: " << current_label << endl;

        if (label_found[current_label].size() > 0)
        {
            auto it = label_found[current_label].begin();
            size_t index = *it;
            label_found[current_label].erase(it); // 删除头部
            cout << "using cached index: " << index << endl;
            current_label++;
            if (current_label == 10)
            {
                current_label = 0;
            }
            if (current_label == INIT_LABEL)
            {
                cout << "Round " << ::round << " completed." << endl;
                ::round++;
            }
            return index;
        }
        while (true)
        {
            auto label = (int)read_nth_label(current_index, train_file_ptr, train_labels_dsname);
            cout << "read label: " << label << " at index: " << current_index << endl;

            if (label == current_label)
            {
                cout << "================================" << endl;
                cout << "label matched" << endl;
                current_label++;
                if (current_label == 10)
                {
                    current_label = 0;
                }
                if (current_label == INIT_LABEL)
                {
                    cout << "Round " << ::round << " completed." << endl;
                    ::round++;
                }

                return current_index++;
            }
            else
            {
                // 存入队列
                label_found[label].push_back(current_index);
            }
            current_index++;
        }
    }

    /**
     * @brief 恢复上次训练结束时的内部状态
     * @param last_idx 上次训练结束时，最后一个训练样本的索引
     */
    void resume_breakpoint(size_t last_idx)
    {
        cout << "Resumimng to breakpoint ......" << endl;
        cout << "================================" << endl;
        while (find_next_index() != last_idx)
            ;
        cout << "================================" << endl;
        cout << "Resumed to where after index: " << last_idx << endl;
    }
    /**
     * @brief 向 sv 开放数组中写入下一个匹配当前标签的样本的脉冲图像数据
     *
     * @param arr sv 开放数组对象
     */
    void next(svOpenArrayHandle arr)
    {
        auto arr_p = (PoissonImage *)svGetArrayPtr(arr);
        auto idx = find_next_index();
        getSampleSpikes(arr_p, idx, train_file_ptr, train_spikes_dsname);
    }
}