#include<stdio.h>
#include <time.h>
#include<math.h>
#define TRUE 1
#define FALSE 0
#define MIN(a,b) (a < b?a:b )
static const int N = 15;

__global__ void cerca_array_device(int *array,int *valor,int *res)
{

    int id = threadIdx.x + blockIdx.x * blockDim.x;
	
	*res = (array[id] == *valor ? TRUE : FALSE);


}


__host__ bool cerca_array_host(int *array, int valor)
{

	for(int i = 0 ; i < N ; ++i)
		if(array[i] == valor)
			return true;
	return false;
}

int main()
{

    srand(time(NULL));

    int a[N],valor;

   

   
 for(int i=0;i<N;i++)
		a[i] = (int)rand()/(int)(RAND_MAX/300.0);

 for(int i=0;i<N;i++)
	printf("valor: %d \t", a[i]);

   
    printf("\nNombre a cercar: ");
    scanf("%d",&valor);


   //Execució a la CPU
    int res;
    clock_t t_host = clock();
    res = cerca_array_host(a,valor);
    t_host = clock() - t_host;
    double time_taken_host = ((double)t_host)/CLOCKS_PER_SEC;
 
    printf("CPU: %f segons \n", time_taken_host);
	
	if(res == TRUE)
		printf("host: We found the number\n");
	else
		printf("host: We don't found the number :(\n");
	
    clock_t t_device = clock();
    int *dev_array , *dev_value , *dev_res;
	cudaMalloc((void**)&dev_array, N*sizeof(int) );
	cudaMalloc((void**)&dev_value, sizeof(int) );
	cudaMalloc((void**)&dev_res, sizeof(int) );
	
    int threads_block = MIN(512,N);
	while(N%threads_block != 0)--threads_block;
	int blocks = N / threads_block;
	
	cerca_array_device<<<blocks,threads_block>>>(dev_array,dev_value,dev_res); 
	cudaMemcpy(res, dev_res, sizeof(int), cudaMemcpyDeviceToHost);//Copy memory from device to host
    t_device = clock() - t_device;

    double time_taken_device = ((double)t_device)/CLOCKS_PER_SEC; 
        printf("GPU %f segons \n", time_taken_device);

   

	//Printa si ha cercat el nombre
	if(res == TRUE)
		printf("device: We found the number\n");
	else
		printf("device:  don't found the number :(\n");
   
return 0;


}

