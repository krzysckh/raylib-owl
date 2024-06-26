## Window-related functions
* [x] void InitWindow(int width, int height, const char *title)
* [x] bool WindowShouldClose(void)
* [x] void CloseWindow(void)
* [x] bool IsWindowReady(void)
* [x] bool IsWindowMinimized(void)
* [x] bool IsWindowResized(void)

* [x] bool IsWindowState(unsigned int flag)
* [x] void SetWindowState(unsigned int flags)
* [x] void ClearWindowState(unsigned int flags)
* [x] void ToggleFullscreen(void)
* [x] void SetWindowIcon(Image image)
* [x] void SetWindowTitle(const char *title)
* [x] void SetWindowPosition(int x, int y)
* [x] void SetWindowMonitor(int monitor)
* [x] void SetWindowMinSize(int width, int height)
* [x] void SetWindowSize(int width, int height)
* [x] void *GetWindowHandle(void)
* [x] int GetScreenWidth(void)
* [x] int GetScreenHeight(void)
* [x] int GetMonitorCount(void)
* [x] int GetMonitorWidth(int monitor)
* [x] int GetMonitorHeight(int monitor)
* [x] int GetMonitorPhysicalWidth(int monitor)
* [x] int GetMonitorPhysicalHeight(int monitor)
* [x] const char *GetMonitorName(int monitor)
* [x] const char *GetClipboardText(void)
* [x] void SetClipboardText(const char *text)

128+
## Cursor-related functions
* [x] void ShowCursor(void)
* [x] void HideCursor(void)
* [x] bool IsCursorHidden(void)
* [x] void EnableCursor(void)
* [x] void DisableCursor(void)
* [x] bool IsCursorOnScreen(void)

* [x] make-color

135+
## Drawing-related functions
* [x] void ClearBackground(Color color)
* [x] void BeginDrawing(void)
* [x] void EndDrawing(void)
* [ ] make-camera2d
* [ ] void BeginMode2D(Camera2D camera)
* [ ] void EndMode2D(void)
* [ ] make-camera3d
* [ ] void BeginMode3D(Camera3D camera)
* [ ] void EndMode3D(void)
* [ ] make-rendertexture2d
* [ ] void BeginTextureMode(RenderTexture2D target)
* [ ] void EndTextureMode(void)

## Screen-space-related functions
* [ ] Ray GetMouseRay(Vector2 mousePosition, Camera camera)
* [ ] Vector2 GetWorldToScreen(Vector3 position, Camera camera)
* [ ] Matrix GetCameraMatrix(Camera camera)

## Timing-related functions
* [x] void SetTargetFPS(int fps)
* [x] int GetFPS(void)
* [x] float GetFrameTime(void)
* [x] double GetTime(void)

154+
## Color-related functions
* [x] Vector4 ColorNormalize(Color color)
* [x] Vector3 ColorToHSV(Color color)
* [ ] Color ColorFromHSV(Vector3 hsv)
* [x] Color Fade(Color color, float alpha)

158+
## Misc. functions
* [x] void SetConfigFlags(unsigned int flags)
* [x] void SetTraceLogLevel(int logType)
* [ ] void SetTraceLogCallback(TraceLogCallback callback)
* [ ] void TraceLog(int logType, const char *text, ...)
* [x] void TakeScreenshot(const char *fileName)

163+
## Files management functions
* [x] FilePathList LoadDroppedFiles()
* [x] void UnloadDroppedFiles(void)
* [x] void OpenURL(const char *url)


# Input Handling Functions


165+
## Input-related functions: keyboard
* [x] bool IsKeyPressed(int key)
* [x] bool IsKeyDown(int key)
* [x] bool IsKeyReleased(int key)
* [x] bool IsKeyUp(int key)
* [x] int GetKeyPressed(void)
* [x] void SetExitKey(int key)

171+
## Input-related functions: gamepads
* [x] bool IsGamepadAvailable(int gamepad)
* [x] const char *GetGamepadName(int gamepad)
* [x] bool IsGamepadButtonPressed(int gamepad, int button)
* [x] bool IsGamepadButtonDown(int gamepad, int button)
* [x] bool IsGamepadButtonReleased(int gamepad, int button)
* [x] bool IsGamepadButtonUp(int gamepad, int button)
* [x] int GetGamepadButtonPressed(void)
* [x] int GetGamepadAxisCount(int gamepad)
* [x] float GetGamepadAxisMovement(int gamepad, int axis)

