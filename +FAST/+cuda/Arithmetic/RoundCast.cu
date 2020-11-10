/********************************************************
*	Author: Zhao Mingxin
*	Date:	2020/11/10
*	Description: CUDA Kernel for mul-shift-round operation.
*	The input x will be multiplied with mul, then right-shift
*	shift-1 bits. Rounding up or down is determined by the 
*	remaining last bit, which means we round down if the 
*	remaining bit is 0.
*
*	NOTE:	If you have any issues about this code, please
*	feedback.
*	Homepage:	https://jackgittes.github.io
*********************************************************/

__global__ void RoundCast(const long long *src, long long *dst,
                        const int mul, const int shift, const int bit_width,
                        const int height, const int width, const int chn)
{
    long long tmp;
    long long last_bit_mask = 1;
    long long bit_value;
    long long upbound = 2 << (bit_width-1) - 1, lowbound = -2 << (bit_width-1);

    // Calculate current element id.
    int chn_id = blockIdx.z;
    int row_id = blockIdx.x * blockDim.x + threadIdx.x;
    int col_id = blockIdx.y * blockDim.y + threadIdx.y;
    int ele_id = chn_id * height * width + col_id * height + row_id;

    if(row_id<width && col_id<height){
        tmp = src[ele_id];

        tmp = (tmp * mul) >> (shift-1);
        bit_value = tmp & last_bit_mask;
        tmp = (tmp >> 1) + bit_value; 

        tmp = tmp > upbound ? upbound:tmp;
        tmp = tmp < lowbound ? lowbound:tmp;

        dst[ele_id] = tmp;
    }
}
