#lang racket

(provide dispatcher)

(require web-server/servlet 
         web-server/dispatch
         web-server/templates
         web-server/http/redirect)

(define (html-response html #:code    [code 200] 
                            #:message [message #"OK"]
                            #:mime    [mime TEXT/HTML-MIME-TYPE]
                            #:headers [headers empty])
  (response/full code 
                 message
                 (current-seconds) 
                 mime
                 headers
                 (list (string->bytes/utf-8 html))))

(define (action app handler)
  (lambda (request . args)
    (apply handler app args)))

(define (main app . _)
  (html-response (include-template "../html/main.html")))

(define (welcome-view)
  (html-response (include-template "../html/welcome.html")))

(define (request-download-view)
  (html-response (include-template "../html/request-download.html")))

(define views-by-name (hash "welcome"  welcome-view
                            "download" request-download-view))

(define (navigate-to app view-name . args)
  (let ([view (hash-ref views-by-name view-name)])
    (apply view args)))

(define (dispatcher app)
  (dispatch-case [("ferem-downloads" "navigate-to" (string-arg))
                  (action app navigate-to)]
                 [else 
                  main]))
