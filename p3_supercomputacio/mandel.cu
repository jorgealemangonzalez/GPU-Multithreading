#include <stdio.h> 
#include <assert.h> 
#include <stdlib.h> 
#include <stdio.h> 
#include <cuda.h> 
#include <time.h>


struct BITMAPFILEHEADER 
{ 
    char bfType[2]; 
    int bfSize; 
    int bfReserved; 
    int bfOffBits; 
}; 

struct BITMAPINFOHEADER { 
    int biSize; 
    int biWidth; 
    int biHeight; 
    short biPlanes; 
    short biBitCount; 
    int biCompression; 
    int biSizeImage; 
    int biXPelsPerMeter; 
    int biYPelsPerMeter; 
    int biClrUsed; 
    int biClrImportant; 
}; 

int write_bitmap(const char *filename, int width, int height, char *red, char *green, char *blue) 
{ 

	int bytes_per_line = (3 * (width + 1) / 4) * 4; 
	unsigned char *image_line = (unsigned char *)malloc(bytes_per_line); 

struct BITMAPFILEHEADER bmph; 
    bmph.bfType[0] = 'B'; 
    bmph.bfType[1] = 'M'; 
    bmph.bfReserved = 0; 
    bmph.bfOffBits = 54; 
    bmph.bfSize = bmph.bfOffBits + bytes_per_line * height; 

    struct BITMAPINFOHEADER bmih; 
    bmih.biSize = 40; 
    bmih.biWidth = width; 
    bmih.biHeight = height; 
    bmih.biPlanes = 1; 
    bmih.biBitCount = 24; 
    bmih.biCompression = 0; 
    bmih.biSizeImage = bytes_per_line * height; 
    bmih.biXPelsPerMeter = 0; 
    bmih.biYPelsPerMeter = 0; 

 bmih.biClrUsed = 0; 
    bmih.biClrImportant = 0; 
    FILE *fit; 
    if((fit = fopen (filename, "wb"))==0) { 
        free(image_line);
	return -1;
    } 

fwrite(&bmph.bfType, 2, 1, fit); 
    fwrite(&bmph.bfSize, 4, 1, fit); 
    fwrite(&bmph.bfReserved, 4, 1, fit); 
    fwrite(&bmph.bfOffBits, 4, 1, fit); 
    
    fwrite(&bmih.biSize, 4, 1, fit); 
    fwrite(&bmih.biWidth, 4, 1, fit); 
    fwrite(&bmih.biHeight, 4, 1, fit); 
    fwrite(&bmih.biPlanes, 2, 1, fit); 
    fwrite(&bmih.biBitCount, 2, 1, fit); 
    fwrite(&bmih.biCompression, 4, 1, fit); 
    fwrite(&bmih.biSizeImage, 4, 1, fit); 
    fwrite(&bmih.biXPelsPerMeter, 4, 1, fit); 
    fwrite(&bmih.biYPelsPerMeter, 4, 1, fit); 
    fwrite(&bmih.biClrUsed, 4, 1, fit); 
    fwrite(&bmih.biClrImportant, 4, 1, fit);

	for(int i=height-1;i>=0;i--) {
        for (int j=0;j<width;j++) { 
            int pos = (width * i + j); 
            image_line[3*j] = blue[pos]; 
            image_line[3*j+1] = green[pos]; 
            image_line[3*j+2] = red[pos]; 
        } 
        fwrite((void *)image_line, bytes_per_line, 1, fit); 
    } 
    free(image_line); 
    fclose(fit); 

return 0; 

} 

void mandel_host(char *red, char *green, char *blue, int width, int height) 
{ 
    for(int pos_x=0;pos_x<width;pos_x++) { 
        for(int pos_y=0;pos_y<height;pos_y++) { 
	    float x0 = ((float)pos_x)*3.5/((float)width)-2.5;
	    float y0 = ((float)pos_y)*2.0/((float)height)-1.0;
            float x = 0.0; 
            float y = 0.0; 
            int iteration = 0; 
            int max_iteration = 256; 
            while(x*x + y*y <= 4 && iteration < max_iteration) { 
		float xtemp = x*x - y*y + x0;
                y = 2*x*y + y0; 
                x = xtemp; 
                iteration++; 
            } 
            int index = width*pos_y + pos_x; 
  
            if(iteration==max_iteration) { 
                iteration = 0; 
            } 
            red[index] = iteration; 
            green[index] = iteration; 
            blue[index] = iteration; 
        } 
    } 
}

