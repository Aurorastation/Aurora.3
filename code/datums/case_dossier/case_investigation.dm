
#define STATUS_OPEN "Open"
#define STATUS_SUBMITTED "Submitted"
#define STATUS_ARCHIVED "Archived"
/datum/investigation_case
	var/case_id = ""
	var/title = "new case"
	var/status = "Open"
	var/investigator = ""
	var/list/tags = list()

	var/list/evidence_refs = list()
	var/list/photo_refs = list()
	var/list/report_refs = list()

	var/summary = ""
	var/created_by = ""
	var/created_at = ""
	var/updated_at = ""

	var/timeline = ""
	var/findings = ""
	var/recommended_action = ""

	var/list/victims = list()
	var/list/suspects = list()
	var/list/witnesses = list()

	var/person_uid = 0
	var/evidence_uid = 0

GLOBAL_VAR_INIT(case_dossier_uid, 1)
GLOBAL_LIST_EMPTY(case_dossier_cases)
/datum/investigation_case/New()
	..()
	case_id = "C-[GLOB.case_dossier_uid++]"

/datum/investigation_case/proc/scan_held_evidence(var/mob/user, var/obj/item/E)
	if(!E)
		return FALSE
	var/collected_area
	var/collected_time
	var/collected_by
	var/bag_label

	if(istype(E, /obj/item/evidencebag))
		var/obj/item/evidencebag/B = E
		E = B.stored_item
		collected_area = B.collected_location
		collected_time = B.collected_time
		collected_by = B.collected_by
		bag_label = B.label_text

	if(!E)
		to_chat(user, SPAN_NOTICE("The evidence bag is empty."))
		return FALSE

	if(istype(E, /obj/item/photo))
		return FALSE

	collected_by ||= user.name

	var/datum/evidence_item/I = new()
	I.id = "E-[evidence_uid++]"
	I.label = bag_label || E.name
	I.evidence_type = "Item"
	I.notes = E.desc

	I.collected_by = collected_by
	I.collected_at = collected_time
	I.location = collected_area

	evidence_refs += I
	touch()

	return TRUE

/datum/investigation_case/proc/scan_held_photo(var/mob/user, var/obj/item/E)
	if(!E)
		return FALSE

	var/collected_area
	var/collected_time
	var/collected_by
	var/bag_label

	if(istype(E, /obj/item/evidencebag))
		var/obj/item/evidencebag/B = E
		E = B.stored_item
		collected_area = B.collected_location
		collected_time = B.collected_time
		collected_by = B.collected_by
		bag_label = B.label_text

	if(!E)
		to_chat(user, SPAN_NOTICE("The evidence bag is empty."))
		return FALSE

	if(!istype(E, /obj/item/photo))
		return FALSE

	var/obj/item/photo/P = E
	var/datum/evidence_item/photo/Photo = new()

	Photo.id = "P-[evidence_uid++]"
	Photo.photo_id = P.id
	Photo.label = bag_label || P.caption
	Photo.evidence_type = "Photo"
	Photo.collected_by = collected_by || P.taken_by
	Photo.collected_at = collected_time || P.time_taken
	Photo.img = P.img
	Photo.scribble = P.scribble
	Photo.picture_desc = P.picture_desc
	Photo.location = collected_area || P.location_taken

	photo_refs += Photo
	touch()

	return TRUE

/datum/investigation_case/proc/get_next_report_id()
	var/index = 0

	while(TRUE)
		var/candidate = "R-[index]"
		var/found = FALSE

		for(var/datum/case_dossier_report/R in report_refs)
			if("[R.id]" == candidate)
				found = TRUE
				break

		if(!found)
			return candidate

		index++

/datum/investigation_case/proc/scan_held_report(var/mob/user, var/obj/item/held_item)
	var/obj/item/paper/P = held_item

	if(!istype(P, /obj/item/paper))
		to_chat(user, SPAN_WARNING("You need to hold a piece of paper to scan it."))
		return FALSE

	var/datum/case_dossier_report/R = new()
	R.id = get_next_report_id()
	R.title = sanitize(P.name, MAX_NAME_LEN)
	R.evidence_type = "Scanned paper"
	R.author = "Unknown"
	R.created_at = worldtime2text()
	R.collected_by = user?.real_name
	R.collected_at = worldtime2text()
	R.scanned_by = user?.real_name
	R.scanned_at = R.collected_at

	var/rendered_content = ""

	if(P.info)
		rendered_content += P.parse_languages(user, P.info, FALSE, TRUE)

	if(P.stamps)
		rendered_content += P.stamps

	R.content = rendered_content

	report_refs += R
	touch()

	to_chat(user, SPAN_NOTICE("You scan \the [P] into [title]."))
	return TRUE

/datum/investigation_case/proc/set_field(var/field, var/value)
	switch(field)
		if("title")
			title = value
		if("status")
			status = value
		if("investigator")
			investigator = value
		if("summary")
			summary = value
		if("timeline")
			timeline = value
		if("findings")
			findings = value
		if("recommended_action")
			recommended_action = value

	touch()

/datum/investigation_case/proc/set_tags_from_text(var/value)
	tags = list()

	if(!value)
		touch()
		return

	var/list/raw_tags = splittext(value, ",")
	for(var/tag in raw_tags)
		var/clean_tag = trim(tag)
		if(clean_tag)
			tags += clean_tag

	touch()

/datum/investigation_case/proc/touch()
	updated_at = worldtime2text()

