(define-library (raylib image)
  (import
   (owl toplevel)
   (raylib common))

  (export
   image-format
   image-to-pot
   image-alpha-crop
   image-alpha-clear
   image-alpha-mask
   image-alpha-premultiply
   image-blur-gaussian
   image-resize
   image-resize-nn
   image-mipmaps
   image-dither
   image-flip-v
   image-flip-h
   image-rotate
   image-rotate-cw
   image-rotate-ccw
   image-color-tint
   image-color-invert
   image-color-grayscale
   image-color-contrast
   image-color-brightness
   image-color-replace

   gen-image-color
   gen-image-gradient-linear
   gen-image-gradient-radial
   gen-image-gradient-square
   gen-image-checked
   bytevector->image
   make-image
   )

  (begin
    (define (image-format img t)           (prim 341 img t))
    (define (image-to-pot img c)           (prim 342 img c))
    (define (image-alpha-crop img fl)      (prim 343 img fl))
    (define (image-alpha-clear img c fl)   (prim 344 img c fl))
    (define (image-alpha-mask img1 img2)   (prim 345 img1 img2))
    (define (image-alpha-premultiply i)    (prim 346 i))
    (define (image-blur-gaussian i f)      (prim 347 i f))
    (define (image-resize i w h)           (prim 348 i w h))
    (define (image-resize-nn i w h)        (prim 349 i w h))
    (define (image-mipmaps i)              (prim 350 i))
    (define (image-dither i r g b a)       (prim 351 i (cons r g) (cons b a)))
    (define (image-flip-v i)               (prim 352 i))
    (define (image-flip-h i)               (prim 353 i))
    (define (image-rotate i deg)           (prim 354 deg))
    (define (image-rotate-cw i)            (prim 355))
    (define (image-rotate-ccw i)           (prim 356))
    (define (image-color-tint i c)         (prim 357 i c))
    (define (image-color-invert i)         (prim 358 i))
    (define (image-color-grayscale i)      (prim 359 i))
    (define (image-color-contrast i flt)   (prim 360 i))
    (define (image-color-brightness i n)   (prim 361 i n))
    (define (image-color-replace i c1 c2)  (prim 362 i c1 c2))

    (define (gen-image-color w h c) (prim 335 w h c))
    (define (gen-image-gradient-linear w h dir start end)
      (prim 336 (cons w h) dir (cons start end)))
    (define (gen-image-gradient-radial w h density inner outer)
      (prim 337 (cons w h) density (cons inner outer)))
    (define (gen-image-gradient-square w h density inner outer)
      (prim 338 (cons w h) density (cons inner outer)))
    (define (gen-image-checked w h cx cy c1 c2)
      (prim 339 (cons w h) (cons cx cy) (cons c1 c2)))

    ;; bv in format R8G8B8A8
    (define (bytevector->image w h bv)
      (prim 340 w h bv))
    (define make-image bytevector->image)
    ))
