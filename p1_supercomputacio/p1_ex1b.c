#include <stdio.h> 
#include <stdlib.h>
#include <time.h>

static const int SIZE = 15;


//swap values at memory locations
void swap(int *elem1, int *elem2)
{

//Your code here

}


//Bubble sort algorithm to sort arrays in ascending order
void bubbleSort(int * const array, const int size)
{


//Your code here


//1. Iterate along array elements

//2. swap adjacent elements if they are out of order



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

	//Sort the array
	//....


	printf("Print ordered values\n");

	//Your code here

	return 0;




}
