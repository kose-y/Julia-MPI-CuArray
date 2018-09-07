using Printf
using GPUArrays
using CuArrays
using CUDAdrv
using MPI

include("MPICUDA.jl")

function do_reduce()
    comm = MPI.COMM_WORLD

    MPI.Barrier(comm)

    root = 0
    r = MPI.Comm_rank(comm)

    N = 100

    A = CuArrays.CuArray{Float64}(10, 10)
    copyto!(A, r * reshape(collect(1:N)*1.0, (10, 10)))
    
    

    sr = Reduce(A, MPI.SUM, root, comm) 

    if(MPI.Comm_rank(comm) == root)
        @printf("sum: %s\n", sr)
    end
end
