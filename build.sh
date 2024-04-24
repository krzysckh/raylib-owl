#!/bin/sh
# -*- mode: sh; sh-basic-offset: 2 -*-

set -xe

OWL_SOURCE_PATH=/home/kpm/nmojeprogramy/owl
CFLAGS="-ggdb -DPRIM_CUSTOM -I/usr/local/include -I$OWL_SOURCE_PATH/c"
LDFLAGS="-L/usr/local/lib"

if [ `uname -s` = "OpenBSD" ]; then
  LDFLAGS="$LDFLAGS -lglfw"
fi

build_unix() {
  set -xe
  ol -C "$OWL_SOURCE_PATH/c/ovm.c" -x c -o test.c test.scm
  clang $CFLAGS $LDFLAGS raylib.c test.c -lraylib -lm -o test
}

build_unix
