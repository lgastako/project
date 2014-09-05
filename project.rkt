#lang racket

(provide main)

(require racket/pretty)
(require "cfg.rkt")
(require "help.rkt")

(define (display-no-projectfile-message)
  (display "No Project.json found.")
  (newline)
  (display "Project is entirely driven by a Project.json file.")
  (newline)
  (display "Eventually there will be instructions for creating one right here.")
  (newline)
  (display "For now, maybe check the README.md file.")
  (newline))

(define (parse-args)
  (let ([args (current-command-line-arguments)])
    (display "Current command line args: ")
    (newline)
    (pretty-print args)
    (newline)
    args))

(define (execute-command config)
  (display "Would execute command here")
  (newline)
  true)

(define (main)
  (let ([config (load-config)])
    (if (eqv? empty config)
        (display-no-projectfile-message)
        (let ([cmdline (parse-args)])
          (if (help-requested? cmdline)
              (display-help config)
              (execute-command config))))))

;; What's the right way to do this?
(main)
