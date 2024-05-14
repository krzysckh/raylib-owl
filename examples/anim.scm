;; -*- mode: scheme; compile-command: "ol-rl -r anim.scm" -*-

(import
 (owl toplevel)
 (raylib))

(define width 600)
(define height width)

(define speed 512)

;; anim = (n-frame (pos-x pos-y))
(define (anim-deltas n)
  (values
   (truncate-precision (* (frame-time) speed n))
   (truncate-precision (* (frame-time) speed n))))

(define (draw-anim anim)
  (lets ((n (car anim))
         (pos (cadr anim))
         (dx dy (anim-deltas n)))

    (for-each (lambda (p) (draw-rectangle (append p (list 10 10)) (list 5 5) (* n 13) red))
              (list
               ;; diag
               (list (+ (car pos) dx) (+ (cadr pos) dy))
               (list (+ (car pos) dx) (- (cadr pos) dy))
               (list (- (car pos) dx) (+ (cadr pos) dy))
               (list (- (car pos) dx) (- (cadr pos) dy))
               ;; normal
               (list (- (car pos) dx) (cadr pos))
               (list (+ (car pos) dx) (cadr pos))
               (list (car pos) (- (cadr pos) dy))
               (list (car pos) (+ (cadr pos) dy))))

    (append (list (+ 1 n)) (list pos))))
;; Add to frame ctr  ^^^^

(define (on-screen? anim)
  (lets ((n (car anim))
         (dx dy (anim-deltas n)))
    (and (> dx width) (> dy height))))

(define (not-on-screen? anim)
  (not (on-screen? anim)))

(lambda (_)
  (set-target-fps! 30)
  (with-window
   width height "a"
   (let loop ((anims '()))
     (begin-drawing) ;; cannot be in a (draw) block, because draw-anim updates anims, and also draws stuff,
                     ;; and the value of binding needs to be kept to loop later
     (clear-background black)
     (let* ((anims (map draw-anim anims))
            (anims (if (mouse-btn-down? mouse-button-left)
                       (append anims (list (list 0 (mouse-pos))))
                       anims))
            (anims (filter not-on-screen? anims)))
       (draw-fps '(0 0))
       (end-drawing)
       (if (window-should-close?)
           0
           (loop anims))))))
