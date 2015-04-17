#lang racket

(provide run)

(require web-server/servlet-env
         "logging.rkt"
         "config.rkt"
         "dbutils.rkt"
         "actions.rkt")

(define (config-path working-directory)
  (build-path working-directory "config" "config.json"))

(define (load-config-failed error)
  (log-frmdls-error "Failed to load config file (error: ~a)!" 
                    (exn-message error))
  #f)

(define (load-config working-directory)
  (let ([config-path (config-path working-directory)])
    (with-handlers ([exn:fail? load-config-failed])
      (log-frmdls-info "Loading config (file: ~a)." config-path)
      (read-config-file config-path))))

(define (compile-paths working-directory)
  (list (build-path working-directory)))

(define (connect-to-db)
  (connect-to "ferem" "ferem" "ferem"))

(struct app (db-conn) #:transparent)

(define (close-log-writers-on-exit exit-code)
  (log-frmdls-info "Closing log writers on exit...")
  (close-writers)
  exit-code)

(define (exit-with-failure)
  (exit (close-log-writers-on-exit 1)))

(define (run working-directory)
  (executable-yield-handler close-log-writers-on-exit)
  (attach-writer (console-writer) 'info)
  (log-frmdls-info "Started FEREM Downloads server (working directory: ~a)." 
                   working-directory)
  (let ([config (load-config working-directory)])
    (if config
        (serve/servlet #:servlet-path      "/ferem-downloads"
                       #:servlet-regexp    #rx"^/ferem-downloads.*$"
                       #:port              17500
                       #:listen-ip         #f
                       #:launch-browser?   #f
                       #:extra-files-paths (compile-paths working-directory)
                       (dispatcher (app (connect-to-db))))
        (exit-with-failure))))
