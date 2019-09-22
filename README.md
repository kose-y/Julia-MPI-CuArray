# Julia-MPI-CuArray
CUDA-aware MPI with CuArrays.jl

This repo originally included code to use CUDA-aware MPI with the older version of [JuliaParallel/MPI.jl](https://github.com/JuliaParallel/MPI.jl).
Now that MPI.jl directly supports CUDA-enabled MPI in [v0.10.0](https://github.com/JuliaParallel/MPI.jl/releases/tag/v0.10.0), only the examples are maintained. You can run the examples if you have 

- CUDA 
- MPI with CUDA-aware support, e.g. OpenMPI [built with CUDA enabled](https://www.open-mpi.org/faq/?category=buildcuda)
- Julia packages MPI.jl, CuArrays.jl, GPUArrays.jl, and CUDAnative.jl.

For example, you can use the command
```bash
mpirun -np 4 02-broadcast.jl
```
to run 02-broadcast.jl with 4 processes (across multiple nodes or CUDA devices if available).
