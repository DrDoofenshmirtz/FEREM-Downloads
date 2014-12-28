#lang racket

(require net/smtp
         net/head
         openssl)

(define (send-mail address subject message)
  (smtp-send-message "mail.gmx.net"
                     "frank.mosebach@gmx.de"
                     (list address)
                     (standard-message-header "frank.mosebach@gmx.de"
                                              (list address)
                                              '()
                                              '()
                                              subject)
                     message
                     #:auth-user   "frank.mosebach@gmx.de"	 	 	 	 
                     #:auth-passwd "AgentP42!"
                     #:port-no     587
                     #:tcp-connect tcp-connect
                     #:tls-encode  ports->ssl-ports))

(define (run)
  (smtp-sending-end-of-message (lambda () 
                                 (displayln "Yeah!")))
  (send-mail "fmosebach66@gmail.com" "FEREM Download" '("Hello!"))
  (displayln "Done."))
