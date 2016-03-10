
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#define imin(a,b) (a<b?a:b)

//Nombre de posicions del vector
const int N = 33 * 1024;

//Nombre de threads per cada block
const int threadsPerBlock = 256;

//Escollim el nombre de blocs a la grid
const int blocksPerGrid = imin(32, (N+threadsPerBlock-1)/threadsPerBlock);

__global__ void producte_escalar(float* a, float* b, float* c) {
	
	//Declarem un vector cache de memoria compartida
	__shared__ float cache[threadsPerBlock];
	//Inicialitzem l'index amb una combinació de blocks i threads
	int tid = threadIdx.x + blockIdx.x * blockDim.x;

	//Inicialitzem l'index del cache. PISTA: Es compartid per cada bloc, és a dir, cada block te una copia
	int indexCache = threadIdx.x;
	
	float temp = 0;
	//Fem la suma de productes al block actual
	while(tid < N) {
		temp += a[tid]*b[tid];
		
		tid += blockDim.x * gridDim.x;
	}
	
	//Emmagatzem el valor temporal de la suma de productes a la cache
	cache[indexCache] = temp;

	//ara hem de llegir els valors de la cache, però abans ens hem d'assegurar que els valors s'han escrit
	
	__syncthreads();
	
	//Reduim el vector
	int i = blockDim.x/2;
	while(i != 0) {
		if(indexCache < i) {
			cache[indexCache] += cache[indexCache + i];
		}

		__syncthreads();
		i /= 2;
	}
	
	//Retornem un vector c que tindrà tantes posicions com blocks estem fent servir.
	//Guardem a c el contingut de cache a la unica posició restant. Per què?------------------------> Porque n es potencia de dos
	c[blockIdx.x] = cache[0] ;

}

int main()
{
	float *a, *b, *c;
	float *dev_a, *dev_b, *dev_c;
	int size = N*sizeof(float);

	//Reserva memoria a la CPU
	a = (float *)malloc(size);
	b = (float *)malloc(size);
	c = (float *)malloc(blocksPerGrid * sizeof(float));

	//Reserva memoria a la GPU.

	cudaMalloc((void**)&dev_a, size);
	cudaMalloc((void**)&dev_b, size);
	cudaMalloc((void**)&dev_c, blocksPerGrid * sizeof(float));

	printf("Blocks : %d ",blocksPerGrid);

	//Emplenem els vector a i b
	for(int i = 0; i < N; i++) {
		a[i] = i;
		b[i] = 2 * i;
	}

	//Copiem els arrays a i b a la GPU
	cudaMemcpy(dev_a,a,size,cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b,b,size,cudaMemcpyHostToDevice);




	producte_escalar<<<blocksPerGrid, threadsPerBlock>>>(dev_a, dev_b, dev_c);

	//Copiem l'array dev_c a c

	cudaMemcpy(c,dev_c,blocksPerGrid * sizeof(float),cudaMemcpyDeviceToHost);

	//Acabem de realitzar la suma de productes
	float value = 0;

	for(int i = 0 ; i < blocksPerGrid ; ++i)
		value += c[i];
	float value_host = 0;
	for(int i = 0 ; i < N ; ++i){
		value_host += a[i]*b[i];
	}
	printf("Producte escalar es: %f pero deberia ser %f diff: %f\nThis is due to we are running less threads that we need\n", value , value_host ,value_host - value);

	//Allibera memoria a la GPU
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	
	//Allibera memoria a la CPU
	free(a);
	free(b);
	free(c);
    return 0;
}

