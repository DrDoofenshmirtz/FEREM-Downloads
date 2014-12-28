#lang racket

(provide run)

(require web-server/servlet
         web-server/servlet-env)
 
(define (app req)
  (response/xexpr `(html (head (title "FEREM Downloads"))
                         (body (p "Enter your user name and e-mail address to request a dowload link.")))))
 
(define (run)
  (serve/servlet #:servlet-path    "/ferem-downloads"
                 #:port            17500
                 #:launch-browser? #f
                 app))
