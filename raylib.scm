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
   )

  (export
   draw
   with-window
   with-mainloop

   vec vec2 vec3 vec4 make-vector ;; same stuff
   rec rectangle rect ;; same

   lightgray gray darkgray yellow gold orange pink
   red maroon green lime darkgreen skyblue blue
   darkblue purple violet darkpurple beige brown
   darkbrown white black blank magenta raywhite

   (exports (raylib window))
   (exports (raylib io))
   (exports (raylib draw))
   (exports (raylib util))
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

    (define colors
      (list
       lightgray gray darkgray yellow gold orange pink
       red maroon green lime darkgreen skyblue blue
       darkblue purple violet darkpurple beige brown
       darkbrown white black blank magenta raywhite))

    (define-syntax draw
      (syntax-rules ()
        ((draw exp1 ...)
         (begin
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
