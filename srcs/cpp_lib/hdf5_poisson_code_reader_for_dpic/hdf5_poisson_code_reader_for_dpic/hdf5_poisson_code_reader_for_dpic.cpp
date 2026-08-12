// hdf5_poisson_code_reader_for_dpic.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <stdexcept>
#include <iostream>
#include <vector>
#include <array>
#include <random>
#include <print>
#include <direct.h>
#include <H5Cpp.h>

#include "hdf5_poisson_code_reader_for_dpic.h"

extern "C" {

	//const std::string train_filename = "..\\..\\..\\mnist_16x16\\train_mnist_poisson_250_NT.h5";
	//auto static train_hdf5_file = H5::H5File(train_filename, H5F_ACC_RDONLY);
	//MYLIB_API void* train_hdf5_file_ptr = &train_hdf5_file;

	//const static std::string test_filename = "..\\..\\..\\mnist_16x16\\test_mnist_poisson_250_NT.h5";
	//auto static test_hdf5_file = H5::H5File(test_filename, H5F_ACC_RDONLY);
	//MYLIB_API void* test_hdf5_file_ptr = &test_hdf5_file;


	MYLIB_API void* get_hdf5_file_ptr(const char* _filename)
		try {
			static H5::H5File file;
			file = H5::H5File(_filename, H5F_ACC_RDONLY);
			return static_cast<void*>(&file);
		}
	catch (const H5::Exception& e) {
		std::cerr << "HDF5 错误: " << e.getDetailMsg() << std::endl;
		char buf[256];
		if (_getcwd(buf, sizeof(buf)) != nullptr) {
			std::clog << "当前工作目录: " << buf << std::endl;
		}
		else {
			std::clog << "获取当前工作目录失败（可能路径过长或权限问题）" << std::endl;
		}
		std::clog << "请检查文件路径和名称是否正确: " << _filename << std::endl;
		return nullptr;
	}
	catch (const std::exception& e) {
		std::cerr << "标准异常: " << e.what() << std::endl;
		return nullptr;
	}
	catch (...) {
		std::cerr << "未知错误" << std::endl;
		return nullptr;
	}

	MYLIB_API void getSampleSpikes(PoissonImage* output, uint64_t sample_index, void* hdf5_file_ptr, const char* dataset_name)
	{
		try {
			H5::H5File& file = *static_cast<H5::H5File*>(hdf5_file_ptr);

			// 打开数据集和数据空间
			H5::DataSet dataset = file.openDataSet(dataset_name);
			H5::DataSpace file_space = dataset.getSpace();

			// 准备读取区域：选择第 sample_index 个样本的全部时间步
			hsize_t start[5] = { sample_index, 0, 0, 0, 0 };
			hsize_t count[5] = { 1, 250, 1, 16, 16 };
			file_space.selectHyperslab(H5S_SELECT_SET, count, start);

			// 内存空间：一维数组，大小为 250 * 1 * 16 * 16 = 64000
			hsize_t mem_size = 250 * 16 * 16;
			H5::DataSpace mem_space(1, &mem_size);

			// 缓冲区（使用 unsigned char，因为 HDF5 布尔型常存为 8 位整型）
			std::vector<unsigned char> buffer(mem_size);

			// 读取数据（数据类型使用原生 unsigned char）
			dataset.read(buffer.data(), H5::PredType::NATIVE_UCHAR, mem_space, file_space);

			// 填充返回的三维 std::array
			for (size_t t = 0; t < 250; ++t) {
				for (size_t h = 0; h < 16; ++h) {
					for (size_t w = 0; w < 16; ++w) {
						// buffer 的排列顺序：时间步优先，然后行，最后列
						size_t idx = t * 16 * 16 + h * 16 + w;
						(*output)[t][h][w] = static_cast<bool>(buffer[idx]);
					}
				}
			}
		}
		catch (const H5::Exception& e) {
			std::cerr << "HDF5 错误: " << e.getDetailMsg() << std::endl;
			return;
		}
		catch (const std::exception& e) {
			std::cerr << "标准异常: " << e.what() << std::endl;
			return;
		}
		catch (...) {
			std::cerr << "未知错误" << std::endl;
			return;
		}
	}

	MYLIB_API unsigned char read_nth_label(uint64_t n, void* hdf5_file_ptr, const char* data_set_name) {
		try {

			H5::H5File& file = *static_cast<H5::H5File*>(hdf5_file_ptr);

			H5::DataSet dataset = file.openDataSet(data_set_name);
			H5::DataSpace dataspace = dataset.getSpace();

			// 选取单个元素
			hsize_t start[1] = { n };
			hsize_t count[1] = { 1 };
			dataspace.selectHyperslab(H5S_SELECT_SET, count, start);

			// 内存标量空间
			H5::DataSpace memspace(H5S_SCALAR);
			unsigned char label;
			dataset.read(&label, H5::PredType::NATIVE_UCHAR, memspace, dataspace);

			return label;
		}
		catch (const H5::Exception& e) {
			std::cerr << "HDF5 错误: " << e.getDetailMsg() << std::endl;
			return 1; // 或者其他错误码
		}
		catch (const std::exception& e) {
			std::cerr << "标准异常: " << e.what() << std::endl;
			return 1; // 或者其他错误码
		}
		catch (...) {
			std::cerr << "未知错误" << std::endl;
			return 1; // 或者其他错误码
		}
	}

}

