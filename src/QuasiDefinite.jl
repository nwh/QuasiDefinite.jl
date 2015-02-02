module QuasiDefinite

# package code goes here

# imports
import Base.blasfunc
import Base.LinAlg: BlasReal, BlasComplex, BlasFloat, BlasChar, BlasInt,
    blas_int, DimensionMismatch, chkstride1, chksquare
import Base.LinAlg.LAPACK: @chkuplo, @assertargsok

# load the libQuasiDefinite
include("../deps/deps.jl")

# see: https://github.com/JuliaLang/julia/blob/master/base/linalg/lapack.jl#L1735
@eval begin
    function qdtrf!(uplo::BlasChar, A::StridedMatrix{Float64})
        chkstride1(A)
        chksquare(A)
        #@chkuplo
        lda = max(1,stride(A,2))
        lda==0 && return A, 0
        info = Array(BlasInt, 1)
        ccall(($(blasfunc(:dqdtrf_)), libQuasiDefinite), Void,
              (Ptr{BlasChar}, Ptr{BlasInt}, Ptr{Float64}, Ptr{BlasInt}, Ptr{BlasInt}),
              &uplo, &size(A,1), A, &lda, info)
        @assertargsok
        return A, info[1]
    end
end

println("Hello from QuasiDefinite julia code.")

ccall((:say_hello,libQuasiDefinite),Void,())

A = [2.0 -1.0; -1.0 2.0]
B, info = qdtrf!('U',A)
show(B)
show(info)

end # module
