#lang br
(require jsonic/parser jsonic/tokenizer brag/support)

(parse-to-datum (apply-tokenizer-maker make-tokenizer "// this here's a comment\n"))

(parse-to-datum (apply-tokenizer-maker make-tokenizer "@$ 42 $@"))

(parse-to-datum (apply-tokenizer-maker make-tokenizer "hi"))

(parse-to-datum (apply-tokenizer-maker make-tokenizer "hi\n// a comment\n@$ 42 $@"))

; HERE STRING
(parse-to-datum (apply-tokenizer-maker make-tokenizer #<<STUFF
"foo"
// comment
@$ 42 $@
STUFF
))