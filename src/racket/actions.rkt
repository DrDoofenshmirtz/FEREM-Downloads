#lang racket

(provide dispatcher)

(require  web-server/servlet 
          web-server/dispatch)

(define (welcome app)
  (response/xexpr `(html (head (title "FEREM Downloads"))
                         (body (p "FEREM Downloads")))))

(define (four-o-four . _)
  (response/xexpr `(html (head (title "FEREM Downloads"))
                         (body (p "Sorry, cannot handle your request...")))))

(define (action app handler)
  (lambda (request . args)
    (apply handler app args)))

(define (dispatcher app)
  (dispatch-case [("ferem-downloads")
                  (action app welcome)]
                 [("ferem-downloads" "welcome") 
                  (action app welcome)]
                 [else 
                  four-o-four]))
