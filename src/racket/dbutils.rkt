#lang racket

(provide connect-to 
         uuid-string)

(require db
         (planet williams/uuid:1:3/uuid))

(define (connection-factory database user password server port)
  (lambda () 
    (postgresql-connect #:database database 
                        #:user     user 
                        #:password password
                        #:server   server
                        #:port     port)))

(define (connect-to database user password 
                    #:server [server "localhost"] 
                    #:port   [port 5432])
  (let* ([factory (connection-factory database user password server port)]
         [pool    (connection-pool factory)])
    (virtual-connection pool)))

(define (uuid-string)
  (uuid->string (make-uuid-1)))
