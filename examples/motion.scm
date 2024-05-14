(import
 (owl toplevel)
 (raylib))

(define width 400)
(define height width)
(define sz (/ width 10))
(define step sz)

(define queue-size 3)

(define (kp?  state k) (and (eqv?  state 'ready) (key-pressed?  k)))

(define speed (/ sz 4))
(define (move-by state pos)
  (cond
   ((eqv?  state 'moving-right) (values (+ (car pos) speed) (cadr pos)))
   ((eqv?  state 'moving-left) (values (- (car pos) speed) (cadr pos)))
   ((eqv?  state 'moving-up) (values (car pos) (- (cadr pos) speed)))
   ((eqv?  state 'moving-down) (values (car pos) (+ (cadr pos) speed)))
   (else
    (values (car pos) (cadr pos)))))

(define (maybe-animate state pos)
  (lets ((x y (move-by state pos)))
        (if (and (= (modulo x step) 0)
	         (= (modulo y step) 0))
	    (values x y 'ready)
	    (values x y state))))

(define (get-state state q)
  (cond
   ((not (eqv?  state 'ready)) (values state q))
   ((null?  q) (values state q))
   ((eqv?  (car q) 'a) (values 'moving-left (cdr q)))
   ((eqv?  (car q) 'd) (values 'moving-right (cdr q)))
   ((eqv?  (car q) 's) (values 'moving-down (cdr q)))
   ((eqv?  (car q) 'w) (values 'moving-up (cdr q)))
   (else
    (get-state state (cdr q))))) ;; drain unused keypresses

(define (lc c) (- c (- #\A #\a)))

(define ask-keys
  (list
   key-w
   key-a
   key-s
   key-d
   ))

(define (char->symbol c)
  (string->symbol (string (lc c))))

(define (keys-down)
  (map char->symbol (filter key-down?  ask-keys)))

(lambda (_)
  (set-target-fps!  30)
  (with-window
   width height ""
   (let loop ((pos '(0 0)) (state 'ready) (q '()))
     (lets ((x y state (maybe-animate state pos))
	    (pos (list x y))
	    (q (if (key-down?  key-left-control)
		   (append q (keys-down))
		   (let kl ((acc '()))
		     (let ((k (key-pressed)))
		       (if (= k 0)
			   (append q acc)
			   (kl (append acc (list (char->symbol k)))))))))
	    (q (take q queue-size)) ;; TODO: hmmm
	    (state q (get-state state q)))
           (draw
	    (clear-background #xff222222)
	    (draw-rectangle-rounded (append pos (list sz sz)) 0.3 10 red)
	    (draw-text-simple (symbol->string state) '(0 0) 21 white)
	    (draw-text-simple (str* q) '(0 25) 21 white)
	    (draw-fps (list 0 (- height 24))))
           (if (window-should-close?)
	       0
	       (loop pos state q))))))
