#lang racket

(provide run)

(require web-server/servlet-env
         "actions.rkt")

(struct app (name) #:transparent)
 
(define (run)
  (serve/servlet #:servlet-path    "/ferem-downloads"
                 #:servlet-regexp  #rx"^/ferem-downloads.*$"
                 #:port            17500
                 #:launch-browser? #f
                 (dispatcher (app "FEREM Downloads"))))
