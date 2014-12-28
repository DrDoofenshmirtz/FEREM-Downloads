#lang racket

(require "mailbox.rkt")

(define (gmx-mailbox)
  (mbx-create #:smtp-host     "mail.gmx.net" 
              #:smtp-port     587 
              #:smtp-user     "frank.mosebach@gmx.de" 
              #:smtp-password "AgentP42!" 
              #:sender        "frank.mosebach@gmx.de"))

(define (when-done mbx)
  (displayln "The test mail has been sent.")
  (mbx-shutdown mbx))

(define (when-failed mbx error)
  (displayln (format "Sending the test mail failed! Error: ~a." error))
  (mbx-shutdown mbx))

(define (send-mail recipient subject message)
  (let* ([mbx         (gmx-mailbox)]
         [when-done   (lambda () (when-done mbx))]
         [when-failed (lambda (error) (when-failed mbx error))])
    (mbx-send mbx recipient subject message 
              #:when-done   when-done 
              #:when-failed when-failed)))

(define (send-test-mail-to-gmail) 
  (send-mail "fmosebach66@gmail.com" 
             "Mailbox Demo" 
             '("Please click the link below:" 
               "" 
               "http://www.google.com")))