180+
## Input-related functions: mouse
* [x] bool IsMouseButtonPressed(int button)
* [x] bool IsMouseButtonDown(int button)
* [x] bool IsMouseButtonReleased(int button)
* [x] bool IsMouseButtonUp(int button)
* [x] int GetMouseX(void)
* [x] int GetMouseY(void)
* [x] Vector2 GetMousePosition(void)
* [x] void SetMousePosition(int x, int y)
* [x] void SetMouseOffset(int offsetX, int offsetY)
* [x] void SetMouseScale(float scaleX, float scaleY)
* [x] float GetMouseWheelMove(void)

191+
## Input-related functions: touch
* [x] int GetTouchX(void)
* [x] int GetTouchY(void)
* [x] Vector2 GetTouchPosition(int index)


## Gestures and Touch Handling Functions (Module: gestures)
194+
* [x] void SetGesturesEnabled(unsigned int gestureFlags)
* [x] bool IsGestureDetected(int gesture)
* [x] int GetGestureDetected(void)
* [x] int GetTouchPointsCount(void)
* [x] float GetGestureHoldDuration(void)
* [x] Vector2 GetGestureDragVector(void)
* [x] float GetGestureDragAngle(void)
* [x] Vector2 GetGesturePinchVector(void)
* [x] float GetGesturePinchAngle(void)


## Camera System Functions (Module: camera)

203+
* [ ] void SetCameraMode(Camera camera, int mode)
* [ ] void UpdateCamera(Camera *camera)
* [ ] void SetCameraPanControl(int panKey)
* [ ] void SetCameraAltControl(int altKey)
* [ ] void SetCameraSmoothZoomControl(int szKey)
* [ ] void SetCameraMoveControls(int frontKey, int backKey,
                            int rightKey, int leftKey,
                            int upKey, int downKey)

209+
## Basic shapes drawing functions
* [x] void DrawPixel(int posX, int posY, Color color)
* [x] void DrawPixelV(Vector2 position, Color color)
* [x] void DrawLineV(Vector2 startPos, Vector2 endPos, Color color)
* [x] void DrawLineEx(Vector2 startPos, Vector2 endPos, float thick, Color color)
* [x] void DrawLineBezier(Vector2 startPos, Vector2 endPos, float thick, Color color)
* [x] void DrawLineStrip(Vector2 *points, int numPoints, Color color)
* [x] void DrawCircleSector(Vector2 center, float radius, int startAngle, int endAngle, int segments, Color color)
* [x] void DrawCircleSectorLines(Vector2 center, float radius, int startAngle, int endAngle, int segments, Color color)
* [x] void DrawCircleGradient(int centerX, int centerY, float radius, Color color1, Color color2)
* [x] void DrawCircleV(Vector2 center, float radius, Color color)
* [x] void DrawCircleLines(int centerX, int centerY, float radius, Color color)
* [x] void DrawRing(Vector2 center, float innerRadius, float outerRadius, int startAngle, int endAngle, int segments, Color color)
* [x] void DrawRingLines(Vector2 center, float innerRadius, float outerRadius, int startAngle, int endAngle, int segments, Color color)
* [x] void DrawRectangleV(Vector2 position, Vector2 size, Color color)
* [x] void DrawRectangleRec(Rectangle rec, Color color)
* [x] void DrawRectanglePro(Rectangle rec, Vector2 origin, float rotation, Color color)
* [x] void DrawRectangleGradientV(int posX, int posY, int width, int height, Color color1, Color color2)
* [x] void DrawRectangleGradientH(int posX, int posY, int width, int height, Color color1, Color color2)
* [x] void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4)
* [x] void DrawRectangleLines(int posX, int posY, int width, int height, Color color)
* [x] void DrawRectangleLinesEx(Rectangle rec, int lineThick, Color color)
* [x] void DrawRectangleRounded(Rectangle rec, float roundness, int segments, Color color)
* [x] void DrawRectangleRoundedLines(Rectangle rec, float roundness, int segments, int lineThick, Color color)
* [x] void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color)
* [x] void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color)
* [x] void DrawTriangleFan(Vector2 *points, int numPoints, Color color)
* [x] void DrawTriangleStrip(Vector2 *points, int numPoints, Color color)
* [x] void DrawPoly(Vector2 center, int sides, float radius, float rotation, Color color)
* [ ] void SetShapesTexture(Texture2D texture, Rectangle source)

