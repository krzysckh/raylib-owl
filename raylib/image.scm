(define-library (raylib image)
  (import
   (owl toplevel)
   (raylib common))

  (export
   img-format
   img-to-pot
   img-alpha-crop
   img-alpha-clear
   img-alpha-mask
   img-alpha-premultiply
   img-blur-gaussian
   img-resize
   img-resize-nn
   img-mipmaps
   img-dither
   img-flip-v
   img-flip-h
   img-rotate
   img-rotate-cw
   img-rotate-ccw
   img-color-tint
   img-color-invert
   img-color-grayscale
   img-color-contrast
   img-color-brightness
   img-color-replace
   )

  (begin
    (define (img-format img t)           (prim 341 img t))
    (define (img-to-pot img c)           (prim 342 img c))
    (define (img-alpha-crop img fl)      (prim 343 img fl))
    (define (img-alpha-clear img c fl)   (prim 344 img c fl))
    (define (img-alpha-mask img1 img2)   (prim 345 img1 img2))
    (define (img-alpha-premultiply i)    (prim 346 i))
    (define (img-blur-gaussian i f)      (prim 347 i f))
    (define (img-resize i w h)           (prim 348 i w h))
    (define (img-resize-nn i w h)        (prim 349 i w h))
    (define (img-mipmaps i)              (prim 350 i))
    (define (img-dither i r g b a)       (prim 351 i (cons r g) (cons b a)))
    (define (img-flip-v i)               (prim 352 i))
    (define (img-flip-h i)               (prim 353 i))
    (define (img-rotate i deg)           (prim 354 deg))
    (define (img-rotate-cw i)            (prim 355))
    (define (img-rotate-ccw i)           (prim 356))
    (define (img-color-tint i c)         (prim 357 i c))
    (define (img-color-invert i)         (prim 358 i))
    (define (img-color-grayscale i)      (prim 359 i))
    (define (img-color-contrast i flt)   (prim 360 i))
    (define (img-color-brightness i n)   (prim 361 i n))
    (define (img-color-replace i c1 c2)  (prim 362 i c1 c2))

    ))
