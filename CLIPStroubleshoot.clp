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

;;;******************
;;;* PC STATE RULES *
;;;******************

(defrule power-on
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
(defrule Blue-issue
(declare (salience 80))
(computer-turn-on yes)
=>
	(if (yes-or-no-p "Have you seen a blue screen(yes/no)?")
	then
	(assert (computer-blue-screen yes))
	(assert (repair "Execute a hard drive failures test"))
        (assert (ask-done no))
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
=>
	(if (yes-or-no-p "Have you seen on initial launch a warning like this 'No format to boot' (yes/no)?")
	then
	(assert (computer-BIOS-NOBOOT yes))
	(assert (repair "recover MBR (master boot register)"))
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
	(refresh power-on)
	(assert (bad-connection 1))
	)
)

(defrule Low-resolution-issue-yes
(declare (salience 80))
(computer-turn-on yes)
(computer-blue-screen no)
(computer-half-screen yes)	

=>
	(if (yes-or-no-p "There is not video or in low resolution(yes/no)?")
	then
	(assert (computer-half-screen yes))
	(assert (repair "Please check if video card driver are correct installed or the computer has last drivers updates"))
	else
	(assert (computer-half-screen no))
	)
)

(defrule HDD-issue-appear
(declare (salience 70))
(computer-turn-on yes)
(computer-blue-screen yes)

=>
	(if (yes-or-no-p "HDD test found any error in the PC(yes/no)?")
	then
	(assert (computer-HDD-damage yes))
	(assert (repair "Hard drive is damage,replace or format it"))
	else
	(assert (computer-HDD-damage no))
	)
)

(defrule half-screen-issue
(declare (salience 80))
(computer-turn-on yes)
(computer-BIOS-NOBOOT no)
(computer-blue-screen no)

=>
	(if (yes-or-no-p "Have you seen a half screen(yes/no)?")
	then
	(assert (computer-half-screen yes))
	else
	(assert (computer-half-screen no))
	)
)

(defrule RAM-issue
(declare (salience 80))
(computer-turn-on yes)
(computer-BIOS-NOBOOT no)
(computer-blue-screen no)
(computer-half-screen no)
(computer-HDD-damage no)

=>
	(if (yes-or-no-p "Are RAM memories correct placed?")
	then
	(assert (RAM-memories-damage yes))
	(assert (repair "Remplace RAM memories"))
	else
	(assert (RAM-memories-damage no))
	(assert (repair "Make sure RAM memories are corrected place on mother board slots"))
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
  (printout t  "Hardware troubleshoot Expert System for PC")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 90))
  (repair ?item)
  =>
  (assert (ask-done yes))
  (printout t crlf crlf)
  (printout t "Suggested Repair:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

(defrule ask-if-end ""
  (declare (salience 0))
  (repair ?item)
  (ask-done yes)
  =>
  (if (yes-or-no-p "This solved the problem?")
    then
     (printout t  "Goodbye" crlf crlf)
    else
    (reset)
    (run)))