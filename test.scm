(import
 (owl toplevel)
 (raylib))


(define black (color 0 0 0 255))
(define blue  (color 0 0 255 255))
(define white (color 255 255 255 255))
(define bg    #x222222)

(lambda (args)
  (init-window 800 600 "balsak")

  (with-window
   (draw
    (clear-background bg)

    (draw-circle-gradient
     (vec 200 200)
     30
     (color 255 0 0 255)
     (color 0 0 255 255))

    (draw-triangle (vec 400 400) (vec 300 500) (vec 500 500) white)

      ))

  (close-window)

  0)
