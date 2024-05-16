(import
 (owl toplevel)
 (owl random)
 (owl list-extra)
 (raylib))

(define width 800)
(define height 600)

(define circle-rad 11)

(define init-max-len 300)
(define speed 5)

(define points (map (lambda (x) (string->symbol (string-append "el-" (number->string x)))) (iota 0 1 128)))
(define connections-pre
  (let loop ((n (length points)) (seed (seed->rands 2137)) (acc '()))
    (lets ((seed N (rand-range seed 1 8))
	   (seed cpts (let L ((seed seed) (N N) (acc '()))
			(lets ((seed pt (rand-range seed 0 (- (length points)
			1))))
			      (if (= N 0)
				  (values seed acc)
				  (L seed (- N 1) (append acc (list pt))))))))
	  (if (= n 0)
	      acc
	      (loop (- n 1) seed (append acc (list cpts)))))))

(define (update-con conns n add)
  (if (has? (list-ref conns n) add)
      conns
      (lset conns n (append (list-ref conns n) (list add)))))

(define connections
  (let loop ((n 0) (connections connections-pre))
    (let* ((cur (list-ref connections n))
           (connections (fold (lambda (c e) (update-con c e n)) connections cur)))
      (if (= n (- (length connections-pre) 1))
          connections
          (loop (+ n 1) connections)))))

(define base-positions
  (let loop ((n (length points)) (seed (seed->rands 420)) (acc '()))
    (lets ((seed x (rand-range seed 0 width))
	   (seed y (rand-range seed 0 height)))
      (if (= n 0)
	  acc
	  (loop (- n 1) seed (append acc (list (list x y))))))))

(define (draw-all-points positions max-len)
  ;; connections behind points
  (for-each
   (lambda (n)
     (let ((pos (list-ref positions n)))
       (for-each
	(lambda (v)
	  (let ((target (list-ref positions v)))
	    (if (> (vec2dist pos target) max-len)
		(draw-line pos target orange)
		(draw-line pos target white))))
	(list-ref connections n))))
     (iota 0 1 (length positions)))

  (for-each
   (lambda (n)
     (let ((pos (list-ref positions n)))
       (draw-circle pos circle-rad red)))
   (iota 0 1 (length positions))))

(define (update-positions positions max-len)
  (map
   (lambda (n)
     (let* ((pos (list-ref positions n))
	    (lens (map (lambda (v) (vec2dist pos (list-ref positions v))) (list-ref connections n)))
	    (max (let loop ((n 0) (max 0)) ;; max AT
		   (if (>= n (length lens))
		       max
		       (loop (+ n 1) (if (> (list-ref lens n) (list-ref lens
		       max)) n max))))))
       (if (> (list-ref lens max) max-len)
	   (vec2move-towards pos (list-ref positions (list-ref (list-ref
	   connections n) max)) speed)
	   pos)))
   (iota 0 1 (length positions))))

(lambda (_)
  (set-target-fps! 60)
  (with-window
   width height "hmmm"
   (let loop ((positions base-positions) (target-map '()) (max-len init-max-len))
     (let* ((max-len (max 0.1 (min 1000 (+ max-len (* 5 (mouse-wheel))))))
            (positions (update-positions positions max-len))
	    (target-map (if (mouse-btn-down?  mouse-button-left)
			    (if (null?  target-map)
				(map (lambda (p) (collision-point-circle?
				(mouse-pos) p circle-rad)) positions)
				target-map)
			    null))
	    (md (mouse-delta))
	    (positions (if (mouse-btn-down?  mouse-button-left)
			   (map (lambda (n) (let ((p (list-ref positions n)))
					 (if (list-ref target-map n)
					     (mouse-pos)
					     p))) (iota 0 1 (length positions)))
			   positions)))
       (draw
	(clear-background black)
	(draw-all-points positions max-len)
	(draw-fps '(0 0))
        (draw-text-simple (string-append "max-len (use mouse-wheel): " (number->string max-len))
                          '(0 24) 21 white))
       (if (window-should-close?)
	   0
	   (loop positions target-map max-len))))))
