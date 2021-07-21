/*
 MODULAR ANTAGONIST SYSTEM

 Attempts to move all the bullshit snowflake antag tracking code into its own system, which
 has the added bonus of making the display procs consistent. Still needs work/adjustment/cleanup
 but should be fairly self-explanatory with a review of the procs. Will supply a few examples
 of common tasks that the system will be expected to perform below. ~Z

 To use:
   - Get the appropriate datum via get_antag_data("antagonist id")
     using the id var of the desired /datum/antagonist ie. var/datum/antagonist/A = get_antag_data("traitor")
   - Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
   - To ignore protected roles, supply a positive second argument.
   - To skip equipping with appropriate gear, supply a positive third argument.
*/

// Globals.
var/global/list/all_antag_types = list()
var/global/list/all_antag_spawnpoints = list()
var/global/list/antag_names_to_ids = list()
// This is a bit dumb but without it the job and antag age whitelisting would be even dumber.
var/global/list/bantype_to_antag_age = list()

// Global procs.
/proc/get_antag_data(var/antag_type)
	if(all_antag_types[antag_type])
		return all_antag_types[antag_type]
	else
		for(var/cur_antag_type in all_antag_types)
			var/datum/antagonist/antag = all_antag_types[cur_antag_type]
			if(antag && antag.is_type(antag_type))
				return antag

/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/populate_antag_type_list()
	for(var/antag_type in typesof(/datum/antagonist)-/datum/antagonist)
		var/datum/antagonist/A = new antag_type
		all_antag_types[A.id] = A
		all_antag_spawnpoints[A.landmark_id] = list()
		antag_names_to_ids[A.role_text] = A.id

		// Set up age restrictions for the different antag bantypes.
		if (!bantype_to_antag_age[A.bantype])
			if (config.age_restrictions_from_file && config.age_restrictions[lowertext(A.bantype)])
				bantype_to_antag_age[lowertext(A.bantype)] = config.age_restrictions[lowertext(A.bantype)]
			else
				bantype_to_antag_age[A.bantype] = 0

/proc/get_antags(var/atype)
	var/datum/antagonist/antag = all_antag_types[atype]
	if(antag && islist(antag.current_antagonists))
		return antag.current_antagonists
	return list()

/proc/player_is_antag(var/datum/mind/player, var/only_offstation_roles = FALSE)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(only_offstation_roles && !(antag.flags & ANTAG_OVERRIDE_JOB))
			continue
		if(player in antag.current_antagonists)
			return antag
		if(player in antag.pending_antagonists)
			return antag

/proc/player_is_obvious_antag(var/datum/mind/player, var/only_offstation_roles = FALSE)
	var/datum/antagonist/antag = player_is_antag(player, only_offstation_roles)
	if(antag)
		return antag.is_obvious_antag(player)
	return FALSE

/**
 * This must be called after map loading is done!
 */
/proc/populate_antag_spawns()
	for (var/T in all_antag_types)
		var/datum/antagonist/A = all_antag_types[T]
		A.get_starting_locations()
