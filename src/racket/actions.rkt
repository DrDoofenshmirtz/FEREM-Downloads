#lang racket

(provide dispatcher)

(require web-server/servlet 
         web-server/dispatch
         web-server/templates)

(define (html-response html)
  (response/full 200 
                 #"Okay"
                 (current-seconds) 
                 TEXT/HTML-MIME-TYPE
                 empty
                 (list (string->bytes/utf-8 html))))

(define (welcome app)
  (html-response (include-template "../html/welcome.html")))

(define (four-o-four . _)
  (html-response (include-template "../html/four-o-four.html")))

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
