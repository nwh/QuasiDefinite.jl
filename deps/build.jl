using BinDeps

@BinDeps.setup

libqdel = library_dependency("libqdel")

depsdir = BinDeps.depsdir(libqdel)
qdeldir = joinpath(depsdir,"src","libqdel")

show(qdeldir)

provides(SimpleBuild,
         (@build_steps begin
             ChangeDirectory(qdeldir)
             `make`
         end),
         libqdel)

@BinDeps.install Dict(:libqdel => :libqdel)
