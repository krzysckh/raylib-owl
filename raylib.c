#include <stdio.h>
#include <stdlib.h>
#include <raylib.h>

#include "ovm.h"

#define cfloat(x) (is_type(x,TRAT)?((float)cnum(x)/(float)cnum(x+W)):   \
                   ((is_type(x,TNUM)?(cnum((x)+W)):                     \
                     ((float)(cnum(car(x)))/(float)cnum(cdr(x))))))

#define v2color(a) (*(Color*)(uint32_t[]){cnum(a)})
#define VOID(exp) {exp; return ITRUE;}
#define list2vec2(t) ((Vector2){cfloat(car(t)), cfloat(cadr(t))})
#define list2vec3(t) ((Vector3){cfloat(car(t)), cfloat(cadr(t)), cfloat(caddr(t))})
#define list2vec list2vec2
#define vec2 Vector2
#define vec3 Vector3
#define vec vec2
#define gg(a, b) list_at(a, b-1)
#define PTR(t) onum((intptr_t)t, 0)
#define cptr(v) ((void*)(intptr_t)cnum(v))

#define list_ref list_at
#define list2rect(t) ((Rectangle){cfloat(list_at(t, 0)), cfloat(list_at(t, 1)), \
                                  cfloat(list_at(t, 2)), cfloat(list_at(t, 3))})
#define DEREF(T, v) (*(T*)cptr(v))

#define not_implemented(f) \
  fprintf(stderr, "not-implemented %s (opcode %d)\n", #f, op);   \
  abort(); \
  return IFALSE;

#define car(l) G(l, 1)
#define cdr(l) G(l, 2)
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
  case 125: return mkstring((char*)GetMonitorName(cnum(a)));
  case 126: return mkstring((char*)GetClipboardText());
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
  case 138: { /* make-camera2d (offset-x . offset-y) (targ-x . targ-y) (rot . zoom) */
    not_implemented(Camera2D);
    /* Camera2D *cd = malloc(sizeof(Camera2D)); */
    /* cd->offset = (Vector2){ cnum(a), cnum(a+W) }; */
    /* cd->target = (Vector2){ cnum(b), cnum(b+W) }; */
    /* cd->rotation = cnum(c); */
    /* cd->zoom = cnum(c+W); */
    /* return onum((uint64_t)cd, 0); */
  }
  case 139:
    /* BeginMode2D(*(Camera2D*)cnum(a)); */
    not_implemented(Camera2D);
    return ITRUE;
  case 140:
    not_implemented(Camera2D);
    /* EndMode2D(); */
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
    not_implemented(ColorFromHSV);
  case 157: {
    Color cl = Fade(v2color(cnum(a)), cfloat(b));
    return mkint(*(uint32_t*)&cl);
  }
  case 158: VOID(SetConfigFlags(cnum(a)));
  case 159: VOID(SetTraceLogLevel(cnum(a)));
  case 160: /* TODO: callback */
    not_implemented(SetTraceLogCallback);
  case 161: /* TODO: variadic or just lisp-side string-append */
    not_implemented(TraceLog);
  case 162: VOID(TakeScreenshot(cstr(a)));
  case 163: {
    FilePathList fpl = LoadDroppedFiles();
    word lst = INULL;
    uint i;
    for (i = 0; i < fpl.count; ++i)
      lst = cons(mkstring(fpl.paths[i]), lst);

    UnloadDroppedFiles(fpl);
    return lst;
  }
  case 164: VOID(OpenURL(cstr(a)));
  case 165: return BOOL(IsKeyPressed(cnum(a)));
  case 166: return BOOL(IsKeyDown(cnum(a)));
  case 167: return BOOL(IsKeyReleased(cnum(a)));
  case 168: return BOOL(IsKeyUp(cnum(a)));
  case 169: return onum(GetKeyPressed(), 1);
  case 170: VOID(SetExitKey(cnum(a)));
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
    int N = cnum(c);
    Image *i = malloc(sizeof(Image));
    unsigned char *d = malloc(N);
    list2data(b, d, N);
    *i = LoadImageFromMemory(cstr(a), d, N);
    free(d);
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
    int N = llen((word*)b);
    unsigned char *d = malloc(N);
    list2data(b, d, N);
    *f = LoadFontFromMemory(cstr(a), d, N, cnum(car(c)), NULL, cnum(cadr(c)));
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
    uint N = llen((word*)b);
    unsigned char *d = malloc(N);
    list2data(b, d, N);
    *m = LoadMusicStreamFromMemory(cstr(a), d, N);
    /* i don't know if i should free(d)
       TODO: look into LoadMusicStreamFromMemory if it copies *d */
    return PTR(m);
  }
  case 302: {
    Wave *w = malloc(sizeof(Wave));
    uint N = llen((word*)b);
    unsigned char *d = malloc(N);
    list2data(b, d, N);
    *w = LoadWaveFromMemory(cstr(a), d, N);
    /* i don't know if i should free(d)
       TODO: look into LoadMusicStreamFromMemory if it copies *d */
    return PTR(w);
  }

  }

  return IFALSE;
}
