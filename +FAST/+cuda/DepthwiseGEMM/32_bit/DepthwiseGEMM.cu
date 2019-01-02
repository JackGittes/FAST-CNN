/********************************************************
*	Author: Zhao Mingxin
*	Date:	2018/12/11
*	Description: CUDA Kernel for DepthwiseGEMM. As GPU is good at
*	dealing with 32 bits computation and gets performance degradation
*	when bit-width is longer than 32, so the current DepthwiseGEMM 
*	version can't give right outputs when fixed point is more than 32 bits.
*
*	NOTE:	If you have any issues about this code, please
*	feedback.
*	Homepage:	https://jackgittes.github.io
*********************************************************/
__global__ void DepthwiseGEMM(const int *A,const int *B,const int Aheight,const int Awidth,const int Bwidth, const int up_bound,const int low_bound,int *C)
{
	int Cvalue = 0;
	int prod_tmp;
	int Bheight = Awidth;
	
	int chn = blockIdx.z;
	int row = blockIdx.x * blockDim.x + threadIdx.x;
	int col = blockIdx.y * blockDim.y + threadIdx.y;
	
	for (int e = 0; e < Awidth; ++e){
		prod_tmp = A[chn * Aheight * Awidth + Aheight * e + row]*B[chn*Bheight*Bwidth + col * Bheight+ e];
		if(prod_tmp>up_bound)
			prod_tmp = up_bound;
		if(prod_tmp<low_bound)
			prod_tmp = low_bound;
		Cvalue += prod_tmp;
		if(Cvalue>up_bound)
			Cvalue=up_bound;
		if(Cvalue<low_bound)
			Cvalue=low_bound;
	}	
	C[chn*Aheight*Bwidth + Aheight*col + row] = Cvalue;
}