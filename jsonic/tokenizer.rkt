#lang br/quicklang
(require brag/support)

(define (make-tokenizer port)
  (define (next-token)
    (define jsonic-lexer
      (lexer
       
       ; we found the end of the file, STAHP
       [(eof) eof]

       ; we found a comment, move on
       [(from/to "//" "\n") (next-token)]

       ; we found a token, let's name it SEXP-TOK
       [(from/to "@$" "$@")
        (token 'SEXP-TOK (trim-ends "@$" lexeme "$@"))]

       ; we found a token, let's call it CHAR-TOK
       [any-char (token 'CHAR-TOK lexeme)]))
    (jsonic-lexer port))
  next-token)

(provide make-tokenizer)