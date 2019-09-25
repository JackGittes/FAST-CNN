/********************************************************
*	Author: Zhao Mingxin
*	Date:	2018/12/11
*	Description: CUDA Kernel for matmul. 
*
*	NOTE:	If you have any issues about this code, please
*	feedback.
*	Homepage:	https://jackgittes.github.io
*********************************************************/
__global__ void MatMulKernel(const long long *A,const long long *B,const int Aheight,const int Awidth,const int Bwidth, const long long up_bound,const long long low_bound,long long *C)
{
	long long Cvalue = 0;
	long long prod_tmp;
	int Bheight = Awidth;
	
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;

	for (int e = 0; e < Awidth; ++e){
		prod_tmp = A[Aheight * e + row]*B[col * Bheight + e];
		if(prod_tmp>up_bound)
			prod_tmp=up_bound;
		if(prod_tmp<low_bound)
			prod_tmp=low_bound;
		
		Cvalue+=prod_tmp;
		if(Cvalue>up_bound)
			Cvalue=up_bound;
		if(Cvalue<low_bound)
			Cvalue=low_bound;
	}	
	C[Aheight*col + row] = Cvalue;
}