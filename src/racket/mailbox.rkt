#lang racket

(provide mbx-create
         mbx-send
         mbx-shutdown)

(require net/smtp
         net/head
         openssl
         racket/async-channel)

(define (mail-header sender recipients subject)
  (standard-message-header sender recipients '() '() subject))

(define (send-mail mail-task smtp-config)
  (let ([sender        (smtp-config-sender smtp-config)]
        [recipients    (list (mail-task-recipient mail-task))]
        [subject       (mail-task-subject mail-task)]
        [message       (mail-task-message mail-task)]
        [smtp-host     (smtp-config-host smtp-config)]
        [smtp-port     (smtp-config-port smtp-config)]
        [smtp-user     (smtp-config-user smtp-config)]
        [smtp-password (smtp-config-password smtp-config)])
    (smtp-send-message smtp-host
                       sender
                       recipients
                       (mail-header sender recipients subject)
                       message
                       #:auth-user   smtp-user	 	 	 	 
                       #:auth-passwd smtp-password
                       #:port-no     smtp-port
                       #:tcp-connect tcp-connect
                       #:tls-encode  ports->ssl-ports)))

(define (next-mail-task stop-channel)
  (when (not (or (stop-signal? (sync stop-channel (thread-receive-evt)))
                 (stop-signal? (async-channel-try-get stop-channel))))
    (thread-try-receive)))

(define (process-mail-task mail-task smtp-config)
  (let ([when-done   (mail-task-when-done mail-task)]
        [when-failed (mail-task-when-failed mail-task)])
    (with-handlers ([exn:fail? when-failed])
      (send-mail mail-task smtp-config)
      (when-done))))

(define (start-message-thread smtp-config stop-channel)
  (letrec ([loop (lambda ()
                   (let ([mail-task (next-mail-task stop-channel)])
                     (when (mail-task? mail-task)
                       (process-mail-task mail-task smtp-config)
                       (loop))))])
    (thread loop)))

(struct smtp-config (host port user password sender) #:transparent)

(struct mailbox (smtp-config message-thread stop-channel) #:transparent)

(define (mbx-create #:smtp-host     smtp-host                    
                    #:smtp-port     smtp-port
                    #:smtp-user     smtp-user
                    #:smtp-password smtp-password
                    #:sender        sender) 
  (let* ([smtp-config (smtp-config smtp-host 
                                   smtp-port 
                                   smtp-user 
                                   smtp-password
                                   sender)]
         [stop-channel   (make-async-channel 1)]
         [message-thread (start-message-thread smtp-config stop-channel)])
    (mailbox smtp-config message-thread stop-channel)))

(define (default-when-done)
  (displayln "Successfully processed mail task."))

(define (default-when-failed error)
  (displayln (format "Failed to process mail task. Error: ~a." error)))

(struct mail-task (recipient 
                   subject 
                   message 
                   when-done 
                   when-failed) #:transparent)

(define (mbx-send mbx recipient subject message
                  #:when-done   [when-done default-when-done]
                  #:when-failed [when-failed default-when-failed])
  (let ([mail-task      (mail-task recipient 
                                   subject 
                                   message 
                                   when-done 
                                   when-failed)]
        [message-thread (mailbox-message-thread mbx)])
    (if (thread-send message-thread mail-task #f) #t #f)))

(struct stop-signal ())

(define shut-down-timeout-secs 5)

(define (mbx-shutdown mbx)
  (let ([stop-channel   (mailbox-stop-channel mbx)]
        [message-thread (mailbox-message-thread mbx)])
    (async-channel-put stop-channel (stop-signal))
    (sync/timeout shut-down-timeout-secs (thread-dead-evt message-thread))))
