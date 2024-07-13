(import
 (owl toplevel)
 (raylib))

(define (f x y) (band x y))

(define l (let loop ((x 0) (y 0) (acc #n))
            (cond
             ((>= y 50) acc)
             ((>= x 50) (print y) (loop 0 (+ y 1) acc))
             (else
              (loop (+ x 1) y (append acc (if (= (f x y) 0) '(0 0 0 255) '(255 255 255 255))))))))

(lambda (args)
  (with-window
   400 400 "make-image example"
   (let* ((bv (list->bytevector l))
          (t (image->texture (img-color-replace (img-color-invert (make-image 50 50 bv)) white red))))
     (with-mainloop
      (draw
       (clear-background red)
       (sys-prim 255 t '(0 0) (list 0 5 white))))))) ;; TODO: case-lambda-too-large on draw-texture

;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
