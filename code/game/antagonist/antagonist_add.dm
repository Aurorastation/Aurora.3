/datum/antagonist/proc/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)

	if(!add_antagonist_mind(player, ignore_role))
		return 0

	//do this again, just in case
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text
	player.special_role = role_text

	if(istype(player.current, /mob/dead))
		create_default(player.current)
	else
		create_antagonist(player, move_to_spawn, do_not_announce, preserve_appearance)
		if(!do_not_equip)
			equip(player.current)

	player.current.faction = faction

	return 1

/datum/antagonist/proc/add_antagonist_mind(var/datum/mind/player, var/ignore_role, var/nonstandard_role_type, var/nonstandard_role_msg)
	if(!istype(player))
		return 0
	if(!player.current)
		return 0
	if(player in current_antagonists)
		return 0
	if(!can_become_antag(player, ignore_role))
		return 0
	current_antagonists |= player

	if(faction_verb && player.current)
		player.current.verbs |= faction_verb

	player.current.client.verbs += /client/proc/aooc

	// Handle only adding a mind and not bothering with gear etc.
	if(nonstandard_role_type)
		faction_members |= player
		player.current << "<span class='danger'><font size=3>You are \a [nonstandard_role_type]!</font></span>"
		player.special_role = nonstandard_role_type
		if(nonstandard_role_msg)
			player.current << "<span class='notice'>[nonstandard_role_msg]</span>"
		update_icons_added(player)
	return 1

/datum/antagonist/proc/remove_antagonist(var/datum/mind/player, var/show_message = TRUE, var/implanted)
	if(!istype(player))
		return 0

	if(player.current && faction_verb)
		player.current.verbs -= faction_verb

	if(player in current_antagonists)
		if (show_message)
			player.current << "<span class='danger'><font size = 3>You are no longer a [role_text]!</font></span>"
		current_antagonists -= player
		faction_members -= player
		player.special_role = null
		update_icons_removed(player)
		BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)

		if (!is_special_character(player) && !check_rights(R_ADMIN|R_MOD|R_CCIAA, 0, player.current))
			player.current.client.verbs -= /client/proc/aooc

		return 1

	return 0
