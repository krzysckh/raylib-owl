(define-library
    (raylib io)
  (import
   (owl toplevel)
   (owl core)
   (raylib common))

  (export
   key-pressed?
   key-down?
   key-released?
   key-up?
   key-pressed
   set-exit-key!

   gamepad-available?
   gamepad-name
   gamepad-btn-pressed?
   gamepad-btn-down?
   gamepad-btn-released?
   gamepad-btn-up?
   gamepad-btn-pressed
   gamepad-axis-count
   gamepad-axis-movement

   mouse-btn-pressed?
   mouse-btn-down?
   mouse-btn-released?
   mouse-btn-up?
   mouse-x
   mouse-y
   mouse-pos
   set-mouse-pos!
   set-mouse-offset!
   set-mouse-scale!
   mouse-wheel

   touch-x
   touch-y
   touch-pos

   set-gestures-enabled!
   gesture-detected?
   gesture-detected
   touch-points-count
   gesture-hold-duration
   gesture-drag-vector
   gesture-drag-angle
   gesture-pinch-vector
   gesture-pinch-angle

   load-image
   list->image
   export-image
   load-texture
   image->texture
   load-texture-cubemap
   unload-image
   unload-texture
   unload-render-texture
   screen->image

   get-font-default
   load-font
   image->font
   unload-font
   list->font
   )

  (begin
    (define (key-pressed? k)  (prim 165 k))
    (define (key-down? k)     (prim 166 k))
    (define (key-released? k) (prim 167 k))
    (define (key-up? k)       (prim 168 k))
    (define (key-pressed)     (prim 169))
    (define (set-exit-key! k) (prim 170 k))

    (define (gamepad-available? n)          (prim 171 n))
    (define (gamepad-name n)                (prim 172 n))
    (define (gamepad-btn-pressed? n)        (prim 173 n))
    (define (gamepad-btn-down? n)           (prim 174 n))
    (define (gamepad-btn-released? n)       (prim 175 n))
    (define (gamepad-btn-up? n)             (prim 176 n))
    (define (gamepad-btn-pressed)           (prim 177))
    (define (gamepad-axis-count n)          (prim 178 n))
    (define (gamepad-axis-movement n axis)  (prim 179 n axis))

    (define (mouse-btn-pressed? b)    (prim 180 b))
    (define (mouse-btn-down? b)       (prim 181 b))
    (define (mouse-btn-released? b)   (prim 182 b))
    (define (mouse-btn-up? b)         (prim 183 b))
    (define (mouse-x)                 (prim 184))
    (define (mouse-y)                 (prim 185))
    (define (mouse-pos)               (prim 186))
    (define (set-mouse-pos! x y)      (prim 187 x y))
    (define (set-mouse-offset! x y)   (prim 188 x y))
    (define (set-mouse-scale! sx sy)  (prim 189 sx sy))
    (define (mouse-wheel)             (prim 190))

    (define (touch-x)    (prim 191))
    (define (touch-y)    (prim 192))
    (define (touch-pos)  (prim 193))

    (define (set-gestures-enabled! flags)  (prim 194 flags))
    (define (gesture-detected? g)          (prim 195 g))
    (define (gesture-detected)             (prim 196))
    (define (touch-points-count)           (prim 197))
    (define (gesture-hold-duration)        (prim 198))
    (define (gesture-drag-vector)          (prim 199))
    (define (gesture-drag-angle)           (prim 200))
    (define (gesture-pinch-vector)         (prim 201))
    (define (gesture-pinch-angle)          (prim 202))

    (define (load-image fname)               (prim 244 fname))
    (define (list->image type data)          (prim 245 (c-string type) data (length data)))
    (define (export-image img fname)         (prim 246 img fname))
    (define (load-texture fname)             (prim 247 fname))
    (define (image->texture img)             (prim 248 img))
    (define (load-texture-cubemap fname lt)  (prim 249 fname lt))
    (define (unload-image img)               (prim 250 img))
    (define (unload-texture txt)             (prim 251 txt))
    (define (unload-render-texture txt)      (prim 252 txt))
    (define (screen->image)                  (prim 253))


    (define (get-font-default) (prim 258))
    (define load-font
      (case-lambda
       ((fname) (prim 259 fname))
       ((fname font-size char-count) (prim 260 fname font-size char-count))))

    (define (image->font image key first-char) (prim 260 image key first-char))
    (define (unload-font f) (prim 261 f))
    (define (list->font lst type font-size n-chars) (prim 261 (c-string type) lst (list font-size n-chars)))

    ))
