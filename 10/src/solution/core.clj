(ns solution.core)
(require '[clojure.string :as str])
(require '[clojure.core.reducers :as reducers])

(defrecord Point [x y dx dy])

(def input (str/split (slurp "C:/Users/Larken/git/AdventOfCode2018/10/resources/input.txt") #"\n"))

(defn sprintln [& more]
  (.write *out* (str (clojure.string/join " " more) "\n")))
; https://stackoverflow.com/questions/5621279/in-clojure-how-can-i-convert-a-string-to-a-number
(defn parse-int [s]
  (Integer/parseInt (re-find #"-?\d+" s)))

(def all-points
  (map (fn [s]
         (def matcher (re-matcher #"position=<([\s-]?\d+), ([\s-]?\d+)> velocity=<([\s-]?\d+), ([\s-]?\d+)>" s))
         (let
           [groups (rest (re-find matcher))
            x (parse-int (nth groups 0))
            y (parse-int (nth groups 1))
            dx (parse-int (nth groups 2))
            dy (parse-int (nth groups 3))]
           (Point. x y dx dy))) input))

(defn forward [points]
  (map (fn [p] (Point. (+ (:x p) (:dx p)) (+ (:y p) (:dy p)) (:dx p) (:dy p))) points))

(defn has-coord [x y points]
  (or (map (fn [p] (and (= x (:x p)) (= y (:y p)))) points)))

(defn print-light [x y end-x end-y points]
  (let [should-print-new-line (or (not (= x end-x)) (not (= y end-y)))
        should-print-coord (has-coord x y points)]
    (if should-print-coord (print "#") (print "."))
    (if should-print-new-line (print "\n") (print ""))))

(defn write-message [points]
  (let [x-coords (doall (map (fn [p] (:x p)) points))
        y-coords (doall (map (fn [p] (:y p)) points))
        start-x (apply min x-coords)
        end-x (apply max x-coords)
        start-y (apply min y-coords)
        end-y (apply max y-coords)]
    (for [y (range start-y end-y)
          x (range start-x end-x)]
      (print-light x y end-x end-y points))))

(write-message (doall all-points))
;(write-message (forward all-points))




