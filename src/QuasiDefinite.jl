module QuasiDefinite

# package code goes here

# imports
import Base.blasfunc
import Base.LinAlg: BlasReal, BlasComplex, BlasFloat, BlasChar, BlasInt,
    blas_int, DimensionMismatch, chkstride1, chksquare

# load the libQuasiDefinite
include("../deps/deps.jl")

#Generic LAPACK error handlers, copied from https://github.com/JuliaLang/julia/blob/master/base/linalg/lapack.jl
macro assertargsok() #Handle only negative info codes - use only if positive info code is useful!
    :(info[1]<0 && throw(ArgumentError("invalid argument #$(-info[1]) to LAPACK call")))
end

#Check that upper/lower (for special matrices) is correctly specified
macro chkuplo()
    :((uplo=='U' || uplo=='L') ||
      throw(ArgumentError(string("uplo argument must be 'U' (upper) or 'L' (lower), got ", repr(uplo)))))
end

# from SCS.jl
function __init__()
    # default binaries need access to Julia's lapack symbols
    @unix_only dlopen(Base.liblapack_name, RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
end

# see: https://github.com/JuliaLang/julia/blob/master/base/linalg/lapack.jl#L1735
@eval begin
    function qdtrf!(uplo::BlasChar, A::StridedMatrix{Float64})
        chkstride1(A)
        chksquare(A)
        @chkuplo
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

@eval begin
    function qdtf2!(uplo::BlasChar, A::StridedMatrix{Float64})
        chkstride1(A)
        chksquare(A)
        @chkuplo
        lda = max(1,stride(A,2))
        lda==0 && return A, 0
        info = Array(BlasInt, 1)
        ccall(($(blasfunc(:dqdtf2_)), libQuasiDefinite), Void,
              (Ptr{BlasChar}, Ptr{BlasInt}, Ptr{Float64}, Ptr{BlasInt}, Ptr{BlasInt}),
              &uplo, &size(A,1), A, &lda, info)
        @assertargsok
        return A, info[1]
    end
end

@eval begin
    function nptf2!(A::StridedMatrix{Float64})
        chkstride1(A)
        lda = max(1,stride(A,2))
        lda==0 && return A, 0
        info = Array(BlasInt, 1)
        ccall(($(blasfunc(:dnptf2_)), libQuasiDefinite), Void,
              (Ptr{BlasInt}, Ptr{BlasInt}, Ptr{Float64}, Ptr{BlasInt}, Ptr{BlasInt}),
              &size(A,1), &size(A,2), A, &lda, info)
        @assertargsok
        return A, info[1]
    end
end

function run()
    A = Float64[2 -1; -1 2]
    B, info = qdtrf!('U',A)
    println(B)
    println(info)
end

end # module
