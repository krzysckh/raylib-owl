(import
 (owl toplevel)
 (owl proof)
 (raylib))

(define (f x y) (band x y))

(define l (let loop ((x 0) (y 0) (acc #n))
            (cond
             ((>= y 50) acc)
             ((>= x 50) (print y) (loop 0 (+ y 1) acc))
             (else
              (loop (+ x 1) y (append acc (if (= (f x y) 0) '(0 0 0 255) '(255 255 255 255))))))))

(lambda (args)
  (set-memory-limit (<< 2 16))
  (with-window
   400 400 "make-image example"
   (let* ((bv (list->bytevector l))
          (i (image-color-replace (image-color-invert (make-image 50 50 bv)) white red))
          (t (image->texture i)))

     (example (len (image->list-palette i 10)) = 2)
     (example (len (image->list i)) = (* 50 50))

     (with-mainloop
      (draw
       (clear-background red)
       (draw-texture-ex t '(0 0) 0 5 white))))))

;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
