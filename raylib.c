#define PRIM_FP_API

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <math.h>

/* what the hell mingw /usr/share/mingw-w64/include/minwindef.h:73 */
#undef far
#undef near

#include <raylib.h>
#include <raymath.h>

#include "ovm.h"

#define cfloat(x) (float)cdouble(x)

/* a quick and dirty bandade fix until i figure out why my code is failing spectacularly with mkrat_approx() */
#ifdef OLRL_USE_MKRAT_APPROX
#define mkfloat(x) mkrat_approx(x)
#else
word mkfloat(float f) {
   int64_t v = 1, m = f < 0;
   f = ABS(f);

   if (f >= (float)INT64_MAX)
      return IFALSE;

   while ((float)(f - (int64_t)f) > 0.0) {
      f *= 10, v *= 10;
      if (v < 0) /* v overflew */
        return IFALSE;
   }

   return mkrat(m ? -f : f, v);
}
#endif

#define v2color(a) (*(Color*)(uint32_t[]){cnum(a)})
#define VOID(exp) {exp; return ITRUE;}
#define SELF(s, exp) {exp; return s;}
#define list2vec2(t) ((Vector2){cfloat(car(t)), cfloat(cadr(t))})
#define list2vec3(t) ((Vector3){cfloat(car(t)), cfloat(cadr(t)), cfloat(caddr(t))})
#define list2vec list2vec2
#define vec2 Vector2
#define vec3 Vector3
#define vec vec2
#define gg(a, b) list_at(a, b-1)
#define vec22list(v) cons(onum(v.x, 1), cons(onum(v.y, 1), INULL));
#define Vec22listH(fcall) { vec2 V = (fcall); return vec22list(V); }
#define with_data(ob, exp) {uint N; void *data = bvlst2ptr(ob, &N); exp;}
#define color2lst(c)                                                    \
  cons(onum(c.r, 1),                                                    \
       cons(onum(c.g, 1),                                               \
            cons(onum(c.b, 1),                                          \
                 cons(onum(c.a, 1), INULL)))) /* stairway to heaven */

#define list_ref list_at
#define list2rect(t) ((Rectangle){cfloat(list_at(t, 0)), cfloat(list_at(t, 1)), \
                                  cfloat(list_at(t, 2)), cfloat(list_at(t, 3))})
#define DEREF(T, v) (*(T*)cptr(v))
#define IMG() malloc(sizeof(Image))
#define IMGDO(exp) {                            \
    Image *i = IMG();                           \
    *i = exp;                                   \
    return PTR(i); }

