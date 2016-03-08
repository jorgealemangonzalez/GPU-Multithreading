#include <stdio.h>
#include <time.h>
#define MIN(a,b) (a < b ? a : b)
#define PINT 1
static const int N = 50000;


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
	/*int aux;
	if(array[id-1] < array [id]){
		aux = array[id-1];
		array[id-1] = array[id];
		array[id] = aux;
	}*/
	if(iteracio%2 == 0 ){
		if(array[2*id] > array[2*id+1])
		{
			int aux = array[2*id];
			array[2*id] = array[2*id+1];
			array[2*id+1] = aux;
		}
	}else{
		if(array[2*id+1] > array[2*id+2]){
			int aux = array[2*id+1];
			array[2*id+1] = array[2*id+2];
			array[2*id+2] = aux;
		}
	}

}
//swap values at memory locations
void swap(int *elem1, int *elem2)//Exange the values stored in the memory spaces elem1 and elem2
{								 //To do it we create an auxiliar variable where the value of the first element
								 //is stored while we store the value of the second iin the first one
//Your code here
	int aux = *elem1; //We use an auxiliar variable to do the swap
	*elem1 = *elem2;
	*elem2 = aux;

}

//Bubble sort algorithm to sort arrays in ascending order
void bubbleSort(int * const array, const int size)
{


//Your code here

//1. Iterate along array elements

//2. swap adjacent elements if they are out of order

	int i , j;
	for(i = 0; i < size-1 ; ++i)
		for(j = 0 ; j < size - i -1 ; ++j)
			if(*(array + j) > *(array + j + 1))
				swap(array+j , array+j+1);


}

int main(int argc, char const *argv[]) 
{
	
    srand(time(NULL));


	int a[N];
	int *dev_a;



	for(int i=0;i<N;i++)
		a[i] = (int)rand()/(int)(RAND_MAX/300.0);
	

#if PRINT
	printf("desordenat\n");	
	for(int i=0;i<N;i++)
		printf("%d ", a[i]);
#endif

 	//execucio al CPU

 	clock_t t_host = clock();
 	bubbleSort(a,N);
 	t_host = clock() - t_host;
   	double time_taken_host = ((double)t_host)/CLOCKS_PER_SEC;
   	printf("CPU: %f segons\n",time_taken_host);

   	//execucio GPU

 	//device Memmory
	cudaMalloc((void**)&dev_a, N*sizeof(int) );

	cudaMemcpy(dev_a,a,N*sizeof(int),cudaMemcpyHostToDevice);
	
	int threads_block = MIN(512,N);
	while(N%threads_block != 0)--threads_block;
	int blocks = N / threads_block;
	//execucio 

	clock_t t_device = clock();
	for (int it = 0; it <= 2*N; it++) {

		//Crida al kernel
		if(it%2 == 0){
			bubble_sort<<<1,(N/2)>>>(dev_a,it);
		}else{
			bubble_sort<<<1,(N/2)>>>(dev_a,it);
		}
			//nose el porque se debe hacer hasta 2*N
		
	}
	cudaMemcpy(a,dev_a,N*sizeof(int),cudaMemcpyDeviceToHost);

	t_device = clock() - t_device;
    double time_taken_device = ((double)t_device)/CLOCKS_PER_SEC; 
    printf("GPU %f segons \n", time_taken_device);
	

	printf("\nOrdenat\n");
	for(int i=0;i<N;i++)
		printf("%d ", a[i]);


	cudaFree(dev_a);
	
	return 0;
}
