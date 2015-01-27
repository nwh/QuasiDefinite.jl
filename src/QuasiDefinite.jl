module QuasiDefinite

# package code goes here

# load the libQuasiDefinite
include("../deps/deps.jl")

println("Hello from QuasiDefinite julia code.")

ccall((:say_hello,libQuasiDefinite),Void,())

end # module
