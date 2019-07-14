/datum/faction
	var/name
	var/description
	var/title_suffix

	var/list/allowed_role_types
	var/list/allowed_species_types

	var/is_default = FALSE

	var/list/titles_to_loadout = list()

/datum/faction/New()
	var/list/l = list()

	for (var/path in allowed_species_types)
		if (allowed_species_types[path] != TRUE)
			l |= typecacheof(path, FALSE)
		else
			l[path] = TRUE

	allowed_species_types = l

/datum/faction/proc/get_occupations()
	. = list()

	for (var/path in allowed_role_types)
		. += SSjobs.type_occupations[path]

/datum/faction/proc/get_selection_error(datum/preferences/prefs)
	if (!length(allowed_species_types))
		return null

	var/datum/species/S = prefs.get_species_datum()

	if (!S)
		return "No valid species selected."

	if (!is_type_in_typecache(S, allowed_species_types))
		return "Invalid species selected."

	return null

/datum/faction/proc/can_select(datum/preferences/prefs)
	return !get_selection_error(prefs)

/datum/faction/proc/get_logo_name()
	return "faction_[title_suffix].png"
