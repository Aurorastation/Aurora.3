/datum/antagonist/proc/update_leader()
	if(!leader && current_antagonists.len && (flags & ANTAG_HAS_LEADER))
		leader = current_antagonists[1]

/datum/antagonist/proc/update_antag_mob(var/datum/mind/player, var/preserve_appearance)

	// Get the mob.
	if((flags & ANTAG_OVERRIDE_MOB) && (!player.current || (mob_path && !istype(player.current, mob_path))))
		var/mob/holder = player.current
		player.current = new mob_path(get_turf(player.current))
		player.transfer_to(player.current)
		if(holder) qdel(holder)
	player.original = player.current
	if(!preserve_appearance && (flags & ANTAG_SET_APPEARANCE))
		spawn(3)
			var/mob/living/carbon/human/H = player.current
			if(istype(H)) H.change_appearance(APPEARANCE_ALL, H.loc, H, valid_species, state = z_state)
	return player.current

/datum/antagonist/proc/update_access(var/mob/living/player)
	for(var/obj/item/card/id/id in player.contents)
		player.set_id_info(id)

/datum/antagonist/proc/clear_indicators(var/datum/mind/recipient)
	if(!recipient.current || !recipient.current.client)
		return
	for(var/image/I in recipient.current.client.images)
		if(I.icon_state == antag_indicator || (faction_indicator && I.icon_state == faction_indicator))
			recipient.current.client.images -= I

/datum/antagonist/proc/get_indicator(var/datum/mind/recipient, var/datum/mind/other)
	if(!antag_indicator || !other.current || !recipient.current)
		return
	var/indicator = (faction_indicator && (other in faction_members)) ? faction_indicator : antag_indicator
	return image('icons/mob/mob.dmi', loc = other.current, icon_state = indicator, layer = LIGHTING_LAYER+0.1)

/datum/antagonist/proc/update_all_icons()
	if(!antag_indicator)
		return
	for(var/datum/mind/antag in current_antagonists)
		clear_indicators(antag)
		if(faction_invisible && (antag in faction_members))
			continue
		for(var/datum/mind/other_antag in current_antagonists)
			if(antag.current && antag.current.client)
				antag.current.client.images |= get_indicator(antag, other_antag)

/datum/antagonist/proc/update_icons_added(var/datum/mind/player)
	set waitfor = FALSE
	if(!antag_indicator || !player.current)
		return

	var/give_to_player = (!faction_invisible || !(player in faction_members))
	for(var/datum/mind/antag in current_antagonists)
		if(!antag.current)
			continue
		if(antag.current.client)
			antag.current.client.images |= get_indicator(antag, player)
		if(!give_to_player)
			continue
		if(player.current.client)
			player.current.client.images |= get_indicator(player, antag)

/datum/antagonist/proc/update_icons_removed(var/datum/mind/player)
	set waitfor = FALSE

	if(!antag_indicator || !player.current)
		return

	clear_indicators(player)
	if(player.current && player.current.client)
		for(var/datum/mind/antag in current_antagonists)
			if(antag.current && antag.current.client)
				for(var/image/I in antag.current.client.images)
					if(I.loc == player.current)
						antag.current.client.images -= I

/datum/antagonist/proc/update_current_antag_max()
	cur_max = hard_cap
	if(SSticker.mode)
		if(SSticker.mode.antag_tags && (id in SSticker.mode.antag_tags))
			cur_max = hard_cap_round

	if(SSticker.mode.antag_scaling_coeff)

		var/count = 0

		if (SSticker.current_state < GAME_STATE_PLAYING)
			// If we're in the pre-game state, we count readied new players as players.
			// Yes, not all get spawned, but it's a close enough guestimation.
			for (var/mob/abstract/new_player/L in player_list)
				if (L.client && L.ready)
					count++
		else
			for (var/mob/living/M in player_list)
				if (M.client)
					count++

		// Minimum: initial_spawn_target
		// Maximum: hard_cap or hard_cap_round
		cur_max = max(initial_spawn_target,min(round(count/SSticker.mode.antag_scaling_coeff),cur_max))

// Updates the initial spawn target to match the player count.
// Intended to stop 6 nuke ops in a 15 player round. RIP those rounds.
/datum/antagonist/proc/update_initial_spawn_target()
	// Default is a linear rise of one antag per 5 players.
	var/modifier = 5

	if (SSticker.mode.antag_scaling_coeff)
		modifier = SSticker.mode.antag_scaling_coeff

	var/count = 0

	if (SSticker.current_state < GAME_STATE_PLAYING)
		// If we're in the pre-game state, we count readied new players as players.
		// Yes, not all get spawned, but it's a close enough guestimation.
		for (var/mob/abstract/new_player/L in player_list)
			if (L.client && L.ready)
				count++
	else
		for (var/mob/living/M in player_list)
			if (M.client)
				count++

	// Never pick less antags than we need to!
	var/new_cap = max(initial_spawn_req, round(count/modifier))

	// Default to the hardcap if we're about to surpass it
	initial_spawn_target = min(hard_cap, new_cap)
