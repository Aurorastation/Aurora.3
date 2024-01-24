var/datum/antagonist/revenant/revenants = null

/datum/antagonist/revenant
	id = MODE_REVENANT
	role_text = "Revenant"
	role_text_plural = "Revenants"
	welcome_text = "A creature borne of bluespace, you are here to wreak havoc and put an end to bluespace experimentation, one station at a time."
	antaghud_indicator = "hudrevenant"
	flags = ANTAG_NO_ROUNDSTART_SPAWN
	initial_spawn_req = 0
	initial_spawn_target = 0
	hard_cap = 12
	hard_cap_round = 12

	var/rifts_left = 1
	var/kill_count = 0
	var/obj/effect/portal/revenant/revenant_rift

	has_idris_account = FALSE

/datum/antagonist/revenant/New()
	..()

	revenants = src

/datum/antagonist/revenant/proc/destroyed_rift()
	revenants.revenant_rift = null
	revenants.rifts_left--
	if(revenants.rifts_left <= 0)
		command_announcement.Announce("[current_map.station_name], we aren't detecting any more rift energy signatures. Mop up the rest of the invaders. Good work.", "Bluespace Breach Alert")

/datum/antagonist/revenant/is_obvious_antag(datum/mind/player)
	return TRUE

/proc/message_all_revenants(var/message)
	for(var/thing in GLOB.human_mob_list)
		if(isrevenant(thing))
			to_chat(thing, message)
