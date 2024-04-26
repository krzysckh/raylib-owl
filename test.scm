(import
 (owl toplevel)
 (owl lazy)
 (prefix (owl sys) sys/)
 (raylib common)
 (raylib))


(define blue  (color 0 0 255 255))
(define white (color 255 255 255 255))
(define bg    #x222222)

(define triangle-pts '((100 400) (300 500) (500 500)))
(define image (list->bytevector (file->list "/home/kpm/Documents/img/bjaaarne.png")))
(define font (list->bytevector (file->list "/home/kpm/.fonts/COMIC.TTF")))

(define (grad-circle pos r)
  (draw-circle-gradient
   pos r (color 255 0 0 255) (color 0 0 255 255)))

(lambda (args)
  (print "image len: " (bytevector-length image))
  (print "font len: " (bytevector-length font))

  (set-target-fps! 30)

  (with-window
   800 600 "hemlo"
   (let* ((bjarne (image->texture (list->image ".png" (bytevector->list image))))
          (font (list->font (bytevector->list font) ".ttf" 45 0)))
     (let loop ((r 20) (points '()))
      (draw
       (clear-background bg)

       (draw-texture-pro
        bjarne
        '(0 0 603 324)
        '(0 0 800 300)
        '(0 0)
        0 white)

       (let ((c (if (collision-point-triangle? (mouse-pos) triangle-pts) blue white)))
         (draw-triangle triangle-pts c))

       (draw-text font "holy hell is that bjarne soup" '(300 300) 45 1 white)

       (draw-fps '(700 500))
       (for-each (λ (p) (grad-circle (car p) (cadr p))) points)

       (grad-circle (mouse-pos) r))

      (if (window-should-close?)
          0
          (loop (max 1 (+ r (* 10 (mouse-wheel))))
                (if (mouse-btn-pressed? 0)
                    (append points (list (list (mouse-pos) r)))
                    points)))))))
