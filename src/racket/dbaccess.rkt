#lang racket

(provide add-download
         record-download)

(require db
         "dbutils.rkt")

(struct download (user-id e-mail download-id) #:transparent)

(define (add-download conn e-mail)
  (let* ([user-id     (uuid-string)]
         [download-id (uuid-string)]
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
