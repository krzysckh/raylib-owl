(import
 (owl toplevel)
 (raylib))

(lambda (args)

  (init-window 800 600 "balsak")

  (let ((c (make-color 255 0 255 255)))
    (with-window
     (draw
      (clear-background c))))

  (close-window)

  0)
