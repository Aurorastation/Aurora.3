/datum/case_dossier_report
	/// The id associated with the report
	var/id
	/// The report's title
	var/title = "Untitled paperwork"
	/// The report type.
	var/evidence_type = "Scanned paper"
	/// The author, mainly for future proofing
	var/author
	/// was created, for future proofing
	var/created_at
	/// Who collected it, for future proofing
	var/collected_by
	/// When it was collected, for future proofing
	var/collected_at
	/// Who scanned it
	var/scanned_by
	/// When it was scanned
	var/scanned_at
	/// What is written
	var/content
	/// Notes, for future proofing
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
