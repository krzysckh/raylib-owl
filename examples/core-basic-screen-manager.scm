(import
 (owl toplevel)
 (raylib))

(lambda (args)
  (set-target-fps! 60)
  (with-window
   800 450 "raylib [core] example - basic screen manager"
   (let loop ((cur-screen 'logo) (frame-ctr 0))
     (cond
      ((window-should-close?) 0)
      ((eqv? cur-screen 'logo)
       (draw
        (clear-background raywhite)
        (draw-text-simple "LOGO SCREEN" '(20 20) 40 lightgray)
        (draw-text-simple "WAIT for 2 SECONDS..." '(290 220) 20 gray))
       (if (> frame-ctr 120) (loop 'title -1) (loop 'logo (+ frame-ctr 1))))
      ((eqv? cur-screen 'title)
       (draw
        (clear-background green)
        (draw-text-simple "TITLE SCREEN" '(20 20) 40 darkgreen)
        (draw-text-simple "PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN" '(120 220) 20 darkgreen))
       (if (or (key-pressed? 257) ;; TODO: KEY-ENTER and the rest of constants
               (gesture-detected? 1))
           (loop 'gameplay frame-ctr)
           (loop cur-screen frame-ctr)))
      ((eqv? cur-screen 'gameplay)
       (draw
        (clear-background purple)
        (draw-text-simple "GAMEPLAY SCREEN" '(20 20) 40 maroon)
        (draw-text-simple "PRESS ENTER or TAP to JUMP to ENDING SCREEN" '(130 220) 20 maroon))
       (if (or (key-pressed? 257)
               (gesture-detected? 1))
           (loop 'ending frame-ctr)
           (loop cur-screen frame-ctr)))
      ((eqv? cur-screen 'ending)
       (draw
        (clear-background blue)
        (draw-text-simple "ENDING SCREEN" '(20 20) 40 darkblue)
        (draw-text-simple "PRESS ENTER or TAP to RETURN to TITLE SCREEN" '(120 220) 20 darkblue))
       (if (or (key-pressed? 257)
               (gesture-detected? 1))
           (loop 'title frame-ctr)
           (loop cur-screen frame-ctr)))))))


;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
