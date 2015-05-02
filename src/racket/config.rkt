#lang racket

(provide read-config-file
         config-value
         config-accessor
         get-db-config
         get-app-config
         get-mailbox-config
         (struct-out db-config)
         (struct-out app-config)
         (struct-out mailbox-config))

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

(define (config-accessor config keys)
  (lambda (key [default #f])
    (config-value config (append keys (list key)) default)))

(struct db-config (database user password server port) #:transparent)

(define (get-db-config config)
  (let* ([value    (config-accessor config '(content db-config))]
         [database (value 'database)]
         [user     (value 'user)]
         [password (value 'password)]
         [server   (value 'server)]
         [port     (value 'port)])
    (db-config database user password server port)))

(struct app-config (port) #:transparent)

(define (get-app-config config)
  (let* ([value (config-accessor config '(content app-config))]         
         [port  (value 'port)])
    (app-config port)))

(struct mailbox-config 
  (smtp-host smtp-port smtp-user smtp-password sender)
  #:transparent)

(define (get-mailbox-config config)
  (let* ([value         (config-accessor config '(content mailbox-config))]
         [smtp-host     (value 'smtp-host)]
         [smtp-port     (value 'smtp-port)]
         [smtp-user     (value 'smtp-user)]
         [smtp-password (value 'smtp-password)]
         [sender        (value 'sender)])
    (mailbox-config smtp-host smtp-port smtp-user smtp-password sender)))
