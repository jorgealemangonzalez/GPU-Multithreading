#include<stdio.h>
#include <time.h>
#define TRUE 1
#define FALSE 0
#define MIN(a,b) (a < b?a:b )
static const int N = 150;

__global__ void cerca_array_device(int *array,int *valor,int *res)
{
	int b;
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    if(*res == FALSE && *valor == array[id]){
    	*res = TRUE;
    	/*for(int i = 0; i <= 1000000; i++) //demostrar que si se hacen mas operacines en la busqueda, los threads son
			b = (b*70)/3;*/				//muxo mas rapidos.
    }

}


__host__ bool cerca_array_host(int *array, int valor)
{
	int b;
	for(int i = 0 ; i < N ; ++i){
		if(array[i] == valor){
			return true;
		}
		/*for(int i = 0; i <= 1000000; i++)
			b = (b*70)/3;*/
	}

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
	
   
    
    int *dev_array , *dev_value , *dev_res;
	cudaMalloc((void**)&dev_array, N*sizeof(int) );
	cudaMalloc((void**)&dev_value, sizeof(int) );
	cudaMalloc((void**)&dev_res, sizeof(int) );
	
	res = FALSE;
	cudaMemcpy(dev_array, a, N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_value, &valor, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_res, &res, sizeof(int), cudaMemcpyHostToDevice);
	
    int threads_block = MIN(512,N);
	while(N%threads_block != 0)--threads_block;
	int blocks = N / threads_block;
	
	clock_t t_device = clock();
	cerca_array_device<<<blocks,threads_block>>>(dev_array,dev_value,dev_res); 
	cudaMemcpy(&res, dev_res, sizeof(int), cudaMemcpyDeviceToHost);//Copy memory from device to host
    t_device = clock() - t_device;

    double time_taken_device = ((double)t_device)/CLOCKS_PER_SEC; 
        printf("GPU %f segons \n", time_taken_device);

   	cudaFree(dev_array);//free device mem
	cudaFree(dev_value);
	cudaFree(dev_res);


	//Printa si ha cercat el nombre
	if(res == TRUE)
		printf("device: We found the number\n");
	else
		printf("device: We don't found the number :(\n");
		
   
return 0;


}

