// Generic data stored in record
/datum/record
	var/name
	var/id
	var/notes = "No notes found."

	var/cmp_field = "id"
	var/list/excluded_fields
	var/list/excluded_print_fields

/datum/record/New()
	..()
	var/tmp_ex = excluded_fields
	excluded_fields = list()
	for(var/f in tmp_ex)
		excluded_fields[f] = f
	tmp_ex = excluded_print_fields
	excluded_print_fields = list()
	for(var/f in tmp_ex)
		excluded_print_fields[f] = f

/datum/record/proc/Copy(var/datum/copied)
	if(!copied)
		copied = new src.type()
	var/exclusions = (SSrecords.excluded_fields | src.excluded_fields)
	for(var/variable in src.vars)
		if(exclusions[variable]) continue
		if(istype(src.vars[variable], /datum/record) || istype(src.vars[variable], /list))
			var/list/V = vars[variable]
			copied.vars[variable] = V.Copy()
		else
			copied.vars[variable] = src.vars[variable]
	return copied

/proc/record_notes_to_paper_html(notes)
	if(!notes)
		return ""

	// Character preferences store records HTML-encoded. Normalize them before
	// sanitizing so entities such as &#39; are not encoded a second time.
	var/text = trim(html_decode("[notes]"))
	if(!length(text))
		return ""

	text = sanitize(text, MAX_PAPER_MESSAGE_LEN, extra = 0)
	return pencode2html(text)

/datum/record/proc/notes_as_paper_html()
	return record_notes_to_paper_html(notes)

