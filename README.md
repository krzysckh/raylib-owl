## raylib-owl

WIP raylib bindings for owl lisp

api.txt imported (and tweaked a bit) from janet-lang/jaylib

## how

Owl lisp supports C extensions via custom sys-prims - basically
syscalls, but to C functions, not the system. You define a
`word prim_custom(int op, word a, word b, word c)` in a C file,
then call `(sys-prim op a b c)` from the lisp side, and then compile 
and link them together.

Also, you probably need the owl lisp source code on your machine,
because `./raylib.c` requires `ovm.h`, and you need `ol.fasl`, to 
bootstrap `ol-rl`.

## bootstraping `ol-rl`

`ol-rl` is the same thing as `ol`, but with compiled-in support for
raylib `sys-prim`s, so it will be then used to interpret and/or
compile Owl lisp programs that depend on raylib.

```console
$ make ol-rl
```

## compiling stuff

```console
$ ol-rl -i /path/to/raylib-owl -x c -o test.c test.scm
$ cc -DPRIM_CUSTOM -I$OWL_SOURCE_PATH/c test.c raylib.c -lraylib -lm -o test
```

## windows

If you're on windows, you can download the pre-compiled `ol-rl.exe` binary
[here](https://pub.krzysckh.org/ol-rl.exe). If running it as a REPL, remember
to use `--no-readline`.

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
  * [ ] implement api.txt fully
