using BinDeps

@BinDeps.setup

libQuasiDefinite = library_dependency("libQuasiDefinite")

provides(SimpleBuild,
         (@build_steps begin
             `make`
             `make install`
         end),
         libQuasiDefinite)

@BinDeps.install [:libQuasiDefinite => :libQuasiDefinite]