237+
## Basic shapes collision detection functions
* [x] bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2)
* [x] bool CheckCollisionCircles(Vector2 center1, float radius1, Vector2 center2, float radius2)
* [x] bool CheckCollisionCircleRec(Vector2 center, float radius, Rectangle rec)
* [x] Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2)
* [x] bool CheckCollisionPointRec(Vector2 point, Rectangle rec)
* [x] bool CheckCollisionPointCircle(Vector2 point, Vector2 center, float radius)
* [x] bool CheckCollisionPointTriangle(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3)

244+
## Image/Texture2D data loading/unloading/saving functions
* [x] Image LoadImage(const char *fileName)
* [x] Image LoadImageFromMemory(const char *fileType, const unsigned char *fileData, int dataSize)
* [x] void ExportImage(Image image, const char *fileName)
* [x] Texture2D LoadTexture(const char *fileName)
* [x] Texture2D LoadTextureFromImage(Image image)
* [x] TextureCubemap LoadTextureCubemap(Image image, int layoutType)
* [x] void UnloadImage(Image image)
* [x] void UnloadTexture(Texture2D texture)
* [x] void UnloadRenderTexture(RenderTexture2D target)
* [x] Image LoadImageFromScreen(void)

TODO: this
## Image manipulation functions
* [ ] Image ImageCopy(Image image)
* [ ] void ImageToPOT(Image *image, Color fillColor)
* [ ] void ImageFormat(Image *image, int newFormat)
* [ ] void ImageAlphaMask(Image *image, Image alphaMask)
* [ ] void ImageAlphaClear(Image *image, Color color, float threshold)
* [ ] void ImageAlphaCrop(Image *image, float threshold)
* [ ] void ImageAlphaPremultiply(Image *image)
* [ ] void ImageCrop(Image *image, Rectangle crop)
* [ ] void ImageResize(Image *image, int newWidth, int newHeight)
* [ ] void ImageResizeNN(Image *image, int newWidth,int newHeight)
* [ ] void ImageResizeCanvas(Image *image, int newWidth, int newHeight, int offsetX, int offsetY, Color color)
* [ ] void ImageMipmaps(Image *image)
* [ ] void ImageDither(Image *image, int rBpp, int gBpp, int bBpp, int aBpp)
* [ ] Color *ImageExtractPalette(Image image, int maxPaletteSize, int *extractCount)
* [ ] Image ImageText(const char *text, int fontSize, Color color)
* [ ] Image ImageTextEx(Font font, const char *text, float fontSize, float spacing, Color tint)
* [ ] void ImageDraw(Image *dst, Image src, Rectangle srcRec, Rectangle dstRec)
* [ ] void ImageDrawRectangleRec(Image *dst, Rectangle rec, Color color)
* [ ] void ImageDrawRectangleLines(Image *dst, Rectangle rec, int thick, Color color)
* [ ] void ImageDrawText(Image *dst, Vector2 position, const char *text, int fontSize, Color color)
* [ ] void ImageDrawTextEx(Image *dst, Vector2 position, Font font, const char *text, float fontSize, float spacing, Color color)
* [ ] void ImageFlipVertical(Image *image)
* [ ] void ImageFlipHorizontal(Image *image)
* [ ] void ImageRotateCW(Image *image)
* [ ] void ImageRotateCCW(Image *image)
* [ ] void ImageColorTint(Image *image, Color color)
* [ ] void ImageColorInvert(Image *image)
* [ ] void ImageColorGrayscale(Image *image)
* [ ] void ImageColorContrast(Image *image, float contrast)
* [ ] void ImageColorBrightness(Image *image, int brightness)
* [ ] void ImageColorReplace(Image *image, Color color, Color replace)

