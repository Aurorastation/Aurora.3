/datum/investigation_person
	/// The person's id
	var/id = ""
	/// The person's name
	var/name = ""
	/// The person's role
	var/role = ""
	/// Notes about the person
	var/notes = ""

/datum/investigation_person/proc/tgui_data()
	var/list/data = list()
	data["id"] = id
	data["name"] = name
	data["role"] = role
	data["notes"] = notes
	return data