auto test_hdf5 = []() {
	const std::string filename = "..\\..\\..\\mnist_16x16\\train_mnist_poisson_250_NT.h5";
	const std::string spikes_dsname = "train_spikes";
	const std::string labels_dsname = "train_labels";

	try {
		// 打开文件（只读）
		H5::H5File file(filename, H5F_ACC_RDONLY);

		// 打开脉冲数据集
		H5::DataSet spikes_ds = file.openDataSet(spikes_dsname);
		H5::DataSpace spikes_space = spikes_ds.getSpace();

		// 获取数据集维度
		int ndims = spikes_space.getSimpleExtentNdims();
		std::vector<hsize_t> dims(ndims);
		spikes_space.getSimpleExtentDims(dims.data(), nullptr);

		std::cout << "train_spikes 维度: [";
		for (int i = 0; i < ndims; ++i) {
			std::cout << dims[i] << (i < ndims - 1 ? ", " : "");
		}
		std::cout << "]" << std::endl;

		hsize_t N = dims[0];   // 样本数
		hsize_t T = dims[1];   // 时间步数
		hsize_t H = dims[3];   // 高度
		hsize_t W = dims[4];   // 宽度

		// 打开标签数据集
		H5::DataSet labels_ds = file.openDataSet(labels_dsname);
		H5::DataSpace labels_space = labels_ds.getSpace();
		ndims = labels_space.getSimpleExtentNdims();
		dims.resize(ndims);
		labels_space.getSimpleExtentDims(dims.data(), nullptr);
		std::cout << "train_labels 维度: [" << dims[0] << "]" << std::endl;

		// 随机选取一个样本索引
		std::random_device rd;
		std::mt19937 gen(rd());
		std::uniform_int_distribution<hsize_t> dist(0, N - 1);
		hsize_t idx = dist(gen);
		std::cout << "随机样本索引: " << idx << std::endl;

		// 读取该样本的全部脉冲数据 [T,1,16,16] 共 T*1*H*W 个元素
		hsize_t sample_size = T * 1 * H * W;
		std::vector<unsigned char> spike_buffer(sample_size);

		// 定义内存中的数据空间（一维）
		H5::DataSpace mem_space(1, &sample_size);

		// 在文件中选取该样本的 hyperslab
		hsize_t start[5] = { idx, 0, 0, 0, 0 };
		hsize_t count[5] = { 1, T, 1, H, W };
		spikes_space.selectHyperslab(H5S_SELECT_SET, count, start);

		// 读出数据（假设存储类型为 H5T_NATIVE_UCHAR，对应布尔/字节）
		spikes_ds.read(spike_buffer.data(), H5::PredType::NATIVE_UCHAR, mem_space, spikes_space);

		// 读取对应标签
		unsigned char label;
		H5::DataSpace label_mem_space(H5S_SCALAR);
		hsize_t label_start[1] = { idx };
		hsize_t label_count[1] = { 1 };
		labels_space.selectHyperslab(H5S_SELECT_SET, label_count, label_start);
		labels_ds.read(&label, H5::PredType::NATIVE_UCHAR, label_mem_space, labels_space);
		std::cout << "该样本的标签: " << (int)label << std::endl;

		// 显示该样本第 0 时间步的 16x16 像素值（0 或 1）
		std::cout << "第 0 时间步脉冲图 (16x16):" << std::endl;
		for (hsize_t y = 0; y < H; ++y) {
			for (hsize_t x = 0; x < W; ++x) {
				// 数据布局：T 维优先，然后 C(1), H, W
				// 对于单个样本，索引为 [t][0][y][x]
				hsize_t offset = 0 * H * W + y * W + x; // t=0 时
				std::cout << (int)spike_buffer[offset] << " ";
			}
			std::cout << std::endl;
		}

		file.close();
		std::cout << "读取成功！" << std::endl;

	}
	catch (const H5::Exception& e) {
		std::cerr << "HDF5 错误: " << e.getCDetailMsg() << std::endl;
		return 1;
	}

	return 0;
	};

//int main() {
//	//test_hdf5();"..\\..\\..\\mnist_16x16\\train_mnist_poisson_250_NT.h5"
//
//	auto spikes_ptr = getSampleSpikes(0, get_hdf5_file_ptr("..\\..\\..\\mnist_16x16\\train_mnist_poisson_250_NT.h5"), "train_spikes");
//
//	std::println("the 0th lable is: {}", read_nth_label(0, get_hdf5_file_ptr("..\\..\\..\\mnist_16x16\\train_mnist_poisson_250_NT.h5"), "train_labels"));
//
//	std::cout << "第 0 个样本的脉冲图:" << std::endl;
//	for (size_t i = 0; i < 250; i += 50) {
//		const auto& row = (*spikes_ptr)[i];
//		std::cout << "-------- T = " << i << " --------" << std::endl;
//		for (const auto& col : row) {
//			for (const auto& val : col) {
//				std::cout << ((bool)val ? "██" : "  ");
//			}
//			std::cout << std::endl;
//		}
//	}
//
//	auto ptr = getSampleSpikes;
//
//	return 0;
//
//}
