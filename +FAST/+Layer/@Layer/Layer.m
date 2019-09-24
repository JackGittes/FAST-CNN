% Auto Generated in 24-Sep-2019 22:53:11 By MATLAB 2018b
% Author: Zhao Mingxin
classdef Layer < FAST.Layer.BaseLayer
	 methods
		[Out1]=AddBias(obj,Arg1,Arg2,Arg3,Arg4);
		[Out1]=Conv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
		[Out1]=DepthwiseConv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
		[Out1,Out2]=LiteConv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12,Arg13,Arg14,Arg15);
		[Out1,Out2]=LiteConv2d_beta(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12,Arg13,Arg14);
		[Out1]=PointwiseConv2d(obj,Arg1,Arg2,Arg3,Arg4);
		[Out1]=Pooling(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7);
		[Out1]=ReLU(obj,Arg1);
		[Out1]=ReLU6(obj,Arg1);
	 end
end
