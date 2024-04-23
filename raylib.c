#include <stdio.h>
#include <raylib.h>

#include "ovm.h"

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
  default:
    return IFALSE;
  }
}
