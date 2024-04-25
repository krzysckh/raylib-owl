(define-library (raylib draw)
  (import
   (owl toplevel)
   (owl core)
   (raylib common))

  (export
   draw-pixel
   draw-rectangle
   draw-rectangle-lines
   draw-line
   draw-line-ex
   draw-line-bezier
   draw-line-strip
   draw-circle-sector
   draw-circle-sector-lines
   draw-circle-gradient
   draw-circle
   draw-circle-lines
   draw-ring
   draw-ring-lines
   draw-rectangle-gradient-v
   draw-rectangle-gradient-h
   draw-rectangle-gradient-ex
   draw-rectangle-rounded
   draw-rectangle-rounded-lines
   draw-triangle
   draw-triangle-lines
   draw-triangle-fan
   draw-triangle-strip
   draw-poly
   )

  (begin
    (define draw-pixel
      (case-lambda
       ((x y color) (prim 209 x y color))
       ((v color) (prim 210 v color))))

    (define (draw-line p1 p2 color)
      (prim 211 p1 p2 color))

    (define (draw-line-ex p1 p2 thick color)
      (prim 212 p1 p2 (list thick color)))

    (define (draw-line-bezier p1 p2 thick color)
      (prim 213 p1 p2 (list thick color)))

    (define (draw-line-strip pts color)
      (prim 214 pts (length pts) color))

    (define (draw-circle-sector pos rad start-angle end-angle segments color)
      (prim 215 pos (list rad start-angle end-angle segments) color))

    (define (draw-circle-sector-lines pos rad start-angle end-angle segments color)
      (prim 216 pos (list rad start-angle end-angle segments) color))

    (define (draw-circle-gradient pos rad color1 color2)
      (prim 217 pos rad (list color1 color2)))

    (define (draw-circle pos rad color)
      (prim 218 pos rad color))

    (define (draw-circle-lines pos rad color)
      (prim 219 pos rad color))

    (define (draw-ring center inner-rad outer-rad start-ang end-ang segments color)
      (prim 220 center (list inner-rad outer-rad)
            (list start-ang end-ang segments color)))

    (define (draw-ring-lines center inner-rad outer-rad start-ang end-ang segments color)
      (prim 221 center (list inner-rad outer-rad)
            (list start-ang end-ang segments color)))

    (define draw-rectangle
      (case-lambda
       ((x y w h color) (prim 222 (list x y) (list w h) color))
       ((pos sizing color) (prim 222 pos sizing color))
       ((rec color) (prim 223 rec color))
       ((rec origin rot color) (prim 224 rec origin (list rot color)))))

    (define (draw-rectangle-gradient-v pos w h col1 col2)
      (prim 225 pos (list w h) (list col1 col2)))

    (define (draw-rectangle-gradient-h pos w h col1 col2)
      (prim 226 pos (list w h) (list col1 col2)))

    (define (draw-rectangle-gradient-ex rec col1 col2 col3 col4)
      (prim 227 rec (list col1 col2) (list col3 col4)))

    (define draw-rectangle-lines
      (case-lambda
       ((rec col) (prim 228 rec 1 col))
       ((rec thick col) (prim 228 rec thick col))))

    (define (draw-rectangle-rounded rect roundness segments color)
      (prim 229 rect (list roundness segments) color))

    (define (draw-rectangle-rounded-lines rect roundness segments color)
      (prim 230 rect (list roundness segments) color))

    (define draw-triangle
      (case-lambda
       ((p1 p2 p3 color) (prim 231 (list p1 p2 p3) color))
       ((l color)        (prim 231 l color))))

    (define draw-triangle-lines
      (case-lambda
       ((p1 p2 p3 color) (prim 232 (list p1 p2 p3) color))
       ((l color)        (prim 232 l color))))

    (define draw-triangle-fan
      (case-lambda
       ((p1 p2 p3 color) (prim 233 (list p1 p2 p3) color))
       ((l color)        (prim 233 l color))))

    (define draw-triangle-strip
      (case-lambda
       ((p1 p2 p3 color) (prim 234 (list p1 p2 p3) color))
       ((l color)        (prim 234 l color))))

    (define (draw-poly center sides radius rot color)
      (prim (list sides radius rot) color))

    ))
