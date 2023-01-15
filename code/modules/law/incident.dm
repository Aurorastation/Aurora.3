/datum/crime_incident
	var/UID // The unique identifier for this incident

	var/notes = "" // The written explanation of the crime

	var/list/charges = list() // What laws were broken in this incident
	var/list/evidence = list() // If its a prison sentence, it'll require evidence

	var/list/arbiters = list( "Witness" = list() ) // The person or list of people who were involved in the conviction of the criminal
	var/datum/weakref/criminal // The person who committed the crimes
	var/datum/weakref/card // The ID of the criminal

	var/datetime = "" //When the crime has been commited

	var/brig_sentence = 0 // How long do they stay in the brig on the station, PERMABRIG_SENTENCE minutes = permabrig
	var/prison_sentence = 0 // How long do they stay in prison, PERMAPRISON_SENTENCE days = life sentence

	var/fine = 0// how much space dosh do they need to cough up if they want to go free
	var/felony // will the criminal become a felon as a result of being found guilty of his crimes?

	var/created_by //The ckey and name of the person that created that charge

/datum/crime_incident/New()
	UID = md5( "[world.realtime][rand(0, 1000000)]" )
	datetime = "[worlddate2text()]-[worldtime2text()]"

	..()

/datum/crime_incident/proc/addArbiter( var/obj/item/card/id/C, var/title )
	if( !istype( C ))
		return "Invalid ID card!"
	var/mob/living/carbon/human/M = C.mob_id.resolve()
	if( !M )
		return "ID card not tied to an SCC Employee!"

	var/list/same_access // The card requires one of these access codes to become this title
	var/minSeverity = 1

	switch( title )
		if( "Witness" ) // anyone can be a witness
			var/list/L = arbiters[title]
			L += list( M ) // some reason adding a mob counts as adding a list, so it would add the mob contents
			arbiters[title] = L
			return 0

	if( minSeverity > getMaxSeverity() )
		return "The severity of the incident does not call for a [title]."

	if( same_access && same_access.len )
		arbiters[title] = M
		return 0
	else
		return "Could not add [M] as [title]."

/datum/crime_incident/proc/missingSentenceReq()
	var/mob/living/carbon/human/C = criminal.resolve()
	if( !istype( C ))
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

/datum/crime_incident/proc/getBrigSentence()
	if(brig_sentence < PERMABRIG_SENTENCE)
		return "[brig_sentence] min"
	else
		return "Holding until Transfer"

/datum/crime_incident/proc/getMaxSeverity()
	var/max = 0
	for( var/datum/law/L in charges )
		if( L.severity > max )
			max = L.severity

	return max

//type: 0 - brig sentence, 1 - fine, 2 - prison sentence
/datum/crime_incident/proc/renderGuilty( var/mob/living/user, var/type=0 )
	var/mob/living/carbon/human/C = criminal.resolve()
	if( !C )
		return

	created_by = "[user.ckey] - [user.real_name]"

	if(type == 0)
		prison_sentence = 0
		fine = 0
	else if(type == 1)
		brig_sentence = 0
		prison_sentence = 0
	else if(type == 2)
		brig_sentence = 0
		fine = 0

	saveCharInfraction()
	return generateReport()

/datum/crime_incident/proc/generateReport()
	var/mob/living/carbon/human/C = criminal.resolve()
	if( !C )
		return
	. = "<center>Security Incident Report</center><hr>"

	. += "<br>"
	. += "<b>CRIMINAL</b>: <i>[C]</i><br><br>"

	. += "[C] was found guilty of the following crimes on [game_year]-[time2text(world.realtime, "MMM-DD")].<br>"

	if( brig_sentence != 0 )
		. += "As decided by the arbiter(s), they will serve the following sentence:<br>"
		if( brig_sentence >= PERMABRIG_SENTENCE )
			. += "\t<b>BRIG</b>: <i>Holding until transfer</i><br>"
		else
			. += "\t<b>BRIG</b>: <i>[brig_sentence] minutes</i><br>"
	else if ( fine != 0 )
		. += "As decided by the arbiter(s), they have been fined [fine] credits.<br>"
	else
		. += "As decided by the arbiter(s), they will serve no time for their crimes.<br>"
	. += "<br><table>"
	. += "<tr><th colspan='2'>CHARGES</th></tr>"
	for( var/datum/law/L in charges )
		. += "<tr>"

		. += "<td><b>[L.name]</b></td>"
		. += "<td><i>[L.desc]</i></td>"

		. += "</tr>"
	. += "</table>"

	return .

