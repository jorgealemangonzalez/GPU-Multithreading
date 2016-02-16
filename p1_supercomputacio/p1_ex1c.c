#include <stdio.h>
#include <stdlib.h>

/*
	Cerca de d'arbres binaris amb funcions recursives
*/


//Struct per arbre binary. Cada node pot tenir fins a dos fills(esq, dret). Cada node conte un enter.
struct arbreBinari
{
	int contingut;
	struct arbreBinari* esq;
	struct arbreBinari* dret;
};


//Reserva memoria per l'arbre en funció dels nodes que s'afegeixen
struct arbreBinari* reserva_memoria(int contingut)
{
	//Reserva memoria
	struct arbreBinari* arbre = //...

	if(arbre!=NULL)
	{
			//Your code here

	}

	return arbre;


}

//Afegeix un node a l'arbre amb un contingut de tipus int
struct arbreBinari* afegeix_node(struct arbreBinari* arrel, int contingut)
{

	//Condició de sortida
	if(arrel==NULL)
	{
		//1.Reserva memoria per el node
		//2.Retorna la nova arrel

	}
	
	//Crida recursiva a afegeix_node segons el valor de contingut
	else if(contingut < arrel->contingut)
	{
		//Your code here
	}
	else
	{
		//Your code here
	}



}

//Cerca en pre-order
void pre_order(struct arbreBinari* arrel)
{

	//1.Condició de sortida
	//2.Imprimeix contingut
	//3.Crida recursiva

	

}

//Cerca en in-order. 
void in_order(struct arbreBinari* arrel)
{

	//1.Condició de sortida
	//2. Imprimeix contingut
	//3. Crida recursiva
	

}


//Allibera la memoria reservada previament i retorna el nombre de nodes esborrats
int esborra_arbre(struct arbreBinari* arrel)
{

	int count = 0;

	//1.Condició de sortida
	//2. Esborrar cada node recursivament
	//3.Allibera memoria de cada node 

	//Retorna nombre de nodes esborrats
	return ++count;


}


int main()
{

//Inicialitzem un arbre buit
struct arbreBinari* arrel = NULL;

//Afegeix els valors(4,1,0,3,6,5,4,9)
arrel = afegeix_node(arrel, 4);
arrel = afegeix_node(arrel, 1);
arrel = afegeix_node(arrel, 0);
arrel = afegeix_node(arrel, 3);
arrel = afegeix_node(arrel, 6);
arrel = afegeix_node(arrel, 5);
arrel = afegeix_node(arrel, 4);
arrel = afegeix_node(arrel, 9);


//Cridem les funcions de cerca
pre_order(arrel);
in_order(arrel);

int count = 0;
//Alliberem la memoria reservada per cada node
//Your code here


arrel=NULL;

//Nombre total de nodes esborrats
printf("Nodes esborrats: %d", count);

return 0;



}







