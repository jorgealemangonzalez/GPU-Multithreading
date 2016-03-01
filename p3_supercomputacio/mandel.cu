#include <stdio.h> 
#include <assert.h> 
#include <stdlib.h> 
#include <stdio.h> 
#include <cuda.h> 

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

/* cal reservar la memòria del dispositiu */ 
    dim3 blockDim(16, 16, 1); 
    dim3 gridDim(width / blockDim.x, height / blockDim.y, 1); 
    
    mandel_cuda<<< gridDim, blockDim, 0 >>>(image_red, image_green, image_blue, width, height); 
    char *host_image_red; 
    char *host_image_green; 
    char *host_image_blue; 
    
    /* cal copiar els valors de la imatge al host */ 
    // Now write the file 
    write_bitmap("output_cuda.bmp", width, height, host_image_red, 
                    host_image_green, host_image_blue); 
    /* cal alliberar la memòria del dispositiu i del host */ 
} 
int main(int argc, const char * argv[]) { 
    fes_cuda(5120, 5120); 
    fes_host(5120, 5120); 
    return 0; 
} 






