# Experimental!
# Raylib Bindings

┌─╴Lib
  Path ← memo(
    $"bin/raylib_" ⍣(
      "_win32.dll" °{"windows" "x86"}
    | "_win64.dll" °{"windows" "x86_64"}
    | ⍩⍤"Unsupported architecture." ⋅0 °{"windows" ∘}
    | ".dylib" °{"macos" "aarch64"}
    | ".so"
    ) {Os Arch}
    {"." ThisFileDir ∘}
    /($"___" ⊙Sep)
  )

  Version ← "5.5"

  Call ← &ffi ⊂□Path
└─╴

# Contains FFI types:
#  - Vector₂
#  - Rect
#  - Color
#  - Image
#  - Texture
┌─╴T
  Vector₂ ← "{float; float}"
  Rect    ← "{float; float; float; float}"
  Color   ← "{unsigned char; unsigned char; unsigned char; unsigned char}"
  Image   ← "{void*; int; int; int; int}"
  Texture ← "{unsigned int; int; int; int; int}"
└─╴

# Represents a 2d vector.
~Vector₂ [X Y]

# Represents a rectangle, with a position and a size.
~Rect [X Y Width Height]

# Contains color constants and color data definition.
┌─╴Color
  ~[R G B A]

  LightGray  ← $LightGray New 200 200 200 255
  Gray       ← $Gray New 130 130 130 255
  DarkGray   ← $DarkGray New 80 80 80 255
  Yellow     ← $Yellow New 253 249 0 255
  Gold       ← $Gold New 255 203 0 255
  Orange     ← $Orange New 255 161 0 255
  Pink       ← $Pink New 255 109 194 255
  Red        ← $Red New 230 41 55 255
  Maroon     ← $Maroon New 190 33 55 255
  Green      ← $Green New 0 228 48 255
  Lime       ← $Lime New 0 158 47 255
  DarkGreen  ← $DarkGreen New 0 117 44 255
  SkyBlue    ← $SkyBlue New 102 191 255 255
  Blue       ← $Blue New 0 121 241 255
  DarkBlue   ← $DarkBlue New 0 82 172 255
  Purple     ← $Purple New 200 122 255 255
  Violet     ← $Violet New 135 60 190 255
  DarkPurple ← $DarkPurple New 112 31 126 255
  Beige      ← $Beige New 211 176 131 255
  Brown      ← $Brown New 127 106 79 255
  DarkBrown  ← $DarkBrown New 76 63 47 255
  White      ← $White New 255 255 255 255
  Black      ← $Black New 0 0 0 255
  Blank      ← $Blank New 0 0 0 0
  Magenta    ← $Magenta New 255 0 255 255
  RayWhite   ← $RayWhite New 245 245 245 255
└─╴

# Contains functions and information related to the `Image` struct:
#  - Data definition
#  - Load
#  - Unload
#  - New: to be used with `⍜`
#  - Formats: named constants for raylib Image formats
┌─╴Image
  ~{Pixels W H Format Mipmaps}

  # image ? format array
  Load ← Lib {T~Image "LoadImageFromMemory" "const char*" "const unsigned char:2" "int"} □₂⊂@.⟜img

  # ? image
  Unload ← ◌Lib {"void" "UnloadImage" T~Image} □₁

  # Loads an image with the given format from an image array as you would
  # normally use it. °Image unloads the image. Should mostly be used like
  # `⍜Image⟜F` to preserve the image for unloading.
  New ← ⌅(Load|Unload)

  FromTexture ← Lib {T~Image "LoadImageFromTexture" T~Texture} □₁

  # Named constants for raylib Image formats.
  ┌─╴Formats
    UGray        ← 1  # ⋯ 8
    UGrayA       ← 2  # ⋯ 16
    URGB₅        ← 3  # ⋯ 16   G has extra bit
    URGB₈        ← 4  # ⋯ 24
    URGBA₅       ← 5  # ⋯ 16   1 bit alpha
    URGBA₄       ← 6  # ⋯ 16
    URGBA₈       ← 7  # ⋯ 32
    UR₃₂         ← 8  # ⋯ 32   1x Float
    URGB₃₂       ← 9  # ⋯ 96   3x Float
    URGBA₃₂      ← 10 # ⋯ 128  4x Float
    UR₁₆         ← 11 # ⋯ 16   1x Float ½
    URGB₁₆       ← 12 # ⋯ 48   3x Float ½
    URGBA₁₆      ← 13 # ⋯ 64   4x Float ½
    CDXTRGB₁     ← 14 # ⋯ 4
    CDXTRGBA₁    ← 15 # ⋯ 4
    CDXTRGBA₃    ← 16 # ⋯ 8
    CDXTRGBA₅    ← 17 # ⋯ 8
    CETCRGB₁     ← 18 # ⋯ 4
    CETCRGB₂     ← 19 # ⋯ 4
    CETCEACRGBA₂ ← 20 # ⋯ 8
    CPVRTRGB     ← 21 # ⋯ 4
    CPVRTRGBA    ← 22 # ⋯ 4
    CASTCRGBA₄   ← 23 # ⋯ 8
    CASTCRGBA₈   ← 24 # ⋯ 2
  └─╴
