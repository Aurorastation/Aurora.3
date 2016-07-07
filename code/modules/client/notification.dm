/*
 * A simple datum for storing notifications for dispaly.
 * Saves SQL query space.
 */
/datum/client_notification
	var/datum/preferences/owner = null

	var/list/note_wrapper = list()
	var/note_text = ""

/datum/client_notification/New(var/datum/preferences/prefs, var/new_wrapper, var/new_text)
	if (prefs)
		qdel(src)
		return

	owner = prefs

	note_wrapper = new_wrapper
	note_text = new_text

/datum/client_notification/Destroy()
	if (owner)
		owner.notifications -= src

	..()

/datum/client_notification/proc/get_html()
	var/html = "[note_wrapper[1]][note_text][note_wrapper[2]]"

	return html
