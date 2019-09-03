# MPICuArrays.jl
CUDA-aware MPI with CuArrays.jl

This repo originally included code to use CUDA-aware MPI with the older version of [JuliaParallel/MPI.jl](https://github.com/JuliaParallel/MPI.jl).
Now that MPI.jl directly supports CUDA-enabled MPI in [v0.10.0](https://discourse.julialang.org/t/ann-mpi-jl-v0-10-0-new-build-process-and-cuda-aware-support/27601/3) , only the examples are maintained. You can run the examples if you have MPI.jl, CuArrays.jl, GPUArrays.jl, and CUDAnative.jl installed properly.
Use the command
```bash
mpirun -np 4 02-broadcast.jl
```
to run 02-broadcast.jl with 4 processes (across multiple nodes or CUDA devices if available).

