/datum/religion
	var/name
	var/description
	var/list/deity_name = list("God")
	var/book_name = "bible"
	var/book_sprite = "bible"

/datum/religion/proc/get_gods_name()
	var/god_name = pick(deity_name)
	return god_name

/datum/religion/proc/get_id_name()
	return name