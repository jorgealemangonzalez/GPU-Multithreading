#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#define MAX(a,b) (((a)>(b))?(a):(b))

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
	int *array = (int *) malloc(size * sizeof(int)); //...


	//Fill array elements using random values. Acces to array position adress. Not by value: (NOT array[i])
	int i;
	int* ptr;
	for(i = 0 , ptr = array; i < size ; ++i, ptr++) //we use ptr for go through "array" and access to the value
	{												//of every position in the array. If we use "array[i]" it loads
		*ptr = (int)rand()/(int)(RAND_MAX/50.0);	// the position in the memory where it's.
	}
	

	// Print the array elements using pointers to each array position. (NOT array[i]) 
	//Your code here
	
	printf("\nArray values:\n");
	for (i = 0 , ptr = array ; i < size ; ++i , ptr ++ ){
		
		printf("%d\n",*ptr);
	} 

	// User specifies the new array size, stored in variable n2.
	printf("New array size:\n");
	int new_size = 0;
	scanf("%d", &new_size);



	// Change the array size dynamically using realloc()
	
	//Your code here
	
	array = (int *) realloc(array, new_size* sizeof(int)); 

	//If the new size is larger, set all members to 0. Why?

	//Your code here
	if(new_size > size)			//we put zeros in all the new positions, if we don't do it, we don't know
	{							//which will be the values of them
		for (i = size , ptr = array+size ; i < new_size ; ++i , ptr ++ ){
			*ptr = 0;
		}	
	}
	
	// Print the resized array elements using pointers to each array position. (NOT array[i]) 

	//Your code here

	printf("Array values:\n");
	for (i = 0 , ptr = array ; i < new_size ; ++i , ptr ++ ){
		
		printf("%d\n",*ptr);
	} 

	//Set memory free
	//Your code here
	
	free(array);
	return 0;



}

