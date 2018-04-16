#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (define module-datum `(module stacker-mod "stacker.rkt"
                          ,@src-datums))
  (datum->syntax #f module-datum))
(provide read-syntax)

; define the macro to export as #%module-begin
(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin ; the #%module-begin macro from br
     HANDLE-EXPR ... ; pass up our (handle ...) calls to br
     (display (first stack)))) ; the result is just whatever's left atop the stack
(provide (rename-out [stacker-module-begin #%module-begin]))

; hacky stateful stack
(define stack empty)

(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  (set! stack (cons arg stack)))

(define (handle [arg #f])
  (cond
    [(number? arg) (push-stack! arg)] ; just push numbers onto the stack
    [(or (equal? + arg) (equal? * arg)) ; operator idents evaluate the top two things on the stack
     (define op-result (arg (pop-stack!) (pop-stack!)))
     (push-stack! op-result)]))
(provide handle)

(provide + *)