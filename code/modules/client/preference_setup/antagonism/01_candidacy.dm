/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	sort_order = 1

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(var/savefile/S)
	S["be_special"]	>> pref.be_special_role

/datum/category_item/player_setup_item/antagonism/candidacy/save_character(var/savefile/S)
	S["be_special"]	<< pref.be_special_role

/datum/category_item/player_setup_item/antagonism/candidacy/gather_load_query()
	return list("ss13_characters" = list("vars" = list("be_special_role"), "args" = list("id")))

/datum/category_item/player_setup_item/antagonism/candidacy/gather_load_parameters()
	return list(":id" = pref.current_character)

/datum/category_item/player_setup_item/antagonism/candidacy/gather_save_query()
	return list("ss13_characters" = list("be_special_role", "id" = 1, "ckey" = 1))

/datum/category_item/player_setup_item/antagonism/candidacy/gather_save_parameters()
	return list(":be_special_role" = list2params(pref.be_special_role), ":id" = pref.current_character, ":ckey" = pref.client.ckey)

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character(var/sql_load = 0)
	if (sql_load)
		if (pref.be_special_role)
			pref.be_special_role = params2list(pref.be_special_role)

	if (!istype(pref.be_special_role))
		pref.be_special_role = list()

	for (var/role in pref.be_special_role)
		if (!(role in valid_special_roles()))
			pref.be_special_role -= role

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	. += "<b>Special Role Availability:</b><br>"
	. += "<table>"
	var/is_global_banned = jobban_isbanned(preference_mob(), "Antagonist")
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		. += "<tr><td>[antag.role_text]: </td><td>"
		if(is_global_banned || jobban_isbanned(preference_mob(), antag.bantype))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(antag.role_type in pref.be_special_role)
			. += "<b>Yes</b> / <a href='?src=\ref[src];del_special=[antag.role_type]'>No</a></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[antag.role_type]'>Yes</a> / <b>No</b></br>"
		. += "</td></tr>"

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_role)
			continue

		. += "<tr><td>[(ghost_trap.ghost_trap_role)]: </td><td>"
		if(banned_from_ghost_role(preference_mob(), ghost_trap))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(ghost_trap.pref_check in pref.be_special_role)
			. += "<b>Yes</b> / <a href='?src=\ref[src];del_special=[ghost_trap.pref_check]'>No</a></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[ghost_trap.pref_check]'>Yes</a> / <b>No</b></br>"
		. += "</td></tr>"
	. += "</table>"

/datum/category_item/player_setup_item/proc/banned_from_ghost_role(var/mob, var/datum/ghosttrap/ghost_trap)
	for(var/ban_type in ghost_trap.ban_checks)
		if(jobban_isbanned(mob, ban_type))
			return 1
	return 0

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["add_special"])
		if(!(href_list["add_special"] in valid_special_roles()))
			return TOPIC_HANDLED
		pref.be_special_role |= href_list["add_special"]
		return TOPIC_REFRESH

	if(href_list["del_special"])
		pref.be_special_role -= href_list["del_special"]
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/antagonism/candidacy/proc/valid_special_roles()
	var/list/private_valid_special_roles = list()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		private_valid_special_roles += antag.role_type

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_role)
			continue
		private_valid_special_roles += ghost_trap.pref_check

	return private_valid_special_roles
