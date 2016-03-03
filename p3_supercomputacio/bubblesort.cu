#include <stdio.h>
#include <time.h>
#define MIN(a,b) (a < b ? a : b)
static const int N = 50;


__global__ void bubble_sort(int *array, int iteracio)
{
	int id = threadIdx.x + blockIdx.x * blockDim.x;
	/*
	for(int i =0 ; i < N - id ; ++i){ //usamos el id del array para saber hasta donde recorrer. Es esto lo k se debe hacer?
		if(array[i] > array[i+1]){
			int aux = array[i];
			array[i]=array[i+1];
			array[i+1] = aux;
		}
	}*/
	int aux;
	if(array[id-1] < array [id]){
		aux = array[id-1];
		array[id-1] = array[id];
		array[id] = aux;
	}
}

int main(int argc, char const *argv[]) 
{
	
    srand(time(NULL));


	int a[N];
	int *dev_a;



	for(int i=0;i<N;i++)
		a[i] = (int)rand()/(int)(RAND_MAX/300.0);
	printf("desordenat\n");
	for(int i=0;i<N;i++)
		printf("%d ", a[i]);


 	
 	//device Memmory
	cudaMalloc((void**)&dev_a, N*sizeof(int) );

	cudaMemcpy(dev_a,a,N*sizeof(int),cudaMemcpyHostToDevice);
	
	int threads_block = MIN(512,N);
	while(N%threads_block != 0)--threads_block;
	int blocks = N / threads_block;
	for (int it = 0; it <= 0; it++) {

		//Crida al kernel
		bubble_sort<<<blocks,threads_block>>>(dev_a,it);	//nose el porque se debe hacer hasta 2*N
		
	}

	cudaMemcpy(a,dev_a,N*sizeof(int),cudaMemcpyDeviceToHost);

	

	printf("\nOrdenat\n");
	for(int i=0;i<N;i++)
		printf("%d ", a[i]);



	
	return 0;
}
