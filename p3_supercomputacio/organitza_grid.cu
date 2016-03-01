#include <stdio.h>
#include <stdlib.h>

static const int N = 16;
//static const int N = 32;
//static const inst N = 13;
//...


//Kernel que distribueix la l'execució a la grid
__global__ void organitza_grid(int *array) {



    //Distribueix la grid(blocks i threads) com a un array unidimensional i calcula l'index d'aquesta distribució. 
    //On cada index correspon a un thread de la grid
    int idx = threadIdx.x;
    int idy = threadIdx.y;
    int idblocy = blockIdx.y;
    int idblocx = blockIdx.x;
    int width = gridDim.x * blockDim.x;
    int id_array = idy*width + idx + idblocx * blockDim.x + idblocy * width * blockDim.y;
    //array [id_array] = (2*idblocy)+idblocx;
    //array[idblocy*width+idblocx*blockDim.x+idy*blockDim.y+idx] = idblocy*width+idblocx*blockDim.x+idy*blockDim.y+idx;
	
    //....
    
     //Recupera l'index del block a la grid

	//...



    //Guarda resultad al array

	//...

}


__host__ void printa(int *array)
{

//Els vostre codi...
    for(int i = 0 ; i < N ; ++i){
        printf("%d-",array[i]);
    }

}


int main(void) {


    //blockDim.x -- number threads in block
    //blockid -- block index
    //gridim number blocks in grid


    int *dev_a;
    int *array;
    int size = N*sizeof(int);

    // Reserva memoria al host i al device
    array = (int *)malloc(size); 

    cudaMalloc((void **)&dev_a, size); 



    //Crea blocks de dos dimensions amb diferent nombre de threads. Ex: Comença amb 4x4
    dim3 block_dim(4,4); //4 threads x bloque
	//...

    // Crea i inicialitza una grid en 2 dimensions
    //dim3 grid_dim(sqrt(size)/block_dim.x, sqrt(size)/block_dim.y);
    dim3 grid_dim(2,2);
	//...

    cudaMemset(dev_a,0,N);
    organitza_grid<<<grid_dim, block_dim>>>(dev_a);
    cudaMemcpy(array,dev_a,N,cudaMemcpyDeviceToHost);


    // Printa els resultats de l'organització de la grid
    printa(array);
   



    return 0;
}
