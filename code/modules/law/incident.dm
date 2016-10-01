/datum/crime_incident
	var/UID // The unique identifier for this incident

	var/notes = "" // The written explanation of the crime

	var/list/charges = list() // What laws were broken in this incident
	var/list/evidence = list() // If its a prison sentence, it'll require evidence

	var/list/arbiters = list( "Witness" = list() ) // The person or list of people who were involved in the conviction of the criminal
	var/mob/living/carbon/human/criminal // The person who committed the crimes

	var/brig_sentence = 0 // How long do they stay in the brig on the station, PERMABRIG_SENTENCE minutes = permabrig
	var/prison_sentence = 0 // How long do they stay in prison, PERMAPRISON_SENTENCE days = life sentence

	var/fine // how much space dosh do they need to cough up if they want to go free
	var/felony // will the criminal become a felon as a result of being found guilty of his crimes?

/datum/crime_incident/New()
	UID = md5( "[world.realtime][rand(0, 1000000)]" )

	..()

/datum/crime_incident/proc/addArbiter( var/obj/item/weapon/card/id/C, var/title )
	if( !istype( C ))
		return "Invalid ID card!"

	if( !C.mob )
		return "ID card not tied to a NanoTrasen Employee!"

	if( criminal == C.mob )
		return "The criminal cannot hold official court positions in his own trial!"

	var/list/same_access // The card requires one of these access codes to become this titl
	var/minSeverity = 1

	switch( title )
		if( "Witness" ) // anyone can be a witness
			var/list/L = arbiters[title]
			L += list( C.mob ) // some reason adding a mob counts as adding a list, so it would add the mob contents
			arbiters[title] = L

			return 0

	if( minSeverity > getMaxSeverity() )
		return "The severity of the incident does not call for a [title]."

	if( same_access && same_access.len )
		arbiters[title] = C.mob
		return 0
	else
		return "Could not add [C.mob] as [title]."

/datum/crime_incident/proc/missingSentenceReq()
	if( !istype( criminal ))
		return "No criminal selected!"

	if( !charges.len )
		return "No criminal charges have been selected!"

	return 0

/datum/crime_incident/proc/refreshSentences()
	felony = 0
	if( getMaxSeverity() >= 2 )
		felony = 1

	if( prison_sentence )
		brig_sentence = PERMABRIG_SENTENCE
	else
		brig_sentence = getMinBrigSentence()

/datum/crime_incident/proc/getMinFine()
	var/min = 0
	for( var/datum/law/L in charges )
		min += L.min_fine

	if( min < 0 )
		min = 0

	return min

/datum/crime_incident/proc/getMaxFine()
	var/max = 0
	for( var/datum/law/L in charges )
		max += L.max_fine

	if( max < 0 )
		max = 0

	return max

/datum/crime_incident/proc/getMinBrigSentence()
	var/min = 0
	for( var/datum/law/L in charges )
		min += L.min_brig_time

	if( min < 0 )
		min = 0

	if( min > PERMABRIG_SENTENCE )
		min = PERMABRIG_SENTENCE

	return min

/datum/crime_incident/proc/getMaxBrigSentence()
	var/max = 0
	for( var/datum/law/L in charges )
		max += L.max_brig_time

	if( max < 0 )
		max = 0

	if( max > PERMABRIG_SENTENCE )
		max = PERMABRIG_SENTENCE

	return max

/datum/crime_incident/proc/getMaxSeverity()
	var/max = 0
	for( var/datum/law/L in charges )
		if( L.severity > max )
			max = L.severity

	return max

/datum/crime_incident/proc/renderGuilty( var/user )
	if( !criminal )
		return

	generateReport()
	for (var/datum/data/record/E in data_core.general)
		if(E.fields["name"] == criminal.name)
			for (var/datum/data/record/R in data_core.security)
				if(R.fields["id"] == E.fields["id"])
					for(var/datum/law/L in charges)
						if(L.severity == 3)
							R.fields["ma_crim"] += " |[L.id]-([time2text(world.realtime, "DD/MMM")]/[game_year])|"
						else
							R.fields["mi_crim"] += " |[L.id]-([time2text(world.realtime, "DD/MMM")]/[game_year])|"

/datum/crime_incident/proc/generateReport()
	. = "<center>Security Incident Report</center><hr>"

	. += "</i><br>"
	. += "<b>CRIMINAL</b>: <i>[criminal]</i><br><br>"

	. += "[criminal] was found guilty of the following crimes on [time2text(world.realtime, "DD/MMM")]/[game_year]. "

	if( !brig_sentence && !prison_sentence )
		. += "As decided by the arbiter(s), they will serve no time for their crimes."
	else
		. += "As decided by the arbiter(s), they will serve the following sentence:<br>"
		if( brig_sentence )
			if( brig_sentence >= PERMABRIG_SENTENCE )
				. += "\t<b>BRIG</b>: <i>Imprisonment until transfer</i><br>"
			else
				. += "\t<b>BRIG</b>: <i>[brig_sentence] minutes</i><br>"

	. += "<br><table>"
	. += "<tr><th colspan='2'>CHARGES</th></tr>"
	for( var/datum/law/L in charges )
		. += "<tr>"

		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"

		. += "</tr>"
	. += "</table>"

	return .