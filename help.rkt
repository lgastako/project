#lang racket

(provide help-requested?)
(provide display-help)

(define (render-cmd-args command-def)
  (let ([in (hash-ref command-def 'in)])
    (format "(arg details would go here: )")))

(define (help-requested? cmdline)
  (or (= 0 (vector-length cmdline))
      (vector-member "--help" cmdline)))

(define (display-help config)
  (display "Debugging Config Dump (for now):")
  (newline)
  (pretty-print config)
  (newline)

  (display "----------------------------------------------------------------------------")
  (newline)
  (newline)

  (let* ([default-project-section (make-hasheq)]
         [default-project-name "Project Specific Commands"]
         [default-commands (list)]
         [myself "project"]
         [project-section (hash-ref config 'project default-project-section)]
         [project-name (hash-ref project-section 'name default-project-name)]
         [subcommands (hash-ref config 'commands default-commands)])

    (display project-name)
    (newline)
    (newline)
    (display "Usage:")
    (newline)

    (for ([(command command-def) subcommands])
      (display "  ")
      (display myself)
      (display " ")
      (display command)
      (display " ")
      (display (render-cmd-args command-def))
      (newline))

    (display "  ")
    (display myself)
    (display " -h | --help")
    (newline)

    (display "  ")
    (display myself)
    (display " --version")
    (newline)

    (display "  ")
    (display myself)
    (display " -v | --verbose")
    (newline)

    (newline)

    (display "Options:")
    (newline)
    (display "  -h --help     Show this screen")
    (newline)
    (display "  -v --verbose  Enable verbose logging")
    (newline)
    (display "  --version     Show version")
    (newline)

    (newline)))
