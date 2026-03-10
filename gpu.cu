#include "md5.cuh"
#include <stdio.h>
#include <string.h>
#include "common.h"

__device__ int found = 0;
__device__ char result[5];

__device__ unsigned int simpleHash(char* str,int len)
{
    unsigned int hash = 5381;

    for(int i=0;i<len;i++)
        hash = ((hash << 5) + hash) + str[i];

    return hash;
}

__global__ void passwordKernel(uint32_t *targetDigest,int pwdLen)
{
    __shared__ char charset[26];

    if(threadIdx.x < 26)
        charset[threadIdx.x] = "abcdefghijklmnopqrstuvwxyz"[threadIdx.x];

    __syncthreads();

    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    if(found) return;

    char pwd[5];

    int idx = tid;

    for(int i=0;i<pwdLen;i++)
    {
        pwd[i] = charset[idx % 26];
        idx /= 26;
    }

    pwd[pwdLen] = '\0';

    uint32_t digest[4];
    md5(pwd,pwdLen,digest);

    if(digest[0] == targetDigest[0] &&
   digest[1] == targetDigest[1] &&
   digest[2] == targetDigest[2] &&
   digest[3] == targetDigest[3])
    {
        if(atomicCAS(&found,0,1)==0)
        {
            for(int i=0;i<pwdLen;i++)
                result[i] = pwd[i];

            result[pwdLen] = '\0';
        }
    }
}

unsigned int simpleHashCPU(char* str,int len)
{
    unsigned int hash = 5381;

    for(int i=0;i<len;i++)
        hash = ((hash << 5) + hash) + str[i];

    return hash;
}

int main()
{
    char target[5];

printf("Enter password to crack (4 lowercase letters): ");
scanf("%4s", target);

    uint32_t targetDigest[4];
    md5(target,4,targetDigest);

    uint32_t *d_targetDigest;
    cudaMalloc(&d_targetDigest,4*sizeof(uint32_t));
    cudaMemcpy(d_targetDigest,targetDigest,4*sizeof(uint32_t),cudaMemcpyHostToDevice);

    cudaEvent_t start,stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    passwordKernel<<<100000,256>>>(d_targetDigest,4);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms,start,stop);

    char h_result[5];
    cudaMemcpyFromSymbol(h_result,result,5);

    printf("Password found: %s\n",h_result);
    printf("Kernel time: %f ms\n",ms);

    return 0;
}