/datum/evidence_item
	/// The id of the evidence item. Assigned automatically.
	var/id = ""
	/// Evidence name
	var/label = ""
	/// The category type a piece of evidence is, such as contraband
	var/evidence_type = "Item"
	/// The location the evidence was found
	var/location = ""
	/// The locker the evidence is in
	var/evidence_locker = ""
	/// The person to collect the evidence
	var/collected_by = ""
	/// The time the evidence was collected
	var/collected_at = ""
	/// The notes attached to the evidence
	var/notes = ""
	/// The people related to the evidence
	var/list/linked_people = list()

/datum/evidence_item/proc/tgui_data()
	var/list/data = list()
	data["id"] = id

	data["label"] = label
	data["type"] = evidence_type
	data["location"] = location
	data["evidence_locker"] = evidence_locker
	data["linked_people"] = linked_people
	data["collected_by"] = collected_by
	data["collected_at"] = collected_at
	data["notes"] = notes

	data["title"] = label
	data["author"] = collected_by
	data["created_at"] = collected_at

	return data

/datum/evidence_item/New(var/id_input, var/label_input, var/evidence_type_input, var/collected_by_input, var/collected_at_input, var/collected_location_input)
	..()
	id = "E-[id_input]"
	label = label_input
	evidence_type = evidence_type_input

	collected_by = collected_by_input
	collected_at = collected_at_input
	location = collected_location_input

/datum/evidence_item/Destroy(force)
	linked_people.Cut()
	return ..()

/datum/evidence_item/photo
	/// The photo id, used as part of ensuring the viewing client gets the proper photo
	var/photo_id = ""
	/// The image of the photo
	var/icon/img
	/// What is scribbled on the photo
	var/scribble = ""
	/// The associated evidence of the photo
	var/list/linked_evidence = list()

/datum/evidence_item/photo/New(id_input, i_label_input, evidence_type_input = "Photo", collected_by_input,
collected_at_input, collected_location_input, var/photo_id_input, var/photo_img_input, var/photo_scribble_input)
	..()
	id = "P-[id_input]"
	photo_id = photo_id_input
	img = photo_img_input
	scribble = photo_scribble_input

/datum/evidence_item/photo/Destroy(force)
	linked_evidence.Cut()
	return ..()

/datum/evidence_item/photo/tgui_data()
	var/list/data = list()
	data["id"] = id
	data["photo_id"] = photo_id
	data["caption"] = label
	data["type"] = evidence_type
	data["location"] = location
	data["taken_by"] = collected_by
	data["taken_at"] = collected_at
	data["collected_by"] = collected_by
	data["collected_at"] = collected_at
	data["notes"] = notes
	data["scribble"] = scribble
	data["linked_evidence"] = linked_evidence

	if(img)
		data["image"] = "tmp_photo_[photo_id || id].png"

	return data

