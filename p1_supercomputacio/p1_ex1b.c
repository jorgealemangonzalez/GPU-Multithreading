#include <stdio.h> 
#include <stdlib.h>
#include <time.h>

static const int SIZE = 15;


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

int main(void)
{

    srand(time(NULL));


	//Initialize an array of size SIZE with random values
	int a[SIZE];

	for(int i=0;i<SIZE;i++)
		a[i] = (int)rand()/(int)(RAND_MAX/60.0);
  

	printf("Print original values\n");

	//Your code here
	int i;
	for(i = 0 ; i < SIZE ; ++i)
		printf("%d ",*(a+i));
	printf("\n");
	//Sort the array
	//....
	bubbleSort(a,SIZE);

	printf("Print ordered values\n");

	//Your code here
	for(i = 0 ; i < SIZE ; ++i)
		printf("%d ",*(a+i));
	printf("\n");
	return 0;




}
