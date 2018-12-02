#lang racket
(define box-scans (port->lines (open-input-file "input.txt")))

(define (add-checksums char-count)
  (* (first char-count) (second char-count)))

(define (add-to-histogram histogram character)
  (if (empty? histogram)
      (list (list character 1))
      (let ([entry (first histogram)])
        (if (char=? (first entry) character)
            (cons (list character (+ 1 (second entry))) (rest histogram))
            (cons entry (add-to-histogram (rest histogram) character))))))

(define (any-has-count n histogram)
  (ormap (λ (entry) (= n (second entry))) histogram))

; returns number of two and three character barcodes, if histogram contains any occurences of 2 or 3 chars, update the counts respectively
(define (count-chars barcode character-counts)
  ; histogram : Listof '(character number)
  (let ([histogram (foldr (λ (char h) (add-to-histogram h char)) (list)  barcode)]
        [two-count (first character-counts)]
        [three-count (second character-counts)])
    (if (empty? histogram)
        character-counts
        (list
         (if (any-has-count 2 histogram) (+ 1 two-count) two-count)
         (if (any-has-count 3 histogram) (+ 1 three-count) three-count)))))


(define all-character-counts
  ; for each barcode, compute the number of 2 & 3 matching character counts
  (foldr (λ (barcode prev-char-counts)
           (count-chars (string->list barcode) prev-char-counts))
         '(0 0) box-scans))

; Puzzle A Solution
; (print (add-checksums all-character-counts))
(define (off-by-one sa sb)
    (= 1 (foldr (λ (a b off-by-n)
                  (if (char=? a b)
                      off-by-n
                      (+ 1 off-by-n)))
                0 sa sb)))
  
(define (differs-by-one id list-of-ids)
  (foldr (λ (possible-match matches)
           (if (off-by-one id possible-match)
               (cons (list id possible-match) matches)
               matches)) '() list-of-ids))
               

; Puzzle B Solution
; Create a list of pairs of box ids where they differ by at most one character
(define (get-pairs-that-differ-by-one ids)
  (foldr (λ (id matching-pairs)
           (let ([new-pairs (differs-by-one id ids)])
             (if (empty? new-pairs)
                 matching-pairs
                 (append new-pairs matching-pairs)))) '() ids))

(define (differs-at-same-index sa sb)
  (ormap (λ (a b) (char=? a b)) sa sb))

(define final-pair
  (first (filter (λ (pair) (differs-at-same-index (first pair) (second pair))) (get-pairs-that-differ-by-one (map (λ (id) (string->list id)) box-scans)))))

(define (get-common-string sa sb)
  (cond
    [(not (char=? (first sa) (first sb))) (rest sa)]
    [else (cons (first sa) (get-common-string (rest sa) (rest sb)))]))

(list->string (get-common-string (first final-pair) (second final-pair)))



