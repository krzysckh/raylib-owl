OWL_SOURCE_PATH=/home/kpm/nmojeprogramy/owl
CFLAGS=-ggdb -DPRIM_CUSTOM -I/usr/local/include -I$(OWL_SOURCE_PATH)/c
LDFLAGS="-L/usr/local/lib"

test: test.c raylib.c
	clang $(CFLAGS) $(LDFLAGS) raylib.c test.c -lraylib -lm -o test
test.c: test.scm ol-rl
	./ol-rl -C $(OWL_SOURCE_PATH)/c/ovm.c -x c -o test.c test.scm
test.scm: raylib.scm raylib/*.scm
ol.c: makeol
	./makeol $(OWL_SOURCE_PATH)/fasl/ol.fasl | cat - $(OWL_SOURCE_PATH)/c/ovm.c > ol.c
makeol: makeol.c
	clang makeol.c -o makeol
ol-rl: ol.c raylib.c
	clang $(CFLAGS) ol.c raylib.c -lraylib -lm -o ol-rl
clean:
	rm -f test test.c ol-rl ol.c makeol
