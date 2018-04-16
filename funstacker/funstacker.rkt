#lang br/quicklang

(define (read-syntax path port)
  (define args (port->lines port))
  (define arg-datums (format-datums '~a args))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@arg-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

; define the macro to export as #%module-begin
(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

(define (handle-args . args)
  (for/fold ([stack-acc empty]) ; initialize an empty stack
            ([arg (filter-not void? args)]) ; filter out blank lines
    (cond
      [(number? arg) (cons arg stack-acc)] ; push numbers directly onto stack
      [(or (equal? * arg) (equal? + arg)) ; evaluate operators and push result
       (define op-result
         (arg (first stack-acc) (second stack-acc)))
       (cons op-result (drop stack-acc 2))])))
(provide handle-args)

(provide + *)