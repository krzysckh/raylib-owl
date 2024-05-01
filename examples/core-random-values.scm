(import
 (owl toplevel)
 (owl random)
 (raylib))

(lambda (args)
  (set-target-fps! 60)
  (with-window
   800 450 "raylib [core] example - basic window"
   (let mainloop ((seed (seed->rands 420)) (frames 0) (r 0))
     (lets ((seed r (if (= frames 120) (rand-range seed -8 5) (values seed r)))
            (frames (modulo frames 120)))
       (draw
        (clear-background raywhite)
        (draw-text-simple "Every 2 seconds a new random value is generated:" '(130 100) 20 maroon)
        (draw-text-simple (number->string r) '(360 180) 80 lightgray))
       (if (window-should-close?) 0 (mainloop seed (+ frames 1) r))))))


;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
