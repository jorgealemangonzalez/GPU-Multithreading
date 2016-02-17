#include <stdio.h> 
#include <stdlib.h>
#include <time.h>


//Multiply two given matrixs
void multiply_matrix(float *A, float *B, float *M, int width, int pos) 
{ 
	
    //Calculate the row and column given position pos
    int row = (int)(pos / width);
    int col = pos % width;

/*
 *Calculate the matrix value at position M[pos] multiplying A * B
 */
//Your code here
    
    float value = 0;
    int i;
    for(i = 0 ; i < width ; ++i){
        value += A[row*width + i] * B[i*width+col];
    }
    M[pos] = value;
}

//Calculate de matrix determinant
void matrix_determinant(float *M, float *D, int width)
{
  
  //Your code here
  *D = M[0]*M[3] - M[1]*M[2];
}



//Print a matrix M
void display_matrix(float *M, int width)
{
    int i;
    for(i = 0 ; i < (width*width); ++i){
        printf("%f ",M[i]);
        if(i%width == width-1)printf("\n");
    }
} 


int main(void) 
{ 
    int i;
    int width=2; 
    srand(time(NULL));
    
    //Allocate the memory
    float *A = (float *) malloc(width * width * sizeof(float)); //..... 
    float *B = (float *) malloc(width * width * sizeof(float)); //..... 
    float *M = (float *) malloc(width * width * sizeof(float)); //..... 


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
    printf("Determinant is: %f\n", D);
    
    

    fprintf(stdout, "Check that M = A * B\n");
    
    //Display A, B and M
    //Set memory free
    printf("A matrix\n");
    display_matrix(A,width);
    printf("B matrix\n");
    display_matrix(B,width);
    printf("M matrix\n");
    display_matrix(M,width);
    //Your code here
    
    free(A);
    free(B);
    free(M);
    return 0; 
}
