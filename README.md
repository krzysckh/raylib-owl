## raylib-owl

WIP raylib bindings for owl lisp

api.md imported (and tweaked a bit) from janet-lang/jaylib,
it is probably a bit outdated.

## dependencies

* raylib from @master - tested on f1007554a0a8145060797c0aa8169bdaf2c1c6b8
* GNU sed - BSD one may not work
* GNU make 

## how

Owl lisp supports C extensions via custom sys-prims - basically
syscalls, but to C functions, not the system. You define a
`word prim_custom(int op, word a, word b, word c)` in a C file,
then call `(sys-prim op a b c)` from the lisp side, and then compile 
and link them together.

## bootstraping `ol-rl`

`ol-rl` is the same thing as `ol`, but with compiled-in support for
raylib `sys-prim`s, so it will be then used to interpret and/or
compile Owl lisp programs that depend on raylib.

```sh
$ make all
# make install
```

## compiling stuff

* unix
```sh
$ ol-rl -o test.c test.scm
$ cc test.c -lraylib -lm -o test
$ ./test
```
* unix targetting windows
```sh
$ wget https://pub.krzysckh.org/ol-rl.exe
$ wget https://pub.krzysckh.org/libraylib5-winlegacy.a
$ wine ol-rl.exe -o test-w32.c test.scm
$ i686-w64-mingw32-gcc -static -o test.exe -I/usr/local/include test-w32.c -L. -l:libraylib5-winlegacy.a -lm -lopengl32 -lwinmm -lgdi32 -lws2_32
```

* windows targetting windows

  you're on your own. good luck.

## usage on ms windows

If you're on windows, you can download the pre-compiled `ol-rl.exe` binary
[here](https://pub.krzysckh.org/ol-rl.exe). If running it as a REPL, remember
to use `--no-readline`.

## targetting web with emscripten

- compile raylib targetting web, or use [this](https://pub.krzysckh.org/libraylib5-web.a)
  pre-compiled binary
```sh
$ git clone https://github.com/raysan5/raylib
$ cd raylib/src
$ make clean all PLATFORM=PLATFORM_WEB
```
- compile your code for web
```sh
$ ol-rl -o test.c test.scm
$ emcc -DPLATFORM_WEB -I/usr/local/include test.c /path/to/libraylib-web.a -o test.html -s USE_GLFW=3 -s ERROR_ON_UNDEFINED_SYMBOLS=0 -s ALLOW_MEMORY_GROWTH=1 -s ASYNCIFY -s ASSERTIONS=0
```

## gotchas and caveats

* Remember, that everything that can be evaluated at compile-time, will
  probably be evaluated at compile time. This can be used to embed files,
  or as a footgun.
* Remember, that there is no mutable data. For "variables", that may change
  depending on frames, scrap the `with-mainloop` macro, and define
  Your own `mainloop` function, that tail-recurses into itself, and
  sets the "variables" as arguments.
* There is no type checking. You're on your own.
* The c code sucks, and i need to come up with some better api for
  writing extensions, but for now - it is what it is.
* You can treat the source code as the docs, because
  [this](https://pub.krzysckh.org/raylib-owl.html) is (for now) not good.
* Good luck.

## TODOs
  * [x] ol-rl
    * [x] works
    * [x] embed `(raylib)` - the lisp sources - into `ol-rl`
    * [x] embed the raylib runtime (`ovm.c` + `raylib.c`) into `ol-rl`
  * [ ] implement `api.md` fully
  * [ ] implement `raymath-api.md` fully
