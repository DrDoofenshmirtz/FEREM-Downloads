#lang racket

(provide read-config-file
         config-value)

(require json)

(define (read-config-file path)
  (call-with-input-file path read-json #:mode 'text))

(struct absent ())

(define (config-value config keys [default #f])
  (if (empty? keys)
      config
      (let* ([key   (first keys)]
             [value (hash-ref config key (absent))])
        (if (absent? value)
            default
            (config-value value (rest keys) default)))))
