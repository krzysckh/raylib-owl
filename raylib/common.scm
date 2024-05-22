(define-library
    (raylib common)

  (import
   (owl toplevel)
   (owl core))

  (export
   maybe-bytevectorize
   prim)

  (begin
    ;; lst → bvec|lst
    (define (maybe-bytevectorize lst)
      (let* ((l (if (bytevector? lst) lst (list->bytevector lst)))
             (l (if l l lst)))
        l))
    (define (prim n . vs)
      (let ((L (length vs)))
        (cond
         ((= L 0) (sys-prim n #f #f #f))
         ((= L 1) (sys-prim n (car vs) #f #f))
         ((= L 2) (sys-prim n (car vs) (cadr vs) #f))
         (else
          (sys-prim n (car vs) (cadr vs) (caddr vs))))))))
