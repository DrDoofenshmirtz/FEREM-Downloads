#lang racket

(provide run)

(require web-server/servlet-env
         "dbutils.rkt"
         "actions.rkt")

(define (compile-paths working-directory)
  (list (build-path working-directory)))

(define (connect-to-db)
  (connect-to "ferem" "ferem" "ferem"))

(struct app (db-conn) #:transparent)
 
(define (run working-directory)
  (serve/servlet #:servlet-path      "/ferem-downloads"
                 #:servlet-regexp    #rx"^/ferem-downloads.*$"
                 #:port              17500
                 #:listen-ip         #f
                 #:launch-browser?   #f
                 #:extra-files-paths (compile-paths working-directory)
                 (dispatcher (app (connect-to-db)))))
