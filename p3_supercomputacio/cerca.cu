#include<stdio.h>
#include <time.h>

static const int N = 15;

__global__ void cerca_array_device(int *array,int *valor,int *res)
{

    int id;

	
	//El vostre codi aquí




}


__host__ bool cerca_array_host(int *array, int valor)
{

	//El vostre codi aquí

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
    clock_t t_host = clock();
    cerca_array_host(a,valor);
    t_host = clock() - t_host;
    double time_taken_host = ((double)t_host)/CLOCKS_PER_SEC;
 
    printf("CPU: %f segons \n", time_taken_host);


    clock_t t_device = clock();
	//Crida al kernel---
    t_device = clock() - t_device;

    double time_taken_device = ((double)t_device)/CLOCKS_PER_SEC; 
        printf("GPU %f segons \n", time_taken_device);

   

	//Printa si ha cercat el nombre

   
return 0;


}