TODO: this
## Image generation functions
* [ ] Image GenImageColor(int width, int height, Color color)
* [ ] Image GenImageGradientLinear(int width, int height, int direction, Color start, Color end)
* [ ] Image GenImageGradientRadial(int width, int height, float density, Color inner, Color outer)
* [ ] Image GenImageGradientSquare(int width, int height, float density, Color inner, Color outer)
* [ ] Image GenImageChecked(int width, int height, int checksX, int checksY, Color col1, Color col2)
* [ ] Image GenImageWhiteNoise(int width, int height, float factor)
* [ ] Image GenImagePerlinNoise(int width, int height, int offsetX, int offsetY, float scale)
* [ ] Image GenImageCellular(int width, int height, int tileSize)

TODO: this
## Texture2D configuration functions
* [ ] void GenTextureMipmaps(Texture2D *texture)
* [ ] void SetTextureFilter(Texture2D texture, int filterMode)
* [ ] void SetTextureWrap(Texture2D texture, int wrapMode)

254+
## Texture2D drawing functions
* [x] void DrawTextureV(Texture2D texture, Vector2 position, Color tint)
* [x] void DrawTextureEx(Texture2D texture, Vector2 position, float rotation, float scale, Color tint)
* [x] void DrawTextureRec(Texture2D texture, Rectangle sourceRec, Vector2 position, Color tint)
* [x] void DrawTexturePro(Texture2D texture, Rectangle sourceRec, Rectangle destRec, Vector2 origin, float rotation, Color tint)

258+
## Font loading/unloading functions
* [x] Font GetFontDefault(void)
* [x] Font LoadFont(const char *fileName)
* [x] Font LoadFontEx(const char *fileName, int fontSize, int *fontChars, int charsCount)
* [x] Font LoadFontFromImage(Image image, Color key, int firstChar)
* [x] void UnloadFont(Font font)
* [x] Font LoadFontFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, int *codepoints, int codepointCount);

264+
## Text drawing functions
* [x] void DrawFPS(int posX, int posY)
* [x] void DrawText(const char *text, int posX, int posY, int fontSize, Color color)
* [x] void DrawTextEx(Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint)

## Text misc. functions
* [x] int MeasureText(const char *text, int fontSize)
* [x] Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing)

TODO: this
## Basic geometric 3D shapes drawing functions
* [ ] void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color)
* [ ] void DrawCircle3D(Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color)
* [ ] void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color)
* [ ] void DrawTriangleStrip3D(Vector3 *points, int pointCount, Color color)
* [ ] void DrawCube(Vector3 position, float width, float height, float length, Color color)
* [ ] void DrawCubeV(Vector3 position, Vector3 size, Color color)
* [ ] void DrawCubeWires(Vector3 position, float width, float height, float length, Color color)
* [ ] void DrawCubeWiresV(Vector3 position, Vector3 size, Color color)
* [ ] void DrawCubeTexture(Texture2D texture, Vector3 position, float width, float height, float length, Color color)
* [ ] void DrawSphere(Vector3 centerPos, float radius, Color color)
* [ ] void DrawSphereEx(Vector3 centerPos, float radius, int rings, int slices, Color color)
* [ ] void DrawSphereWires(Vector3 centerPos, float radius, int rings, int slices, Color color)
* [ ] void DrawCylinder(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color)
* [ ] void DrawCylinderEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color)
* [ ] void DrawCylinderWires(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color)
* [ ] void DrawCylinderWiresEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color)
* [ ] void DrawPlane(Vector3 centerPos, Vector2 size, Color color)
* [ ] void DrawRay(Ray ray, Color color)
* [ ] void DrawGrid(int slices, float spacing)

## Model loading/unloading functions
* [ ] Model LoadModel(const char *fileName)
* [ ] Model LoadModelFromMesh(Mesh mesh)
* [ ] void UnloadModel(Model model)
* [ ] BoundingBox GetModelBoundingBox(Model model)

## Mesh loading/unloading functions
* [ ] void ExportMesh(Mesh mesh, const char *fileName)
* [ ] void UploadMesh(Mesh *mesh, bool dynamic)
* [ ] void UnloadMesh(Mesh *mesh)
* [ ] void DrawMesh(Mesh mesh, Material material, Matrix transform)
* [ ] void DrawMeshInstanced(Mesh mesh, Material material, const Matrix *transforms, int instances)

