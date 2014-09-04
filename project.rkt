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
    (let ([args (current-command-line-arguments)])
      (display "Current command line args: ")
      (newline)
      (pretty-print args)
      (newline)
      args))

  (define (help-requested? cmdline)
    (not (not (vector-member "--help" cmdline))))

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
      (if (help-requested? cmdline)
          (display-help config)
          (execute-command config)))))
