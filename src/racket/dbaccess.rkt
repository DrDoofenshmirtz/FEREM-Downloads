#lang racket

(provide add-download)

(require db
         (planet williams/uuid:1:3/uuid))

(define (connect)
  (postgresql-connect #:user     "frank"
                      #:database "ferem"
                      #:password "katzenfisch"))

(define (uuid)
  (uuid->string (make-uuid-1)))

(struct download (id e-mail) #:transparent)

(define (add-download conn e-mail)
  (let ([user-id     (uuid)]
        [download-id (uuid)])
    (query-exec conn "begin;")
    (query-exec conn "lock table only users;")
    (query-exec conn 
                (string-append "insert into users (id, e_mail)"
                               (format " select '~a'" user-id)
                               ", $1 where not exists"
                               " (select users.id from users" 
                               " where users.e_mail = $1);") 
                e-mail)
    (query-exec conn 
                (string-append "insert into downloads (id, user_id)"
                               (format " select '~a'" download-id)
                               ", users.id from users where users.e_mail = $1;")
                e-mail)
    (query-exec conn "commit;")
    (download download-id e-mail)))
