#include <iostream>
#include <math.h>
#include <cuda.h>

#define N 256

__global__ void matrix_vector_multi_gpu_1_1(float *A_d, float *B_d, float *C_d) {
    int i, j;

    for (j=0;j<N;j++) {
        A_d[j]=0.0;
        for(i=0;i<N;i++) {
            A_d[j]=A_d[j]+B_d[j*N+i]*C_d[i];
        }
    }
}

int main() {

    int i, j;
    float A[N], B[N*N], C[N];   //ホスト
    float *A_d, *B_d, *C_d;     //デバイス

    dim3 blocks(1,1,1);         //blockの配置
    dim3 threads(1,1,1);        //threadの配置

    for(j=0; j<N; j++) {
        for (i=0; i<N; i++) {
            B[j*N+i] = ((float)j)/256.0;
        }
    }

    for(j=0; j<N; j++) {
        C[j] = 1.0F;
    }

    cudaMalloc((void**)&A_d, N*sizeof(float));      //デバイス側のメモリの確保
    cudaMalloc((void**)&B_d, N*N*sizeof(float));
    cudaMalloc((void**)&C_d, N*sizeof(float));

    cudaMemcpy(A_d, A, N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(B_d, B, N*N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(C_d, C, N*sizeof(float), cudaMemcpyHostToDevice);

    matrix_vector_multi_gpu_1_1<<< blocks, threads >>>(A_d, B_d, C_d);

    cudaMemcpy(A, A_d, N*sizeof(float), cudaMemcpyDeviceToHost);

    for(j=0;j<N;j++) {
        printf("A[ %d ]=%f \n", j, A[j]);
    }

    cudaFree(A_d); //メモリの開放
    cudaFree(B_d);
    cudaFree(C_d);

}