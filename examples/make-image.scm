(import
 (owl toplevel)
 (owl proof)
 (raylib))

(define (f x y) (band x y))

(define bv (list->bytevector
            (let loop ((x 0) (y 0) (acc #n))
              (cond
               ((>= y 50) acc)
               ((>= x 50) (print y) (loop 0 (+ y 1) acc))
               (else
                (loop (+ x 1) y (append acc (if (= (f x y) 0) '(0 0 0 255) '(255 255 255 255)))))))))

(define texture-filters
  (vector
   (cons 'point           texture-filter-point)
   (cons 'bilinear        texture-filter-bilinear)
   (cons 'trilinear       texture-filter-trilinear)
   (cons 'anisotropic-4x  texture-filter-anisotropic-4x)
   (cons 'anisotropic-8x  texture-filter-anisotropic-8x)
   (cons 'anisotropic-16x texture-filter-anisotropic-16x)))

(lambda (args)
  (set-memory-limit (<< 2 16))
  (set-target-fps! 30)
  (with-window
   400 400 "make-image example"
   (let* ((i (image-color-replace (image-color-invert (make-image 50 50 bv)) white red))
          (t (image->texture i)))

     (example (len (image->list-palette i 10)) = 2)
     (example (len (image->list i)) = (* 50 50))

     (set-window-state! flag-window-resizable)
     (let loop ((cur -1))
       (draw
        (clear-background red)
        (draw-texture-pro t '(0 0 50 50) (list 0 0 (window-width) (window-height)) '(0 0) 0 white)
        (when (>= cur 0)
          (draw-text-simple (str (car (vector-ref texture-filters cur))) '(0 0) 36 white)))
       (cond
        ((key-pressed? key-space)
         (let ((cur (modulo (+ cur 1) (vector-length texture-filters))))
           (set-texture-filter! t (cdr (vector-ref texture-filters cur)))
           (loop cur)))
        ((window-should-close?) 0)
        (else
         (loop cur)))))))


;; Local Variables:
;; mode: scheme
;; eval: (setq compile-command (concat "../ol-rl -r " (buffer-file-name)))
;; End:
