(define-library (raylib window)
;; TODO: check types
  (import
   (owl toplevel)
   (owl string)
   (owl core)
   (raylib common))

  (export
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
   make-color
   color

   set-config-flags!
   set-tracelog-level!
   take-screenshot!

   dropped-files
   open-url

   begin-camera2d-mode
   end-camera2d-mode

   window-fullscreen?
   window-hidden?
   window-maximized?
   window-focused?
   toggle-borderless-windowed
   window-maximize
   window-minimize
   window-restore
   set-window-icons!
   set-window-max-size!
   set-window-opacity!
   set-window-focused!
   render-width
   render-height
   render-size
   current-monitor
   monitor-position
   monitor-refresh-rate
   window-position
   window-scale-dpi
   enable-event-waiting!
   disable-event-waiting!
   begin-scissor-mode
   end-scissor-mode

   swap-screen-buffer
   poll-input-events
   wait-time
   set-random-seed!
   random-value
   random-sequence
   set-mouse-cursor!

   with-camera2d
   with-scissors
   )

  (begin
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
    (define color make-color)

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

    (define (begin-camera2d-mode offset target rotation zoom)
      (prim 139 offset target (list rotation zoom)))

    (define (end-camera2d-mode)
      (prim 140))

    (define (window-fullscreen?)          (prim 305))
    (define (window-hidden?)              (prim 306))
    (define (window-maximized?)           (prim 307))
    (define (window-focused?)             (prim 308))
    (define (toggle-borderless-windowed)  (prim 309))
    (define (window-maximize)             (prim 310))
    (define (window-minimize)             (prim 311))
    (define (window-restore)              (prim 312))
    (define (set-window-icons! icons)     (prim 313 icons))
    (define (set-window-max-size! w h)    (prim 314 w h))
    (define (set-window-opacity! flt)     (prim 315 flt))
    (define (set-window-focused!)         (prim 316))
    (define (render-width)                (prim 317))
    (define (render-height)               (prim 318))
    (define (render-size)                 (list (render-width) (render-height)))
    (define (current-monitor)             (prim 319))
    (define (monitor-position n)          (prim 320 n))
    (define (monitor-refresh-rate n)      (prim 321 n))
    (define (window-position)             (prim 322))
    (define (window-scale-dpi)            (prim 323))
    (define (enable-event-waiting!)       (prim 324))
    (define (disable-event-waiting!)      (prim 325))
    (define (begin-scissor-mode x y w h)  (prim 326 (cons x y) (cons w h)))
    (define (end-scissor-mode)            (prim 327))
    (define (swap-screen-buffer)          (prim 328))
    (define (poll-input-events)           (prim 329))
    (define (wait-time t)                 (prim 330 t))
    (define (set-random-seed! s)          (prim 331 s))
    (define (random-value min max)        (prim 332 min max))
    (define (random-sequence N min max)   (prim 333 N min max))

    (define (set-mouse-cursor! c)         (prim 334 c))

    (define-syntax with-scissors
      (syntax-rules ()
        ((with-scissors x y w h e ...)
         (begin
           (begin-scissor-mode x y w h)
           e ...
           (end-scissor-mode)))
        ((with-scissors s e ...)
         (begin
           (apply begin-scissor-mode s)
           e ...
           (end-scissor-mode)))))

    (define-syntax with-camera2d
      (syntax-rules ()
        ((with-camera2d offset target rotation zoom e ...)
         (begin
           (begin-camera2d-mode offset target rotation zoom)
           e ...
           (end-camera2d-mode)))
        ((with-camera2d cam e ...)
         (begin
           (apply begin-camera2d-mode cam)
           e ...
           (end-camera2d-mode)))))
    ))
