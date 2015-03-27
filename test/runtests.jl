using QuasiDefinite
using Base.Test

# generate random nxn spd matrix
function gen_spd(n,seed=0)
    srand(seed)
    A = rand(n,n)
    A = A*A' + eye(n)
    A
end

function test_qdtf2!(A,uplo::Char)
    m, n = size(A)
    LD = copy(A)
    LD, info = QuasiDefinite.qdtf2!(uplo,LD)
    @test info == 0
    D = diagm(diag(LD))
    if uplo == 'L'
        L = tril(LD,-1) + eye(m)
        U = triu(LD)
        @test_approx_eq_eps norm(L*D*L' - A,1) 0.0 1e-12
    else
        L = tril(LD)
        U = triu(LD,1) + eye(m)
        @test_approx_eq_eps norm(U'*D*U - A,1) 0.0 1e-12
    end
    @test_approx_eq_eps norm(L*U - A,1) 0.0 1e-12
end

# set size and generate matrix
n = 35
A = gen_spd(n)

# test unblocked LDL^T
test_qdtf2!(A,'L')
test_qdtf2!(A,'U')
