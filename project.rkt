(module project racket

  (require json)
  (require racket/pretty)

  (define (load-config)
    (with-input-from-file "Project.json"
      (lambda ()
        ;; TODO: Actually process buffer instead of 999999
        (let* ([contents (read-string 999999)])
          (string->jsexpr contents)))))

  (define (parse-args)
    (command-line
     #:program "Project Specific Commands"
     #:args (foo)
     foo))

  (define (execute-command config)
    (display "Would execute command here")
    (newline)
    true)

  (let ([config (load-config)])
    (let ([cmdline (parse-args)])
      (execute-command config))))
