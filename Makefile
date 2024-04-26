OWL_TEMP_SOURCE_PATH=/tmp/owl
OWL_REVISION=4a1edc5657a4f06ab736ef92714facce890e05b0
CFLAGS=-ggdb -DPRIM_CUSTOM -I/usr/local/include -I$(OWL_TEMP_SOURCE_PATH)/c -fsanitize=address
LDFLAGS=-L/usr/local/lib -lraylib -lm
LDFLAGS_WIN=-L$(PWD) -l:libraylib5-winlegacy.a -lm -lopengl32 -lwinmm -lgdi32 -lws2_32 -static

FEATHER=/tmp/feather

.PHONY: docs pubcpy make-owl patch-owl

$(OWL_TEMP_SOURCE_PATH):
	git clone https://gitlab.com/owl-lisp/owl $(OWL_TEMP_SOURCE_PATH)
	cd $(OWL_TEMP_SOURCE_PATH) && git checkout $(OWL_REVISION)
$(OWL_TEMP_SOURCE_PATH)/fasl/ol.fasl: ol-rt.c
	$(MAKE) patch-owl
	$(MAKE) -C $(OWL_TEMP_SOURCE_PATH) CC=$(CC)
patch-owl:
	sed -i.bak 's!"c/_vm\.c"!"$(PWD)/ol-rt.c"!' $(OWL_TEMP_SOURCE_PATH)/owl/compile.scm
	sed -i.bak 's!'"'"'("\.")!'"'"'("$(PWD)" ".")! ; s/(define \*features\*/(import (raylib))\n(define *features*/' $(OWL_TEMP_SOURCE_PATH)/owl/ol.scm
	sed -i.bak -e 's!bin/olp $$?!bin/olp -DPRIM_CUSTOM $$? $(LDFLAGS)!' \
		-e 's!tests/\*\.scm tests/\*\.sh!!' \
		$(OWL_TEMP_SOURCE_PATH)/Makefile
	cd $(OWL_TEMP_SOURCE_PATH) && rm tests/*
	echo "echo no tests" > $(OWL_TEMP_SOURCE_PATH)/tests/run
	chmod +x $(OWL_TEMP_SOURCE_PATH)/tests/run
ol-rt.c: raylib.c $(OWL_TEMP_SOURCE_PATH)
	grep -v "ovm\.h" raylib.c | cat $(OWL_TEMP_SOURCE_PATH)/c/ovm.h - $(OWL_TEMP_SOURCE_PATH)/c/ovm.c > ol-rt.c
ol-rt-win.c: raylib.c ovm-win.c
	grep -v "ovm\.h" raylib.c | cat ovm-win.c - > ol-rt-win.c
ol-rl: $(OWL_TEMP_SOURCE_PATH)/fasl/ol.fasl
	cp -v $(OWL_TEMP_SOURCE_PATH)/bin/ol ol-rl
test: test.c raylib.c
	clang $(CFLAGS) test.c $(LDFLAGS) -lraylib -lm -o test
test.c: test.scm ol-rl
	./ol-rl -x c -o test.c -x c test.scm
test-win.c: test.scm ol-rl.exe
	wine ol-rl.exe -x c -o test-win.c test.scm
test-win.exe: test-win.c
	i686-w64-mingw32-gcc $(CFLAGS) test-win.c $(LDFLAGS_WIN) -o test-win.exe
test.scm: raylib.scm raylib/*.scm
libraylib5-winlegacy.a:
	wget https://pub.krzysckh.org/libraylib5-winlegacy.a -O libraylib5-winlegacy.a
ovm-win.c:
	wget https://raw.githubusercontent.com/krzysckh/owl-winrt/master/ovm.c -O ovm-win.c
ol-rl.exe: libraylib5-winlegacy.a ovm-win.c
	$(MAKE) clean
	$(MAKE) ol-rt-win.c
	mv ol-rt-win.c ol-rt.c
	$(MAKE) $(OWL_TEMP_SOURCE_PATH)
	$(MAKE) patch-owl
	$(MAKE) -C $(OWL_TEMP_SOURCE_PATH) CC=$(CC) c/ol.c
	i686-w64-mingw32-gcc $(CFLAGS) -o ol-rl.exe -DSILENT -DPRIM_CUSTOM $(OWL_TEMP_SOURCE_PATH)/c/ol.c $(LDFLAGS_WIN)

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
	rm -fr test test.c *.exe test-win.c *.html raylib-owl.md ol-rt.c \
		$(OWL_TEMP_SOURCE_PATH)
pubcpy: docs ol-rl.exe
	yes | pubcpy raylib-owl.html
	yes | pubcpy ol-rl.exe