/datum/investigation_case/proc/get_person_list(var/list_name)
	switch(list_name)
		if("victims")
			return victims
		if("suspects")
			return suspects
		if("witnesses")
			return witnesses

	return null

/datum/investigation_case/proc/add_person(var/list_name)
	var/list/L = get_person_list(list_name)
	if(!L)
		return FALSE

	var/datum/investigation_person/P = new()
	P.id = "P-[person_uid++]"

	switch(list_name)
		if("victims")
			P.role = "Victim"
		if("suspects")
			P.role = "Suspect"
		if("witnesses")
			P.role = "Witness"

	L += P
	touch()
	return TRUE

/datum/investigation_case/proc/edit_person(var/list_name, var/id, var/field, var/value)
	var/list/L = get_person_list(list_name)
	if(!L)
		return FALSE

	for(var/datum/investigation_person/P in L)
		if(P.id == id)
			switch(field)
				if("name")
					P.name = value
				if("role")
					P.role = value
				if("notes")
					P.notes = value

			touch()
			return TRUE

	return FALSE

/datum/investigation_case/proc/remove_person(var/list_name, var/id)
	var/list/L = get_person_list(list_name)
	if(!L)
		return FALSE

	for(var/datum/investigation_person/P in L)
		if(P.id == id)
			L -= P
			qdel(P)
			touch()
			return TRUE

	return FALSE

/datum/investigation_case/proc/person_list_tgui_data(var/list/L)
	var/list/out = list()

	for(var/datum/investigation_person/P in L)
		out += list(P.tgui_data())

	return out

/datum/investigation_case/proc/evidence_list_tgui_data(var/list/L)
	var/list/out = list()

	for(var/datum/evidence_item/I in L)
		out += list(I.tgui_data())

	return out

/datum/investigation_case/proc/report_list_tgui_data(var/list/reports)
	var/list/data = list()

	if(!reports)
		return data

	for(var/datum/case_dossier_report/R in reports)
		data += list(R.tgui_data())

	return data

/datum/investigation_case/proc/add_manual_evidence(var/mob/user)
	var/datum/evidence_item/I = new()
	I.id = "E-[evidence_uid++]"
	I.label = "New Evidence"
	I.evidence_type = "Item"
	I.collected_by = user?.name
	I.collected_at = worldtime2text()
	evidence_refs += I
	touch()
	return TRUE

/datum/investigation_case/proc/find_evidence_in_list(var/list/L, var/id)
	for(var/datum/evidence_item/I in L)
		if(I.id == id)
			return I
	return null

/datum/investigation_case/proc/edit_evidence_item(var/list/L, var/id, var/field, var/value)
	var/datum/evidence_item/I = find_evidence_in_list(L, id)
	if(!I)
		return FALSE

	switch(field)
		if("label", "caption", "title")
			I.label = value

		if("type")
			I.evidence_type = value

		if("location")
			I.location = value

		if("evidence_locker")
			I.evidence_locker = value

		if("notes")
			I.notes = value

		if("collected_by", "taken_by", "author")
			I.collected_by = value

		if("collected_at", "taken_at", "created_at")
			I.collected_at = value

		if("linked_people")
			I.linked_people = text_to_clean_list(value)

		if("linked_evidence")
			if(istype(I, /datum/evidence_item/photo))
				var/datum/evidence_item/photo/P = I
				P.linked_evidence = text_to_clean_list(value)

	touch()
	return TRUE

/datum/investigation_case/proc/remove_evidence_item(var/list/L, var/id)
	var/datum/evidence_item/I = find_evidence_in_list(L, id)
	if(!I)
		return FALSE

	L -= I
	qdel(I)
	touch()
	return TRUE

/datum/investigation_case/proc/edit_evidence(var/id, var/field, var/value)
	return edit_evidence_item(evidence_refs, id, field, value)

/datum/investigation_case/proc/remove_evidence(var/id)
	return remove_evidence_item(evidence_refs, id)

/datum/investigation_case/proc/edit_photo(var/id, var/field, var/value)
	return edit_evidence_item(photo_refs, id, field, value)

/datum/investigation_case/proc/remove_photo(var/id)
	return remove_evidence_item(photo_refs, id)

/datum/investigation_case/proc/remove_report(var/id)
	return remove_evidence_item(report_refs, id)

/datum/investigation_case/proc/copy_case()
	var/datum/investigation_case/N = new()

	N.title = title
	N.status = STATUS_OPEN
	N.investigator = investigator
	N.tags = tags.Copy()

	N.summary = summary
	N.timeline = timeline
	N.findings = findings
	N.recommended_action = recommended_action

	N.victims = victims
	N.suspects = suspects
	N.witnesses = witnesses
	N.evidence_refs = evidence_refs
	N.photo_refs = photo_refs
	N.report_refs = report_refs

	return N

/datum/investigation_case/proc/text_to_clean_list(var/value)
	var/list/out = list()

	if(!value)
		return out

	var/list/raw_values = splittext(value, ",")
	for(var/raw_value in raw_values)
		var/clean_value = trim(raw_value)
		if(clean_value)
			out += clean_value

	return out

/datum/investigation_case/proc/send_photo_resources(var/mob/user)
	if(!user)
		return

	for(var/datum/evidence_item/photo/P in photo_refs)
		if(!P.img)
			continue

		send_rsc(user, P.img, "tmp_photo_[P.photo_id || P.id].png")