└─╴

┌─╴Texture
  ~{Id Width Height Mipmaps Format}
  
  Load   ← Lib {T~Texture "LoadTexture" "const char*"} □₁
  Unload ← ◌Lib {"void" "UnloadTexture" T~Texture} □₁
  
  New ← ⌅(Load|Unload)
  
  FromImage ← Lib {T~Texture "LoadTextureFromImage" T~Image} □₁
  
  # t ? format img-array
  FromArray ← ⌅(⍜Image⟜FromImage|Unload)
└─╴

# Window related functions:
#  - Data definition
#  - Constructor for raylib
#  - FPS & °FPS
#  - Time, FrameTime
#  - ShouldClose, Close
#  - IsFullscreen & ToggleFullscreen
#  - RenderWidth, RenderHeight & Size
#  - Loop! for simple applications
┌─╴Window
  ~{Width Height Title}
  
  # Initialize window and OpenGL context.
  # This should be called before any other Raylib functions.
  # ? width height title
  Call ← ◌Lib {"void" "InitWindow" "int" "int" "const char*"} □₃
  
  # FPS gets current, °FPS sets target
  # FPS ?
  FPS ← ⌅(
    Lib {"int" "GetFPS"} {}
  | ◌Lib {"void" "SetTargetFPS" "int"} □₁
  )
  
  # Get time in seconds for last frame drawn (delta time)
  # frame-time ?
  FrameTime ← (Lib {"float" "GetFrameTime"} {})
  
  # Get elapsed time in seconds since InitWindow
  # elapsed ?
  Time ← (Lib {"double" "GetTime"} {})
  
  # Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
  # Boolean ?
  ShouldClose ← (Lib {"int" "WindowShouldClose"} {})
  
  # Close window and unload OpenGL context.
  Close ← (◌Lib {"void" "CloseWindow"} {})
  
  # Check if window is currently fullscreen
  # Boolean ?
  IsFullscreen ← (Lib {"int" "IsWindowFullscreen"} {})
  
  # Toggle window state: fullscreen/windowed, resizes monitor to match window resolution
  ToggleFullscreen ← (◌ Lib {"void" "ToggleFullscreen"} {})
  
  # Get current render width (it considers HiDPI)
  # width ?
  RenderWidth ← (Lib {"int" "GetRenderWidth"} {})
  
  # Get current render height (it considers HiDPI)
  # height ?
  RenderHeight ← (Lib {"int" "GetRenderHeight"} {})
  
  # Size gets current render size, °Size sets it.
  Size ← ⌅(
    RenderWidth RenderHeight
  | ◌Lib {"void" "SetWindowSize" "int" "int"} □₂
  )
  
  # Main loop for a basic application
  Loop! ← Close ⍢^0(¬ShouldClose)
└─╴

# Drawing related functions:
#  - Begin
#  - End
#  - Call: to be used with `⍜`
┌─╴Drawing
  Begin ← (◌Lib {"void" "BeginDrawing"} {})
  End   ← (◌Lib {"void" "EndDrawing"} {})
  
  # To be used with `⍜`. Begins and ends drawing.
  # Needs to happen after initializing a window.
  Call ← ⌅(Begin|End)
└─╴

