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

(define (json-response json #:code    [code 200] 
                            #:message [message #"OK"]
                            #:mime    [mime    #"application/json; charset=utf-8"]
                            #:headers [headers empty])
  (response/full code 
                 message
                 (current-seconds) 
                 mime
                 headers
                 (list (string->bytes/utf-8 json))))

(define (action app handler . args)
  (lambda (request . request-args)
    (apply handler app (append args request-args))))

(define (main app . _)
  (html-response (include-template "../html/main.html")))

(define (welcome-view)
  (html-response (include-template "../html/welcome.html")))

(define (request-download-view)
  (html-response (include-template "../html/request-download.html")))

(define views-by-name (hash "welcome"          welcome-view
                            "request-download" request-download-view
                            "perform-download" request-download-view))

(define (render-view app view-name . args)
  (let ([view (hash-ref views-by-name view-name)])
    (apply view args)))

(define (dispatcher app)
  (dispatch-case [("ferem-downloads" "view" (string-arg))
                  (action app render-view)]
                 [("ferem-downloads" "action" (string-arg))
                  #:method "post"
                  (lambda args 
                    (displayln args)
                    (json-response "{\"message\": \"Thank You!\"}"))]
                 [else 
                  (action app main)]))
