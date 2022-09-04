/datum/faction
	var/name
	var/description
	var/title_suffix
	var/departments

	var/list/allowed_role_types
	var/list/allowed_species_types
	var/list/job_species_blacklist //will override the normal job species list for a member of this faction

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
		if(islist(path))
			for(var/role_path in path)
				var/datum/job/role = SSjobs.type_occupations[role_path]
				if(!istype(role))
					continue
				if(LAZYACCESS(job_species_blacklist, role.title))
					role.blacklisted_species = job_species_blacklist[role.title]
				else
					var/datum/job/J = new role.type
					role.blacklisted_species = J.blacklisted_species
				. += role
		else
			var/datum/job/role = SSjobs.type_occupations[path]
			if(LAZYACCESS(job_species_blacklist, role.title))
				role.blacklisted_species = job_species_blacklist[role.title]
			else
				var/datum/job/J = new role.type
				role.blacklisted_species = J.blacklisted_species
			. += role

/datum/faction/proc/get_selection_error(datum/preferences/prefs, var/mob/user)
	if (!length(allowed_species_types))
		return null

	var/datum/species/S = prefs.get_species_datum()

	if (!S)
		return "No valid species selected."

	if (!is_type_in_typecache(S, allowed_species_types))
		return "Invalid species selected."

	if (!is_visible(user))
		return "This faction is not available to you."

	return null

/datum/faction/proc/can_select(datum/preferences/prefs, var/mob/user)
	return !get_selection_error(prefs, user)

/datum/faction/proc/get_logo_name()
	return "faction_[title_suffix].png"

/datum/faction/proc/get_corporate_objectives(var/mission_level)
	var/objective
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			objective = pick("Assist your contractor in smuggling [rand(1,4)] items of value",
							"Collect evidence of [current_map.company_short] being unfair or oppressive against your contractors to be used as leverage in future talks")
		if(REPRESENTATIVE_MISSION_MEDIUM)
			objective = pick("Convince [rand(1,3)] non-[name] employees to join [name] instead",
							"Have [rand(1,3)] of your contractors write down their grievances with the company, and present the report to [current_map.station_name] command.")
		else
			objective = pick("Collect [rand(3,7)] pictures of secure areas",
							"Make sure that [rand(2,4)] complaints related to contractors are solved on the [current_map.station_name]")

	return objective

/datum/faction/proc/is_visible(var/mob/user)
	return TRUE