# Mouse related functions and modules:
#  - Pos & °Pos: get/set
#  - ▲: mouse delta between frames
#  - Button: Button related functions & constants
#  - Cursor: Cursor related functions
┌─╴Mouse
  # `Pos` gets the current position as a vector, `°Pos` sets it.
  # Vector₂ ?
  Pos ← ⌅(
    Lib {T~Vector₂ "GetMousePosition"} {}
  | ◌Lib {"void" "SetMousePosition" "int" "int"} □₂)
  
  # Get mouse delta between frames.
  # Vector₂ ?
  ▲ ← (Lib {T~Vector₂ "GetMouseDelta"} {})
  
  # Button related constants and functions:
  #  - Left, Right, Middle, Side, Extra, Forward, Back constants
  #  - Pressed & °Pressed (Released)
  #  - Down & °Down (Up)
  ┌─╴Button
    Left    ← 0
    Right   ← 1
    Middle  ← 2
    Side    ← 3
    Extra   ← 4
    Forward ← 5
    Back    ← 6
    
    # Check if a mouse button has been pressed once. Inverse → released.
    # bool ? button
    Pressed ← ⌅(
      Lib {"char" "IsMouseButtonPressed" "int"} □₁
    | Lib {"char" "IsMouseButtonReleased" "int"} □₁
    )
    
    # Check if a mouse button is being pressed. Inverse → NOT pressed.
    # bool ? button
    Down ← ⌅(
      Lib {"char" "IsMouseButtonDown" "int"} □₁
    | Lib {"char" "IsMouseButtonUp" "int"} □₁
    )
  └─╴
  
  # Cursor related functions:
  #  - Hide & °Hide (Show)
  #  - IsHidden
  #  - IsOnScreen
  ┌─╴Cursor
    # `Hide` hides the cursor, `°Hide` shows it.
    Hide ← ⌅(
      ◌Lib {"void" "HideCursor"} {}
    | ◌Lib {"void" "ShowCursor"} {}
    )
    
    IsHidden ← (Lib {"int" "IsCursorHidden"} {})
    
    IsOnScreen ← (Lib {"int" "IsCursorOnScreen"} {})
  └─╴
└─╴

# Keyboard related functions and constants:
#  - Code: Key code constants and conversion
#  - Pressed & °Pressed (Released)
#  - PressedRepeat
#  - Down & °Down (Up)
#  - Exit: sets exit key
#  - PressedCode & PressedCodes
#  - PressedChar & PressedChars
┌─╴Keyboard
  # Key code constants and conversion
  ┌─╴Code
    Escape       ← 256
    Enter        ← 257
    Tab          ← 258
    Backspace    ← 259
    Insert       ← 260
    Delete       ← 261
    Right        ← 262
    Left         ← 263
    Down         ← 264
    Up           ← 265
    PageUp       ← 266
    PageDown     ← 267
    Home         ← 268
    End          ← 269
    CapsLock     ← 280
    ScrollLock   ← 281
    NumLock      ← 282
    PrintScreen  ← 283
    Pause        ← 284
    F₁           ← 290
    F₂           ← 291
    F₃           ← 292
    F₄           ← 293
    F₅           ← 294
    F₆           ← 295
    F₇           ← 296
    F₈           ← 297
    F₉           ← 298
    F₁₀          ← 299
    F₁₁          ← 300
    F₁₂          ← 301
    LeftShift    ← 340
    LeftControl  ← 341
    LeftAlt      ← 342
    LeftSuper    ← 343
    RightShift   ← 344
    RightControl ← 345
    RightAlt     ← 346
    RightSuper   ← 347
    Menu         ← 348
    
    Kp₀        ← 320
    Kp₁        ← 321
    Kp₂        ← 322
    Kp₃        ← 323
    Kp₄        ← 324
    Kp₅        ← 325
    Kp₆        ← 326
    Kp₇        ← 327
    Kp₈        ← 328
    Kp₉        ← 329
    KpDecimal  ← 330
    KpDivide   ← 331
    KpMultiply ← 332
    KpSubtract ← 333
    KpAdd      ← 334
    KpEnter    ← 335
    KpEqual    ← 336
    New        ← ⍥(-@\0⌵)⊸type
  └─╴
  
  # Checks if a key has been pressed once. `°Pressed` = released
  # bool ? char
  Pressed ← ⌅(
    Lib {"char" "IsKeyPressed" "int"} {Code}
  | Lib {"char" "IsKeyReleased" "int"} {Code}
  )
  
  # Checks if a key has been pressed again.
  # bool ? char
  PressedRepeat ← Lib {"char" "IsKeyPressedRepeat" "int"} {Code}
  
  # Checks if a key is being pressed. `°Down` = not pressed
  # bool ? char
  Down ← ⌅(
    Lib {"char" "IsKeyDown" "int"} {Code}
  | Lib {"char" "IsKeyUp" "int"} {Code}
  )
  
  ‼ ↚ ⋅≡◇∘ ⍢⊂(⊸≠^0 ^1) {}
  
  # Gets key pressed (keycode), call multiple times for keys queued, returns 0 when the queue is empty.
  # code ?
  PressedCode  ← (Lib {"int" "GetKeyPressed"} {})
  PressedCodes ← (‼0 PressedCode)
  
  # Gets char pressed (unicode), call multiple times for chars queued, returns 0 when the queue is empty.
  # char ?
  PressedChar  ← (+@\0 Lib {"int" "GetCharPressed"} {})
  PressedChars ← (‼@\0 PressedChar)
  
  # Sets a custom key to exit program (default is ESC).
  # ? char
  Exit ← ◌Lib {"void" "SetExitKey" "int"} {Code}
