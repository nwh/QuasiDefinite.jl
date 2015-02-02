# delete default suffixes
.SUFFIXES:

# library name
LIBNAME := libQuasiDefinite

# figure out OS
BUILD_OS := $(shell uname)
OS := $(BUILD_OS)

# file extension for shared library
ifeq ($(OS), Darwin)
  SHLIB_EXT := dylib
else ifeq ($(OS), Linux)
  SHLIB_EXT := so
else
	$(error "Unsupported operating system")
endif

# compilers and linkers
ifeq ($(OS), Darwin)
  # c compiler
  CC := clang
  CFLAGS := -fPIC
  # fortran compiler
  FC := gfortran
  FFLAGS := -fPIC
  # linker
  LD := clang
  LDFLAGS := -framework Accelerate
else ifeq ($(OS), Linux)
  # c compiler
  CC := gcc
  CFLAGS := -fPIC
  # fortran compiler
  FC := gfortran
  FFLAGS := -fPIC
  # linker
  LD := gcc
  LDFLAGS :=
else
	$(error "Unsupported operating system")
endif

# archive tool
AR := ar
ARFLAGS := rcs

# c source and object files
CSRC := $(shell find . -name '*.c')
COBJ := $(patsubst %.c,%.o,$(filter %.c,$(CSRC)))

# fortran source and object files
FSRC := $(shell find . -name '*.f')
FOBJ := $(patsubst %.f,%.o,$(filter %.f,$(FSRC)))

# default goal
.DEFAULT_GOAL := $(LIBNAME).$(SHLIB_EXT)

# pattern rule for c source
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

# pattern rule for fortran source
%.o : %.f
	$(FC) $(FFLAGS) -c $< -o $@

# rule to generate arive file
$(LIBNAME).a: $(COBJ) $(FOBJ)
	$(AR) $(ARFLAGS) $@ $^

# rename symbols
$(LIBNAME).a.renamed: $(LIBNAME).a
	objcopy --redefine-syms objcopy.def $< $@

# rule to create shared object
$(LIBNAME).$(SHLIB_EXT): $(LIBNAME).a.renamed
	$(LD) $(LDFLAGS) -shared -o $@ \
    -Wl,--whole-archive $< \
    -Wl,--no-whole-archive

#    -Wl,-undefined,suppress \

.PHONY: install
install: $(LIBNAME).$(SHLIB_EXT)
	mkdir -p ./usr/lib
	cp $(LIBNAME).$(SHLIB_EXT) ./usr/lib/$(LIBNAME).$(SHLIB_EXT)

.PHONY: clean
clean:
	$(RM) $(LIBNAME).a
	$(RM) $(LIBNAME).a.renamed
	$(RM) $(LIBNAME).$(SHLIB_EXT)
	$(RM) $(COBJ) $(FOBJ)
	$(RM) ./usr/lib/$(LIBNAME).$(SHLIB_EXT)
	$(RM) -r usr
