(define-library
    (raylib const)

  (import
   (owl toplevel)
   (owl core)
   (raylib common))

  (export
   colors

   lightgray gray darkgray yellow gold orange pink
   red maroon green lime darkgreen skyblue blue
   darkblue purple violet darkpurple beige brown
   darkbrown white black blank magenta raywhite

   window-flags

   flag-vsync-hint flag-fullscreen-mode flag-window-resizable
   flag-window-undecorated flag-window-hidden flag-window-minimized
   flag-window-maximized flag-window-unfocused flag-window-topmost
   flag-window-always-run flag-window-transparent flag-window-highdpi
   flag-window-mouse-passthrough flag-borderless-windowed-mode
   flag-msaa-4x-hint flag-interlaced-hint

   log-all log-trace log-debug log-info log-warning log-error
   log-fatal log-none

   key-null key-apostrophe key-comma key-minus key-period key-slash
   key-zero key-one key-two key-three key-four key-five key-six
   key-seven key-eight key-nine key-semicolon key-equal key-a
   key-b key-c key-d key-e key-f key-g key-h key-i key-j key-k
   key-l key-m key-n key-o key-p key-q key-r key-s key-t key-u
   key-v key-w key-x key-y key-z key-left-bracket key-backslash
   key-right-bracket key-grave key-space key-escape key-enter key-tab
   key-backspace key-insert key-delete key-right key-left key-down key-up
   key-page-up key-page-down key-home key-end key-caps-lock key-scroll-lock
   key-num-lock key-print-screen key-pause key-f1 key-f2 key-f3 key-f4 key-f5
   key-f6 key-f7 key-f8 key-f9 key-f10 key-f11 key-f12 key-left-shift key-left-control
   key-left-alt key-left-super key-right-shift key-right-control key-right-alt
   key-right-super key-kb-menu key-kp-0 key-kp-1 key-kp-2 key-kp-3 key-kp-4 key-kp-5
   key-kp-6 key-kp-7 key-kp-8 key-kp-9 key-kp-decimal key-kp-divide key-kp-multiply
   key-kp-subtract key-kp-add key-kp-enter key-kp-equal key-back key-menu
   key-volume-up key-volume-down

   mouse-button-left mouse-button-right mouse-button-middle mouse-button-side
   mouse-button-extra mouse-button-forward mouse-button-back mouse-left-button
   mouse-right-button mouse-middle-button

   mouse-cursor-default mouse-cursor-arrow mouse-cursor-ibeam mouse-cursor-crosshair
   mouse-cursor-pointing-hand mouse-cursor-resize-ew mouse-cursor-resize-ns
   mouse-cursor-resize-nwse mouse-cursor-resize-nesw mouse-cursor-resize-all
   mouse-cursor-not-allowed

   gamepad-button-unknown gamepad-button-left-face-up gamepad-button-left-face-right
   gamepad-button-left-face-down gamepad-button-left-face-left gamepad-button-right-face-up
   gamepad-button-right-face-right gamepad-button-right-face-down
   gamepad-button-right-face-left gamepad-button-left-trigger-1 gamepad-button-left-trigger-2
   gamepad-button-right-trigger-1 gamepad-button-right-trigger-2 gamepad-button-middle-left
   gamepad-button-middle gamepad-button-middle-right gamepad-button-left-thumb
   gamepad-button-right-thumb gamepad-axis-left-x gamepad-axis-left-y gamepad-axis-right-x
   gamepad-axis-right-y gamepad-axis-left-trigger gamepad-axis-right-trigger

   gesture-none gesture-tap gesture-doubletap gesture-hold gesture-drag gesture-swipe-right
   gesture-swipe-left gesture-swipe-up gesture-swipe-down gesture-pinch-in
   gesture-pinch-out

   camera-custom camera-free camera-orbital camera-first-person camera-third-person
   camera-perspective camera-orthographic

   texture-filter-point texture-filter-bilinear texture-filter-trilinear
   texture-filter-anisotropic-4x texture-filter-anisotropic-8x
   texture-filter-anisotropic-16x
   )

  (begin
    (define lightgray  4291348680)
    (define gray       4286743170)
    (define darkgray   4283453520)
    (define yellow     4278254077)
    (define gold       4278242303)
    (define orange     4278231551)
    (define pink       4290932223)
    (define red        4281805286)
    (define maroon     4281803198)
    (define green      4281394176)
    (define lime       4281310720)
    (define darkgreen  4281103616)
    (define skyblue    4294950758)
    (define blue       4294015232)
    (define darkblue   4289483264)
    (define purple     4294933192)
    (define violet     4290657415)
    (define darkpurple 4286455664)
    (define beige      4286820563)
    (define brown      4283394687)
    (define darkbrown  4281286476)
    (define white      4294967295)
    (define black      4278190080)
    (define blank      0)
    (define magenta    4294902015)
    (define raywhite   4294309365)

    (define flag-vsync-hint                #x00000040)
    (define flag-fullscreen-mode           #x00000002)
    (define flag-window-resizable          #x00000004)
    (define flag-window-undecorated        #x00000008)
    (define flag-window-hidden             #x00000080)
    (define flag-window-minimized          #x00000200)
    (define flag-window-maximized          #x00000400)
    (define flag-window-unfocused          #x00000800)
    (define flag-window-topmost            #x00001000)
    (define flag-window-always-run         #x00000100)
    (define flag-window-transparent        #x00000010)
    (define flag-window-highdpi            #x00002000)
    (define flag-window-mouse-passthrough  #x00004000)
    (define flag-borderless-windowed-mode  #x00008000)
    (define flag-msaa-4x-hint              #x00000020)
    (define flag-interlaced-hint           #x00010000)

    (define colors
      (list
       lightgray gray darkgray yellow gold orange pink
       red maroon green lime darkgreen skyblue blue
       darkblue purple violet darkpurple beige brown
       darkbrown white black blank magenta raywhite))

    (define window-flags
      flag-vsync-hint flag-fullscreen-mode flag-window-resizable
      flag-window-undecorated flag-window-hidden flag-window-minimized
      flag-window-maximized flag-window-unfocused flag-window-topmost
      flag-window-always-run flag-window-transparent flag-window-highdpi
      flag-window-mouse-passthrough flag-borderless-windowed-mode
      flag-msaa-4x-hint flag-interlaced-hint)

    (define log-all      0)
    (define log-trace    1)
    (define log-debug    2)
    (define log-info     3)
    (define log-warning  4)
    (define log-error    5)
    (define log-fatal    6)
    (define log-none     7)

    (define key-null            0)        ;; key: null, used for no key pressed
    (define key-apostrophe      39)       ;; key: '
    (define key-comma           44)       ;; key: ,
    (define key-minus           45)       ;; key: -
    (define key-period          46)       ;; key: .
    (define key-slash           47)       ;; key: /
    (define key-zero            48)       ;; key: 0
    (define key-one             49)       ;; key: 1
    (define key-two             50)       ;; key: 2
    (define key-three           51)       ;; key: 3
    (define key-four            52)       ;; key: 4
    (define key-five            53)       ;; key: 5
    (define key-six             54)       ;; key: 6
    (define key-seven           55)       ;; key: 7
    (define key-eight           56)       ;; key: 8
    (define key-nine            57)       ;; key: 9
    (define key-semicolon       59)       ;; key: ;
    (define key-equal           61)       ;; key: =
    (define key-a               65)       ;; key: a | a
    (define key-b               66)       ;; key: b | b
    (define key-c               67)       ;; key: c | c
    (define key-d               68)       ;; key: d | d
    (define key-e               69)       ;; key: e | e
    (define key-f               70)       ;; key: f | f
    (define key-g               71)       ;; key: g | g
    (define key-h               72)       ;; key: h | h
    (define key-i               73)       ;; key: i | i
    (define key-j               74)       ;; key: j | j
    (define key-k               75)       ;; key: k | k
    (define key-l               76)       ;; key: l | l
    (define key-m               77)       ;; key: m | m
    (define key-n               78)       ;; key: n | n
    (define key-o               79)       ;; key: o | o
    (define key-p               80)       ;; key: p | p
    (define key-q               81)       ;; key: q | q
    (define key-r               82)       ;; key: r | r
    (define key-s               83)       ;; key: s | s
    (define key-t               84)       ;; key: t | t
    (define key-u               85)       ;; key: u | u
    (define key-v               86)       ;; key: v | v
    (define key-w               87)       ;; key: w | w
    (define key-x               88)       ;; key: x | x
    (define key-y               89)       ;; key: y | y
    (define key-z               90)       ;; key: z | z
    (define key-left-bracket    91)       ;; key: [
    (define key-backslash       92)       ;; key: '\'
    (define key-right-bracket   93)       ;; key: ]
    (define key-grave           96)       ;; key: `
    (define key-space           32)       ;; key: space
    (define key-escape          256)      ;; key: esc
    (define key-enter           257)      ;; key: enter
    (define key-tab             258)      ;; key: tab
    (define key-backspace       259)      ;; key: backspace
    (define key-insert          260)      ;; key: ins
    (define key-delete          261)      ;; key: del
    (define key-right           262)      ;; key: cursor right
    (define key-left            263)      ;; key: cursor left
    (define key-down            264)      ;; key: cursor down
    (define key-up              265)      ;; key: cursor up
    (define key-page-up         266)      ;; key: page up
    (define key-page-down       267)      ;; key: page down
    (define key-home            268)      ;; key: home
    (define key-end             269)      ;; key: end
    (define key-caps-lock       280)      ;; key: caps lock
    (define key-scroll-lock     281)      ;; key: scroll down
    (define key-num-lock        282)      ;; key: num lock
    (define key-print-screen    283)      ;; key: print screen
    (define key-pause           284)      ;; key: pause
    (define key-f1              290)      ;; key: f1
    (define key-f2              291)      ;; key: f2
    (define key-f3              292)      ;; key: f3
    (define key-f4              293)      ;; key: f4
    (define key-f5              294)      ;; key: f5
    (define key-f6              295)      ;; key: f6
    (define key-f7              296)      ;; key: f7
    (define key-f8              297)      ;; key: f8
    (define key-f9              298)      ;; key: f9
    (define key-f10             299)      ;; key: f10
    (define key-f11             300)      ;; key: f11
    (define key-f12             301)      ;; key: f12
    (define key-left-shift      340)      ;; key: shift left
    (define key-left-control    341)      ;; key: control left
    (define key-left-alt        342)      ;; key: alt left
    (define key-left-super      343)      ;; key: super left
    (define key-right-shift     344)      ;; key: shift right
    (define key-right-control   345)      ;; key: control right
    (define key-right-alt       346)      ;; key: alt right
    (define key-right-super     347)      ;; key: super right
    (define key-kb-menu         348)      ;; key: kb menu
    (define key-kp-0            320)      ;; key: keypad 0
    (define key-kp-1            321)      ;; key: keypad 1
    (define key-kp-2            322)      ;; key: keypad 2
    (define key-kp-3            323)      ;; key: keypad 3
    (define key-kp-4            324)      ;; key: keypad 4
    (define key-kp-5            325)      ;; key: keypad 5
    (define key-kp-6            326)      ;; key: keypad 6
    (define key-kp-7            327)      ;; key: keypad 7
    (define key-kp-8            328)      ;; key: keypad 8
    (define key-kp-9            329)      ;; key: keypad 9
    (define key-kp-decimal      330)      ;; key: keypad .
    (define key-kp-divide       331)      ;; key: keypad /
    (define key-kp-multiply     332)      ;; key: keypad *
    (define key-kp-subtract     333)      ;; key: keypad -
    (define key-kp-add          334)      ;; key: keypad +
    (define key-kp-enter        335)      ;; key: keypad enter
    (define key-kp-equal        336)      ;; key: keypad =
    (define key-back            4)        ;; key: android back button
    (define key-menu            5)        ;; key: android menu button
    (define key-volume-up       24)       ;; key: android volume up button
    (define key-volume-down     25)       ;; key: android volume down button


    (define mouse-button-left    0)       ;; mouse button left
    (define mouse-button-right   1)       ;; mouse button right
    (define mouse-button-middle  2)       ;; mouse button middle (pressed wheel)
    (define mouse-button-side    3)       ;; mouse button side (advanced mouse device)
    (define mouse-button-extra   4)       ;; mouse button extra (advanced mouse device)
    (define mouse-button-forward 5)       ;; mouse button forward (advanced mouse device)
    (define mouse-button-back    6)       ;; mouse button back (advanced mouse device)

    (define mouse-left-button   mouse-button-left)
    (define mouse-right-button  mouse-button-right)
    (define mouse-middle-button mouse-button-middle)

    (define mouse-cursor-default       0)     ;; default pointer shape
    (define mouse-cursor-arrow         1)     ;; arrow shape
    (define mouse-cursor-ibeam         2)     ;; text writing cursor shape
    (define mouse-cursor-crosshair     3)     ;; cross shape
    (define mouse-cursor-pointing-hand 4)     ;; pointing hand cursor
    (define mouse-cursor-resize-ew     5)     ;; horizontal resize/move arrow shape
    (define mouse-cursor-resize-ns     6)     ;; vertical resize/move arrow shape
    (define mouse-cursor-resize-nwse   7)     ;; top-left to bottom-right diagonal resize/move arrow shape
    (define mouse-cursor-resize-nesw   8)     ;; the top-right to bottom-left diagonal resize/move arrow shape
    (define mouse-cursor-resize-all    9)     ;; the omnidirectional resize/move cursor shape
    (define mouse-cursor-not-allowed   10)    ;; the operation-not-allowed shape

    (define gamepad-button-unknown             0)
    (define gamepad-button-left-face-up        1)
    (define gamepad-button-left-face-right     2)
    (define gamepad-button-left-face-down      3)
    (define gamepad-button-left-face-left      4)
    (define gamepad-button-right-face-up       5)
    (define gamepad-button-right-face-right    6)
    (define gamepad-button-right-face-down     7)
    (define gamepad-button-right-face-left     8)
    (define gamepad-button-left-trigger-1      9)
    (define gamepad-button-left-trigger-2      10)
    (define gamepad-button-right-trigger-1     11)
    (define gamepad-button-right-trigger-2     12)
    (define gamepad-button-middle-left         13)
    (define gamepad-button-middle              14)
    (define gamepad-button-middle-right        15)
    (define gamepad-button-left-thumb          16)
    (define gamepad-button-right-thumb         17)

    (define gamepad-axis-left-x        0)     ;; gamepad left stick x axis
    (define gamepad-axis-left-y        1)     ;; gamepad left stick y axis
    (define gamepad-axis-right-x       2)     ;; gamepad right stick x axis
    (define gamepad-axis-right-y       3)     ;; gamepad right stick y axis
    (define gamepad-axis-left-trigger  4)     ;; gamepad back trigger left, pressure level: [1..-1]
    (define gamepad-axis-right-trigger 5)     ;; gamepad back trigger right, pressure level: [1..-1]

    ;; [...]

    (define gesture-none        0)        ;; no gesture
    (define gesture-tap         1)        ;; tap gesture
    (define gesture-doubletap   2)        ;; double tap gesture
    (define gesture-hold        4)        ;; hold gesture
    (define gesture-drag        8)        ;; drag gesture
    (define gesture-swipe-right 16)       ;; swipe right gesture
    (define gesture-swipe-left  32)       ;; swipe left gesture
    (define gesture-swipe-up    64)       ;; swipe up gesture
    (define gesture-swipe-down  128)      ;; swipe down gesture
    (define gesture-pinch-in    256)      ;; pinch in gesture
    (define gesture-pinch-out   512)      ;; pinch out gesture

    (define camera-custom        0)
    (define camera-free          1)
    (define camera-orbital       2)
    (define camera-first-person  2)
    (define camera-third-person  3)

    (define camera-perspective 0)
    (define camera-orthographic 1)

    (define texture-filter-point 0)           ;; no filter, just pixel approximation
    (define texture-filter-bilinear 1)        ;; linear filtering
    (define texture-filter-trilinear 2)       ;; trilinear filtering (linear with mipmaps)
    (define texture-filter-anisotropic-4x 3)  ;; anisotropic filtering 4x
    (define texture-filter-anisotropic-8x 4)  ;; anisotropic filtering 8x
    (define texture-filter-anisotropic-16x 5) ;; anisotropic filtering 16x

    ))
