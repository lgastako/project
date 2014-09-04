(module project racket

  (define (load-config)
    (display "Would load config here")
    (newline)
    true)

  (define (parse-args)
    (display "Would parse args here")
    (newline)
    true)

  (define (help-requested? cmdline)
    (display "Would check for help request here")
    (newline)
    true)

  (define (display-help config)
    (display "Would display help here")
    (newline)
    true)

  (define (execute-command config)
    (display "Would execute command here")
    (newline)
    true)

  (let ([config (load-config)]
        [cmdline (parse-args)])
    (if (help-requested? cmdline)
        (display-help config)
        (execute-command config))))
