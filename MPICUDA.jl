using CuArrays
using CUDAdrv
using MPI

const Send = MPI.Send
const Isend = MPI.Isend
const Recv! = MPI.Recv!
const Irecv! = MPI.Irecv!
const Bcast! = MPI.Bcast!
const Reduce = MPI.Reduce
const Allreduce! = MPI.Allreduce!

function Send(arr::CuArrays.CuArray{T}, dest::Integer, tag::Integer, 
                comm::MPI.Comm) where T
    cubuf = Base.cconvert(Ptr{T}, arr)
    CUDAdrv.synchronize(cubuf.ctx)
    cuptr = convert(Ptr{T}, cubuf.ptr)
    count = cubuf.bytesize ÷ T.size
    Send(cuptr, count, dest, tag, comm)
end

function Isend(arr::CuArrays.CuArray{T}, dest::Integer, tag::Integer, 
                comm::MPI.Comm) where T
    cubuf = Base.cconvert(Ptr{T}, arr)
    CUDAdrv.synchronize(cubuf.ctx)
    cuptr = convert(Ptr{T}, cubuf.ptr)
    count = cubuf.bytesize ÷ T.size
    Isend(cuptr, count, dest, tag, comm)
end

function Recv!(arr::CuArrays.CuArray{T}, src::Integer, 
                tag::Integer, comm::MPI.Comm) where T
    cubuf = Base.cconvert(Ptr{T}, arr)
    CUDAdrv.synchronize(cubuf.ctx)
    cuptr = convert(Ptr{T}, cubuf.ptr)
    count = cubuf.bytesize ÷ T.size
    Recv!(cuptr, count, src, tag, comm)
end

function Irecv!(arr::CuArrays.CuArray{T},  
                src::Integer, tag::Integer, comm::MPI.Comm) where T
    cubuf = Base.cconvert(Ptr{T}, arr)
    CUDAdrv.synchronize(cubuf.ctx)
    cuptr = convert(Ptr{T}, cubuf.ptr)
    count = cubuf.bytesize ÷ T.size
    Irecv!(cuptr, count, src, tag, comm)
end

function Bcast!(arr::CuArrays.CuArray{T}, root::Integer, comm::MPI.Comm) where T
    cubuf = Base.cconvert(Ptr{T}, arr)
    CUDAdrv.synchronize(cubuf.ctx)
    cuptr = convert(Ptr{T}, cubuf.ptr)
    count = cubuf.bytesize ÷ T.size
    Bcast!(cuptr, count, root, comm)
end

function Reduce(arr::CuArrays.CuArray{T}, op::MPI.Op, 
                root::Integer, comm::MPI.Comm) where T
    isroot = MPI.Comm_rank(comm) == root
    cubuf = Base.cconvert(Ptr{T}, arr)
    CUDAdrv.synchronize(cubuf.ctx)
    cuptr = convert(Ptr{T}, cubuf.ptr)
    count = cubuf.bytesize ÷ T.size
    
    recvarr = CuArrays.CuArray{T}(isroot ? size(arr) : 0)
    recvbuf = Base.cconvert(Ptr{T}, recvarr)
    recvptr = convert(Ptr{T}, recvbuf.ptr)
    ccall(MPI.MPI_REDUCE, Nothing,
          (Ptr{T}, Ptr{T}, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cint},
           Ref{Cint}, Ref{Cint}),
          cuptr, recvptr, count, MPI.mpitype(T), op.val, root, comm.val,
          0)
    isroot ? recvarr : nothing
end

function Allreduce!(sendarr::CuArrays.CuArray{T}, recvarr::CuArrays.CuArray{T}, 
                    op::MPI.Op, comm::MPI.Comm) where T
    sendcubuf = Base.cconvert(Ptr{T}, sendarr)
    CUDAdrv.synchronize(sendcubuf.ctx)
    sendcuptr = convert(Ptr{T}, sendcubuf.ptr)
    sendcount = sendcubuf.bytesize ÷ T.size
    
    recvcubuf = Base.cconvert(Ptr{T}, recvarr)
    CUDAdrv.synchronize(recvcubuf.ctx)
    recvcuptr = convert(Ptr{T}, recvcubuf.ptr)
    recvcount = recvcubuf.bytesize ÷ T.size
    
    @assert sendcount == recvcount
    
    Allreduce!(sendcubuf, recvcubuf, recvcount, op, comm)
end

function Allreduce!(sendarr::CuArrays.CuArray{T}, op::MPI.Op, comm::MPI.Comm) where T
    Allreduce!(sendarr, sendarr, op, comm)
end
    
