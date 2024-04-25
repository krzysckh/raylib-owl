(import
 (owl toplevel)
 (owl lazy)
 (raylib common)
 (raylib))


(define blue  (color 0 0 255 255))
(define white (color 255 255 255 255))
(define bg    #x222222)

(define triangle-pts '((100 400) (300 500) (500 500)))
(define image (list->bytevector (file->list "/home/kpm/Documents/img/bjaaarne.png")))

(lambda (args)
  (print "image len: " (bytevector-length image))

  (with-window
   800 600 "hemlo"
   (let* ((texture (image->texture (list->image ".png" (bytevector->list image)))))
     (with-mainloop
      (draw
       (clear-background bg)

       (draw-texture-pro
        texture
        '(0 0 603 324)
        '(0 0 800 300)
        '(0 0)
        0 white)

       (let ((c (if (collision-point-triangle? (mouse-pos) triangle-pts) blue white)))
         (draw-triangle triangle-pts c))

       (draw-circle-gradient
        (mouse-pos)
        30
        (color 255 0 0 255)
        (color 0 0 255 255))

       ))
     ))

  0)
