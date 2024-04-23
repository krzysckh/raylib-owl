#include <stdio.h>
#include <stdlib.h>
#include <raylib.h>

#include "ovm.h"

#define v2color(a) (*(Color*)(uint32_t[]){cnum(a)})

word
prim_custom(int op, word a, word b, word c)
{
  switch (op) {
  case 100:
    InitWindow(cnum(a), cnum(b), (char*)c+W);
    return ITRUE;
  case 101:
    return WindowShouldClose() ? ITRUE : IFALSE;
  case 102:
    CloseWindow();
    return ITRUE;
  case 103:
    return IsWindowReady() ? ITRUE : IFALSE;
  case 104:
    return IsWindowMinimized() ? ITRUE : IFALSE;
  case 105:
    return IsWindowMaximized() ? ITRUE : IFALSE;
  case 106:
    return IsWindowResized() ? ITRUE : IFALSE;
  case 107:
    return IsWindowState(cnum(a)) ? ITRUE : IFALSE;
  case 108:
    SetWindowState(cnum(a));
    return ITRUE;
  case 109:
    ClearWindowState(cnum(a));
    return ITRUE;
  case 110:
    ToggleFullscreen();
    return ITRUE;
  case 111:
    SetWindowIcon(*(Image*)cnum(a));
    return ITRUE;
  case 112:
    SetWindowTitle((char*)a+W);
    return ITRUE;
  case 113:
    SetWindowPosition(cnum(a), cnum(b));
    return ITRUE;
  case 114:
    SetWindowMonitor(cnum(a));
    return ITRUE;
  case 115:
    SetWindowMinSize(cnum(a), cnum(b));
    return ITRUE;
  case 116:
    SetWindowSize(cnum(a), cnum(b));
    return ITRUE;
  case 117:
    return mkint((uint64_t)GetWindowHandle());
  case 118:
    return mkint(GetScreenWidth());
  case 119:
    return mkint(GetScreenHeight());
  case 120:
    return mkint(GetMonitorCount());
  case 121:
    return mkint(GetMonitorWidth(cnum(a)));
  case 122:
    return mkint(GetMonitorHeight(cnum(a)));
  case 123:
    return mkint(GetMonitorPhysicalWidth(cnum(a)));
  case 124:
    return mkint(GetMonitorPhysicalHeight(cnum(a)));
  case 125:
    return mkstring((char*)GetMonitorName(cnum(a)));
  case 126:
    return mkstring((char*)GetClipboardText());
  case 127:
    SetClipboardText((char*)a+W);
    return ITRUE;
  case 128:
    ShowCursor();
    return ITRUE;
  case 129:
    HideCursor();
    return ITRUE;
  case 130:
    return IsCursorHidden() ? ITRUE : IFALSE;
  case 131:
    EnableCursor();
    return ITRUE;
  case 132:
    DisableCursor();
    return ITRUE;
  case 133:
    return IsCursorOnScreen() ? ITRUE : IFALSE;
  case 134: { /* make-color (r g b a) → color */
    int c[4], i;
    for (i = 0; i < 4; ++i)
      c[i] = cnum(G(a, 1)), a = G(a, 2);

    return mkint((uint32_t)(c[3]<<24)|(c[2]<<16)|(c[1]<<8)|c[0]);
  }
  case 135:
    ClearBackground(v2color(a));
    return ITRUE;
  case 136:
    BeginDrawing();
    return ITRUE;
  case 137:
    EndDrawing();
    return ITRUE;
    /* TODO: i have no clue how floats work */
  case 138: { /* make-camera2d (offset-x . offset-y) (targ-x . targ-y) (rot . zoom) */
    Camera2D *cd = malloc(sizeof(Camera2D));
    cd->offset = (Vector2){ cnum(a), cnum(a+W) };
    cd->target = (Vector2){ cnum(b), cnum(b+W) };
    cd->rotation = cnum(c);
    cd->zoom = cnum(c+W);
    return onum((uint64_t)cd, 0);
  }
  case 139:
    BeginMode2D(*(Camera2D*)cnum(a));
    return ITRUE;
  case 140:
    EndMode2D();
    return ITRUE;
  case 141:
  case 142:
  case 143:
  case 144:
  case 145:
  case 146:
    fprintf(stderr, "not-implemented %d", op);
    abort();
    return IFALSE;
  default:
    return IFALSE;
  }
}
