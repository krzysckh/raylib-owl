(import
 (owl toplevel)
 (raylib))

(define scr-width 800)
(define scr-height 450)

(define n-buildings 100)
(define buildings
  (let loop ((rs (seed->rands 420)) (spacing 0) (acc '()))
    (if (= (length acc) n-buildings)
        acc
        (lets ((rs width  (rand-range rs 50 200))
               (rs height (rand-range rs 50 200))
               (rs r (rand-range rs 200 240))
               (rs g (rand-range rs 200 240))
               (rs b (rand-range rs 200 240))
               (y (- scr-height 130 height))
               (x (+ -6000 spacing)))
         (loop rs (+ spacing width)
               (append acc (list (list (make-color r g b 255) x y width height))))))))

(lambda (args)
  (set-target-fps! 60)
  (with-window
   scr-width scr-height "raylib [core] example - 2d camera"
   (let loop ((player '(400 280 40 40))
              (cam-offset (list (/ scr-width 2) (/ scr-height 2)))
              (cam-target '(420 300))
              (cam-rot 0)
              (cam-zoom 0))
     (if
      (window-should-close?) 0
      (let* ((player (if (key-down? 262) (append (list (+ (car player) 2)) (cdr player)) player))
             (player (if (key-down? 263) (append (list (- (car player) 2)) (cdr player)) player))
             (cam-target (map (λ (x) (+ x 20)) (take player 2)))
             (cam-rot (if (key-down? 65) (max (- cam-rot 1) -40) cam-rot))
             (cam-rot (if (key-down? 83) (min (+ cam-rot 1) 40) cam-rot))
             (cam-zoom (min (max (+ cam-zoom (* 5/100 (mouse-wheel))) 1/10) 3))
             (cam-zoom (if (key-pressed? 82) 1 cam-zoom))
             (cam-rot (if (key-pressed? 82) 0 cam-rot)))
        (draw
         (clear-background white)
         (with-camera2d
          cam-offset cam-target cam-rot cam-zoom
          (draw-rectangle '(-6000 320 13000 8000) darkgray)
          (for-each (λ (l) (draw-rectangle (cdr l) (car l))) buildings)
          (draw-rectangle player red)
          (draw-line-simple
           (car cam-target) (- 0 (* scr-height 10))
           (car cam-target) (* scr-height 10)
           green)
          (draw-line-simple
           (- 0 (* scr-width 10)) (cadr cam-target)
           (* scr-width 10)       (cadr cam-target)
           green))

         (draw-text-simple "SCREEN AREA" '(640 10) 20 red)

         (draw-rectangle-lines (list 0 0 scr-width scr-height) 5 red)
         (draw-rectangle '(10 10 250 113) (fade skyblue 0.5))
         (draw-rectangle-lines '(10 10 250 113) blue)

         (draw-text-simple "Free 2d camera controls:"       '(20 20)  10 black)
         (draw-text-simple "- Right/Left to move Offset"    '(40 40)  10 darkgray)
         (draw-text-simple "- Mouse Wheel to Zoom in-out"   '(40 60)  10 darkgray)
         (draw-text-simple "- A / S to Rotate"              '(40 80)  10 darkgray)
         (draw-text-simple "- R to reset Zoom and Rotation" '(40 100) 10 darkgray))
        (loop player cam-offset cam-target cam-rot cam-zoom))))))


;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
