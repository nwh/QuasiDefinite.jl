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
  # c++ compiler
  CXX := clang++
  CXXFLAGS := -O2
  # fortran compiler
  FC := gfortran
  FFLAGS := -O2 -Wall -m64 -fdefault-integer-8 -fPIC
  # linker
  LD := gfortran
  LDFLAGS := -all_load -undefined suppress -flat_namespace
else ifeq ($(OS), Linux)
  # c compiler
  CC := gcc
  CFLAGS := -fPIC
  # c++ compiler
  CXX := g++
  CXXFLAGS := -O2
  # fortran compiler
  FC := gfortran
  FFLAGS := -O2 -Wall -m64 -fdefault-integer-8 -fPIC
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

# rule to download and build objconv
./objconv:
	curl -O http://www.agner.org/optimize/objconv.zip
	unzip -d objconv-dir objconv.zip
	unzip -d objconv-src objconv-dir/source.zip
	$(CXX) $(CXXFLAGS) -o objconv objconv-src/*.cpp

# rule to generate arive file
$(LIBNAME).a: $(COBJ) $(FOBJ)
	$(AR) $(ARFLAGS) $@ $^

# rule to rename symbols and create shared object
ifeq ($(OS), Darwin)

$(LIBNAME).a.renamed: $(LIBNAME).a ./objconv
	./objconv @objconv.def $< $@
	ranlib $@

$(LIBNAME).$(SHLIB_EXT): $(LIBNAME).a.renamed
	$(LD) $(LDFLAGS) -dynamiclib -o $@ $^

else ifeq ($(OS), Linux)

$(LIBNAME).a.renamed: $(LIBNAME).a
	objcopy --redefine-syms objcopy.def $< $@
	ranlib $@

$(LIBNAME).$(SHLIB_EXT): $(LIBNAME).a.renamed
	$(LD) $(LDFLAGS) -shared -o $@ \
    -Wl,--whole-archive $< \
    -Wl,--no-whole-archive

else
	$(error "Unsupported operating system")
endif

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
	$(RM) deps.jl

.PHONY: clean-objconv
clean-objconv:
	$(RM) objconv.zip
	$(RM) -r objconv-dir
	$(RM) -r objconv-src
	$(RM) objconv

.PHONY: clean-all
clean-all: clean clean-objconv
