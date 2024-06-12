OWL_TEMP_SOURCE_PATH=/tmp/owl
OWL_REVISION=4f1ab716388b425148f533efa7fb7d84a9ab1933

CFLAGS_COMMON=-g -DPRIM_CUSTOM -I/usr/local/include -I$(OWL_TEMP_SOURCE_PATH)/c
CFLAGS=$(CFLAGS_COMMON)
CFLAGS_WIN=$(CFLAGS_COMMON)
CFLAGS_OPENBSD=$(CFLAGS_COMMON)

SED=sed

LDFLAGS=-L/usr/local/lib -lraylib -lm
LDFLAGS_WIN=-L$(PWD) -l:libraylib5-winlegacy.a -lm -lopengl32 -lwinmm -lgdi32 -lws2_32 -static
LDFLAGS_OPENBSD=$(LDFLAGS) -lpthread -lglfw

PREFIX=/usr/local

OS!=uname -s|tr '[:upper:]' '[:lower:]'

ifeq "$(OS)" "openbsd"
CFLAGS:=$(CFLAGS_OPENBSD)
LDFLAGS:=$(LDFLAGS_OPENBSD)
SED:=gsed
endif

FEATHER=/tmp/feather

.PHONY: docs pubcpy make-owl patch-owl

$(OWL_TEMP_SOURCE_PATH):
	git clone https://gitlab.com/owl-lisp/owl $(OWL_TEMP_SOURCE_PATH)
	cd $(OWL_TEMP_SOURCE_PATH) && git checkout $(OWL_REVISION)
$(OWL_TEMP_SOURCE_PATH)/fasl/ol.fasl: ol-rt.c
	$(MAKE) patch-owl
	$(MAKE) -C $(OWL_TEMP_SOURCE_PATH) CC=$(CC)
patch-owl:
	$(SED) -i.bak 's!"c/_vm\.c"!"$(PWD)/ol-rt.c"!' $(OWL_TEMP_SOURCE_PATH)/owl/compile.scm
	$(SED) -i.bak 's!'"'"'("\.")!'"'"'("$(PWD)" ".")! ; s/(define \*features\*/(import (raylib))\n(define *features*/' $(OWL_TEMP_SOURCE_PATH)/owl/ol.scm
	$(SED) -i.bak -e 's!bin/olp $$?!bin/olp -g -DPRIM_CUSTOM $$? -I/usr/local/include $(LDFLAGS)!' \
		-e 's!tests/\*\.scm tests/\*\.sh!!' \
		$(OWL_TEMP_SOURCE_PATH)/Makefile
	cd $(OWL_TEMP_SOURCE_PATH) && rm tests/*
	echo "echo no tests" > $(OWL_TEMP_SOURCE_PATH)/tests/run
	chmod +x $(OWL_TEMP_SOURCE_PATH)/tests/run
ol-rt.c: raylib.c $(OWL_TEMP_SOURCE_PATH)
	echo '#define PRIM_CUSTOM' > /tmp/_prim.c
	grep -v "ovm\.h" raylib.c | cat /tmp/_prim.c $(OWL_TEMP_SOURCE_PATH)/c/ovm.h - $(OWL_TEMP_SOURCE_PATH)/c/ovm.c > ol-rt.c
ol-rt-win.c: raylib.c ovm-win.c
	echo '#define PRIM_CUSTOM' > /tmp/_prim.c
	grep -v "ovm\.h" raylib.c | cat /tmp/_prim.c ovm-win.c - > ol-rt-win.c
ol-rl: $(OWL_TEMP_SOURCE_PATH)/fasl/ol.fasl
	cp -v $(OWL_TEMP_SOURCE_PATH)/bin/ol ol-rl
test: test.c
	$(CC) $(CFLAGS) test.c $(LDFLAGS) -lraylib -lm -o test
test.c: test.scm ol-rl
	./ol-rl -x c -o test.c -x c test.scm
test-win.c: test.scm ol-rl.exe ovm-win.c
	wine ol-rl.exe -x c -o test-win.c test.scm
test-win.exe: test-win.c
	i686-w64-mingw32-gcc $(CFLAGS_WIN) test-win.c $(LDFLAGS_WIN) -o test-win.exe
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
	i686-w64-mingw32-gcc $(CFLAGS_WIN) -o ol-rl.exe -DPRIM_CUSTOM $(OWL_TEMP_SOURCE_PATH)/c/ol.c $(LDFLAGS_WIN)

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
	rm -fr test test.c test-win.c *.html raylib-owl.md ol-rt.c \
		$(OWL_TEMP_SOURCE_PATH)
install:
	cp -v ol-rl $(PREFIX)/bin
uninstall:
	rm -vf $(PREFIX)/bin/ol-rl
pubcpy: ol-rl.exe test-win.exe docs
	yes | pubcpy raylib-owl.html
	yes | pubcpy ol-rl.exe
	yes | pubcpy test-win.exe
