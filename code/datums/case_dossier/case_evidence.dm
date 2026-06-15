/datum/evidence_item
	var/id = ""
	var/label = ""
	var/evidence_type = "Item"
	var/location = ""
	var/evidence_locker = ""
	var/collected_by = ""
	var/collected_at = ""
	var/notes = ""
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

/datum/evidence_item/photo
	var/photo_id = ""
	var/icon/img
	var/scribble = ""
	var/picture_desc = ""
	var/list/linked_evidence = list()

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

