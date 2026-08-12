#pragma once

#ifdef CMARTIN_LIB_POISSON_CODE_READER_FOR_DPIC_EXPORTS
#define MYLIB_API __declspec(dllexport)
#else
#define MYLIB_API __declspec(dllimport)
#endif

#include <string>

extern "C" {

	using PoissonImage = unsigned char[250][16][16];

	MYLIB_API void* get_hdf5_file_ptr(const char* filename);



	const char train_spikes_dsname[] = "train_spikes";
	const char train_labels_dsname[] = "train_labels";
	const char test_spikes_dsname[] = "test_spikes";
	const char test_labels_dsname[] = "test_labels";


	/**
	 * 从 HDF5 脉冲数据集中读取第 sample_index 个样本的全部时间步
	 * @param hdf5_file_ptr          已打开的 HDF5 文件的指针
	 * @param dataset_name  脉冲数据集名称（例如 "train_spikes" 或 "test_spikes"）
	 * @param sample_index  样本索引（0 起始）
	 * @return 三维数组指针，维度 [时间步数][高度][宽度]，每个元素为 bool
	 * @note 返回的指针指向静态数组，调用者无需释放内存，但在下一次调用该函数时内容会被覆盖
	 */
	MYLIB_API void getSampleSpikes(PoissonImage* output, uint64_t sample_index, void* hdf5_file_ptr, const char* dataset_name);


	/**
	 * 读取 HDF5 文件中第 n 个标签
	 * @param hdf5_file_ptr  已打开的 HDF5 文件的指针
	 * @param data_set_name  标签数据集名称（例如 "train_labels" 或 "test_labels"）
	 * @param n         样本索引（0-based）
	 * @return          标签值 (0~9)
	 */
	MYLIB_API unsigned char read_nth_label(uint64_t n, void* hdf5_file_ptr, const char* data_set_name);

}
