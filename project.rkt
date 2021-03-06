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

(define (render-cmd in out cmdline)
  out)

(define (execute-command config cmdline)
  (display "Would execute command here.")
  (newline)
  (display "Config:")
  (newline)
  (pretty-print config)
  (newline)
  (display "Command Line:")
  (newline)
  (pretty-print cmdline)
  (newline)
  (let* ([cmds (hash-ref config 'commands)]
         [cmd-name (vector-ref cmdline 0)]
         [cmd-sym (string->symbol cmd-name)]
         [cmd (hash-ref cmds cmd-sym)]
         [out (hash-ref cmd 'out)]
         [in (hash-ref cmd 'in)]
         [candidate (render-cmd in out cmdline)])
    (display "Candidate command: ")
    (display candidate)
    (newline))
  true)

(define (main)
  (let ([config (load-config)])
    (if (eqv? empty config)
        (display-no-projectfile-message)
        (let ([cmdline (parse-args)])
          (if (help-requested? cmdline)
              (display-help config)
              (execute-command config cmdline))))))

;; What's the right way to do this?
(main)
