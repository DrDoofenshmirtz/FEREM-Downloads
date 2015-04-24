#lang racket

(provide run)

(require web-server/servlet-env
         "logging.rkt"
         "config.rkt"
         "dbutils.rkt"
         "actions.rkt")

(define (config-path working-directory)
  (build-path working-directory "config" "config.json"))

(define (load-config working-directory)
  (let ([config-path (config-path working-directory)])
    (log-frmdls-info "...loading config (file: ~a)..." config-path)
    (read-config-file config-path)))

(define (connect-to-db config)
  (log-frmdls-info "...connecting to the database...")
  (let* ([db-config (get-db-config config)]
         [server    (db-config-server db-config)]
         [port      (db-config-port db-config)]
         [database  (db-config-database db-config)]
         [user      (db-config-user db-config)]
         [password  (db-config-password db-config)])
    (connect-to database user password #:server server #:port port)))

(struct app (port db-conn) #:transparent)

(define (set-up config db-conn)
  (log-frmdls-info "...setting up the application...")
  (let* ([app-config (get-app-config config)]
         [port       (app-config-port app-config)])
    (app port db-conn)))

(define (boot-failed error)
  (log-frmdls-error "Failed to boot the application (error: ~a)!"
                    (exn-message error))
  #f)

(define (boot working-directory)
  (log-frmdls-info "Booting the application...")
  (with-handlers ([exn:fail? boot-failed])
    (let* ([config  (load-config working-directory)]
           [db-conn (connect-to-db config)]
           [app     (set-up config db-conn)])
      (log-frmdls-info "~a" app)  
      app)))

(define (close-log-writers-on-exit exit-code)
  (log-frmdls-info "Closing log writers on exit...")
  (close-writers)
  exit-code)

(define (exit-with-failure)
  (exit (close-log-writers-on-exit 1)))

(define (compile-paths working-directory)
  (list (build-path working-directory)))

(define (run working-directory)
  (executable-yield-handler close-log-writers-on-exit)
  (attach-writer (console-writer) 'info)
  (log-frmdls-info "Started FEREM Downloads server (working directory: ~a)." 
                   working-directory)
  (let ([app (boot working-directory)])
    (if app
        (serve/servlet #:servlet-path      "/ferem-downloads"
                       #:servlet-regexp    #rx"^/ferem-downloads.*$"
                       #:port              (app-port app)
                       #:listen-ip         #f
                       #:launch-browser?   #f
                       #:extra-files-paths (compile-paths working-directory)
                       (dispatcher app))
        (exit-with-failure))))
