% Auto Generated in 12-Nov-2020 16:03:45 By MATLAB 2018b
% Author: Zhao Mingxin
classdef Layer < FAST.Layer.BaseLayer
    methods
        [Out1]=Add(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
        [Out1]=AddBias(obj,Arg1,Arg2,Arg3,Arg4);
        [Out1]=Conv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
        [Out1]=DepthwiseConv2d(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6);
        [Out1]=PointwiseConv2d(obj,Arg1,Arg2,Arg3,Arg4);
        [Out1]=Pooling(obj,Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7);
        [Out1]=ReLU(obj,Arg1);
        [Out1]=ReLU6(obj,Arg1);
        [Out1]=RoundCast(obj,Arg1,Arg2,Arg3,Arg4);
        [Out1]=ZeroPad2d(obj,Arg1,Arg2);
    end
end
