import MPI
MPI.Init()
comm = MPI.COMM_WORLD

import CUDAnative
CUDAnative.device!(MPI.Comm_rank(comm))

include("03-reduce-impl.jl")
function main()

    println("Hello world, I am $(MPI.Comm_rank(comm)) of $(MPI.Comm_size(comm))")



    do_reduce()



end



main()

MPI.Finalize()
