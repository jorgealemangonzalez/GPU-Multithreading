#include <stdlib.h>
#include <stdio.h>
#include <time.h>

/*

	Allocate memory for an array of ints and resize it dynamically

*/



int main(void)
{


	srand(time(NULL));

	printf("Array size: ");
	int size = 0;
	scanf("%d", &size);

	// Allocate memory for an array of size elements
	int *array = //...


	//Fill array elements using random values. Acces to array position adress. Not by value: (NOT array[i])
	
	/* ??? */ = (int)rand()/(int)(RAND_MAX/50.0);;


	// Print the array elements using pointers to each array position. (NOT array[i]) 
	//Your code here

	// User specifies the new array size, stored in variable n2.
	printf("\nNew array size: ");
	int new_size = 0;
	scanf("%d", &new_size);



	// Change the array size dynamically using realloc()

	//Your code here

	//If the new size is larger, set all members to 0. Why?

	//Your code here
	
	// Print the resized array elements using pointers to each array position. (NOT array[i]) 

	//Your code here



	//Set memory free
	//Your code here

	return 0;



}

