
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
	__shared__ float vectorShared[N];
	//Inicialitzem l'index amb una combinació de blocks i threads
	int tid = hreadIdx.x + blockIdx.x * blockDim.x;

	//Inicialitzem l'index del cache. PISTA: Es compartid per cada bloc, és a dir, cada block te una copia
	int indexCache = 
	
	float temp = 0;
	//Fem la suma de productes al block actual
	while(tid < N) {
		

		tid += blockDim.x * gridDim.x;
	}

	//Emmagatzem el valor temporal de la suma de productes a la cache
	

	//ara hem de llegir els valors de la cahche, però abans ens hem d'assegurar que els valors s'han escrit


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
	//Guardem a c el contingut de cache a la unica posició restant. Per què?
	c[/*...*/] =


}

int main()
{
	float *a, *b, *c;
	float *dev_a, *dev_b, *dev_c;
	int size = N*sizeof(float);

	//Reserva memoria a la CPU
	a = (float *)malloc(size);
	b = (float *)malloc(size);
	c = (float *)malloc(size);

	//Reserva memoria a la GPU.

	cudaMalloc((void**)&dev_a, size);
	cudaMalloc((void**)&dev_b, size);
	cudaMalloc((void**)&dev_c, size);



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

	cudaMemcpy(c,dev_c,size,cudaMemcpyDeviceToHost);

	//Acabem de realitzar la suma de productes
	float value = 0;



printf("Producte escalar es: %f", value);

	//Allibera memoria a la GPU


	//Allibera memoria a la CPU


    return 0;
}

