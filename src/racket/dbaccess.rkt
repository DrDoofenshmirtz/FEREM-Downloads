#lang racket

(require db
         racket/date
         (planet williams/uuid:1:3/uuid))

(define (connect)
  (postgresql-connect #:user     "frank"
                      #:database "ferem"
                      #:password "katzenfisch"))

(define (uuid)
  (uuid->string (make-uuid-1)))

(define (timestamp)
  (let ([now (seconds->date (current-seconds))])
    (format "~a-~a-~a ~a:~a:~a" 
            (date-year now)
            (date-month now)
            (date-day now)
            (date-hour now)
            (date-minute now)
            (date-second now))))

(define (create-user conn name e-mail)
  (let* ([id        (uuid)]
         [timestamp (timestamp)]
         [statement (format "insert into users values ('~a', '~a', '~a', '~a')" 
                            id 
                            name 
                            e-mail 
                            timestamp)])
    (query-exec conn statement)
    id))
