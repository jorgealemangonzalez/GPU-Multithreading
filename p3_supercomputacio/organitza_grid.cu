#include <stdio.h>
#include <stdlib.h>

static const int N = 16;
//static const int N = 32;
//static const inst N = 13;
//...


//Kernel que distribueix la l'execució a la grid
__global__ void organitza_grid(int *array) {

    int idx_x;
    int idx_y; 

    //Distribueix la grid(blocks i threads) com a un array unidimensional i calcula l'index d'aquesta distribució. 
    //On cada index correspon a un thread de la grid
    
	//....
    
     //Recupera l'index del block a la grid

	//...



    //Guarda resultad al array

	//...

}


__host__ void printa(int *array)
{

//Els vostre codi...


}


int main(void) {



    int *dev_a;
    int *array;

    // Reserva memoria al host i al device


    //Crea blocks de dos dimensions amb diferent nombre de threads. Ex: Comença amb 4x4
    dim3 block_dim;
	//...

    // Crea i inicialitza una grid en 2 dimensions
    dim3 grid_dim;
	//...


    organitza_grid<<<grid_dim, block_dim>>>(dev_a);



    // Printa els resultats de l'organització de la grid
    printa(array);
   



    return 0;
}
