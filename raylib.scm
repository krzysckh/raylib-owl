(define-library (raylib)
;; TODO: check types
  (import
   (owl toplevel)
   (owl string)
   (owl core)

   (raylib common)

   (raylib window)
   (raylib io)
   (raylib draw)
   (raylib util)
   (raylib audio)
   (raylib const)
   (raylib raymath)
   (raylib image)
   )

  (export
   draw
   with-window
   with-mainloop

   vec vec2 vec3 vec4 make-vector ;; same stuff
   rec rectangle rect ;; same

   (exports (raylib window))
   (exports (raylib io))
   (exports (raylib draw))
   (exports (raylib util))
   (exports (raylib audio))
   (exports (raylib const))
   (exports (raylib raymath))
   (exports (raylib image))
   )

  (begin
    ;; this sucks
    ;; TODO: check if still needed
    (define (ensure-rational f)
      (read (number->string f)))

    (define (vec2 a b)
      (list (ensure-rational a)
            (ensure-rational b)))

    (define (vec3 a b c)
      (list (ensure-rational a)
            (ensure-rational b)
            (ensure-rational c)))

    (define (vec4 a b c d)
      (list (ensure-rational a)
            (ensure-rational b)
            (ensure-rational c)
            (ensure-rational d)))

    (define rectangle vec4)
    (define rect vec4)
    (define rec vec4)

    (define vec
      (case-lambda
       ((a b) (vec2 a b))
       ((a b c) (vec3 a b c))
       ((a b c d) (vec4 a b c d))))

    (define make-vector vec)

    (define-syntax draw
      (syntax-rules ()
        ((draw exp1 ...)
         (when (window-ready?)
           (begin-drawing)
           exp1 ...
           (end-drawing)))))

    ;; while !window-should-close do
    (define-syntax with-mainloop
      (syntax-rules ()
        ((with-window e ...)
         (let loop ()
           (if (window-should-close?)
               0
               (begin
                 e ...
                 (loop)))))))

    ;; create window. only 1 exp afterwards
    (define-syntax with-window
      (syntax-rules ()
        ((with-window width height title exp1)
         (begin
           (init-window width height title)
           (let ((res exp1))
             (close-window)
             res)))))
    ))
