#lang racket

(provide add-download)

(require db
         (planet williams/uuid:1:3/uuid))

(define (connection-factory database user password)
  (lambda () 
    (postgresql-connect #:database database 
                        #:user     user 
                        #:password password)))

(define (connect-to database user password)
  (virtual-connection (connection-pool (connection-factory database 
                                                           user 
                                                           password))))

(define (uuid)
  (uuid->string (make-uuid-1)))

(struct download (user-id e-mail download-id) #:transparent)

(define (add-download conn e-mail)
  (let* ([user-id     (uuid)]
         [download-id (uuid)]
         [user-id     (query-value conn 
                                   "select add_download($1, $2, $3);" 
                                   user-id 
                                   e-mail 
                                   download-id)])
    (download user-id e-mail download-id)))

(define (record-download conn download-id)
  (let* ([sql    (string-append "update downloads"
                                " set downloaded_at = current_timestamp"
                                (format " where id = '~a'" download-id)
                                " and downloaded_at is null;")]
         [result (query conn sql)])
    (> (cdr (assoc 'affected-rows (simple-result-info result))) 0)))
