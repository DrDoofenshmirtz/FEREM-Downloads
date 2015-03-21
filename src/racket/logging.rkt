#lang racket

(provide log-frmdls-fatal
         log-frmdls-error
         log-frmdls-warning
         log-frmdls-info
         log-frmdls-debug         
         attach-writer
         close-writers
         console-writer
         (struct-out log-entry))

(define-logger frmdls)

(struct log-entry (logger level text close-writer?) #:transparent)

(define (close-entry)
  (log-entry 'frmdls 'info "Log writer has been closed." #t))

(define (message-entry log-message)
  (let ([level  (vector-ref log-message 0)]
        [text   (vector-ref log-message 1)]
        [logger (vector-ref log-message 3)])
    (log-entry logger level text #f)))

(define (entry-receiver log-level)
  (wrap-evt (make-log-receiver frmdls-logger log-level) message-entry))

(define (next-entry entry-receiver)
  (let ([next-entry (sync (thread-receive-evt) entry-receiver)])
    (if (log-entry? next-entry)
        next-entry
        (let ([next-entry (thread-try-receive)])
          (if (log-entry? next-entry)
              next-entry
              (close-entry))))))

(define (attach-writer log-writer log-level)
  (letrec  ([receiver (entry-receiver log-level)]
            [loop     (lambda ()
                        (let ([log-entry (next-entry receiver)])
                          (log-writer log-entry)
                          (when (not (log-entry-close-writer? log-entry))
                            (loop))))])                              
    (add-writer-thread (thread loop))))

(define writer-threads '())

(define writer-threads-mutex (make-semaphore 1))

(define (add-writer-thread writer-thread)
  (call-with-semaphore writer-threads-mutex
                       (lambda ()
                         (let ([active-threads writer-threads])
                           (set! writer-threads 
                                 (cons writer-thread active-threads))
                           writer-threads))))

(define (drain-writer-threads)
  (call-with-semaphore writer-threads-mutex 
                       (lambda ()
                         (let ([active-threads writer-threads])
                           (set! writer-threads '())
                           active-threads))))

(define (close-writers)
  (let ([active-threads (drain-writer-threads)]
        [close-entry    (close-entry)])
    (for ([writer-thread active-threads])
      (thread-send writer-thread close-entry)
      (thread-wait writer-thread))))

(define (console-writer [entry-format "[~a ~a] ~a"])
  (lambda (log-entry)
    (let ([logger (log-entry-logger log-entry)]
          [level  (log-entry-level  log-entry)]
          [text   (log-entry-text   log-entry)])
      (displayln (format entry-format logger level text)))))
    