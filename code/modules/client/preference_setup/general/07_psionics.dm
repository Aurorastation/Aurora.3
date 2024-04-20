/datum/category_item/player_setup_item/general/psionics
	name = "Psionics"
	sort_order = 7

/datum/category_item/player_setup_item/general/psionics/load_character(var/savefile/S)
	S["psionics"] >> pref.psionics

/datum/category_item/player_setup_item/general/psionics/save_character(var/savefile/S)
	var/list/psionics = pref.psionics
	for(var/psi in psionics)
		var/singleton/psionic_power/P = GET_SINGLETON(text2path(psi))
		if(!istype(P))
			continue
		psionics |= P.type
	S["psionics"] << json_encode(psionics)

/datum/category_item/player_setup_item/general/psionics/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"psionics" = "psionics",
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/general/psionics/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/general/psionics/gather_save_query()
	return list(
		"ss13_characters" = list(
			"psionics",
			"id" = 1
		)
	)

/datum/category_item/player_setup_item/general/psionics/gather_save_parameters()
	var/list/sanitized_psionics = list()
	for(var/S in pref.psionics)
		var/singleton/psionic_power/P = GET_SINGLETON(text2path(S))
		if(!istype(P))
			continue
		sanitized_psionics |= "[P.type]"
	return list(
		"psionics" = json_encode(sanitized_psionics),
		"char_id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/psionics/load_character_special(savefile/S)
	if(!pref.psionics)
		pref.psionics = "{}"

	var/before = pref.psionics
	try
		pref.psionics = json_decode(pref.psionics)
	catch (var/exception/e)
		log_debug("PSIONICS: Caught [e]. Initial value: [before]")
		pref.psionics = list()

/datum/category_item/player_setup_item/general/psionics/sanitize_character(var/sql_load = 0)
	var/datum/species/mob_species = GLOB.all_species[pref.species]
	if(length(pref.psionics) && !mob_species.has_psionics)
		to_chat(pref.client, SPAN_WARNING("This species does not have psionics! Resetting..."))
		pref.psionics = list()
		return
	var/list/bought_psionic_powers = list()
	for(var/S in pref.psionics)
		var/singleton/psionic_power/P = GET_SINGLETON(text2path(S))
		if(istype(P))
			if(!(P.ability_flags & PSI_FLAG_CANON))
				pref.psionics -= S
				to_chat(pref.client, SPAN_WARNING("[P.name] is an invalid psionic!"))
				continue
			bought_psionic_powers |= P
		else
			to_chat(pref.client, SPAN_WARNING("[S] is an invalid psionic!"))
			pref.psionics -= S
			continue
	if(length(bought_psionic_powers) > mob_species.character_creation_psi_points)
		to_chat(pref.client, SPAN_WARNING("You have more psionics than possible! Resetting..."))
		pref.psionics = list()

/datum/category_item/player_setup_item/general/psionics/content(var/mob/user)
	var/datum/species/mob_species = GLOB.all_species[pref.species]
	if(!(mob_species.has_psionics))
		return
	var/list/bought_psionic_powers = list()
	for(var/S in pref.psionics)
		var/singleton/psionic_power/P = GET_SINGLETON(text2path(S))
		if(istype(P))
			bought_psionic_powers |= P

	var/list/dat = list(
		"<b>Psionics:</b><br>"
	)
	for(var/singleton/psionic_power/P in bought_psionic_powers)
		dat += "- [P.name] <a href='?src=\ref[src];remove_psi_power=[P.type]'>-</a><br>"
	dat += "<a href='?src=\ref[src];add_psi_power=1'>Add Psionic Power</a><br>"
	. = dat.Join()

/datum/category_item/player_setup_item/general/psionics/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["remove_psi_power"])
		var/power_to_remove = href_list["remove_psi_power"]
		if(power_to_remove && (power_to_remove in pref.psionics))
			pref.psionics -= power_to_remove
			return TOPIC_REFRESH

	else if(href_list["add_psi_power"])
		var/datum/species/mob_species = GLOB.all_species[pref.species]
		var/total_psi_points = mob_species.character_creation_psi_points
		var/list/available_psionics = list()
		var/list/psionic_map = list()
		var/list/bought_psionic_powers = list()

		for(var/S in pref.psionics)
			var/singleton/psionic_power/P = GET_SINGLETON(text2path(S))
			if(istype(P))
				bought_psionic_powers |= P
				total_psi_points = max(0, total_psi_points - P.point_cost)

		for(var/singleton/psionic_power/P in GET_SINGLETON_SUBTYPE_LIST(/singleton/psionic_power))
			if((P.ability_flags & PSI_FLAG_CANON) && (P.point_cost <= total_psi_points) && !(P in bought_psionic_powers))
				available_psionics |= "[P.name]"
				psionic_map[P.name] = P.type

		if(!length(available_psionics))
			to_chat(user, SPAN_WARNING("You ran out of points!"))
			return

		var/new_power = tgui_input_list(user, "Choose a psionic power to add.", "Psionics", available_psionics)
		if(new_power)
			var/singleton/psionic_power/P = GET_SINGLETON(psionic_map[new_power])
			if(istype(P))
				pref.psionics += "[P.type]"
				return TOPIC_REFRESH

