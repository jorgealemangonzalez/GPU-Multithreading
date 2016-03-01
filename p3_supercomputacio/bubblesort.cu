#include <stdio.h>
#include <time.h>


static const int N = 15;


__global__ void bubble_sort(int *array, int iteracio)
{
	int idx;

	//Condició per a continuar iterant
	//...

		//El vostre codi principal aquí
	
}



int main(int argc, char const *argv[]) 
{
	
    srand(time(NULL));


	int a[N];
	int *dev_a;



	for(int i=0;i<N;i++)
		a[i] = (int)rand()/(int)(RAND_MAX/100.0);

	for(int i=0;i<N;i++)
		printf("Unsorted: %d \n", a[i]);



	for (int it = 0; it <= N*2; it++) {

		//Crida al kernel
		
	}

	


	for(int i=0;i<N;i++)
		printf("Sorted: %d \n", a[i]);



	
	return 0;
}
