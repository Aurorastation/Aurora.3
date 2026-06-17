#define STATUS_OPEN "Open"
#define STATUS_SUBMITTED "Submitted"
#define STATUS_ARCHIVED "Archived"
/datum/investigation_case
	/// The id of the case. Assigned automatically.
	var/case_id = ""
	/// The case name
	var/title = "new case"
	/// Case status, determining its current status and ability to be editted
	var/status = "Open"
	/// The investigators working on the case
	var/investigator = ""
	/// Tags associated with the case
	var/list/tags = list()

	/// Evidence associated with the case
	var/list/evidence_refs = list()
	/// Photos associated with the case
	var/list/photo_refs = list()
	/// Reports associated with the case
	var/list/report_refs = list()

	/// Case summary
	var/summary = ""
	/// Who started the case
	var/created_by = ""
	/// When the case was opened
	var/created_at = ""
	/// When the case was last updated/editted
	var/updated_at = ""

	/// Timeline description of the events of the case
	var/timeline = ""
	/// The findings of the case, such as motive
	var/findings = ""

	/// The victims in the case
	var/list/victims = list()
	/// The suspects in the case
	var/list/suspects = list()
	/// The witnesses in the case
	var/list/witnesses = list()

	/// Person IDs, set per case
	var/person_uid = 1
	/// Evidence ID, set per case
	var/evidence_uid = 1
	/// Report ID, set per case
	var/report_uid = 1

/// The case ID, to be incremented per new case
GLOBAL_VAR_INIT(case_dossier_uid, 1)
/// All case dossiers
GLOBAL_LIST_EMPTY(case_dossier_cases)
/datum/investigation_case/New()
	..()
	case_id = "C-[worlddate2text]-[GLOB.case_dossier_uid++]"

/// Scans the evidence held in the active hand, into the case files
/datum/investigation_case/proc/scan_held_evidence(var/mob/user, var/obj/item/E)
	if(!E)
		return FALSE
	// Temporary storage of case labels, to use in case evidence bags are used
	/// The area the evidence was collected in
	var/collected_area
	/// The time the evidence was collected
	var/collected_time
	/// Who collected the evidence
	var/collected_by
	/// The label on the evidence bag the evidence is in, if any
	var/bag_label

	// If it is an evidence bag, then we want what is inside of it
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

	/// The evidence item
	var/datum/evidence_item/I = new()
	I.id = "E-[evidence_uid++]"
	I.label = bag_label || E.name
	I.evidence_type = "Item"

	I.collected_by = collected_by
	I.collected_at = collected_time
	I.location = collected_area

	evidence_refs += I
	touch()

	return TRUE

/datum/investigation_case/proc/scan_held_photo(var/mob/user, var/obj/item/E)
	if(!E)
		return FALSE

	// Temporary storage of case labels, to use in case evidence bags are used
	/// The area the evidence was collected in
	var/collected_area
	/// The time the evidence was collected
	var/collected_time
	/// Who collected the evidence
	var/collected_by
	/// The label on the evidence bag the evidence is in, if any
	var/bag_label

	// If it is an evidence bag, then we want what is inside of it, just like with regular evidence items
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

	/// The photo being copied
	var/obj/item/photo/P = E
	/// The evidence linked photo being stored
	var/datum/evidence_item/photo/Photo = new()

	Photo.id = "P-[evidence_uid++]"
	Photo.photo_id = P.id
	Photo.label = bag_label || P.caption
	Photo.evidence_type = "Photo"
	Photo.collected_by = collected_by || P.taken_by
	Photo.collected_at = collected_time || P.time_taken
	Photo.img = P.img
	Photo.scribble = P.scribble
	Photo.location = collected_area || P.location_taken

	photo_refs += Photo
	touch()

	return TRUE

/// Scan the new held paperwork to add to the case. Only takes singular pages
/datum/investigation_case/proc/scan_held_report(var/mob/user, var/obj/item/held_item)
	/// The scanned piece of paper
	var/obj/item/paper/P = held_item

	if(!istype(P, /obj/item/paper))
		to_chat(user, SPAN_WARNING("You need to hold a piece of paper to scan it."))
		return FALSE

	/// The new paper item
	var/datum/case_dossier_report/R = new()
	R.id = "R-[report_uid++]"
	R.title = sanitize(P.name, MAX_NAME_LEN)
	R.evidence_type = "Scanned paper"
	R.author = "Unknown"
	R.created_at = worldtime2text()
	R.collected_by = user?.real_name
	R.collected_at = worldtime2text()
	R.scanned_by = user?.real_name
	R.scanned_at = R.collected_at

	var/rendered_content = ""

	// Part 1: Deal with languages
	if(P.info)
		rendered_content += P.parse_languages(user, P.info, FALSE, TRUE)

	// Part 2: Get the stamps
	if(P.stamps)
		rendered_content += P.stamps

	// Part 3: Done
	R.content = rendered_content

	report_refs += R
	touch()

	to_chat(user, SPAN_NOTICE("You scan \the [P] into [title]."))
	return TRUE

