/datum/case_dossier_report
	var/id
	var/title = "Untitled paperwork"
	var/evidence_type = "Scanned paper"
	var/author
	var/created_at
	var/collected_by
	var/collected_at
	var/scanned_by
	var/scanned_at
	var/content
	var/notes

/datum/case_dossier_report/proc/tgui_data()
	var/list/data = list()

	data["id"] = "[id]"
	data["title"] = title
	data["type"] = evidence_type
	data["author"] = author
	data["created_at"] = created_at
	data["collected_by"] = collected_by
	data["collected_at"] = collected_at
	data["scanned_by"] = scanned_by
	data["scanned_at"] = scanned_at
	data["content"] = content
	data["notes"] = notes

	return data
