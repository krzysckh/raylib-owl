OWL_SOURCE_PATH=/home/kpm/nmojeprogramy/owl
CFLAGS=-ggdb -DPRIM_CUSTOM -I/usr/local/include -I$(OWL_SOURCE_PATH)/c
LDFLAGS="-L/usr/local/lib"

FEATHER=/tmp/feather

.PHONY: docs pubcpy

test: test.c raylib.c
	clang $(CFLAGS) $(LDFLAGS) raylib.c test.c -lraylib -lm -o test
test.c: test.scm ol-rl
	./ol-rl -x c -o test.c test.scm
test.scm: raylib.scm raylib/*.scm
ol.c: makeol
	./makeol $(OWL_SOURCE_PATH)/fasl/ol.fasl | cat - $(OWL_SOURCE_PATH)/c/ovm.c > ol.c
makeol: makeol.c
	clang makeol.c -o makeol
ol-rl: ol.c raylib.c
	clang $(CFLAGS) ol.c raylib.c -lraylib -lm -o ol-rl
libraylib5-winlegacy.a:
	wget https://pub.krzysckh.org/libraylib5-winlegacy.a -O libraylib5-winlegacy.a
ovm-win.c: makeol
	wget https://raw.githubusercontent.com/krzysckh/owl-winrt/master/ovm.c -O ovm-win.c
ol-win.c: ovm-win.c
	./makeol $(OWL_SOURCE_PATH)/fasl/ol.fasl | cat - ./ovm-win.c > ol-win.c
ol-rl.exe: libraylib5-winlegacy.a ol-win.c raylib.c
	i686-w64-mingw32-gcc $(CFLAGS) ol-win.c raylib.c \
		-L. -l:libraylib5-winlegacy.a -lm -lopengl32 -lwinmm -lgdi32 -lws2_32 -static \
		-o ol-rl.exe
test-win.c: test.scm ol-rl
	./ol-rl -C ./ovm-win.c -o test-win.c -x c test.scm
test-win.exe: libraylib5-winlegacy.a test-win.c raylib.c
	i686-w64-mingw32-gcc $(CFLAGS) test-win.c raylib.c \
		-L. -l:libraylib5-winlegacy.a -lm -lopengl32 -lwinmm -lgdi32 -lws2_32 -static \
		-o test-win.exe
docs: raylib-owl.html raylib.scm raylib/*.scm
raylib-owl.md: $(FEATHER)
	$(FEATHER) -o raylib-owl.md --title "(raylib)" \
		README.md `find . -type f -iname '*.scm' | grep -v test`
raylib-owl.html: raylib-owl.md
	pandoc --toc -s -f gfm -t html raylib-owl.md -o raylib-owl.html
$(FEATHER):
	wget -O $(FEATHER) https://gitlab.com/owl-lisp/owl/-/raw/master/bin/feather
	chmod +x $(FEATHER)
clean:
	rm -f test test.c ol-rl ol.c makeol *.exe test-win.c *.html raylib-owl.md
pubcpy: docs test-win.exe
	yes | pubcpy raylib-owl.html
	yes | pubcpy test-win.exe
