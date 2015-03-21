#lang racket

(provide run)

(require web-server/servlet-env
         "logging.rkt"
         "dbutils.rkt"
         "actions.rkt")

(define (compile-paths working-directory)
  (list (build-path working-directory)))

(define (connect-to-db)
  (connect-to "ferem" "ferem" "ferem"))

(struct app (db-conn) #:transparent)

(define (close-log-writers-on-exit exit-code)
  (log-frmdls-info "Closing log writers on exit...")
  (close-writers)
  exit-code)

(define (run working-directory)
  (executable-yield-handler close-log-writers-on-exit)
  (attach-writer (console-writer) 'info)
  (log-frmdls-info "Started FEREM Downloads server (working directory: ~a)." 
                   working-directory)
  (serve/servlet #:servlet-path      "/ferem-downloads"
                 #:servlet-regexp    #rx"^/ferem-downloads.*$"
                 #:port              17500
                 #:listen-ip         #f
                 #:launch-browser?   #f
                 #:extra-files-paths (compile-paths working-directory)
                 (dispatcher (app (connect-to-db)))))
