#lang racket

(provide raw-response
         html-response
         json-response
         status-success
         status-failure
         message-response)

(require json
         web-server/servlet)

(define (raw-response code message mime headers bytes)
  (response/full code 
                 message
                 (current-seconds) 
                 mime
                 headers
                 (list bytes)))

(define (html-response html-string 
                       #:code    [code 200] 
                       #:message [message #"OK"]
                       #:mime    [mime TEXT/HTML-MIME-TYPE]
                       #:headers [headers empty])
  (raw-response code message mime headers (string->bytes/utf-8 html-string)))
  
(define (json-response jsexpr 
                       #:code    [code 200] 
                       #:message [message #"OK"]
                       #:mime    [mime    #"application/json; charset=utf-8"]
                       #:headers [headers empty])
  (raw-response code message mime headers (jsexpr->bytes jsexpr)))

(define status-success "SUCCESS") 

(define status-failure "FAILURE")

(define (message-response status title content)
  (json-response (hasheq 'status status 'title title 'content content)))