#define rl_not_implemented(f) \
  fprintf(stderr, "not-implemented %s (opcode %d)\n", #f, op);   \
  abort(); \
  return IFALSE;

#define cadr(l) car(cdr(l))
#define caddr(l) car(cdr(cdr(l)))
#define cadddr(l) car(cdr(cdr(cdr(l))))

/* i hope the god forsaken compiler optimizes this to a loop */
word
list_at(word l, int n)
{
  if (n == 0)
    return G(l, 1);
  return list_at(G(l, 2), n-1);
}

void
list2data(word l, unsigned char *u, int N)
{
  int i;
  for (i = 0; i < N; ++i) {
    u[i] = cnum(car(l));
    l = cdr(l);
  }
}

void
list2dataW(word l, uintptr_t *u, int N)
{
  int i;
  for (i = 0; i < N; ++i) {
    u[i] = (uintptr_t)cptr(car(l));
    l = cdr(l);
  }
}


uint32_t
bvec_len(word bvec)
{
  word hdr = header(bvec);
  return payl_len(hdr);
}

uint8_t
bvecp(word ob)
{
  if (allocp(ob))
    ob = V(ob);
  return ((hval)ob >> TPOS & 63) == TBVEC;
}

void *
bvlst2ptr(word ob, uint *N)
{
  void *ret;
  if (bvecp(ob)) {
    *N = bvec_len(ob);
    ret = malloc(*N);
    memcpy(ret, (void*)ob+W, *N);
    return ret;
  } else { /* list */
    *N = llen((word*)ob);
    uint8_t *d = malloc(*N);
    list2data(ob, d, *N);
    return d;
  }
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
  case 108: VOID(SetWindowState(cnum(a)));
  case 109: VOID(ClearWindowState(cnum(a)));
  case 110: VOID(ToggleFullscreen());
  case 111: VOID(SetWindowIcon(DEREF(Image, a)));
  case 112: VOID(SetWindowTitle((char*)a+W));
  case 113: VOID(SetWindowPosition(cnum(a), cnum(b)));
  case 114: VOID(SetWindowMonitor(cnum(a)));
  case 115: VOID(SetWindowMinSize(cnum(a), cnum(b)));
  case 116: VOID(SetWindowSize(cnum(a), cnum(b)));
  case 117: return onum((intptr_t)GetWindowHandle(), 1);
  case 118: return onum(GetScreenWidth(), 1);
  case 119: return onum(GetScreenHeight(), 1);
  case 120: return onum(GetMonitorCount(), 1);
  case 121: return onum(GetMonitorWidth(cnum(a)), 1);
  case 122: return onum(GetMonitorHeight(cnum(a)), 1);
  case 123: return onum(GetMonitorPhysicalWidth(cnum(a)), 1);
  case 124: return onum(GetMonitorPhysicalHeight(cnum(a)), 1);
  case 125: return mkstring((void*)GetMonitorName(cnum(a)));
  case 126: return mkstring((void*)GetClipboardText());
  case 127: VOID(SetClipboardText((char*)a+W));
  case 128: VOID(ShowCursor());
  case 129: VOID(HideCursor());
  case 130: return BOOL(IsCursorHidden());
  case 131: VOID(EnableCursor());
  case 132: VOID(DisableCursor());
  case 133: return BOOL(IsCursorOnScreen());
  case 134: { /* make-color (r g b a) → color */
    short R = cnum(list_at(a, 0)), G = cnum(list_at(a, 1)),
      B = cnum(list_at(a, 2)), A = cnum(list_at(a, 3));
    return onum((uint32_t)(A<<24)|(B<<16)|(G<<8)|R, 4);
  }
  case 135: VOID(ClearBackground(v2color(a)));
  case 136: VOID(BeginDrawing());
  case 137: VOID(EndDrawing());
  case 138: rl_not_implemented("unreal");
  case 139: { /* offset target (rot zoom) a*/
    Camera2D cam = {0};
    cam.offset = list2vec(a);
    cam.target = list2vec(b);
    cam.rotation = cfloat(car(c));
    cam.zoom = cfloat(cadr(c));
    VOID(BeginMode2D(cam));
  }
  case 140: VOID(EndMode2D());
  case 141: case 142: case 143: case 144:
  case 145: case 146: case 147: case 148: case 149:
    rl_not_implemented("what are you even trying to do");
  case 150: VOID(SetTargetFPS(cnum(a)));
  case 151: return onum(GetFPS(), 1);
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
    rl_not_implemented(ColorFromHSV);
  case 157: {
    Color cl = Fade(v2color(cnum(a)), cfloat(b));
    return mkint(*(uint32_t*)&cl);
  }
  case 158: VOID(SetConfigFlags(cnum(a)));
  case 159: VOID(SetTraceLogLevel(cnum(a)));
  case 160: /* TODO: callback */
    rl_not_implemented(SetTraceLogCallback);
  case 161: /* TODO: variadic or just lisp-side string-append */
    rl_not_implemented(TraceLog);
  case 162: VOID(TakeScreenshot(cstr(a)));
  case 163: {
    FilePathList fpl = LoadDroppedFiles();
    word lst = INULL;
    uint i;
    for (i = 0; i < fpl.count; ++i)
      lst = cons(mkstring((void*)fpl.paths[i]), lst);

    UnloadDroppedFiles(fpl);
    return lst;
  }
  case 164: VOID(OpenURL(cstr(a)));
  case 165: return BOOL(IsKeyPressed(cnum(a)));
  case 166: return BOOL(IsKeyDown(cnum(a)));
  case 167: return BOOL(IsKeyReleased(cnum(a)));
  case 168: return BOOL(IsKeyUp(cnum(a)));
  case 169: if (cnum(a)) return onum(GetKeyPressed(), 1); else return onum(GetCharPressed(), 1);
  case 170: VOID(SetExitKey(cnum(a)));
  case 171: return BOOL(IsGamepadAvailable(cnum(a)));
  case 172: return mkstring((void*)GetGamepadName(cnum(a)));
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
  case 184: return onum(GetMouseX(), 1);
  case 185: return onum(GetMouseY(), 1);
  case 186: {
    vec pos = GetMousePosition();
    return cons(mkfloat(pos.x),
                cons(mkfloat(pos.y), INULL)); /* not a pair, so list2vec can be applied */
  }
  case 187: VOID(SetMousePosition(cnum(a), cnum(b)));
  case 188: VOID(SetMouseOffset(cnum(a), cnum(b)));
  case 189: VOID(SetMouseScale(cfloat(a), cfloat(b)));
  case 190: return mkfloat(GetMouseWheelMove());
  case 191: return onum(GetTouchX(), 1);
  case 192: return onum(GetTouchY(), 1);
  case 193: {
    vec pos = GetTouchPosition(cnum(a));
    return cons(onum(pos.x, 1), onum(pos.y, 1));
  }

  case 194: VOID(SetGesturesEnabled(cnum(a)));
  case 195: return BOOL(IsGestureDetected(cnum(a)));
  case 196: return onum(GetGestureDetected(), 1);
  case 197: return onum(GetTouchPointCount(), 1);
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

  case 203: case 204: case 205: case 206: case 207: case 208: rl_not_implemented("these numbers are imaginary");
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
    VOID(DrawCircleGradient(pos.x, pos.y, cfloat(b), v2color(car(c)), v2color(cadr(c))));
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
  case 230: VOID(DrawRectangleRoundedLines(list2rect(a),
                                           cfloat(gg(b, 1)),
                                           cnum(gg(b, 2)),
                                           v2color(c)));
  case 231: VOID(DrawTriangle(list2vec(gg(a, 1)), list2vec(gg(a, 2)), list2vec(gg(a, 3)), v2color(b)));
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


  case 237: return BOOL(CheckCollisionRecs(list2rect(a), list2rect(b)));
  case 238: return BOOL(CheckCollisionCircles(list2vec(car(a)), cfloat(cadr(a)), list2vec(car(b)), cfloat(cadr(b))));
  case 239: return BOOL(CheckCollisionCircleRec(list2vec(a), cfloat(b), list2rect(c)));
  case 240: {
    Rectangle r = GetCollisionRec(list2rect(a), list2rect(b));
    return cons(mkfloat(r.x),
                cons(mkfloat(r.y),
                     cons(mkfloat(r.width),
                          cons(mkfloat(r.height), INULL))));

  }
  case 241: return BOOL(CheckCollisionPointRec(list2vec(a), list2rect(b)));
  case 242: return BOOL(CheckCollisionPointCircle(list2vec(a), list2vec(b), cfloat(c)));
  case 243: return BOOL(CheckCollisionPointTriangle(list2vec(a),
                                                    list2vec(list_ref(b, 0)),
                                                    list2vec(list_ref(b, 1)),
                                                    list2vec(list_ref(b, 2))));
  case 244: {
    Image *i = malloc(sizeof(Image));
    *i = LoadImage(cstr(a));
    return PTR(i);
  }

  case 245: {
    Image *i = malloc(sizeof(Image));
    with_data(b, *i = LoadImageFromMemory(cstr(a), data, N));
    return PTR(i);
  }

  case 246: VOID(ExportImage(*(Image*)cptr(a), cstr(b)));
  case 247: {
    Texture2D *t = malloc(sizeof(Texture2D));
    *t = LoadTexture(cstr(a));
    return PTR(t);
  }

  case 248: {
    Texture2D *texture = malloc(sizeof(Texture2D));
    *texture = LoadTextureFromImage(*(Image*)cptr(a));
    return PTR(texture);
  }

  case 249: {
    TextureCubemap *t = malloc(sizeof(TextureCubemap));
    *t = LoadTextureCubemap(*(Image*)cptr(a), cnum(b));
    return PTR(t);
  }

  case 250: {
    UnloadImage(*(Image*)cptr(a));
    /* free(cptr(a)); */
  }

  case 251: {
    UnloadTexture(*(Texture2D*)cptr(a));
    /* free(cptr(a)); */
  }

  case 252: {
    UnloadRenderTexture(*(RenderTexture2D*)cptr(a));
    /* free(cptr(a)); */
  }

  case 253: {
    Image *i = malloc(sizeof(Image));
    *i = LoadImageFromScreen();
    return PTR(i);
  }

  case 254: VOID(DrawTextureV(DEREF(Texture2D, a), list2vec(b), v2color(c)));
  case 255: VOID(DrawTextureEx(DEREF(Texture2D, a), list2vec(b),
                               cfloat(list_at(c, 0)),
                               cfloat(list_at(c, 1)),
                               v2color(list_at(c, 2))));
  case 256: VOID(DrawTextureRec(DEREF(Texture2D, a), list2rect(b), list2vec(car(c)), v2color(cadr(c))));
  case 257: VOID(DrawTexturePro(DEREF(Texture2D, a), list2rect(car(b)),
                                list2rect(cadr(b)), list2vec(car(c)), cfloat(cadr(c)),
                                v2color(list_at(c, 2))));
  case 258: {
    Font *f = malloc(sizeof(Font));
    *f = GetFontDefault();
    return PTR(f);
  }
  case 259: {
    Font *f = malloc(sizeof(Font));
    *f = LoadFont(cstr(a));
    return PTR(f);
  }
  case 260: {
    Font *f = malloc(sizeof(Font));
    int n;
    *f = LoadFontEx(cstr(a), cnum(b), &n, cnum(c));
    return PTR(f);
  }
  case 261: {
    Font *f = malloc(sizeof(Font));
    *f = LoadFontFromImage(DEREF(Image, a), v2color(b), cnum(c));
    return PTR(f);
  }
  case 262: {
    UnloadFont(DEREF(Font, a));
    /* free(cptr(a)); */
    return ITRUE;
  }
  case 263: {
    Font *f = malloc(sizeof(Font));
    with_data(b, *f = LoadFontFromMemory(cstr(a), data, N, cnum(car(c)), NULL, cnum(cadr(c))));
    return PTR(f);
  }

  case 264: {
    vec pos = list2vec(a);
    VOID(DrawFPS(pos.x, pos.y));
  }

  case 265: {
    vec pos = list2vec(b);
    VOID(DrawText(cstr(a), pos.x, pos.y, cnum(car(c)), v2color(cadr(c))));
  }
  case 266:
    VOID(DrawTextEx(DEREF(Font, a), cstr(b), list2vec(car(c)), cfloat(cadr(c)),
                    cfloat(caddr(c)), v2color(cadddr(c))));
  case 267: return onum(MeasureText(cstr(a), cnum(b)), 1);
  case 268: {
    vec s = MeasureTextEx(DEREF(Font, a), cstr(b), cfloat(car(c)), cfloat(cadr(c)));
    return cons(onum(s.x, 1), onum(s.y, 1));
  }

  case 269: VOID(InitAudioDevice());
  case 270: VOID(CloseAudioDevice());
  case 271: return BOOL(IsAudioDeviceReady());
  case 272: VOID(SetMasterVolume(cfloat(a)));

  case 273: {
    Wave *w = malloc(sizeof(Wave));
    *w = LoadWave(cstr(a));
    return PTR(w);
  }
  case 274: {
    Sound *s = malloc(sizeof(Sound));
    *s = LoadSound(cstr(a));
    return PTR(s);
  }
  case 275: {
    Sound *s = malloc(sizeof(Sound));
    *s = LoadSoundFromWave(DEREF(Wave, a));
    return PTR(s);
  }
  case 276: VOID(UnloadWave(DEREF(Wave, a)));
  case 277: VOID(UnloadSound(DEREF(Sound, a)));
  case 278: VOID(ExportWave(DEREF(Wave, a), cstr(b)));

  case 279: VOID(PlaySound(DEREF(Sound, a)));
  case 280: VOID(PauseSound(DEREF(Sound, a)));
  case 281: VOID(ResumeSound(DEREF(Sound, a)));
  case 282: VOID(StopSound(DEREF(Sound, a)));

  case 283: return BOOL(IsSoundPlaying(DEREF(Sound, a)));
  case 284: VOID(SetSoundVolume(DEREF(Sound, a), cfloat(b)));
  case 285: VOID(SetSoundPitch(DEREF(Sound, a), cfloat(b)));
  case 286: VOID(WaveFormat(cptr(a), cnum(b), cnum(car(c)), cnum(cadr(c))))
  case 287: {
    Wave *w = malloc(sizeof(Wave));
    *w = WaveCopy(DEREF(Wave, a));
    return PTR(w);
  }
  case 288: VOID(WaveCrop(cptr(a), cnum(b), cnum(c)));

  case 289: {
    Music* m = malloc(sizeof(Music));
    *m = LoadMusicStream(cstr(a));
    return PTR(m);
  }
  case 290: VOID(UnloadMusicStream(DEREF(Music, a)));
  case 291: VOID(PlayMusicStream(DEREF(Music, a)));
  case 292: VOID(UpdateMusicStream(DEREF(Music, a)));
  case 293: VOID(StopMusicStream(DEREF(Music, a)));
  case 294: VOID(PauseMusicStream(DEREF(Music, a)));
  case 295: VOID(ResumeMusicStream(DEREF(Music, a)));
  case 296: return BOOL(IsMusicStreamPlaying(DEREF(Music, a)));
  case 297: VOID(SetMusicVolume(DEREF(Music, a), cfloat(b)))
  case 298: VOID(SetMusicPitch(DEREF(Music, a), cfloat(b)))
  case 299: return mkfloat(GetMusicTimeLength(DEREF(Music, a)));
  case 300: return mkfloat(GetMusicTimePlayed(DEREF(Music, a)));

  case 301: {
    Music *m = malloc(sizeof(Music));
    with_data(b, *m = LoadMusicStreamFromMemory(cstr(a), data, N));
    /* i don't know if i should free(d)
       TODO: look into LoadMusicStreamFromMemory if it copies *d */
    return PTR(m);
  }
  case 302: {
    Wave *w = malloc(sizeof(Wave));
    with_data(b, *w = LoadWaveFromMemory(cstr(a), data, N));
    return PTR(w);
  }

  case 303: {
    Vector2 m = GetMouseDelta();
    return cons(mkfloat(m.x), mkfloat(m.y));
  }

  case 304: VOID(SetTextureFilter(DEREF(Texture2D, a), cnum(b)));
  /* new api5 fixtures */
  case 305: return BOOL(IsWindowFullscreen());
  case 306: return BOOL(IsWindowHidden());
  case 307: return BOOL(IsWindowMaximized());
  case 308: return BOOL(IsWindowFocused());
  case 309: VOID(ToggleBorderlessWindowed());
  case 310: VOID(MaximizeWindow());
  case 311: VOID(MinimizeWindow());
  case 312: VOID(RestoreWindow());
  case 313: {
    // i have NOT tested that
    uint i, N = llen((word*)a);
    uintptr_t *d = malloc(N);
    Image *imgs = malloc(N*sizeof(Image));
    list2dataW(a, d, N);

    for (i = 0; i < N; ++i)
      imgs[i] = DEREF(Image, list_ref(a, i));

    SetWindowIcons(imgs, N);
    free(imgs);
    free(d);
  }
  case 314: VOID(SetWindowMaxSize(cnum(a), cnum(b)));
  case 315: VOID(SetWindowOpacity(cfloat(a)));
  case 316: VOID(SetWindowFocused());
  case 317: return onum(GetRenderWidth(), 1);
  case 318: return onum(GetRenderHeight(), 1);
  case 319: return onum(GetCurrentMonitor(), 1);
  case 320: return vec22list(GetMonitorPosition(cnum(a)));
  case 321: return onum(GetMonitorRefreshRate(cnum(a)), 1);
  case 322: return vec22list(GetWindowPosition());
  case 323: return vec22list(GetWindowScaleDPI());
  case 324: VOID(EnableEventWaiting());
  case 325: VOID(DisableEventWaiting());
  case 326: VOID(BeginScissorMode(cnum(car(a)), cnum(cdr(a)), cnum(car(b)), cnum(cdr(b))));
  case 327: VOID(EndScissorMode());
  case 328: VOID(SwapScreenBuffer());
  case 329: VOID(PollInputEvents());
  case 330: VOID(WaitTime(cnum(a)));
  case 331: VOID(SetRandomSeed(cnum(a)));
  case 332: return onum(GetRandomValue(cnum(a), cnum(b)), 1);
  case 333: {
    word l = INULL;
    uint n = cnum(a);
    int *vs = LoadRandomSequence(n, cnum(b), cnum(c));
    while (n--)
      l = cons(onum(vs[n], 1), l);

    UnloadRandomSequence(vs);
    return l;
  }
  case 334: VOID(SetMouseCursor(cnum(a)));
  case 335: IMGDO(GenImageColor(cnum(a), cnum(b), v2color(c)));
  case 336: IMGDO(GenImageGradientLinear(cnum(car(a)), cnum(cdr(b)),
                                         cnum(b), v2color(car(c)),
                                         v2color(cdr(c))));
  case 337: IMGDO(GenImageGradientRadial(cnum(car(a)), cnum(cdr(a)),
                    cfloat(b), v2color(car(c)), v2color(cdr(c))));
  case 338: IMGDO(GenImageGradientSquare(cnum(car(a)), cnum(cdr(a)),
                    cfloat(b), v2color(car(c)), v2color(cdr(c))));
  case 339: IMGDO(GenImageChecked(cnum(car(a)), cnum(cdr(a)),
                    cnum(car(b)), cnum(cdr(b)), v2color(car(c)),
                    v2color(cdr(c))));
  case 340: {
    Image *i = IMG();
    uint N;
    i->format = PIXELFORMAT_UNCOMPRESSED_R8G8B8A8;
    i->width = cnum(a);
    i->height = cnum(b);
    i->data = bvlst2ptr(c, &N);
    i->mipmaps = 1;

    if ((int)N != i->width*i->height*4) {
      free(i->data);
      TraceLog(LOG_ERROR, "invalid data for prim 340");
      return IFALSE;
    }

    return PTR(i);
  }

  case 341: SELF(a, ImageFormat(cptr(a), cnum(b)));
  case 342: SELF(a, ImageToPOT(cptr(a), v2color(b)));
  case 343: SELF(a, ImageAlphaCrop(cptr(a), cfloat(b)));
  case 344: SELF(a, ImageAlphaClear(cptr(a), v2color(b), cfloat(c)));
  case 345: SELF(a, ImageAlphaMask(cptr(a), DEREF(Image, b)));
  case 346: SELF(a, ImageAlphaPremultiply(cptr(a)));
  case 347: SELF(a, ImageBlurGaussian(cptr(a), cnum(b)));
  case 348: SELF(a, ImageResize(cptr(a), cnum(b), cnum(c)));
  case 349: SELF(a, ImageResizeNN(cptr(a), cnum(b), cnum(c)));
  case 350: SELF(a, ImageMipmaps(cptr(a)));
  case 351: SELF(a, ImageDither(cptr(a), cnum(car(b)), cnum(cdr(b)), cnum(car(c)), cnum(cdr(c))));
  case 352: SELF(a, ImageFlipVertical(cptr(a)));
  case 353: SELF(a, ImageFlipHorizontal(cptr(a)));
  case 354: SELF(a, ImageRotate(cptr(a), cnum(b)));
  case 355: SELF(a, ImageRotateCW(cptr(a)));
  case 356: SELF(a, ImageRotateCCW(cptr(a)));
  case 357: SELF(a, ImageColorTint(cptr(a), v2color(b)));
  case 358: SELF(a, ImageColorInvert(cptr(a)));
  case 359: SELF(a, ImageColorGrayscale(cptr(a)));
  case 360: SELF(a, ImageColorContrast(cptr(a), cfloat(b)));
  case 361: SELF(a, ImageColorBrightness(cptr(a), cnum(b)));
  case 362: SELF(a, ImageColorReplace(cptr(a), v2color(b), v2color(c)));
  case 363: {
    word l = INULL;
    Image i = DEREF(Image, a);
    Color *c = LoadImageColors(i);
    int n = i.width * i.height;
    while (n--)
      l = cons(color2lst(c[n]), l);

    UnloadImageColors(c);

    return l;
  };
  case 364: {
    int n;
    word l = INULL;
    Color *c = LoadImagePalette(DEREF(Image, a), cnum(b), &n);
    while (n--)
      l = cons(color2lst(c[n]), l);

    UnloadImagePalette(c);

    return l;
  };

  /*-- raymath --*/
  case 500: return mkfloat(Clamp(cfloat(a), cfloat(b), cfloat(c)));
  case 501: return mkfloat(Lerp(cfloat(a), cfloat(b), cfloat(c)));
  case 502: return mkfloat(Normalize(cfloat(a), cfloat(b), cfloat(c)));
  case 503: return mkfloat(Remap(cfloat(a), cfloat(b), cfloat(car(c)), cfloat(cadr(c)), cfloat(caddr(c))));
  case 504: return mkfloat(Wrap(cfloat(a), cfloat(b), cfloat(c)));

  case 505: Vec22listH(Vector2Zero());
  case 506: Vec22listH(Vector2One());
  case 507: Vec22listH(Vector2Add(list2vec(a), list2vec(b)));
  case 508: Vec22listH(Vector2AddValue(list2vec(a), cfloat(b)));
  case 509: Vec22listH(Vector2Subtract(list2vec(a), list2vec(b)));
  case 510: Vec22listH(Vector2SubtractValue(list2vec(a), cfloat(b)));
  case 511: return mkfloat(Vector2Length(list2vec(a)));
  case 512: return mkfloat(Vector2LengthSqr(list2vec(a)));
  case 513: return mkfloat(Vector2DotProduct(list2vec(a), list2vec(b)));
  case 514: return mkfloat(Vector2Distance(list2vec(a), list2vec(b)));
  case 515: return mkfloat(Vector2DistanceSqr(list2vec(a), list2vec(b)));
  case 516: return mkfloat(Vector2Angle(list2vec(a), list2vec(b)));
  case 517: return mkfloat(Vector2LineAngle(list2vec(a), list2vec(b)));
  case 518: Vec22listH(Vector2Scale(list2vec(a), cfloat(b)));
  case 519: Vec22listH(Vector2Multiply(list2vec(a), list2vec(b)));
  case 520: Vec22listH(Vector2Negate(list2vec(a)));
  case 521: Vec22listH(Vector2Divide(list2vec(a), list2vec(b)));
  case 522: Vec22listH(Vector2Normalize(list2vec(a)));
  /* case 523: Vec22listH(Vector2Transform(Vector2 v, Matrix mat)); */
  case 524: Vec22listH(Vector2Lerp(list2vec(a), list2vec(b), cfloat(c)));
  case 525: Vec22listH(Vector2Reflect(list2vec(a), list2vec(b)));
  case 526: Vec22listH(Vector2Min(list2vec(a), list2vec(b)));
  case 527: Vec22listH(Vector2Max(list2vec(a), list2vec(b)));
  case 528: Vec22listH(Vector2Rotate(list2vec(a), cfloat(b)));
  case 529: Vec22listH(Vector2MoveTowards(list2vec(a), list2vec(b), cfloat(c)));
  case 530: Vec22listH(Vector2Invert(list2vec(a)));
  case 531: Vec22listH(Vector2Clamp(list2vec(a), list2vec(b), list2vec(c)));
  case 532: Vec22listH(Vector2ClampValue(list2vec(a), cfloat(b), cfloat(c)));
  case 533: return BOOL(Vector2Equals(list2vec(a), list2vec(b)));
  case 534: Vec22listH(Vector2Refract(list2vec(a), list2vec(b), cfloat(c)));
  }

  return IFALSE;
}

#undef PRIM_FP_API // shits fucked
