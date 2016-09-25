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

/*/datum/crime_incident/proc/isInTrial( var/mob/M )
	if( criminal == M )
		return 1

	for( var/arbiter in arbiters )
		if( arbiters[arbiter] == M )
			return 1

	return 0

// I know there's a better way to do this, but we're rarely going to add new court roles, so this works well enough
/datum/crime_incident/proc/addArbiter( var/obj/item/weapon/card/id/C, var/title )
	if( !istype( C ))
		return "Invalid ID card!"

	if( !C.mob )
		return "ID card not tied to a NanoTrasen Employee!"

	if( criminal == C.mob )
		return "The criminal cannot hold official court positions in his own trial!"

	if( title != "Witness" && arbiters[title] )
		return "Someone has already filled the role of [title]! Clear them from the console to take their place."

	if( title != "Witness" && isInTrial( C.mob ))
		return "That person already has a role in the trial! Clear them from the console first to change their role."

	var/list/same_access // The card requires one of these access codes to become this titl
	var/minSeverity = 1

	switch( title )
		if( "Witness" ) // anyone can be a witness
			var/list/L = arbiters[title]
			L += list( C.mob ) // some reason adding a mob counts as adding a list, so it would add the mob contents
			arbiters[title] = L

			return 0
		if( "Justice #1" )
			minSeverity = 3.0
			same_access = C.access & list( access_heads )
		if( "Justice #2")
			minSeverity = 3.0
			same_access = C.access & list( access_heads )
		if( "Chief Justice" )
			minSeverity = 2.0

			if( getMaxSeverity() < 3.0 ) // If its a court
				same_access = C.access & list( access_brig, access_heads ) // Anyone who can perform arrests / any command officers can sentence in medium crimes
			else // If its a tribunal
				same_access = C.access & list( access_hop, access_captain ) // Only HOP or captain can preside as chief justice in a tribunal
		if( "Prosecuting Attorney" )
			minSeverity = 2.0
			same_access = C.access & list( access_lawyer, access_iaa ) // IAA or lawyers can be attorneys
		if( "Defending Attorney" )
			minSeverity = 2.0
			same_access = C.access & list( access_lawyer, access_iaa ) // IAA or lawyers can be attorneys

	if( minSeverity > getMaxSeverity() )
		return "The severity of the incident does not call for a [title]."

	if( same_access && same_access.len )
		arbiters[title] = C.mob
		return 0
	else
		return "Could not add [C.mob] as [title]. They do not have sufficient access to act in that capacity in a [getCourtType()]."

/datum/crime_incident/proc/missingCourtReq()
	var/error = missingSentenceReq()
	if( error )
		return error

	if( getMaxSeverity() != 2.0 )
		return "Selected crimes do not require a court!"

	return 0

/datum/crime_incident/proc/missingTribunalReq()
	var/error = missingSentenceReq()
	if( error )
		return error

	if( getMaxSeverity() != 3.0 )
		return "Selected crimes do not require a tribunal!"

	return 0*/

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

	prison_sentence = getMinPrisonSentence()

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

/datum/crime_incident/proc/getMinPrisonSentence()
	var/min = 0
	for( var/datum/law/L in charges )
		min += L.min_prison_time

	if( min < 0 )
		min = 0

	if( min > PERMAPRISON_SENTENCE )
		min = PERMAPRISON_SENTENCE

	return min

/datum/crime_incident/proc/getMaxPrisonSentence()
	var/max = 0
	for( var/datum/law/L in charges )
		max += L.max_prison_time

	if( max < 0 )
		max = 0

	if( max > PERMAPRISON_SENTENCE )
		max = PERMAPRISON_SENTENCE

	return max

/datum/crime_incident/proc/getMaxSeverity()
	var/max = 0
	for( var/datum/law/L in charges )
		if( L.severity > max )
			max = L.severity

	return max

/*/datum/crime_incident/proc/getCourtType()
	switch( getMaxSeverity() )
		if( 2.0 )
			return "Court"
		if( 3.0 )
			return "Tribunal"
*/
/datum/crime_incident/proc/renderGuilty( var/user )
	if( !criminal )
		return

	generateReport()
	/*addToPaperworkRecord( user, criminal.character.unique_identifier,  generateReport(), "Criminal Sentence", "Classified", "Security Records" )

	if( prison_sentence )
		if( prison_sentence >= PERMAPRISON_SENTENCE )
			criminal.character.employment_status = "Serving a life sentence"
		else
			criminal.character.prison_date = progessDate( universe.date, prison_sentence+1 )

	if( getMaxSeverity() >= FELONY_LEVEL )
		criminal.character.felon = 1

	if( !criminal.character.new_character ) // If they already exist in the database
		criminal.character.saveCharacter()*/

/datum/crime_incident/proc/generateReport()
	. = "<center>Security Incident Report</center><hr>"

	/*. += "<b>ARBITER(S)</b>: <i>"
	for( var/i = 1, i <= arbiters.len, i++ )
		var/mob/living/carbon/human/H = arbiters[i]

		if( !istype( H ))
			continue

		if( i > 1 )
			. += ", "

		. += "[H]"*/

	. += "</i><br>"
	. += "<b>CRIMINAL</b>: <i>[criminal]</i><br><br>"

	. += "[criminal] was found guilty of the following crimes on [time2text(world.realtime, "DD-MMM")], [game_year]. "

	if( !brig_sentence && !prison_sentence )
		. += "As decided by the arbiter(s), they will serve no time for their crimes."
	else
		. += "As decided by the arbiter(s), they will serve the following sentence:<br>"
		if( brig_sentence )
			if( brig_sentence >= PERMABRIG_SENTENCE )
				. += "\t<b>BRIG</b>: <i>Imprisonment until transfer</i><br>"
			else
				. += "\t<b>BRIG</b>: <i>[brig_sentence] minutes</i><br>"
			/*if( prison_sentence >= PERMAPRISON_SENTENCE )
				. += "\t<b>PRISON</b>: <i>Life imprisonment</i><br>"
			else
				. += "\t<b>PRISON</b>: <i>[prison_sentence] days</i><br>"*/

	. += "<br><table>"
	. += "<tr><th colspan='2'>CHARGES</th></tr>"
	for( var/datum/law/L in charges )
		. += "<tr>"

		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"

		. += "</tr>"
	. += "</table>"

	return .