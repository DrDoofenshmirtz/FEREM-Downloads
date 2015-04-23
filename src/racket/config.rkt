#lang racket

(provide read-config-file
         config-value
         get-db-config
         get-app-config
         (struct-out db-config)
         (struct-out app-config))

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

(struct db-config (database user password server port) #:transparent)

(define (get-db-config config)
  (let ([database (config-value config '(content db-config database))]
        [user     (config-value config '(content db-config user))]
        [password (config-value config '(content db-config password))]
        [server   (config-value config '(content db-config server))]
        [port     (config-value config '(content db-config port))])
    (db-config database user password server port)))

(struct app-config (port) #:transparent)

(define (get-app-config config)
  (let ([port (config-value config '(content app-config port))])
    (app-config port)))
