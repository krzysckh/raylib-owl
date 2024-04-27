(import
 (owl toplevel)
 (owl lazy)
 (prefix (owl sys) sys/)
 (raylib common)
 (raylib))

(define bg #x222222)

(define triangle-pts '((100 400) (300 500) (500 500)))
(define image (list->bytevector (file->list "/home/kpm/Documents/img/bjaaarne.jpg")))
(define font (list->bytevector (file->list "/home/kpm/.fonts/COMIC.TTF")))
(define v (halve (file->list "/home/kpm/Documents/mus/radlery32.mp3")))
(define sndf-1 (list->bytevector (cadr v)))
(define sndf-2 (list->bytevector (caddr v)))

(define (grad-circle pos r)
  (draw-circle-gradient
   pos r (color 255 0 0 255) (color 0 0 255 255)))

(lambda (args)
  (print "image len: " (bytevector-length image))
  (print "font len: " (bytevector-length font))
  (print "snd1 len: " (bytevector-length sndf-1))
  (print "snd2 len: " (bytevector-length sndf-2))

  (set-target-fps! 60)
  (set-config-flags! flag-window-resizable)

  (with-window
   800 600 "hemlo"
   (let* ((_ (init-audio-device))
          (bjarne (image->texture (list->image ".png" (bytevector->list image))))
          (font (list->font (bytevector->list font) ".ttf" 45 0))
          (snd (list->music-stream ".mp3" (append
                                           (bytevector->list sndf-1)
                                           (bytevector->list sndf-2)))))
     (play-music-stream snd)
     (let loop ((r 20) (points '()))
      (draw
       (clear-background bg)
       (update-music-stream snd)

       (draw-texture-pro
        bjarne
        '(0 0 603 324)
        `(0 0 ,(window-width) ,(/ (window-height) 2))
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
