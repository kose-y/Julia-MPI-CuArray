import MPI
MPI.Init()
comm = MPI.COMM_WORLD

import CUDAnative
CUDAnative.device!(MPI.Comm_rank(comm))

include("04-sendrecv-impl.jl")
function main()

    println("Hello world, I am $(MPI.Comm_rank(comm)) of $(MPI.Comm_size(comm))")



    do_sendrecv()



end



main()

MPI.Finalize()
