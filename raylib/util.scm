(define-library
    (raylib util)

  (import
   (owl toplevel)
   (owl core)
   (raylib common))

  (export
   collision-rects?
   collision-circles?
   collision-circle-rect?
   collision-rects
   collision-point-rect?
   collision-point-circle?
   collision-point-triangle?

   truncate-precision

   image-color
   image-gradient-linear
   image-gradient-radial
   image-gradient-square
   image-checked
   bytevector->image
   make-image
   )

  (begin
    (define (collision-rects? rec1 rec2) (prim 237 rec1 rec2))
    (define (collision-circles? c1 rad1 c2 rad2) (prim 238 (list c1 rad1) (list c2 rad2)))
    (define (collision-circle-rect? center rad rect) (prim 239 center rad rect))
    (define (collision-rects rec1 rec2) (prim 240 rec1 rec2))
    (define (collision-point-rect? pt rect) (prim 241 pt rect))
    (define (collision-point-circle? pt center rad) (prim 242 pt center rad))
    (define collision-point-triangle?
      (case-lambda
       ((pt p1 p2 p3) (prim 243 pt (list p1 p2 p3)))
       ((pt l)        (prim 243 pt l))))

    (define (truncate-precision n . max-precision)
      (lets ((max-precision (if (null? max-precision) 50 (car max-precision)))
             (l (numerator n))
             (m (denominator n))
             (trunc-1 (- (log 10 l) max-precision))
             (trunc-2 (- (log 10 m) max-precision))
             (trunc (max trunc-1 trunc-2))
             (a1 b1 (if (negative? trunc) (values l 0) (truncate/ l (expt 10 trunc))))
             (a2 b2 (if (negative? trunc) (values m 0) (truncate/ m (expt 10 trunc)))))
            (/ a1 a2)))

    (define (image-color w h c) (prim 335 w h c))
    (define (image-gradient-linear w h dir start end)
      (prim 336 (cons w h) dir (cons start end)))
    (define (image-gradient-radial w h density inner outer)
      (prim 337 (cons w h) density (cons inner outer)))
    (define (image-gradient-square w h density inner outer)
      (prim 338 (cons w h) density (cons inner outer)))
    (define (image-checked w h cx cy c1 c2)
      (prim 339 (cons w h) (cons cx cy) (cons c1 c2)))

    ;; bv in format R8G8B8A8
    (define (bytevector->image w h bv)
      (prim 340 w h bv))
    (define make-image bytevector->image)

    ))
