(import
 (owl toplevel)
 (raylib))

(lambda (args)
  (with-window
   800 450 "raylib [core] example - basic window"
   (with-mainloop
    (draw
     (clear-background raywhite)
     (draw-text-simple "Congrats! You created your first window!" '(190 200) 20 lightgray)))))

;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
