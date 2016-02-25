#include "stdio.h"
#define N 10

__global__ void add(int *a, int *b, int *c)
{
	int tid = threadIdx.x;
	c[tid]=a[tid]+b[tid];
}

int main()
{
	int a[N], b[N], c[N];//host 
	int *dev_a, *dev_b, *dev_c;//device

	cudaMalloc((void**)&dev_a, N*sizeof(int) );  
	cudaMalloc((void**)&dev_b, N*sizeof(int) );
	cudaMalloc((void**)&dev_c, N*sizeof(int) );


	for (int i = 0; i < N; i++){
		a[i] = i,
		b[i] = 1;
	}

	cudaMemcpy(dev_a, a, N*sizeof(int), cudaMemcpyHostToDevice); //host to device
	cudaMemcpy(dev_b, b, N*sizeof(int), cudaMemcpyHostToDevice);

	int blockSize = 1024;
	int gridSize = (int)ceil((int)N/blockSize);
	
	add<<<N,N>>>(dev_a,dev_b,dev_c); //Execute Kernel
	//Call CUDA kernel
	
	cudaMemcpy(c, dev_c, N*sizeof(int), cudaMemcpyDeviceToHost);//Copy memory from device to host
	//copy array to host
	for (int i = 0; i < N; i++)
		printf("%d + %d = %d\n", a[i], b[i], c[i]);
	
	cudaFree(dev_a);//free device mem
	cudaFree(dev_b);
	cudaFree(dev_c);

	/*
	free(a);//free host
	free(b);
	free(c);*/
	return 0;

}
