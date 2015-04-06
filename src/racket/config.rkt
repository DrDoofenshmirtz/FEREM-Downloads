#lang racket

(provide read-config-file
         config-value)

(require json)

(define (read-config-file path)
  (call-with-input-file path read-json #:mode 'text))

(define (config-value config keys [default #f])
  (if (empty? keys)
      config
      (let ([key  (first keys)]
            [keys (rest keys)])
        (config-value (hash-ref config key default) keys default))))
