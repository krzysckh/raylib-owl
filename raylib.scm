(define-library (raylib)
  (import
   (owl toplevel)
   (owl string)
   (owl core))

  (export
   draw
   with-window

   init-window
   window-should-close?
   close-window
   window-ready?
   window-minimized?
   window-resized?

   window-state?
   set-window-state!
   clear-window-state!
   toggle-fullscreen!
   set-window-icon!
   set-window-title!
   set-window-position!
   set-window-monitor!
   set-window-min-size!
   set-window-size!
   window-handle
   window-width
   window-height
   window-size
   monitor-count
   monitor-width
   monitor-height
   monitor-size
   monitor-physical-width
   monitor-physical-height
   monitor-name
   clipboard
   set-clipboard!

   show-cursor!
   hide-cursor!
   cursor-hidden?
   enable-cursor!
   disable-cursor!
   cursor-on-screen?
   make-color
   clear-background
   begin-drawing
   end-drawing
   make-camera2d
   begin-mode2d
   end-mode2d

   set-target-fps!
   fps
   frame-time
   time

   color-normalize
   color->hsv
   color->number ;; self
   fade

   set-config-flags!
   set-tracelog-level!
   take-screenshot!

   dropped-files
   open-url

   key-pressed?
   key-down?
   key-released?
   key-up?
   key-pressed
   set-exit-key!

   gamepad-available?
   gamepad-name
   gamepad-btn-pressed?
   gamepad-btn-down?
   gamepad-btn-released?
   gamepad-btn-up?
   gamepad-btn-pressed
   gamepad-axis-count
   gamepad-axis-movement

   mouse-btn-pressed?
   mouse-btn-down?
   mouse-btn-released?
   mouse-btn-up?
   mouse-x
   mouse-y
   mouse-pos
   set-mouse-pos!
   set-mouse-offset!
   set-mouse-scale!
   mouse-wheel

   touch-x
   touch-y
   touch-pos

   set-gestures-enabled!
   gesture-detected?
   gesture-detected
   touch-points-count
   gesture-hold-duration
   gesture-drag-vector
   gesture-drag-angle
   gesture-pinch-vector
   gesture-pinch-angle
   )

  (begin
    (define (prim n . vs)
      (let ((L (length vs)))
        (cond
         ((= L 0) (sys-prim n #f #f #f))
         ((= L 1) (sys-prim n (car vs) #f #f))
         ((= L 2) (sys-prim n (car vs) (cadr vs) #f))
         (else
          (sys-prim n (car vs) (cadr vs) (caddr vs))))))

    (define (init-window width height title)
      (prim 100 width height (c-string title)))

    (define (window-should-close?)         (prim 101))
    (define (close-window)                 (prim 102))
    (define (window-ready?)                (prim 103))
    (define (window-minimized?)            (prim 104))
    (define (window-maximized?)            (prim 105))
    (define (window-resized?)              (prim 106))
    (define (window-state? flag)           (prim 107 flag))
    (define (set-window-state! flags)      (prim 108 flags))
    (define (clear-window-state! flags)    (prim 109 flags))
    (define (toggle-fullscreen!)           (prim 110))
    (define (set-window-icon! image)       (prim 111 image))
    (define (set-window-title! title)      (prim 112 title))
    (define (set-window-position! x y)     (prim 113 x y))
    (define (set-window-monitor! monitor)  (prim 114 monitor))
    (define (set-window-min-size! w h)     (prim 115 w h))
    (define (set-window-size! w h)         (prim 116 w h))
    (define (window-handle)                (prim 117))
    (define (window-width)                 (prim 118))
    (define (window-height)                (prim 119))
    (define (monitor-count)                (prim 120))
    (define (monitor-width monitor)        (prim 121 monitor))
    (define (monitor-height monitor)       (prim 122 monitor))

    (define (window-size)
      (cons (window-width) (window-height)))

    (define (monitor-size monitor)
      (cons (monitor-width monitor)
            (monitor-height monitor)))

    (define (monitor-physical-width monitor)   (prim 123 monitor))
    (define (monitor-physical-height monitor)  (prim 124 monitor))
    (define (monitor-name monitor)             (prim 125 monitor))
    (define (clipboard)                        (prim 126))
    (define (set-clipboard! text)              (prim 127 text))
    (define (show-cursor!)                     (prim 128))
    (define (hide-cursor!)                     (prim 129))
    (define (cursor-hidden?)                   (prim 130))
    (define (enable-cursor!)                   (prim 131))
    (define (disable-cursor!)                  (prim 132))
    (define (cursor-on-screen?)                (prim 133))
    (define (make-color r g b a)               (prim 134 (list r g b a)))

    (define (clear-background color)
      (if (list? color)
          (prim 135 (apply make-color color))
          (prim 135 color)))

    (define (begin-drawing)                         (prim 136))
    (define (end-drawing)                           (prim 137))
    (define (make-camera2d offset target rot zoom)  (prim 138 offset target (cons rot zoom)))
    (define (begin-mode2d cam)                      (prim 139 cam))
    (define (end-mode2d)                            (prim 140))
    (define (set-target-fps! fps)                   (prim 150 fps))
    (define (fps)                                   (prim 151))
    (define (frame-time)                            (prim 152))
    (define (time)                                  (prim 153))
    (define (color-normalize c)                     (prim 154 c))
    (define color->number I)
    (define (color->hsv c)                          (prim 155 c))
    (define (fade c alpha)                          (prim 157 c alpha))
    (define (set-config-flags! f)                   (prim 158 f))
    (define (set-tracelog-level! l)                 (prim 159 l))
    (define (take-screenshot! path)                 (prim 162 path))
    (define (dropped-files)                         (prim 163))
    (define (open-url url)                          (prim 164 url))

    (define (key-pressed? k)  (prim 165 k))
    (define (key-down? k)     (prim 166 k))
    (define (key-released? k) (prim 167 k))
    (define (key-up? k)       (prim 168 k))
    (define (key-pressed)     (prim 169))
    (define (set-exit-key! k) (prim 170 k))

    (define (gamepad-available? n)          (prim 171 n))
    (define (gamepad-name n)                (prim 172 n))
    (define (gamepad-btn-pressed? n)        (prim 173 n))
    (define (gamepad-btn-down? n)           (prim 174 n))
    (define (gamepad-btn-released? n)       (prim 175 n))
    (define (gamepad-btn-up? n)             (prim 176 n))
    (define (gamepad-btn-pressed)           (prim 177))
    (define (gamepad-axis-count n)          (prim 178 n))
    (define (gamepad-axis-movement n axis)  (prim 179 n axis))

    (define (mouse-btn-pressed? b)    (prim 180 b))
    (define (mouse-btn-down? b)       (prim 181 b))
    (define (mouse-btn-released? b)   (prim 182 b))
    (define (mouse-btn-up? b)         (prim 183 b))
    (define (mouse-x)                 (prim 184))
    (define (mouse-y)                 (prim 185))
    (define (mouse-pos)               (prim 186))
    (define (set-mouse-pos! x y)      (prim 187 x y))
    (define (set-mouse-offset! x y)   (prim 188 x y))
    (define (set-mouse-scale! sx sy)  (prim 189 sx sy))
    (define (mouse-wheel)             (prim 190))

    (define (touch-x) (prim 191))
    (define (touch-y) (prim 192))
    (define (touch-pos) (prim 193))

    (define (set-gestures-enabled! flags) (prim 194 flags))
    (define (gesture-detected? g) (prim 195 g))
    (define (gesture-detected) (prim 196))
    (define (touch-points-count) (prim 197))
    (define (gesture-hold-duration) (prim 198))
    (define (gesture-drag-vector) (prim 199))
    (define (gesture-drag-angle) (prim 200))
    (define (gesture-pinch-vector) (prim 201))
    (define (gesture-pinch-angle) (prim 202))


    (define-syntax draw
      (syntax-rules ()
        ((draw exp1 ...)
         (begin
           (begin-drawing)
           exp1 ...
           (end-drawing)))))

    ;; while !window-should-close do
    (define-syntax with-window
      (syntax-rules ()
        ((with-window e ...)
         (let loop ()
           (if (window-should-close?)
               0
               (begin
                 e ...
                 (loop)))))))


    ))
