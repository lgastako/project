#lang racket

(provide load-config)

(require json)

(define (load-config)
  (with-input-from-file "Project.json"
    (lambda ()
      ;; TODO: Actually process buffer instead of 999999
      (let* ([contents (read-string 999999)])
        (string->jsexpr contents)))))