#define CONDITIONAL_HTML_DECODE(VAR)\
	if(decode_html){\
		if(istext(##VAR)){\
			##VAR = html_decode(##VAR);\
		}\
	}

/datum/record/proc/Listify(var/deep = 1, var/list/excluded = list(), var/list/to_update, decode_html = FALSE) // Mostly to support old things or to use with serialization
	var/list/record
	if(!to_update)
		. = record = list()
	else
		record = to_update || list()
	var/tmp_ex = excluded
	excluded = list()
	for(var/e in tmp_ex)
		excluded[e] = e
	var/exclusions = (SSrecords.excluded_fields | src.excluded_fields | excluded)
	for(var/variable in src.vars)
		if(!exclusions[variable])
			if(deep && (istype(src.vars[variable], /datum/record)))
				if(to_update)
					var/datum/record/R = src.vars[variable]
					var/listified = R.Listify(to_update = to_update[variable], decode_html = decode_html)
					if(listified)
						record[variable] = listified
						CONDITIONAL_HTML_DECODE(record[variable])
						. = record
				else
					var/datum/record/R = src.vars[variable]
					record[variable] = R.Listify(decode_html = decode_html)
					//no escape
			else if(deep && islist(src.vars[variable]) && is_list_containing_type(src.vars[variable], /datum/record))
				record[variable] = list()
				for(var/subr in src.vars[variable])
					var/datum/record/r = subr
					record[variable] += list(r.Listify(decode_html = decode_html))
				var/llen = 0
				if((variable in to_update) && islist(to_update[variable]))
					var/list/L = to_update[variable]
					llen = L.len
				if(llen != LAZYLEN(record[variable]))
					. = record
					CONDITIONAL_HTML_DECODE(.)
			else if(islist(src.vars[variable]) || istext(src.vars[variable]) || isnum(src.vars[variable]))
				if(to_update && record[variable] != src.vars[variable])
					record[variable] = src.vars[variable]
					CONDITIONAL_HTML_DECODE(record[variable])
					. = record
				else if(!to_update)
					record[variable] = src.vars[variable]
					CONDITIONAL_HTML_DECODE(record[variable])

	if(!exclusions["notes"])
		record["notes_html"] = notes_as_paper_html()

#undef CONDITIONAL_HTML_DECODE


/datum/record/proc/Printify(var/list/excluded = list()) // Mostly to support old things or to use with serialization
	. = ""
	var/tmp_ex = excluded
	excluded = list()
	for(var/e in tmp_ex)
		excluded[e] = e
	var/exclusions = (SSrecords.excluded_fields | src.excluded_fields | excluded | src.excluded_print_fields)
	var/extendedVars = list() // To put last
	for(var/variable in src.vars)
		if(!exclusions[variable])
			if(istype(src.vars[variable], /datum/record))
				var/datum/record/R = src.vars[variable]
				extendedVars[variable] = R
				// . += "<h3>[variable]</h3>"
				// . += src.vars[variable].Printify()
			else if(istype(src.vars[variable], /list))
				. += "<b>[get_field_name(variable)]:</b><br>"
				var/list/values = src.vars[variable]
				if(is_list_containing_type(values, /datum/record/record_comment))
					for(var/datum/record/record_comment/record_comment in values)
						. += "[record_comment.as_html()]<br>"
				else
					. += jointext(values, "<br>")
			else if(istext(src.vars[variable]) || isnum(src.vars[variable]))
				. += "<b>[get_field_name(variable)]:</b> [src.vars[variable]]<br>"
	for(var/variable in extendedVars)
		. += "<center><h3>[get_field_name(variable)]</h3></center>"
		var/datum/record/R = src.vars[variable]
		. += R.Printify()

/datum/record/proc/get_field_name(var/field)
	. = SSrecords.localized_fields[src.type][field]
	if(!.)
		return capitalize(replacetext(field, "_", " "))

/datum/record/record_comment
	var/db_id = 0
	var/char_id = 0
	var/record_type
	var/comment = ""
	var/author = "Unknown"
	var/created_at = ""
	var/created_by
	var/updated_at = ""
	var/updated_by
	excluded_fields = list("name", "notes", "db_id", "char_id", "record_type", "created_by", "updated_by")

/datum/record/record_comment/New(var/new_char_id, var/new_record_type, var/new_comment, var/new_author, var/new_created_by)
	..()
	char_id = new_char_id
	record_type = new_record_type
	comment = new_comment
	author = new_author
	if(!author)
		author = "Unknown"
	created_by = new_created_by
	id = md5("[world.realtime][rand(0, 1000000)][REF(src)]")
	created_at = "[time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]"

/datum/record/record_comment/proc/save_to_db()
	if(!establish_db_connection(GLOB.dbcon) || !char_id)
		return FALSE

	var/list/sql_args = list(
		"char_id" = char_id,
		"uid" = id,
		"record_type" = record_type,
		"comment" = comment,
		"author" = author,
		"created_by" = created_by,
		"updated_by" = updated_by,
		"game_id" = GLOB.round_id
	)
	var/DBQuery/query
	if(db_id)
		query = GLOB.dbcon.NewQuery({"UPDATE ss13_character_record_comments
			SET body = :comment:, updated_by = :updated_by:, updated_at = NOW()
			WHERE id = :db_id: AND deleted_at IS NULL"})
		sql_args["db_id"] = db_id
	else
		query = GLOB.dbcon.NewQuery({"INSERT INTO ss13_character_record_comments
			(char_id, UID, record_type, body, author, created_by, updated_by, game_id)
			VALUES
			(:char_id:, :uid:, :record_type:, :comment:, :author:, :created_by:, :updated_by:, :game_id:)"})

	if(!query.Execute(sql_args))
		log_world("ERROR: Failed to save a persistent record comment for character #[char_id]: [query.ErrorMsg()]")
		return FALSE
	if(!db_id)
		var/DBQuery/id_query = GLOB.dbcon.NewQuery("SELECT LAST_INSERT_ID()")
		if(!id_query.Execute() || !id_query.NextRow())
			log_world("ERROR: Failed to retrieve the database ID for persistent record comment [id]: [id_query.ErrorMsg()]")
			return FALSE
		db_id = text2num(id_query.item[1])
	return TRUE

/datum/record/record_comment/proc/delete_from_db(var/deleted_by)
	if(!establish_db_connection(GLOB.dbcon) || !db_id)
		return FALSE
	var/DBQuery/query = GLOB.dbcon.NewQuery({"UPDATE ss13_character_record_comments
		SET deleted_by = :deleted_by:, deleted_at = NOW()
		WHERE id = :db_id: AND deleted_at IS NULL"})
	if(!query.Execute(list("db_id" = db_id, "deleted_by" = deleted_by)))
		log_world("ERROR: Failed to delete persistent record comment #[db_id]: [query.ErrorMsg()]")
		return FALSE
	return TRUE

/datum/record/record_comment/proc/as_html()
	return "Made by [author] on [created_at]<BR>[replacetext(comment, "\n", "<BR>")]"

// Record for storing general data, data tree top level datum
/datum/record/general
	name = "New Record"
	var/character_id = 0
	var/real_rank = "Unassigned"
	var/rank = "Unassigned"
	var/age = 0
	var/sex = "Unknown"
	var/species = "Unknown"
	var/fingerprint = "Unknown"
	var/physical_status = "Active"
	var/mental_status = "Stable"
	var/citizenship = "Unknown"
	var/employer = "Unknown"
	var/religion = "Unknown"
	var/ccia_record = "No CCIA records found"
	var/list/ccia_actions = list()
	var/icon/photo_front
	var/icon/photo_side
	var/datum/record/medical/medical
	var/datum/record/security/security
	var/list/comments = list()
	var/list/advanced_fields = list("citizenship", "employer", "religion", "ccia_record", "ccia_actions")
	cmp_field = "name"
	excluded_fields = list("photo_front", "photo_side", "advanced_fields", "real_rank", "character_id")
	excluded_print_fields = list("ccia_actions")

/datum/record/general/New(var/mob/living/carbon/human/H, var/nid)
	..()
	if (!H)
		var/mob/living/carbon/human/dummy/mannequin/dummy = SSmobs.get_mannequin("New record")
		photo_front = getFlatIcon(dummy, SOUTH, no_anim = TRUE)
		photo_side = getFlatIcon(dummy, WEST, no_anim = TRUE)
	else
		photo_front = getFlatIcon(H, SOUTH, no_anim = TRUE)
		photo_side = getFlatIcon(H, WEST, no_anim = TRUE)
	if(!nid)
		nid = generate_record_id()
	id = nid
	if(H)
		character_id = H.character_id
		name = H.real_name
		real_rank = H.mind.assigned_role
		rank = GetAssignment(H, TRUE)
		age = H.age
		fingerprint = md5(H.dna.uni_identity)
		sex = H.species.get_species_record_sex(H)
		species = H.get_species(FALSE, TRUE)
		citizenship = SSrecords.get_citizenship_record_name(H.citizenship)
		employer = H.employer_faction
		religion = SSrecords.get_religion_record_name(H.religion)
		ccia_record = H.ccia_record
		ccia_actions = H.ccia_actions
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			notes = H.gen_record
	medical = new(H, id)
	security = new(H, id)
	if(H)
		for(var/datum/record/record_comment/record_comment in H.record_comments)
			switch(record_comment.record_type)
				if("employment")
					comments += record_comment
				if("medical")
					medical.comments += record_comment
				if("security")
					security.comments += record_comment

/datum/record/general/proc/get_comments(var/record_type)
	switch(record_type)
		if("employment")
			return comments
		if("medical")
			return medical?.comments
		if("security")
			return security?.comments

/datum/record/general/proc/add_comment(var/record_type, var/comment_text, var/author, var/created_by)
	var/list/comment_list = get_comments(record_type)
	if(!comment_list)
		return
	var/datum/record/record_comment/record_comment = new(character_id, record_type, comment_text, author, created_by)
	comment_list += record_comment
	record_comment.save_to_db()
	return record_comment


// Record for locked data
/datum/record/general/locked
	var/nid = ""
	var/enzymes
	var/identity
	var/exploit_record

/datum/record/general/locked/New(var/mob/living/carbon/human/H)
	..()
	// Only init things that are needed
	if(H)
		nid = md5("[H.real_name][H.mind.assigned_role]")
		enzymes = H.dna.SE
		identity = H.dna.UI
		if(H.exploit_record && !jobban_isbanned(H, "Records"))
			exploit_record = H.exploit_record

// Record for storing medical data
/datum/record/medical
	var/blood_type = "AB+"
	var/blood_dna = "63920c3ec24b5d57d459b33a2f4d6446"
	var/list/comments = list()

/datum/record/medical/New(var/mob/living/carbon/human/H, var/nid)
	..()
	if(!nid)
		nid = generate_record_id()
	id = nid
	if(H)
		blood_type = H.b_type
		blood_dna = H.dna.unique_enzymes
		if(H.med_record && !jobban_isbanned(H, "Records"))
			notes = H.med_record
		else notes = "No history has been reported yet."

// Record for storing security data
/datum/record/security
	var/criminal = "None"
	var/crimes = "No criminal record."
	var/list/incidents = list()
	var/list/comments = list()

/datum/record/security/New(var/mob/living/carbon/human/H, var/nid)
	..()
	if(!nid)
		nid = generate_record_id()
	id = nid
	if(H)
		incidents = H.incidents
		if(H.sec_record && !jobban_isbanned(H, "Records"))
			notes = H.sec_record


// Digital warrant
/datum/record/warrant
	name = "Unknown"
	notes = "No charges present"
	cmp_field = "name"

	var/authorization = "Unauthorized"
	var/wtype = "Unknown"

GLOBAL_VAR_INIT(warrant_uid, 0)
/datum/record/warrant/New()
	..()
	id = GLOB.warrant_uid++

//Manifest record
/datum/record/shuttle_manifest
	name = "Unknown"
	cmp_field = "name"
	var/shuttle = "Unknown"
	var/pilot = FALSE
	var/lead = FALSE

GLOBAL_VAR_INIT(shuttle_uid, 0)
/datum/record/shuttle_manifest/New()
	..()
	id = GLOB.shuttle_uid++

/datum/record/shuttle_assignment
	var/shuttle
	var/destination = "Unknown"
	var/heading = 0
	var/mission = "Exploration"
	var/departure_time
	var/return_time
	cmp_field = "destination"

/datum/record/shuttle_assignment/New(var/for_shuttle)
	. = ..()
	shuttle = for_shuttle
