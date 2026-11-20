#include "filtering.h"

unsigned int compute_dim(std::uint64_t global_size, int block_size)
{
	return static_cast<unsigned int>((global_size / block_size) + (global_size % block_size > 0 ? 1 : 0));
}


__global__ void gray_scale_kernel(
	std::uint32_t* dst_data,
	std::uint32_t* src_data,
	std::uint64_t w, std::uint64_t h)
{
	//TODO: 1.2) Implement conversion
	auto pos_x = (blockIdx.x * blockDim.x) + threadIdx.x;
	auto pos_y = (blockIdx.y * blockDim.y) + threadIdx.y;

	if(pos_x >= w || pos_y >= h)
		return;

	auto pixel = src_data[pos_x + pos_y * w];
	unsigned char r = pixel & 0xff;
	unsigned char g = (pixel >> 8) & 0xff;
	unsigned char b = (pixel >> 16) & 0xff;

	float f = 0.2126f * static_cast<float>(r) + 0.7152f * static_cast<float>(g) + 0.0722f * static_cast<float>(b);
	unsigned char l = static_cast<unsigned char>(f + 0.5f);

	dst_data[pos_x + pos_y * w] = (l) | (l << 8) | (l << 16);
}

void to_grayscale(gpu_image& dst, gpu_image const& src)
{
	dim3 block_size = { 32, 32 };
	dim3 grid_size = { compute_dim(src.width, block_size.x), compute_dim(src.height, block_size.y) };
	gray_scale_kernel<<<grid_size, block_size>>>(dst.data.get(), src.data.get(), src.width, src.height);
}


__global__ void convolution_kernel(
	std::uint32_t* dst_data,
	std::uint32_t* src_data,
	std::uint64_t w, std::uint64_t h,
	float* filter_data,
	std::uint64_t fw, std::uint64_t fh,
	bool use_abs_value)
{
	//TODO: 1.3) Implement convolution

	float rf = 0.f;
	float gf = 0.f;
	float bf = 0.f;

	int64_t x_offset = fw / 2;
	int64_t y_offset = fh / 2;

	int64_t x_index = (blockIdx.x * blockDim.x) + threadIdx.x;
	int64_t y_index = (blockIdx.y * blockDim.y) + threadIdx.y;

	if(x_index >= w || y_index >= h)
		return;

	int64_t x_idx = x_index - x_offset;
	int64_t y_idx = y_index - y_offset;

	for(int64_t i = 0; i < fw; ++i)
	{
		for(int64_t j = 0; j < fh; ++j)
		{
			int64_t x = std::max<int64_t>(0, std::min((x_idx + i), static_cast<int64_t>(w - 1)));
			int64_t y = std::max<int64_t>(0, std::min((y_idx + j), static_cast<int64_t>(h - 1)));
			uint32_t pixel = src_data[x + y * w];
			unsigned char r = pixel & 0xff;
			unsigned char g = (pixel >> 8) & 0xff;
			unsigned char b = (pixel >> 16) & 0xff;

			float weight = filter_data[i + j * fw];
			rf += static_cast<float>(r) * weight;
			gf += static_cast<float>(g) * weight;
			bf += static_cast<float>(b) * weight;
		}
	}

	if(use_abs_value)
	{
		rf = abs(rf) / 2.f;
		gf = abs(gf) / 2.f;
		bf = abs(bf) / 2.f;
	}

	unsigned char rn = static_cast<unsigned char>(rf + 0.5f);
	unsigned char gn = static_cast<unsigned char>(gf + 0.5f);
	unsigned char bn = static_cast<unsigned char>(bf + 0.5f);

	dst_data[x_index + y_index * w] = (rn) | (gn << 8) | (bn << 16);
}

void apply_convolution(gpu_image& dst, gpu_image const& src, gpu_filter const& filter, bool use_abs_value)
{
	dim3 block_size = { 32, 32 };
	dim3 grid_size = { compute_dim(src.width, block_size.x), compute_dim(src.height, block_size.y) };
	convolution_kernel<<<grid_size, block_size>>>(dst.data.get(), src.data.get(), src.width, src.height, filter.data.get(), filter.width, filter.height, use_abs_value);
}


constexpr int num_threads = 64;
__global__ void histogram_kernel(
	std::uint32_t* hist_data,
	std::uint32_t* img_data,
	std::uint64_t w, std::uint64_t h,
	std::uint8_t channel_flags = 1)
{
	//TODO: 1.4) Implement histogram computation
	auto x = (blockIdx.x * blockDim.x) + threadIdx.x;

	if(x >= w)
		return;

	for(int row = 0; row < h; ++row)
	{
		uint32_t pixel = img_data[x + row * w];
		unsigned char r = pixel & 0xff;
		unsigned char g = (pixel >> 8) & 0xff;
		unsigned char b = (pixel >> 16) & 0xff;

		if(channel_flags & 1)
			atomicAdd(&hist_data[r / (256 / num_bins)], 1);
		if(channel_flags & 2)
			atomicAdd(&hist_data[g / (256 / num_bins)], 1);
		if(channel_flags & 4)
			atomicAdd(&hist_data[b / (256 / num_bins)], 1);
	}
}

void compute_histogram(gpu_matrix<std::uint32_t>& hist, gpu_image const& img)
{
	std::uint8_t channel_flags = 1;
	cudaMemset(hist.data.get(), 0, hist.width * hist.height * sizeof(std::uint32_t));
	dim3 block_size = { num_threads };
	dim3 grid_size = { compute_dim(img.width, block_size.x) };
	histogram_kernel<<<grid_size, block_size>>>(hist.data.get(), img.data.get(), img.width, img.height, channel_flags);
}
