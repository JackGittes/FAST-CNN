## Fixed-point Arithmetic Simulation Toolbox for CNN (FAST-CNN)

The motivation for this project is creating a general library which can simulate a CNN with fixed-point operations fast. Since **Python** is poor in fixed-point calculation support, I try to write the project in MATLAB thoroughly. While the fi object in MATLAB can conviniently express fixed-point(FXP) operations, there are still many functions in MATLAB that don't support fi. So I have to rewrite a lot of basic functions such as conv2d etc step by step.

### Project Progress
Several basic functions have been completed and carried on in a parallel way as possible. The comprehensive review of all functions as below:

<center>

|        **Type**         |       **Status**     |        **Description**          |
|:-----------------------:|:--------------------:|:-------------------------------:|
| Conv2d                  |      Completed       |                                 |
| Depthwise Conv          |      Completed       |                                 |
| Pooling                 |      Completed       |           MAX/AVG*              |
| ReLU                    |      Completed       |                                 |
| FC                      |      Completed       | By converting FC to Conv or MM  |
| Pointwise Conv          |      Completed       |  Can be replaced by Conv2d**    |

</center>

### Details

- The parallelism level (PL) of the source code is from vector to tensor. The definition of different levels is as below:
  - L1 Vector: 1×N array
  - L2 Matrix: M×N matrix
  - L3 Tensor: M×N×[H1,H2 ...], where the length of [H] is no less than 1.
  
  Higher the PL is, faster the function runs.

- Conv2d calculates 2d convolution of the input tensor, PL is L3, the input and output format are TF-compatible.
- Pooling calculates 2d pooling of the input tensor, PL is L3, while pooling function doesn't support 3d pooling like TF.
- Up to present, a standard ConvNet like MobileNet without ResBlock can run on this library. The MobileNet which has 28 layers with depthwise and pointwise convolution consumes about 3~5 minutes to forward once on a 224×224×3 input image @Intel Core i5-8400 CPU with 16.0 GB RAM.
- NOTE: If your MATLAB supports parallel computing with **Parallel Computing Toolbox (PCT)**, the algorithm will become faster. According to my test, fully parallel MobileNet will save about 65% time of non-parallel version, which means it takes 70 seconds to forward total 28 layers once. More cores you have on your PC, faster it runs.
- The acceleration mainly benefits from the **Im2col - Reshape - GEMM - Reshape - Output** procedure as below:

<center>
<img src="http://wx1.sinaimg.cn/large/41f56ddcly1fxq2je7sidg21fm0c0aaa.gif" width="900px">
</center>

### Requirement

All codes tested in **MATLAB R2017/18b and 2019a** on GTX 1050Ti/1080/1080Ti and RTX 2080Ti/2060. As I say above, this library is designed for simulating FXP-CNN and it's also an experimental research which helps us understand FXP behaviors of deep neural networks. Furthermore, it can help people who want to deploy their CNN algorithms on FXP devices (FPGA/ASIC etc) to verify the effectiveness of quantization method.

### GPU Support

GPU support is described as below, as for different hardware design, the GPU support is not a general implementation.

<center>
<img src="http://wx4.sinaimg.cn/large/41f56ddcly1fxsgd1cqqxj26fx1jtqv5.jpg" width="900px">
</center>

### TODO

More features will be added into FAST-CNN, including:

- Construct computation graph and execute forward process automatically.
  - User defines basic graph structure
  - Make graph and optimize the executation order
  - Initialize Graph with given parameters
  - Execute computation graph and report intermediate results for analyzing
- Support batch input mode as a suppplement to single image input mode which is the current implementation.
- Add backward function.