└─╴

# Contains font related functions. Doesn't work right now.
#  - New returns the default font
#  - File
┌─╴Font
  # default-font ?
  New ← (Lib {"const void*" "GetFontDefault"} {})
  
  # font ? filename
  File ← Lib {"const void*" "LoadFont" "const char*"} □₁
  
  # font ? filename size codepoints count
  FileEx ← Lib {"const void*" "LoadFontEx" "const char*" "int" "int*" "int"} □₄
  
  # font ? type raw size
  FromMemory ← (
    □₅ ⊙⊙⊙(NULL 0)
    Lib {"const void*" "LoadFontFromMemory" "const char*" "const unsigned char:2" "int" "int" "int*" "int"}
  )
  
  # font ? file size
  TTF ← (
    FromMemory⟜(&frab˜⊂) ".ttf"
  )
└─╴

# Contains the following functions for drawing various shapes.
# The modules (`Name & ~...`) each have a `Call` function and the listed functions.
#  - Background
#  - Pixel
#  - Line & ~Thickness, ~Strip, ~Bezier
#  - Circle & ~Outline
#  - Sector & ~Outline
#  - Ellipse & ~Outline
#  - Ring & ~Outline
#  - Rect & ~Outline
#  - Triangle & ~Outline
#  - Poly & ~Outline
#  - Text & ~Measure, ~Centered
┌─╴Draw
  # Sets background color
  # ? color
  Background ← ◌Lib {"void" "ClearBackground" T~Color} □₁
  
  # Draws a pixel using geometry. Slow when used a lot.
  # ? pos color
  Pixel ← ◌Lib {"void" "DrawPixelV" T~Vector₂ T~Color} □₂
  
  ┌─╴Texture    
    # Draws a texture at a position with some tint.
    # ? texture pos tint
    Call ← ◌Lib {"void" "DrawTextureV" T~Texture T~Vector₂ T~Color} □₃
    
    # Draws a texture with extended rotation and scale.
    # ? texture pos rot scale tint
    ScaleRot ← (
      ◌Lib {"void" "DrawTextureEx" T~Texture T~Vector₂ "float" "float" T~Color} □₅
    )
    
    # Draws a part of a texture defined by a rectangle.
    # ? texture rect pos tint
    Rect ← (
      ◌Lib {"void" "DrawTextureRec" T~Texture T~Rect T~Vector₂ T~Color} □₄
    )
    
    # Draws a part of a texture defined by a rectangle with custom destination,
    # as well as rotation.
    # ? texture source dest origin rot tint
    RectPro ← (
      ◌Lib {"void" "DrawTexturePro" T~Texture T~Rect T~Rect T~Vector₂ "float" T~Color} □₆
    )
  └─╴
  
  # Contains Line drawing functions:
  #  - Call
  #  - Thickness
  #  - Strip
  #  - Bezier
  ┌─╴Line
    # Draws a line.
    # ? from to color
    Call ← (
      ◌Lib {"void" "DrawLineV" T~Vector₂ T~Vector₂ T~Color} □₃
    )
    
    # Draws a line with thickness.
    # ? from to thickness color
    Thickness ← (
      ◌Lib {"void" "DrawLineEx" T~Vector₂ T~Vector₂ "float" T~Color} □₄
    )
    
    # Draws a line strip.
    # ? vectors₂ color
    Strip ← (
      ◌Lib {"void" "DrawLineStrip" $"const _:1"T~Vector₂ "int" T~Color} □₂
    )
    
    # Draws line segment cubic-bezier in-out interpolation.
    # ? from to thickness color
    Bezier ← ◌Lib {"void" "DrawLineBezier" T~Vector₂ T~Vector₂ "float" T~Color} □₄
  └─╴
  
  ┌─╴Circle
    # ? center r color
    Call ← ◌Lib {"void" "DrawCircleV" T~Vector₂ "float" T~Color} □₃
    
    # ? center r color
    Outline ← ◌Lib {"void" "DrawCircleLinesV" T~Vector₂ "float" T~Color} □₃
  └─╴
  
  ┌─╴Sector
    # ? center r θ₀ θ₁ segments color
    Call ← (
      ◌Lib {"void" "DrawCircleSector" T~Vector₂ "float" "float" "float" "int" T~Color} □₆
    )
    
    # ? center r θ₀ θ₁ segments color
    Outline ← (
      ◌Lib {"void" "DrawCircleSectorLines" T~Vector₂ "float" "float" "float" "int" T~Color} □₆
    )
  └─╴
  
  ┌─╴Ellipse
    # ? center hr vr color
    Call ← (
      ◌Lib {"void" "DrawEllipse" "int" "int" "float" "float" T~Color} □₅ °⊟
    )
    
    # ? center hr vr color
    Outline ← (
      ◌Lib {"void" "DrawEllipseLines" "int" "int" "float" "float" T~Color} □₅ °⊟
    )
  └─╴
  
  ┌─╴Ring
    # ? center ir or θ₀ θ₁ segments color
    Call ← (
      ◌Lib {"void" "DrawRing" T~Vector₂ "float" "float" "float" "float" "int" T~Color} □₇
    )
    
    # ? center ir or θ₀ θ₁ segments color
    Outline ← ◌Lib {"void" "DrawRingLines" T~Vector₂ "float" "float" "float" "float" "int" T~Color} □₇
  └─╴
  
  ┌─╴Rect
    # ? pos size color
    Call ← ◌Lib {"void" "DrawRectangleV" T~Vector₂ T~Vector₂ T~Color} □₃
    
    # ? pos size color
    Outline ← ◌Lib {"void" "DrawRectangleLines" "int" "int" "int" "int" T~Color} □₅ ∩°⊟
  └─╴
  
  ┌─╴Triangle
    # ? p₁ p₂ p₃ color
    Call ← ◌Lib {"void" "DrawTriangle" T~Vector₂ T~Vector₂ T~Vector₂ T~Color} □₄
    
    # ? p₁ p₂ p₃ color
    Outline ← ◌Lib {"void" "DrawTriangleLines" T~Vector₂ T~Vector₂ T~Vector₂ T~Color} □₄
  └─╴
  
  ┌─╴Poly
    # ? center sides r θ color
    Call ← ◌Lib {"void" "DrawPoly" T~Vector₂ "int" "float" "float" T~Color} □₅
    
    # ? center sides r θ color
    Outline ← ◌Lib {"void" "DrawPolyLines" T~Vector₂ "int" "float" "float" T~Color} □₅
  └─╴
  
  # All functions use the default font.
  # - Call
  # - Measure
  # - DrawCentered
  ┌─╴Text
    # ? text x y size color
    Call ← ◌Lib {"void" "DrawText" "const char*" "int" "int" "int" T~Color} □₅
    
    # ? font text pos size spacing tint
    Ex ← ◌Lib {"void" "DrawTextEx" "const void*" "const char*" T~Vector₂ "float" "float" T~Color} □₆
    
    # width ? text size
    Measure ← Lib {"int" "MeasureText" "const char*" "int"} □₂
    
    # size ? font text size spacing
    MeasureEx ← Lib {T~Vector₂ "MeasureTextEx" "const void*" "const char*" "float" "float"} □₄
    
    # ? text x y size color
    Centered ← Call 𝄐⌞-÷₂◡𝄐𝄐Measure
    
    # font text pos size spacing tint
    CenteredEx ← Ex ⟜₂⊸₂(-÷₂MeasureEx⊙⊙⤚⋅⊙∘)
  └─╴
