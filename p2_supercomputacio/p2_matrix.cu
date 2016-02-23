#include <stdio.h> 
#include <stdlib.h> 

__global__ void fill_matrix_device(int *m, int width) 
{ 
    int tx=threadIdx.x; 
    int ty=threadIdx.y; 
    
    int value=(tx+1)*(ty+1); 
    m[tx*width+ty] = value; 
}

void fill_matrix_host(int *m, int width) 
{ 
    for(int x=0;x<width;++x) { 
        for(int y=0;y<width;++y) { 
            int value=(x+1)*(y+1); 
            m[x*width+y] = value; 
        } 
    } 
} 

int main(void) 
{ 
    int width=2; 
    int size=width*width*sizeof(int); 

    int *m; 
    m = (int *)malloc(size); 
 
    fill_matrix_host(m, width); 
    
    int *dev_m; 
    cudaMalloc((void **)&dev_m, size); 
    dim3 dimGrid(1, 1); 
    dim3 dimBlock(width, width); 
    
    fill_matrix_device<<<dimGrid, dimBlock>>>(dev_m, width); 
    int *m2; 
    m2 = (int *)malloc(size); 
    
    cudaMemcpy(m2, dev_m, size, cudaMemcpyDeviceToHost); 
    
    int ok=1; 
    for(int i=0;i<(width*width);++i) { 
        if(m[i]!=m2[i]) ok=0; 
    } 
    
    fprintf(stdout, "%s\n", ok?"ok":"error"); 
    
    free(m); 
    free(m2); 
    cudaFree(m); 
    
    return 0; 
}


