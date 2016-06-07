;;;======================================================
;;;   Hardware troubleshoot Expert System
;;;
;;;     This expert system diagnoses some desk and mobile 
;;;	PC hardware issues.
;;;
;;;
;;;     To execute merely, load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
       (while (not (member ?answer ?allowed-values)) do
        (printout t ?question)
        (bind ?answer (read))
        (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n si no ))
   (if (or (eq ?response yes) (eq ?response y))
       then TRUE 
       else FALSE))

;;;**********************
;;;* ENGINE STATE RULES *
;;;**********************
(deffacts initial-facts
 (bad-connection 0)
)
(defrule computer-power-on
(declare (salience 100))
(initial-fact)
=>
	(if (yes-or-no-p "can your computer turn on(yes/no)?")
	then
	(assert (computer-turn-on yes))
	else
	(assert (computer-turn-on no))
	)
)
(defrule RAM-issue
(declare (salience 80))
(computer-turn-on yes)
;;(computer-BIOS-alert ?)
=>
	(if (yes-or-no-p "Have you seen a blue screnshot(yes/no)?")
	then
	(assert (computer-blue-screen yes))
	else
	(assert (computer-blue-screen no))
	)
	
)
(defrule Batterie-RTC-issue
(declare (salience 80))
(computer-turn-on yes)
(computer-blue-screen no)
=>
	(if (yes-or-no-p "Have you seen on launch a warning at beginning and include a work like (batterie or RTC)(yes/no)?")
	then
	(assert (computer-BIOS-warning yes))
	else
	(assert (computer-BIOS-warning no))
	)
)

(defrule Nostart-OS-issue
(declare (salience 80))
(computer-turn-on yes)
(computer-blue-screen no)
(computer-BIOS-warning yes)
=>
	(if (yes-or-no-p "Have you seen on initial launch a warning like this (No format to boot)(yes/no)?")
	then
	(assert (computer-BIOS-NOBOOT yes))
	else
	(assert (computer-BIOS-NOBOOT no))
	)
)

(defrule NoTurn-on-PC
(declare (salience 80))
(computer-turn-on no)
=>
	(printout t "Please check if power cable have a good connection" crlf)
	(if (eq bad-connection 1)
	then
	(assert (repair "Buy a new power cord according to your PC "))
	else
	(refresh computer-power-on)
	(assert (bad-connection 1))
	)
)
;;;****************************
;;;* STARTUP AND REPAIR RULES *
;;;****************************

(defrule system-banner ""
  (declare (salience 110))
  =>
  (system "reset")
  (printout t crlf crlf)
  (printout t  "Hardware troubleshoot Expert System")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Repair:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item crlf))
