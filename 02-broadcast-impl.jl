using Printf
using GPUArrays
using CuArrays
using CUDAdrv
using MPI

include("MPICUDA.jl")
function do_broadcast()
    comm = MPI.COMM_WORLD

    if MPI.Comm_rank(comm) == 0
        println(repeat("-",78))
        println(" Running on $(MPI.Comm_size(comm)) processes")
        println(repeat("-",78))
    end

    MPI.Barrier(comm)

    N = 100
    
    root = 0
    
    A = CuArrays.CuArray{Float64}(10, 10)
    if MPI.Comm_rank(comm) == root
        copyto!(A, reshape(collect(1:N)*1.0,  (10, 10)))
    end
    
    println(GPUArrays.device(A))

    Bcast!(A, root, comm)
    

    @printf("[%02d] A:%s\n", MPI.Comm_rank(comm), A)
    #map(println, CUDAdrv.devices())


end
