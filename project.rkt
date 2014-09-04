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
    (display "Current command line args: ")
    (newline)
    (pretty-print (current-command-line-arguments))
    (newline)
    #f)

  (define (display-help config)
    (display "Would display help here.")
    (newline)
    (display "Config:")
    (newline)
    (pretty-print config)
    #t)

  (define (execute-command config)
    (display "Would execute command here")
    (newline)
    true)

  (let ([config (load-config)])
    (let ([cmdline (parse-args)])
      (if (not cmdline)
          (display-help config)
          (execute-command config)))))
