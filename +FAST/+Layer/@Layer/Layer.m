% Auto Generated in 2018-12-22 22:40:35 By MATLAB 2017b
% Author: Zhao Mingxin
classdef Layer < FAST.Layer.BaseLayer
	 methods
		[Out1]=AddBias(obj,Arg1,Arg2,Arg3,Arg4);
		[Out1]=Conv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
		[Out1]=DepthwiseConv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
		[Out1]=LiteConv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11);
		[Out1]=PointwiseConv2d(obj,Arg1,Arg2,Arg3,Arg4);
		[Out1]=Pooling(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7);
		[Out1]=ReLU(obj,Arg1);
		[Out1]=ReLU6(obj,Arg1);
	 end
end