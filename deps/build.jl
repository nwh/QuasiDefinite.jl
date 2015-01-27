using BinDeps

@BinDeps.setup

libQuasiDefinite = library_dependency("libQuasiDefinite")

libdir = joinpath(Pkg.dir(),"QuasiDefinite","deps")

provides(SimpleBuild,
         (@build_steps begin
             `make`
             `make install`
         end),
         libQuasiDefinite)

@BinDeps.install Dict(:libQuasiDefinite => :libQuasiDefinite)
