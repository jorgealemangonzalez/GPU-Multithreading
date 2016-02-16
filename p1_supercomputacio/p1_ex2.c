#include <stdio.h> 
#include <stdlib.h>
#include <time.h>


//Multiply two given matrixs
void multiply_matrix(float *A, float *B, float *M, int width, int pos) 
{ 
	
    //Calculate the row and column given position pos
    int row = (int)(pos / width);
    int col = pos % width;
    printf("%d--%d",row,col);

/*
 *Calculate the matrix value at position M[pos] multiplying A * B
 */

//Your code here


}

//Calculate de matrix determinant
void matrix_determinant(float *M, float *D, int width)
{
  
  //Your code here
  
}



//Print a matrix M
void display_matrix(float *M, int width)
{

//Your code here

} 


int main(void) 
{ 
    int i;
    int width=2; 
    srand(time(NULL));
    
    //Allocate the memory
    float *A = (float *) malloc (width  * sizeof(float); //..... 
    float *B = (float *) malloc(width  * sizeof(float); //..... 
    float *M = (float *) malloc(width  * sizeof(float); //..... 
    for ( i = 0 ; i < width ; ++i){
        (A+i) = (float *) malloc(width  * sizeof(float);
        (D+i) = (float *) malloc(width  * sizeof(float);
        (M+i) = (float *) malloc(width  * sizeof(float);
    }

    for(int i=0;i<(width*width);i++) { 
      
	A[i] = (float)rand()/(float)(RAND_MAX/15.0);
	B[i] = (float)rand()/(float)(RAND_MAX/15.0);
      
    } 
    
	
    for(int i=0;i<(width*width);i++) { 
        multiply_matrix(A, B, M, width, i); 
    } 
    
    //Calculate the matrix determinant
    float D;
    matrix_determinant(M, &D, width);   
    printf("Determinant is: %f", D);
    
    

    fprintf(stdout, "Check that M = A * B\n");
    
    //Display A, B and M
    //Set memory free
    
    //Your code here
 
    return 0; 
}
