#lang racket

(provide add-download)

(require db
         (planet williams/uuid:1:3/uuid))

(define (connect)
  (postgresql-connect #:user     "deinc"
                      #:database "ferem"
                      #:password "doofolistic"))

(define (uuid)
  (uuid->string (make-uuid-1)))

(struct download (id e-mail) #:transparent)

(define (add-download conn e-mail)
  (let ([user-id     (uuid)]
        [download-id (uuid)])
    (query-exec conn 
                "select add_download($1, $2, $3);" 
                user-id 
                e-mail 
                download-id)
    (download download-id e-mail)))

(define (record-download download-id)
  (error "Not yet implemented..."))