__global__ void mandel_cuda(char *red, char *green, char *blue, int width, int height) 
{

	/* kernel que calcula un pixel */ 
    	/* Per saber quin pixel és, cal tenir en compte totes les dimensions 
       	del grid (el número de blocs i el número de threads */ 
    	/* Podeu fer servir els valors de 
       		blockIdx.x, blockIdx.y 
       		gridDim.x, gridDim.y 
       		threadIdx.x, threadIdx.y 
       		blockDim.x, blockDim.y */ 
            
    int pos_x = threadIdx.x+blockDim.x*blockIdx.x;
    int pos_y = threadIdx.y+blockDim.y*blockIdx.y;

    float x0 = ((float)pos_x)*3.5/((float)width)-2.5;
    float y0 = ((float)pos_y)*2.0/((float)height)-1.0;
        float x = 0.0; 
        float y = 0.0; 
        int iteration = 0; 
        int max_iteration = 256; 
        while(x*x + y*y <= 4 && iteration < max_iteration) { 
    float xtemp = x*x - y*y + x0;
            y = 2*x*y + y0; 
            x = xtemp; 
            iteration++; 
        } 
        int index = width*pos_y + pos_x; 

        if(iteration==max_iteration) { 
            iteration = 0; 
        } 
        red[index] = iteration; 
        green[index] = iteration; 
        blue[index] = iteration;

}

void fes_host(int width, int height) 
{ 
    size_t buffer_size = sizeof(char) * width * height; 
    char *image_red = (char *)malloc(buffer_size); 
    char *image_green = (char *)malloc(buffer_size); 
    char *image_blue = (char *)malloc(buffer_size); 
    mandel_host(image_red, image_green, image_blue, width, height); 
    // Now write the file 
    write_bitmap("output_host.bmp", width, height, image_red, 
                    image_green, image_blue); 
    free(image_red); 
    free(image_green); 
    free(image_blue); 
} 

void fes_cuda(int width, int height) 
{ 
    size_t buffer_size = sizeof(char) * width * height; 
    char *image_red; 
    char *image_green; 
    char *image_blue; 
 
    cudaMalloc((void**)&image_red, buffer_size);
    cudaMalloc((void**)&image_green, buffer_size);
    cudaMalloc((void**)&image_blue, buffer_size);

    clock_t t_device = clock();

    dim3 blockDim(6, 6,1); 
    dim3 gridDim(width / blockDim.x, height / blockDim.y,1); 
    
    mandel_cuda<<< gridDim, blockDim,0>>>(image_red, image_green, image_blue, width, height); 
    char *host_image_red = (char*)malloc(buffer_size); 
    char *host_image_green= (char*)malloc(buffer_size); 
    char *host_image_blue= (char*)malloc(buffer_size); 
    
    /* cal copiar els valors de la imatge al host */ 

    cudaMemcpy(host_image_red,image_red,buffer_size,cudaMemcpyDeviceToHost);
    cudaMemcpy(host_image_green,image_green,buffer_size,cudaMemcpyDeviceToHost);
    cudaMemcpy(host_image_blue,image_blue,buffer_size,cudaMemcpyDeviceToHost);
    // Now write the file 
    write_bitmap("output_cuda.bmp", width, height, host_image_red, 
                    host_image_green, host_image_blue); 
    t_device = clock() - t_device;
    double time_taken_device = ((double)t_device)/CLOCKS_PER_SEC; 
    printf("GPU %f segons with %d threats \n", time_taken_device,blockDim.x);
    /* cal alliberar la memòria del dispositiu i del host */ 
    cudaFree(image_blue);
    cudaFree(image_green);
    cudaFree(image_red);
    free(host_image_blue);
    free(host_image_green);
    free(host_image_red);
} 

unsigned char* readBMP(const char* filename)
{
    int i;
    FILE* f = fopen(filename, "rb");
    unsigned char info[54];
    fread(info, sizeof(unsigned char), 54, f); // read the 54-byte header

    // extract image height and width from header
    int width = *(int*)&info[18];
    int height = *(int*)&info[22];

    int size = 3 * width * height;
    unsigned char* data = new unsigned char[size]; // allocate 3 bytes per pixel
    fread(data, sizeof(unsigned char), size, f); // read the rest of the data at once
    fclose(f);

    for(i = 0; i < size; i += 3)
    {
            unsigned char tmp = data[i];
            data[i] = data[i+2];
            data[i+2] = tmp;
    }

    return data;
}

int main(int argc, const char * argv[]) { 
    fes_cuda(5120, 5120); 
    fes_host(5120, 5120); 
    unsigned char *c , *h;
    c = readBMP("output_cuda.bmp");
    h = readBMP("output_host.bmp");
    int errors =0;
    int lengc = 5120*5120;
    for(int i = 0 ; i < lengc;++i){
        if(c[i] != h[i]){
            errors++;
        }
    }
    if(errors)printf("There are no difference,have %d errors\n",errors);
    else printf("There are no difference\n");
    return 0; 
} 






