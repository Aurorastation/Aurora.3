/datum/religion
	var/name
	var/description
	var/book_name = "bible"
	var/book_sprite = "holybook"
	var/list/nulloptions //religion-specific nullrod options

/datum/religion/proc/get_records_name()
	return name
