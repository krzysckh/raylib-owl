(define-library (raylib)
  (import
   (owl toplevel)
   (owl string))

  (export
   draw

   init-window
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

    (define-syntax draw
      (syntax-rules ()
        ((draw exp1 ...)
         (begin
           (begin-drawing)
           exp1 ...
           (end-drawing)))))

    (define (init-window width height title)
      (prim 100 width height (c-string title)))

    (define (window-should-close?)
      (prim 101))

    (define (close-window)
      (prim 102))

    (define (window-ready?)
      (prim 103))

    (define (window-minimized?)
      (prim 104))

    (define (window-maximized?)
      (prim 105))

    (define (window-resized?)
      (prim 106))

    (define (window-state? flag)
      (prim 107 flag))

    (define (set-window-state! flags)
      (prim 108 flags))

    (define (clear-window-state! flags)
      (prim 109 flags))

    (define (toggle-fullscreen!)
      (prim 110))

    (define (set-window-icon! image)
      (prim 111 image))

    (define (set-window-title! title)
      (prim 112 title))

    (define (set-window-position! x y)
      (prim 113 x y))

    (define (set-window-monitor! monitor)
      (prim 114 monitor))

    (define (set-window-min-size! w h)
      (prim 115 w h))

    (define (set-window-size! w h)
      (prim 116 w h))

    (define (window-handle)
      (prim 117))

    (define (window-width)
      (prim 118))

    (define (window-height)
      (prim 119))

    (define (window-size)
      (cons (window-width) (window-height)))

    (define (monitor-count)
      (prim 120))

    (define (monitor-width monitor)
      (prim 121 monitor))

    (define (monitor-height monitor)
      (prim 122 monitor))

    (define (monitor-size monitor)
      (cons (monitor-width monitor)
            (monitor-height monitor)))

    (define (monitor-physical-width monitor)
      (prim 123 monitor))

    (define (monitor-physical-height monitor)
      (prim 124 monitor))

    (define (monitor-name monitor)
      (prim 125 monitor))

    (define (clipboard)
      (prim 126))

    (define (set-clipboard! text)
      (prim 127 text))

    ))
