/datum/religion
	var/name
	var/description
	var/unique_book_path = null //if religion has a special book/codex, i.e. versebook
	var/book_name = "bible"
	var/book_sprite = "holybook"
	var/list/nulloptions //religion-specific nullrod options

/datum/religion/proc/get_records_name()
	return name