└─╴

┌─╴Collision
  # Checks collision between two rectangles.
  # bool ? rect₁ rect₂
  Rects ← (
    Lib {"char" "CheckCollisionRecs" T~Rect T~Rect} □₂
  )
  
  # Checks collision between two circles.
  # bool ? center₁ r₁ center₂ r₂
  Circles ← (
    Lib {"char" "CheckCollisionCircles" T~Vector₂ "float" T~Vector₂ "float"} □₄
  )
  
  # Checks collision between circle and rectangle.
  # bool ? center r rect
  CircleRect ← (
    Lib {"char" "CheckCollisionCircleRec" T~Vector₂ "float" T~Rect} □₃
  )
  
  # Checks if circle collides with the straight line between two points.
  # bool ? center r start end
  CircleLine ← (
    Lib {"char" "CheckCollisionCircleLine" T~Vector₂ "float" T~Vector₂ T~Vector₂} □₄
  )
  
  # Checks if point is inside rectangle.
  # bool ? point rect
  PointRect ← (
    Lib {"char" "CheckCollisionPointRec" T~Vector₂ T~Rect} □₂
  )
  
  # Checks if point is inside circle, given as center point and radius.
  # bool ? point center r
  PointCircle ← (
    Lib {"char" "CheckCollisionPointCircle" T~Vector₂ T~Vector₂ "float"} □₃
  )
  
  # Checks if point is inside a triangle, given as 3 vertices.
  # bool ? p a b c
  PointTriangle ← (
    Lib {"char" "CheckCollisionPointTriangle" T~Vector₂ T~Vector₂ T~Vector₂ T~Vector₂} □₄
  )
  
  # Checks if point belongs to the line between two points.
  # bool ? p start end threshold
  PointLine ← (
    Lib {"char" "CheckCollisionPointLine" T~Vector₂ T~Vector₂ T~Vector₂ "int"} □₄
  )
  
  # Checks if point is within a polygon, described by an array of vertices.
  # bool ? p ps
  PointPoly ← (
    Lib {"char" "CheckCollisionPointPoly" T~Vector₂ $"const _:2"T~Vector₂ "int"} □₂
  )
  
  # Checks the collision between two lines defined by two points each.
  # bool ? start₁ end₁ start₂ end₂
  Lines ← (
    Lib {"char" "CheckCollisionLines" T~Vector₂ T~Vector₂ T~Vector₂ T~Vector₂} □₄
  )
  
  # Gets the intersection of two rectangles.
  # rect ? rect₁ rect₂
  Intersection ← (
    Lib {T~Rect "GetCollisionRec" T~Rect T~Rect} □₂
  )