/datum/crime_incident/proc/saveCharInfraction()
	var/mob/living/carbon/human/C = criminal.resolve()
	var/datum/record/char_infraction/cinf = new()
	cinf.char_id = C.character_id
	cinf.id = UID
	cinf.notes = notes
	cinf.charges = json_decode(json_encode(charges)) //Thats there to strip all the non-needed values from the data before saving it to the db
	cinf.evidence = json_decode(json_encode(evidence))
	cinf.arbiters = json_decode(json_encode(arbiters))
	cinf.datetime = datetime
	cinf.brig_sentence = brig_sentence
	cinf.prison_sentence = prison_sentence
	cinf.fine = fine
	cinf.felony = felony
	cinf.created_by = created_by
	// Check if player is a antag
	if(isnull(C.mind.special_role))
		cinf.saveToDB()
	var/datum/record/general/R = SSrecords.find_record("name", C.name)
	if(istype(R) && istype(R.security))
		R.security.incidents += cinf

/datum/record/char_infraction
	var/db_id = 0
	var/char_id
	notes = "" // The written explanation of the crime
	var/list/charges = list() // What laws were broken in this incident
	var/list/evidence = list() // If its a prison sentence, it'll require evidence
	var/list/arbiters = list( "Witness" = list() ) // The person or list of people who were involved in the conviction of the criminal
	var/datetime = "" //When the crime has been commited
	var/brig_sentence = 0 // How long do they stay in the brig on the station, PERMABRIG_SENTENCE minutes = permabrig
	var/prison_sentence = 0 // How long do they stay in prison, PERMAPRISON_SENTENCE days = life sentence
	var/fine = 0// how much space dosh do they need to cough up if they want to go free
	var/felony = 0// will the criminal become a felon as a result of being found guilty of his crimes?
	var/created_by //The ckey and name of the person that created that charge
	excluded_fields = list("db_id", "char_id", "created_by", "felony", "evidence", "arbiters", "brig_sentence", "prison_sentence", "fine")

/datum/record/char_infraction/proc/getBrigSentence()
	if(brig_sentence < PERMABRIG_SENTENCE)
		return "[brig_sentence] min"
	else
		return "Holding until Transfer"

/datum/record/char_infraction/proc/saveToDB()
	if(!establish_db_connection(dbcon))
		error("SQL database connection failed. Infractions Datum failed to save information")
		return

	//Dont save the infraction to the db if the char id is 0
	if(char_id == 0)
		log_debug("Infraction: Not saved to the db - Char ID = 0")
		return

	//Check for Level 3 infractions and dont run the query if there are some
	for( var/datum/law/L in charges )
		if (L.severity == 3)
			log_debug("Infraction: Not saved to the db - Red Level Infraction")
			return

	var/list/sql_args[] = list(
		"char_id" = char_id,
		"uid" = id,
		"datetime" = datetime,
		"notes" = notes,
		"charges" = json_encode(charges),
		"evidence" = json_encode(evidence),
		"arbiters" = json_encode(arbiters),
		"brig_sentence" = brig_sentence,
		"fine" = fine,
		"felony" = felony,
		"created_by" = created_by,
		"game_id" = game_id
	)
	//Insert a new entry into the db. Upate if a entry with the same chard_id and UID already exists
	var/DBQuery/infraction_insert_query = dbcon.NewQuery({"INSERT INTO ss13_character_incidents
		(char_id,  UID, datetime, notes, charges, evidence, arbiters, brig_sentence, fine, felony, created_by, game_id)
	VALUES
		(:char_id:, :uid:, :datetime:, :notes:, :charges:, :evidence:, :arbiters:, :brig_sentence:, :fine:, :felony:, :created_by:, :game_id:)
	ON DUPLICATE KEY UPDATE
		notes = :notes:,
		charges = :charges:,
		evidence = :evidence:,
		arbiters = :arbiters:,
		brig_sentence = :brig_sentence:,
		fine = :fine:,
		felony = :felony:,
		created_by = :created_by:,
		game_id = :game_id:
	"})
	infraction_insert_query.Execute(sql_args)

/datum/record/char_infraction/proc/deleteFromDB(var/deleted_by)
	if(!establish_db_connection(dbcon))
		error("SQL database connection failed. Infractions Datum failed to save information")
		return

	//Dont save the infraction to the db if the char id is 0
	if(char_id == 0)
		log_debug("Infraction: Not deleted from the db - char_id = 0")
		return

	//Dont delete if the db_id is 0 (Then the incident has not been loaded from the db)
	if(db_id == 0)
		log_debug("Infraction: Not deleted from the db - db_id 0")

	var/list/sql_args[] = list(
		"id" = db_id,
		"deleted_by" = deleted_by
	)
	//Insert a new entry into the db. Upate if a entry with the same chard_id and UID already exists
	var/DBQuery/infraction_delete_query = dbcon.NewQuery({"UPDATE ss13_character_incidents
	SET
		deleted_by=:deleted_by:,
		deleted_at=NOW()
	WHERE
		id = :id:"})
	infraction_delete_query.Execute(sql_args)
