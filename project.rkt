(module project racket

  (define (load-config)
    (print "Would load config here")
    (newline)
    true)

  (define (help-requested? cmdline)
    (print "Would check for help request here")
    (newline)
    true)

  (define (display-help config)
    (print "Would display help here")
    (newline)
    true)

  (define (execute-command config)
    (print "Would execute command here")
    (newline)
    true)

  (let ([config (load-config)]
        [cmdline (parse-command-line)])
    (if (help-requested? cmdline)
        (display-help config)
        (execute-command config))))
