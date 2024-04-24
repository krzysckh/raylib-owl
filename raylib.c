#include <stdio.h>
#include <stdlib.h>
#include <raylib.h>

#include "ovm.h"

/* #define cfloat(x) (is_type(x,TRAT)?((float)cnum(x)/(float)cnum((x)+W)):cnum((x))) */
/* TODO: this does not work */
#define cfloat(x) (is_type(x,TRAT)?((float)cnum(x)/(float)cnum(x)):cnum((x)+W))

#define v2color(a) (*(Color*)(uint32_t[]){cnum(a)})
#define VOID(exp) {exp; return ITRUE;}
#define list2vec2(t) ((Vector2){cfloat(list_at(t, 0)), cfloat(list_at(t, 1))})
#define list2vec3(t) ((Vector3){cfloat(list_at(t, 0)), cfloat(list_at(t, 1)), cfloat(list_at(t, 2))})
#define list2vec list2vec2
#define vec2 Vector2
#define vec3 Vector3
#define vec vec2
#define gg(a, b) list_at(a, b-1)

#define list2rect(t) ((Rectangle){cfloat(list_at(t, 0)), cfloat(list_at(t, 1)), \
                                  cfloat(list_at(t, 2)), cfloat(list_at(t, 3))})

#define not_implemented(f) \
  fprintf(stderr, "not-implemented %s (opcode %d)\n", #f, op);   \
  abort(); \
  return IFALSE;

/* i hope the god forsaken compiler optimizes this to a loop */
word
list_at(word l, int n)
{
  if (n == 0)
    return G(l, 1);
  return list_at(G(l, 2), n-1);
}

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
  case 103: return BOOL(IsWindowReady());
  case 104: return BOOL(IsWindowMinimized());
  case 105: return BOOL(IsWindowMaximized());
  case 106: return BOOL(IsWindowResized());
  case 107: return BOOL(IsWindowState(cnum(a)));
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
  case 117: return mkint((uint64_t)GetWindowHandle());
  case 118: return mkint(GetScreenWidth());
  case 119: return mkint(GetScreenHeight());
  case 120: return mkint(GetMonitorCount());
  case 121: return mkint(GetMonitorWidth(cnum(a)));
  case 122: return mkint(GetMonitorHeight(cnum(a)));
  case 123: return mkint(GetMonitorPhysicalWidth(cnum(a)));
  case 124: return mkint(GetMonitorPhysicalHeight(cnum(a)));
  case 125: return mkstring((char*)GetMonitorName(cnum(a)));
  case 126: return mkstring((char*)GetClipboardText());
  case 127:
    SetClipboardText((char*)a+W);
    return ITRUE;
  case 128:
    ShowCursor();
    return ITRUE;
  case 129:
    HideCursor();
    return ITRUE;
  case 130: return BOOL(IsCursorHidden());
  case 131:
    EnableCursor();
    return ITRUE;
  case 132:
    DisableCursor();
    return ITRUE;
  case 133: return BOOL(IsCursorOnScreen());
  case 134: { /* make-color (r g b a) → color */
    short R = cnum(list_at(a, 0)), G = cnum(list_at(a, 1)),
      B = cnum(list_at(a, 2)), A = cnum(list_at(a, 3));
    return mkint((uint32_t)(A<<24)|(B<<16)|(G<<8)|R);
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
  case 147:
  case 148:
  case 149:
    not_implemented("lol");
  case 150:
    SetTargetFPS(cnum(a));
    return ITRUE;
  case 151: return mkint(GetFPS());
  case 152: return mkfloat(GetFrameTime());
  case 153: return mkfloat(GetTime());
  case 154: {
    Vector4 c = ColorNormalize(v2color(cnum(a)));
    return cons(mkfloat(c.x),
                cons(mkfloat(c.y),
                     cons(mkfloat(c.z),
                          cons(mkfloat(c.w), INULL))));
  }
  case 155: {
    Vector3 h = ColorToHSV(v2color(cnum(a)));
    return cons(mkfloat(h.x),
                cons(mkfloat(h.y),
                     cons(mkfloat(h.z), INULL)));
  }
  case 156:
    not_implemented(ColorFromHSV);
  case 157: {
    Color cl = Fade(v2color(cnum(a)), cfloat(b));
    return mkint(*(uint32_t*)&cl);
  }
  case 158:
    SetConfigFlags(cnum(a));
    return ITRUE;
  case 159:
    SetTraceLogLevel(cnum(a));
    return ITRUE;
  case 160: /* TODO: callback */
    not_implemented(SetTraceLogCallback);
  case 161: /* TODO: variadic or just lisp-side string-append */
    not_implemented(TraceLog);
  case 162:
    TakeScreenshot(cstr(a));
    return ITRUE;
  case 163: {
    FilePathList fpl = LoadDroppedFiles();
    word lst = INULL;
    uint i;
    for (i = 0; i < fpl.count; ++i)
      lst = cons(mkstring(fpl.paths[i]), lst);

    UnloadDroppedFiles(fpl);
    return lst;
  }
  case 164:
    OpenURL(cstr(a));
    return ITRUE;
  case 165: return BOOL(IsKeyPressed(cnum(a)));
  case 166: return BOOL(IsKeyDown(cnum(a)));
  case 167: return BOOL(IsKeyReleased(cnum(a)));
  case 168: return BOOL(IsKeyUp(cnum(a)));
  case 169: return mkint(GetKeyPressed());
  case 170:
    SetExitKey(cnum(a));
    return ITRUE;
  case 171: return BOOL(IsGamepadAvailable(cnum(a)));
  case 172: return mkstring((char*)GetGamepadName(cnum(a)));
  case 173: return BOOL(IsGamepadButtonPressed(cnum(a), cnum(b)));
  case 174: return BOOL(IsGamepadButtonDown(cnum(a), cnum(b)));
  case 175: return BOOL(IsGamepadButtonReleased(cnum(a), cnum(b)));
  case 176: return BOOL(IsGamepadButtonUp(cnum(a), cnum(b)));
  case 177: return onum(GetGamepadButtonPressed(), 1);
  case 178: return onum(GetGamepadAxisCount(cnum(a)), 1);
  case 179: return mkfloat(GetGamepadAxisMovement(cnum(a), cnum(b)));

  case 180: return BOOL(IsMouseButtonPressed(cnum(a)));
  case 181: return BOOL(IsMouseButtonDown(cnum(a)));
  case 182: return BOOL(IsMouseButtonReleased(cnum(a)));
  case 183: return BOOL(IsMouseButtonUp(cnum(a)));
  case 184: return mkint(GetMouseX());
  case 185: return mkint(GetMouseY());
  case 186: {
    vec pos = GetMousePosition();
    return cons(mkint(pos.x), mkint(pos.y));
  }
  case 187:
    SetMousePosition(cnum(a), cnum(b));
    return ITRUE;
  case 188:
    SetMouseOffset(cnum(a), cnum(b));
    return ITRUE;
  case 189:
    SetMouseScale(cfloat(a), cfloat(b));
    return ITRUE;
  case 190: return mkfloat(GetMouseWheelMove());
  case 191: return mkint(GetTouchX());
  case 192: return mkint(GetTouchY());
  case 193: {
    vec pos = GetTouchPosition(cnum(a));
    return cons(mkint(pos.x), mkint(pos.y));
  }

  case 194:
    SetGesturesEnabled(cnum(a));
    return ITRUE;
  case 195: return BOOL(IsGestureDetected(cnum(a)));
  case 196: return mkint(GetGestureDetected());
  case 197: return mkint(GetTouchPointCount());
  case 198: return mkfloat(GetGestureHoldDuration());
  case 199: {
    vec dv = GetGestureDragVector();
    return cons(mkfloat(dv.x), mkfloat(dv.y));
  }
  case 200: return mkfloat(GetGestureDragAngle());
  case 201: {
    vec pv = GetGesturePinchVector();
    return cons(mkfloat(pv.x), mkfloat(pv.y));
  }
  case 202: return mkfloat(GetGesturePinchAngle());

  case 203:
  case 204:
  case 205:
  case 206:
  case 207:
  case 208:
    not_implemented("camera stuff");
  case 209: VOID(DrawPixel(cnum(a), cnum(b), v2color(c)));
  case 210: VOID(DrawPixelV(list2vec2(a), v2color(b)));
  case 211: VOID(DrawLineV(list2vec2(a), list2vec(b), v2color(c)));
  case 212: VOID(DrawLineEx(list2vec2(a), list2vec(b),
                            cfloat(gg(c, 1)), v2color(gg(c, 2)))); /* #[x y] #[x y] #[thick color] */
  case 213: VOID(DrawLineBezier(list2vec2(a), list2vec(b),
                                cfloat(gg(c, 1)), v2color(gg(c, 2))));
  case 214: { /* (pts) N color */
    int i, N = cnum(b);
    vec pts[N];
    for (i = 0; i < N; ++i)
      pts[i] = list2vec(gg(a, i+1));
    VOID(DrawLineStrip(pts, N, v2color(c)));
  }
  case 215: /* pos #[radius startang end-ang segments] color */
    VOID(DrawCircleSector(list2vec(a), cfloat(gg(b, 1)), cnum(gg(b, 2)), cnum(gg(b, 3)), cnum(gg(b, 4)), v2color(c)));
  case 216: VOID(DrawCircleSectorLines(list2vec(a), cfloat(gg(b, 1)), cnum(gg(b, 2)), cnum(gg(b, 3)), cnum(gg(b, 4)), v2color(c)));
  case 217: { /* pos radius #[col1 col2] */
    vec pos = list2vec(a);
    VOID(DrawCircleGradient(pos.x, pos.y, cfloat(b), v2color(gg(c, 1)), v2color(gg(c, 2))));
  }
  case 218: VOID(DrawCircleV(list2vec(a), cfloat(b), v2color(c)));
  case 219: {
    vec pos = list2vec(a);
    VOID(DrawCircleLines(pos.x, pos.y, cfloat(b), v2color(c)));
  }
  case 220: /* center #[inner outer] #[start-ang end-ang segs color] */
    VOID(DrawRing(list2vec(a), cfloat(gg(b, 1)), cfloat(gg(b, 2)), cnum(gg(c, 1)), cnum(gg(c, 2)), cnum(gg(c, 3)), v2color(gg(c, 4))));
  case 221: VOID(DrawRingLines(list2vec(a), cfloat(gg(b, 1)), cfloat(gg(b, 2)), cnum(gg(c, 1)), cnum(gg(c, 2)), cnum(gg(c, 3)), v2color(gg(c, 4))));
  case 222: VOID(DrawRectangleV(list2vec(a), list2vec(b), v2color(c)));
  case 223: VOID(DrawRectangleRec(list2rect(a), v2color(b)));
  case 224: /* rec or #[rot color] */
    VOID(DrawRectanglePro(list2rect(a), list2vec2(b), cfloat(gg(c, 1)), v2color(gg(c, 2))));
  case 225: { /* vec #[num num] #[col col] */
    vec pos = list2vec(a);
    VOID(DrawRectangleGradientV(pos.x, pos.y, cnum(gg(b, 1)), cnum(gg(b, 2)), v2color(gg(c, 1)), v2color(gg(c, 2))));
  }
  case 226: {
    vec pos = list2vec(a);
    VOID(DrawRectangleGradientH(pos.x, pos.y, cnum(gg(b, 1)), cnum(gg(b, 2)), v2color(gg(c, 1)), v2color(gg(c, 2))));
  }
  case 227: VOID(DrawRectangleGradientEx(list2rect(a), v2color(gg(b, 1)), v2color(gg(b, 2)), v2color(gg(c, 1)), v2color(gg(c, 2))));
  case 228: VOID(DrawRectangleLinesEx(list2rect(a), cnum(b), v2color(c)));
  case 229: VOID(DrawRectangleRounded(list2rect(a), cfloat(gg(b, 1)), cnum(gg(b, 2)), v2color(c)));
  case 230: VOID(DrawRectangleRoundedLines(list2rect(a), cfloat(gg(b, 1)), cnum(gg(b, 2)), cnum(gg(b, 3)), v2color(c)));
  case 231: {
    vec p1 = list2vec(gg(a, 1));
    /* printf("fuck: %d\n", is_type(a, )); */
    /* printf("tuple?: %d, p1: .x = %f, .y = %f\n", is_type(gg(a, 1), TTUPLE), p1.x, p1.y); */
    /* printf("denominator: %ld\n", cnum(gg(a,1)+W)); */
    VOID(DrawTriangle(list2vec(gg(a, 1)), list2vec(gg(a, 2)), list2vec(gg(a, 3)), v2color(b)));
  }
  case 232: VOID(DrawTriangleLines(list2vec(gg(a, 1)), list2vec(gg(a, 2)), list2vec(gg(a, 3)), v2color(b)));
  case 233: {
    int N = cnum(b), i;
    Vector2 pts[N];
    for (i = 0; i < N; ++i)
      pts[i] = list2vec2(gg(a, i+1));
    VOID(DrawTriangleFan(pts, N, v2color(c)));
  }
  case 234: {
    int N = cnum(b), i;
    Vector2 pts[N];
    for (i = 0; i < N; ++i)
      pts[i] = list2vec2(gg(a, i+1));
    VOID(DrawTriangleStrip(pts, N, v2color(c)));
  }
  case 235: VOID(DrawPoly(list2vec(a), cnum(gg(b, 1)), cfloat(gg(b, 2)), cfloat(gg(b, 3)), v2color(c)));
  /* case 236: VOID(SetShapesTexture(Texture2D texture, Rectangle source)); */

  case 300:
    /* testin' */
    abort();
    printf("%s\n", cstr(list_at(a, 0)));
    printf("%ld\n", cnum(list_at(a, 1)));
    printf("%f\n", cfloat(list_at(a, 2)));
    printf("len: %d\n", llen((word*)list_at(a, 3)));
    break;
  }
  return IFALSE;
}
