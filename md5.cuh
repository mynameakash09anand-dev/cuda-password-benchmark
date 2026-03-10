#pragma once
#include <stdint.h>

__host__ __device__ uint32_t leftrotate(uint32_t x, uint32_t c)
{
    return (x << c) | (x >> (32 - c));
}

__host__ __device__ void md5(char* msg,int len,uint32_t* digest)
{
    uint32_t a = 0x67452301;
    uint32_t b = 0xefcdab89;
    uint32_t c = 0x98badcfe;
    uint32_t d = 0x10325476;

    for(int i=0;i<len;i++)
    {
        a += msg[i];
        b ^= a;
        c += b;
        d ^= c;

        a = leftrotate(a,7);
        b = leftrotate(b,12);
        c = leftrotate(c,17);
        d = leftrotate(d,22);
    }

    digest[0] = a;
    digest[1] = b;
    digest[2] = c;
    digest[3] = d;
}