└─╴

# A shortcut function to simply show a single array
# at the origin (0, 0). Also handles begin and end of drawing.
ShowArray ← ⍜Texture~FromArray⟜(
  ⍜Drawing Draw~Texture⊙(0_0 Color~White)
) "png"

# W.I.P.
# put all the shapes into one module and have
# a single draw / collision function?
# collision works nicely, drawing is uglier since
# there are a lot of functions beyond one per shape.
# performance would be bad in bigger systems.
┌─╴Shape
  |Point [x y]
  |Triangle [x₀ y₀ x₁ y₁ x₂ y₂]
  |Circle [cx cy r]
  |Sector [cx cy r θ₀ θ₁ s]
  |Ring [cx cy in out θ₀ θ₁ s]
  |Rect [x y w h]
  |Text {Raw x y s}
  |Ellipse [cx cy hr vr]
  ┌─╴Line
    |New [x₀ y₀ x₁ y₁]
    |wThickness [x₀ y₀ x₁ y₁ t]
    |Strip {ps}
    |Bezier [x₀ y₀ x₁ y₁ t]
  └─╴
  ┌─╴Poly
    |New {ps}
    |Regular [cx cy s r θ]
  └─╴
  
  # bool ? shape₀ shape₁
  Collision ← ⍣(
    Collision~Rects ∩⊟₄ °∩Rect
  | Collision~Lines ∩₄⊟ °∩Line
  | Collision~Circles ⊓⊟⊙⊟ °∩Circle
  | Collision~CircleRect ⊓⊟⊙⊟₄ °⊓Circle Rect
  | Collision~CircleLine ⊓⊟⊙∩⊟ °⊓Circle Line
  | Collision~PointRect ⊓⊟⊟₄ °⊓Point Rect
  | Collision~PointCircle ∩⊟ °⊓Point Circle
  | Collision~PointTriangle ∩₄⊟ °⊓Point Triangle
  | Collision~PointLine ∩₃⊟ °⊓Point Line
  | Collision~PointPoly ⊟ °⊓Point Poly
  | 0 ⍩⍤.$ Unknown shapes or invalid combination.
         $ Make sure you use the variants provided by this module!
  )
  
  ┌─╴Draw
    # ? shape color
    Call ← ⍣(
      ◌Lib {"void" "DrawPixelV" T~Vector₂ T~Color} □₂ ⊟ °Point
    | ◌Lib {"void" "DrawLineV" T~Vector₂ T~Vector₂ T~Color} □₃ ∩⊟ °Line
    | ◌Lib {"void" "DrawLineEx" T~Vector₂ T~Vector₂ "float" T~Color} □₄ ∩⊟ °Line~wThickness
    | ◌Lib {"void" "DrawLineStrip" $"const _:1"T~Vector₂ "int" T~Color} □₂ °Line~Strip
    | ◌Lib {"void" "DrawLineBezier" T~Vector₂ T~Vector₂ "float" T~Color} □₄ ∩⊟ °Line~Bezier
    | ◌Lib {"void" "DrawTriangle" T~Vector₂ T~Vector₂ T~Vector₂ T~Color} □₄ ∩₃⊟ °Triangle
    | ◌Lib {"void" "DrawRectangleV" T~Vector₂ T~Vector₂ T~Color} □₃ ∩⊟ °Rect
    | ◌Lib {"void" "DrawCircleV" T~Vector₂ "float" T~Color} □₃ ⊟ °Circle
    | ◌Lib {"void" "DrawCircleSector" T~Vector₂ "float" "float" "float" "int" T~Color} □₆ ⊟ °Sector
    | ◌Lib {"void" "DrawRing" T~Vector₂ "float" "float" "float" "float" "int" T~Color} □₇ ⊟ °Ring
    | ◌Lib {"void" "DrawEllipse" "int" "int" "float" "float" T~Color} □₅ °Ellipse
    | ◌Lib {"void" "DrawPoly" T~Vector₂ "int" "float" "float" T~Color} □₅ ⊟ °Poly~Regular
    | ◌Lib {"void" "DrawText" "const char*" "int" "int" "int" T~Color} □₅ °Text
    | ⍩⍤.$ Unknown shape. Make sure you use the variants provided by this module!
    )
    
    # ? shape color
    Outline ← ⍣(
      ◌Lib {"void" "DrawCircleLinesV" T~Vector₂ "float" T~Color} □₃ ⊟ °Circle
    | ◌Lib {"void" "DrawTriangleLines" T~Vector₂ T~Vector₂ T~Vector₂ T~Color} □₄ ∩₃⊟ °Triangle
    | ◌Lib {"void" "DrawPolyLines" T~Vector₂ "int" "float" "float" T~Color} □₅ ⊟ °Poly~Regular
    | ◌Lib {"void" "DrawCircleSectorLines" T~Vector₂ "float" "float" "float" "int" T~Color} □₆ ⊟ °Sector
    | ◌Lib {"void" "DrawRingLines" T~Vector₂ "float" "float" "float" "float" "int" T~Color} □₇ ⊟ °Ring
    | ◌Lib {"void" "DrawEllipseLines" "int" "int" "float" "float" T~Color} □₅ °Ellipse
    | ◌Lib {"void" "DrawRectangleLines" "int" "int" "int" "int" T~Color} □₅ °Rect
    | ⍩⍤.$ Unknown shape. Make sure you use the variants provided by this module!
         $ Supported shapes: Circle, Triangle, Poly~Regular, Sector, Ring, Ellipse, Rect
    )
  └─╴
└─╴