## Material loading/unloading functions
* [ ] Material *LoadMaterials(const char *fileName, int *materialCount)
* [ ] Material LoadMaterialDefault(void)
* [ ] void UnloadMaterial(Material material)
* [ ] void SetMaterialTexture(Material *material, int mapType, Texture2D texture)
* [ ] void SetModelMeshMaterial(Model *model, int meshId, int materialId)

## Model animations loading/unloading functions
* [ ] ModelAnimation *LoadModelAnimations(const char *fileName, int *animsCount)
* [ ] void UpdateModelAnimation(Model model, ModelAnimation anim, int frame)
* [ ] void UnloadModelAnimation(ModelAnimation anim)
* [ ] void UnloadModelAnimations(ModelAnimation *animations, unsigned int count)
* [ ] bool IsModelAnimationValid(Model model, ModelAnimation anim)

## Mesh generation functions
* [ ] Mesh GenMeshPoly(int sides, float radius)
* [ ] Mesh GenMeshPlane(float width, float length, int resX, int resZ)
* [ ] Mesh GenMeshCube(float width, float height, float length)
* [ ] Mesh GenMeshSphere(float radius, int rings, int slices)
* [ ] Mesh GenMeshHemiSphere(float radius, int rings, int slices)
* [ ] Mesh GenMeshCylinder(float radius, float height, int slices)
* [ ] Mesh GenMeshTorus(float radius, float size, int radSeg, int sides)
* [ ] Mesh GenMeshKnot(float radius, float size, int radSeg, int sides)
* [ ] Mesh GenMeshHeightmap(Image heightmap, Vector3 size)
* [ ] Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize)

## Mesh manipulation functions
* [ ] BoundingBox GetMeshBoundingBox(Mesh mesh)
* [ ] void GenMeshTangents(Mesh *mesh)
* [ ] void GenMeshBinormals(Mesh *mesh)

## Model drawing functions
* [ ] void DrawModel(Model model, Vector3 position, float scale, Color tint)
* [ ] void DrawModelEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint)
* [ ] void DrawModelWires(Model model, Vector3 position, float scale, Color tint)
* [ ] void DrawModelWiresEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint)
* [ ] void DrawBoundingBox(BoundingBox box, Color color)
* [ ] void DrawBillboard(Camera camera, Texture2D texture, Vector3 center, float size, Color tint)
* [ ] void DrawBillboardRec(Camera camera, Texture2D texture, Rectangle sourceRec, Vector3 center, float size, Color tint)
* [ ] void DrawBillboardPro(Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint)

## Collision detection functions
* [ ] bool CheckCollisionSpheres(Vector3 centerA, float radiusA, Vector3 centerB, float radiusB)
* [ ] bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2)
* [ ] bool CheckCollisionBoxSphere(BoundingBox box, Vector3 centerSphere, float radiusSphere)
* [ ] RayCollision GetRayCollisionSphere(Ray ray, Vector3 spherePosition, float sphereRadius)
* [ ] RayCollision GetRayCollisionBox(Ray ray, BoundingBox box)
* [ ] RayCollision GetRayCollisionMesh(Ray ray, Mesh mesh, Matrix transform)
* [ ] RayCollision GetRayCollisionTriangle(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3)
* [ ] RayCollision GetRayCollisionModel(Ray ray, Model *model)
* [ ] RayCollision GetRayCollisionQuad(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4)

## Shader loading/unloading functions
* [ ] char *LoadText(const char *fileName)
* [ ] Shader LoadShader(const char *vsFileName, const char *fsFileName)
* [ ] Shader LoadShaderCode(char *vsCode, char *fsCode)
* [ ] void UnloadShader(Shader shader)
* [ ] Shader GetShaderDefault(void)
* [ ] Texture2D GetTextureDefault(void)

