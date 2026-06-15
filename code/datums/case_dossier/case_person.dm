/datum/investigation_person
	var/id = ""
	var/name = ""
	var/role = ""
	var/notes = ""

/datum/investigation_person/proc/tgui_data()
	var/list/data = list()
	data["id"] = id
	data["name"] = name
	data["role"] = role
	data["notes"] = notes
	return data

