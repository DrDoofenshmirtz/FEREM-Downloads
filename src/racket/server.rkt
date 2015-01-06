#! /usr/bin/env racket

#lang racket

(require "app.rkt")

(define (working-directory argv)
  (if (> (vector-length argv) 0)
      (vector-ref argv 0)
      "."))

(define (start-app argv)
  (run (working-directory argv)))

(start-app (current-command-line-arguments))