## Shader configuration functions
* [ ] int GetShaderLocation(Shader shader, const char *uniformName)
* [ ] void SetShaderValue(Shader shader, int uniformLoc, const void *value, int uniformType)
* [ ] void SetShaderValueV(Shader shader, int uniformLoc, const void *value, int uniformType, int count)
* [ ] void SetShaderValueMatrix(Shader shader, int uniformLoc, Matrix mat)
* [ ] void SetShaderValueTexture(Shader shader, int uniformLoc, Texture2D texture)
* [ ] void SetMatrixProjection(Matrix proj)
* [ ] void SetMatrixModelview(Matrix view)
* [ ] Matrix GetMatrixModelview()

## Shading begin/end functions
* [ ] void BeginShaderMode(Shader shader)
* [ ] void EndShaderMode(void)
* [ ] void BeginBlendMode(int mode)
* [ ] void EndBlendMode(void)
* [ ] void BeginScissorMode(int x, int y, int width, int height)
* [ ] void EndScissorMode(void)

## VR control functions
* [ ] void InitVrSimulator(void)
* [ ] void CloseVrSimulator(void)
* [ ] void UpdateVrTracking(Camera *camera)
* [ ] void SetVrConfiguration(VrDeviceInfo info, Shader distortion)
* [ ] bool IsVrSimulatorReady(void)
* [ ] void ToggleVrMode(void)
* [ ] void BeginVrDrawing(void)
* [ ] void EndVrDrawing(void)

269+
## Audio device management functions
* [x] void InitAudioDevice(void)
* [x] void CloseAudioDevice(void)
* [x] bool IsAudioDeviceReady(void)
* [x] void SetMasterVolume(float volume)

273+
## Wave/Sound loading/unloading functions
* [x] Wave LoadWave(const char *fileName)
* [x] Sound LoadSound(const char *fileName)
* [x] Sound LoadSoundFromWave(Wave wave)
* [x] void UnloadWave(Wave wave)
* [x] void UnloadSound(Sound sound)
* [x] void ExportWave(Wave wave, const char *fileName)

279+
## Wave/Sound management functions
* [x] void PlaySound(Sound sound)
* [x] void PauseSound(Sound sound)
* [x] void ResumeSound(Sound sound)
* [x] void StopSound(Sound sound)
* [x] bool IsSoundPlaying(Sound sound)
* [x] void SetSoundVolume(Sound sound, float volume)
* [x] void SetSoundPitch(Sound sound, float pitch)
* [x] void WaveFormat(Wave *wave, int sampleRate, int sampleSize, int channels)
* [x] Wave WaveCopy(Wave wave)
* [x] void WaveCrop(Wave *wave, int initSample, int finalSample)

289+
## Music management functions
* [x] Music LoadMusicStream(const char *fileName)
* [x] void UnloadMusicStream(Music music)
* [x] void PlayMusicStream(Music music)
* [x] void UpdateMusicStream(Music music)
* [x] void StopMusicStream(Music music)
* [x] void PauseMusicStream(Music music)
* [x] void ResumeMusicStream(Music music)
* [x] bool IsMusicStreamPlaying(Music music)
* [x] void SetMusicVolume(Music music, float volume)
* [x] void SetMusicPitch(Music music, float pitch)
* [x] float GetMusicTimeLength(Music music)
* [x] float GetMusicTimePlayed(Music music)

301+
## stuff
* [ ] Music LoadMusicStreamFromMemory(const char *fileType, const unsigned char *data, int dataSize);
* [ ] Wave LoadWaveFromMemory(const char *fileType, const unsigned char *fileData, int dataSize);

## AudioStream management functions
* [ ] AudioStream InitAudioStream(unsigned int sampleRate, unsigned int sampleSize, unsigned int channels)
* [ ] void UpdateAudioStream(AudioStream stream, const void *data, int samplesCount)
* [ ] void CloseAudioStream(AudioStream stream)
* [ ] bool IsAudioStreamProcessed(AudioStream stream)
* [ ] void PlayAudioStream(AudioStream stream)
* [ ] void PauseAudioStream(AudioStream stream)
* [ ] void ResumeAudioStream(AudioStream stream)
* [ ] bool IsAudioStreamPlaying(AudioStream stream)
* [ ] void StopAudioStream(AudioStream stream)
* [ ] void SetAudioStreamVolume(AudioStream stream, float volume)
* [ ] void SetAudioStreamPitch(AudioStream stream, float pitch)
