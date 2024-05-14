(import
 (owl toplevel)
 (raylib))

(lambda (_)
  (set-target-fps!  120)
  (with-window
   600 600 "mp"
   (let loop ((last (mouse-pos)) (persist ()) (sz 1))
     (let* ((delta-sum (+ (abs (car (mouse-delta))) (abs (cdr (mouse-delta)))))
	    (mp (mouse-pos))
	    (sz (/ (- 100 delta-sum) 10))
	    (persist (if (mouse-btn-down?  mouse-button-left)
			 (append persist (list (list sz last mp)))
			 persist))
            (persist (if (key-pressed? key-c) () persist)))
       (draw
	(clear-background black)
	(draw-line-ex last mp sz white)
	(for-each
	 (lambda (p) (draw-line-ex (cadr p) (caddr p) (car p) white))
	 persist)
	(draw-circle '(100 10) sz white)
	(draw-fps '(0 0)))
       (if (window-should-close?)
	   0
	   (loop mp persist sz))))))
