#include "stdio.h"
#define N 10

__global__ void add(int *a, int *b, int *c)
{
	int tid;
	
}

int main()
{
	int a[N], b[N], c[N];
	int *dev_a, *dev_b, *dev_c;

	cudaMalloc(/*...*/);
	cudaMalloc(/*...*/);
	cudaMalloc(/*...*/);

	for (int i = 0; i < N; i++){
		a[i] = i,
		b[i] = 1;
	}

	cudaMemcpy(dev_a, a, N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N*sizeof(int), cudaMemcpyHostToDevice);

	//Call CUDA kernel

	cudaMemcpy();//Copy memory from device to host

	for (int i = 0; i < N; i++)
		printf("%d + %d = %d\n", a[i], b[i], c[i]);
	
	return 0;

}