/// Sets the fields to the specified values
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

	touch()

/// Figures out and sets the tags
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

/// We updated it. Time to set the updated time.
/datum/investigation_case/proc/touch()
	updated_at = worldtime2text()

/// Fetch the relevant people
/datum/investigation_case/proc/get_person_list(var/list_name)
	switch(list_name)
		if("victims")
			return victims
		if("suspects")
			return suspects
		if("witnesses")
			return witnesses

	return

/// Add a new person
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

/// Edit the values of a person
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

/// Alright removing a person
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

/// Send the person data to TGUI
/datum/investigation_case/proc/person_list_tgui_data(var/list/L)
	var/list/out = list()

	for(var/datum/investigation_person/P in L)
		out += list(P.tgui_data())

	return out

/// Send the evidence data to TGUI
/datum/investigation_case/proc/evidence_list_tgui_data(var/list/L)
	var/list/out = list()

	for(var/datum/evidence_item/I in L)
		out += list(I.tgui_data())

	return out

/// Send the report data to TGUI
/datum/investigation_case/proc/report_list_tgui_data(var/list/reports)
	var/list/data = list()

	if(!reports)
		return data

	for(var/datum/case_dossier_report/R in reports)
		data += list(R.tgui_data())

	return data

/// Manually add evidence, instead of scanning it
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

/// Find a specific evidence based on ID
/datum/investigation_case/proc/find_evidence_in_list(var/list/L, var/id)
	for(var/datum/evidence_item/I in L)
		if(I.id == id)
			return I
	return

/// Edit an evidence item
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

/// Remove an evidence item
/datum/investigation_case/proc/remove_evidence_item(var/list/L, var/id)
	var/datum/evidence_item/I = find_evidence_in_list(L, id)
	if(!I)
		return FALSE

	L -= I
	qdel(I)
	touch()
	return TRUE

/// Edit an evidence item
/datum/investigation_case/proc/edit_evidence(var/id, var/field, var/value)
	return edit_evidence_item(evidence_refs, id, field, value)

/// Remove evidence
/datum/investigation_case/proc/remove_evidence(var/id)
	return remove_evidence_item(evidence_refs, id)

/// Edit a photo
/datum/investigation_case/proc/edit_photo(var/id, var/field, var/value)
	return edit_evidence_item(photo_refs, id, field, value)

/// Remove a photo
/datum/investigation_case/proc/remove_photo(var/id)
	return remove_evidence_item(photo_refs, id)

/// remove a report
/datum/investigation_case/proc/remove_report(var/id)
	return remove_evidence_item(report_refs, id)

/// Makes an identical case
/datum/investigation_case/proc/copy_case()
	var/datum/investigation_case/N = new()

	N.title = title
	N.status = STATUS_OPEN
	N.investigator = investigator
	N.tags = tags.Copy()

	N.summary = summary
	N.timeline = timeline
	N.findings = findings

	N.victims = victims
	N.suspects = suspects
	N.witnesses = witnesses
	N.evidence_refs = evidence_refs
	N.photo_refs = photo_refs
	N.report_refs = report_refs

	return N

/// creates a clean list from a set of text
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

/// Send a photo to a viewing user so they can see it
/datum/investigation_case/proc/send_photo_resources(var/mob/user)
	if(!user)
		return

	for(var/datum/evidence_item/photo/P in photo_refs)
		if(!P.img)
			continue

		send_rsc(user, P.img, "tmp_photo_[P.photo_id || P.id].png")

/datum/investigation_case/Destroy(force)
	QDEL_LIST(evidence_refs)
	QDEL_LIST(photo_refs)
	QDEL_LIST(report_refs)
	..()

#undef STATUS_OPEN
#undef STATUS_SUBMITTED
#undef STATUS_ARCHIVED
