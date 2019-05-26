/datum/faction
	var/name
	var/description
	var/list/allowed_role_names
	var/list/allowed_race_names
	var/list/titles_to_loadout = list()
	var/is_default = FALSE

/datum/faction/proc/get_occupations()
	. = list()

	for (var/title in allowed_role_names)
		. += SSjobs.name_occupations[title]

/datum/faction/proc/get_selection_error(datum/preferences/prefs)
	if (allowed_race_names && !(prefs.species in allowed_race_names))
		return "Race not allowed."

	return null

/datum/faction/proc/can_select(datum/preferences/prefs)
	return !get_selection_error(prefs)

/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = "Your lord and saviour."
	is_default = TRUE

/datum/faction/nano_trasen/New()
	..()

	allowed_role_names = list()

	for (var/datum/job/job in SSjobs.occupations)
		allowed_role_names += job.title

/datum/faction/einstein_engines
	name = "Einstein Engines"
	description = "Nikola Tesla is great."
	allowed_role_names = list("Station Engineer", "Atmospherics Technician")

/datum/faction/ncropolis
	name = "Necropolis"
	description = "OW THE FUCKING EDGE"
	allowed_role_names = list("Security Cadet", "Security Officer")
