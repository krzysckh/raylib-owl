(import
 (owl toplevel)
 (raylib common)
 (raylib))


(define blue  (color 0 0 255 255))
(define white (color 255 255 255 255))
(define bg    #x222222)

(define triangle-pts '((100 400) (300 500) (500 500)))

(lambda (args)
  (with-window
   800 600 "hemlo"
   (begin
     (define image (load-image "/home/kpm/Documents/img/bjaaarne.png"))
     (define texture (image->texture image))

     (with-mainloop
      (draw
       (clear-background bg)

       (draw-circle-gradient
        (vec 100.45 200)
        30
        (color 255 0 0 255)
        (color 0 0 255 255))

       (let ((c (if (collision-point-triangle? (mouse-pos) triangle-pts) blue white)))
         (draw-triangle triangle-pts c))
       ))
     ))

  0)
