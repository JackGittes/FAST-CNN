/********************************************************
*	Author: Zhao Mingxin
*	Date:	2018/12/11
*	Description: CUDA Kernel for matmul. 
*
*	NOTE:	If you have any issues about this code, please
*	feedback.
*	Homepage:	https://jackgittes.github.io
*********************************************************/
__global__ void MatMulKernel(const int *A,const int *B,const int Aheight,const int Awidth,const int Bwidth, const int up_bound,const int low_bound,int *C)
{
	int Cvalue = 0;
	int prod_tmp;
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