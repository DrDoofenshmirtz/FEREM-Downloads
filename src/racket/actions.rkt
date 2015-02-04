#lang racket

(provide dispatcher)

(require json
         web-server/servlet 
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

(define (action handler app . args)
  (lambda (request . request-args)
    (apply handler app request (append args request-args))))

(define (main app request . _)
  (html-response (include-template "../html/main.html")))

(define (welcome-view)
  (html-response (include-template "../html/welcome.html")))

(define (request-download-view)
  (html-response (include-template "../html/request-download.html")))

(define views-by-name (hash "welcome"          welcome-view
                            "request-download" request-download-view
                            "perform-download" request-download-view))

(define (render-view app request view-name . args)
  (let ([view (hash-ref views-by-name view-name)])
    (apply view args)))

(define (request-download app request args)
  (displayln (string-append "ACTION: request-download ARGS: " 
                            args
                            " DATA: "
                            (jsexpr->string (post-data request))))
  (json-response "{\"result\": true}"))

(define (post-data request)
  (bytes->jsexpr (request-post-data/raw request)))

(define (dispatcher app)
  (dispatch-case [("ferem-downloads" "view" (string-arg))
                  (action render-view app)]
                 [("ferem-downloads" "action" (string-arg))
                  #:method "post"
                  (action request-download app)]
                 [else 
                  (action main app)]))
