libqdel.dylib: say_hello.c
	clang -shared -fPIC say_hello.c -o libqdel.dylib

.PHONY: install
install: libqdel.dylib
	mkdir -p ../../usr/lib
	cp libqdel.dylib ../../usr/lib/

.PHONY: uninstall
uninstall:
	$(RM) ../../usr/lib/libqdel.dylib

.PHONY: clean
clean:
	$(RM) libqdel.dylib
