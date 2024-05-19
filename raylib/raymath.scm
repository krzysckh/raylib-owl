(define-library
    (raylib raymath)

  (import
   (owl toplevel)
   (raylib common))

  (export
   clamp
   lerp
   normalize
   remap
   wrap
   vec2zero
   vec2one
   vec2+
   vec2+val
   vec2-
   vec2-val
   vec2length
   vec2lensqr
   vec2dotprod
   vec2dist
   vec2distsqr
   vec2angle
   vec2lineangle
   vec2scale
   vec2*
   vec2negate
   vec2/
   vec2normalize
   vec2lerp
   vec2reflect
   vec2min
   vec2max
   vec2rotate
   vec2move-towards
   vec2invert
   vec2clamp
   vec2clampvalue
   vec2eq?
   vec2refract
   )

  (begin
    (define (clamp val min max)                    (prim 500 val min max))
    (define (lerp start end amount)                (prim 501 start end amount))
    (define (normalize value start end)            (prim 502 value start end))
    (define (remap value istart iend ostart oend)  (prim 503 value istart (list iend ostart oend)))
    (define (wrap val min max)                     (prim 504 val min max))
    (define (vec2zero)                             (prim 505 ))
    (define (vec2one)                              (prim 506 ))
    (define (vec2+ v1 v2)                          (prim 507 v1 v2))
    (define (vec2+val v add)                       (prim 508 v add))
    (define (vec2- v1 v2)                          (prim 509 v1 v2))
    (define (vec2-val v sub)                       (prim 510 v sub))
    (define (vec2length v)                         (prim 511 v))
    (define (vec2lensqr v)                         (prim 512 v))
    (define (vec2dotprod v1 v2)                    (prim 513 v1 v2))
    (define (vec2dist v1 v2)                       (prim 514 v1 v2))
    (define (vec2distsqr v1 v2)                    (prim 515 v1 v2))
    (define (vec2angle v1 v2)                      (prim 516 v1 v2))
    (define (vec2lineangle v1 v2)                  (prim 517 v1 v2))
    (define (vec2scale v scale)                    (prim 518 v scale))
    (define (vec2* v1 v2)                          (prim 519 v1 v2))
    (define (vec2negate v)                         (prim 520 v))
    (define (vec2/ v1 v2)                          (prim 521 v1 v2))
    (define (vec2normalize v)                      (prim 522 v))
    (define (vec2lerp v1 v2 amount)                (prim 524 v1 v2 amount))
    (define (vec2reflect v normal)                 (prim 525 v normal))
    (define (vec2min v1 v2)                        (prim 526 v1 v2))
    (define (vec2max v1 v2)                        (prim 527 v1 v2))
    (define (vec2rotate v angle)                   (prim 528 v angle))
    (define (vec2move-towards v target max-dist)   (prim 529 v target max-dist))
    (define (vec2invert v)                         (prim 530 v))
    (define (vec2clamp v min max)                  (prim 531 v min max))
    (define (vec2clampvalue v min max)             (prim 532 v min max))
    (define (vec2eq? p q)                          (prim 533 p q))
    (define (vec2refract v n r)                    (prim 534 v n r))
    ))
