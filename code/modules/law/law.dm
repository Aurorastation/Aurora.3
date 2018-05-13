/*
	There's a single instance of each law datum per rounds. These hold all of the data
	that is needed to process a crime. When a criminal is brought in, you select a law
	that was broken, and a crime datum is created.

	record_template = {"
<center>NOS Apollo Incident Report</center><hr>
$PRISONER_NAME was found guilty of $CRIME on $DATE. Their sentence was $SENTENCE and they were fined $FINE.
	"}

	$PRISONER_NAME - Gets replaced with the prisoner's name
	$SENTENCE - Gets replaced with the length of the sentence
	$CRIME - Gets replaced with the name of the law broken
	$FINE - Gets replaced with the fine amount
	$DATE - Gets replaced with the current IC date
*/

/datum/law
	var/name = "Law"
	var/desc = "Pay the court a fine or serve your sentence."
	var/id = "i000"

	var/min_fine = 0 // Minimum fine (in credits)
	var/max_fine = 0 // Maximum fine (in credits)

	var/min_brig_time = 0 // Used for low-medium severity crimes, brig sentence measured in minutes
	var/max_brig_time = 0 // A sentence of 60 minutes or more is permabrig for the round

	/*var/min_prison_time = 0  Used for medium-high severity crimes, prison sentence measured in days
	var/max_prison_time = 0  A sentence totalling 60 days or more is a life sentence*/

	var/severity = 0 // 1 - Low, 2 - Medium, 3 - High
	var/felony = 0 // Does this law carry a felony conviction?

/datum/law/proc/can_fine()
	if(max_fine == 0)
		return FALSE
	return TRUE

/datum/law/proc/get_fine_string()
	if(max_fine == 0)
		return "n.a."
	return "[min_fine] - [max_fine] cR"

/datum/law/proc/get_brig_time_string()
	if(min_brig_time >= PERMABRIG_SENTENCE)
		return "HuT"
	if(max_brig_time >= PERMABRIG_SENTENCE)
		return "[min_brig_time] minutes - HuT"
	else
		return "[min_brig_time] - [max_brig_time] minutes"