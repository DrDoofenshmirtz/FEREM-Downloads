#lang racket

(provide dispatcher)

(require json
         web-server/servlet 
         web-server/dispatch
         web-server/templates
         "responses.rkt")

(define (action handler app . args)
  (lambda (request . request-args)
    (apply handler app request (append args request-args))))

(define (main app request . _)
  (html-response (include-template "../html/main.html")))

(define (welcome-view)
  (html-response (include-template "../html/welcome.html")))

(define (request-download-view)
  (html-response (include-template "../html/request-download.html")))

(define (request-download-success e-mail-address)
  (include-template "../html/request-download-success.html"))

(define views-by-name (hash "welcome"          welcome-view
                            "request-download" request-download-view
                            "perform-download" request-download-view))

(define (render-view app request view-name . args)
  (let ([view (hash-ref views-by-name view-name)])
    (apply view args)))

(define (request-download app request args)
  (let* ([post-data      (post-data request)]
         [e-mail-address (hash-ref post-data 'e-mail-address)]
         [store-e-mail?  (hash-ref post-data 'store-e-mail?)])
    (message-response status-success 
                      "Thank You!" 
                      (request-download-success e-mail-address))))

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
