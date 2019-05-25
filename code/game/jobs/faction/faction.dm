/datum/faction
	var/name
	var/description
	var/list/allowed_roles
	var/is_default = FALSE

/datum/faction/proc/get_occupations()
	. = list()

	for (var/title in allowed_roles)
		. += SSjobs.name_occupations[title]

/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = "Your lord and saviour."
	is_default = TRUE

/datum/faction/nano_trasen/New()
	..()

	allowed_roles = list()

	for (var/datum/job/job in SSjobs.occupations)
		allowed_roles += job.title

/datum/faction/einstein_engines
	name = "Einstein Engines"
	description = "Nikola Tesla is great."
	allowed_roles = list("Station Engineer", "Atmospherics Technician")

/datum/faction/ncropolis
	name = "Necropolis"
	description = "OW THE FUCKING EDGE"
	allowed_roles = list("Security Cadet", "Security Officer")
