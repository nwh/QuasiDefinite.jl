module QuasiDefinite

# package code goes here

# load the libqdel
include("../deps/deps.jl")

println("Hello from QuasiDefinite julia code.")

ccall((:say_hello,libqdel),Void,())

end # module
