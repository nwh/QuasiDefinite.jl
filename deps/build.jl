using BinDeps

@BinDeps.setup

libQuasiDefinite = library_dependency("libQuasiDefinite")

provides(SimpleBuild,
         (@build_steps begin
             `make`
         end),
         libQuasiDefinite)

@BinDeps.install Dict(:libQuasiDefinite => :libQuasiDefinite)
