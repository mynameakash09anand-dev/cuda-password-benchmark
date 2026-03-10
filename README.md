# CUDA Password Cracker



A GPU-accelerated brute force password search implemented using CUDA.



This project demonstrates how GPUs can test hundreds of millions of password combinations per second using parallel computing.



---



## Features



- CUDA parallel kernel

- GPU MD5 hashing

- Shared memory optimization

- Atomic early exit

- GPU performance benchmarking

- Nsight Compute profiling



---



## Hardware Used



GPU: NVIDIA RTX 3050  

CUDA Version: 13.1  

OS: Windows  



---



## How It Works



The program performs a brute-force search over all lowercase 4-character passwords.



Each CUDA thread:



1. Generates a password candidate  

2. Computes its MD5 hash  

3. Compares the hash with the target password hash  



If a match is found, the kernel stops and returns the cracked password.



---



## Example Run



Enter password to crack: test

Password found: test

Kernel time: 33 ms



---



## Performance



| Threads | Kernel Time | Hash Rate |

|--------|-------------|-----------|

| 25.6M | ~33 ms | ~775M hashes/sec |



---



## Benchmark Chart



![Benchmark](benchmarks/benchmark\_chart.png)



---



## Nsight Compute Profiling



### Kernel Summary

![Kernel Summary](benchmarks/nsight\_kernel\_summary.png)



### Occupancy

![Occupancy](benchmarks/nsight\_occupancy.png)



### Memory Throughput

![Memory](benchmarks/nsight\_memory.png)



---



## Project Structure



cuda-password-cracker

│

├── gpu.cu

├── md5.cuh

├── common.h

├── cpu.cpp

│

├── benchmarks

│ ├── benchmark\_chart.png

│ ├── nsight\_kernel\_summary.png

│ ├── nsight\_memory.png

│ └── nsight\_occupancy.png

│

└── README.md



---



## Compile





nvcc gpu.cu -o gpu





---



## Run





.gpu





---



## Author



CUDA GPU programming project demonstrating parallel brute-force password search.

