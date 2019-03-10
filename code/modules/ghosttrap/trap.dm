// This system is used to grab a ghost from observers with the required preferences and
// lack of bans set. See posibrain.dm for an example of how they are called/used. ~Z

var/list/ghost_traps

/proc/get_ghost_trap(var/trap_key)
	if(!ghost_traps)
		populate_ghost_traps()
	return ghost_traps[trap_key]

/proc/get_ghost_traps()
	if(!ghost_traps)
		populate_ghost_traps()
	return ghost_traps

/proc/populate_ghost_traps()
	ghost_traps = list()
	for(var/traptype in typesof(/datum/ghosttrap))
		var/datum/ghosttrap/G = new traptype
		ghost_traps[G.object] = G

/datum/ghosttrap
	var/object = "positronic brain"
	var/respawn_check = 0//Which respawning test we check against
	var/list/ban_checks = list("AI","Cyborg")
	var/pref_check = BE_SYNTH
	var/ghost_trap_message = "They are occupying a positronic brain now."
	var/ghost_trap_role = "Positronic Brain"
	var/can_set_own_name = TRUE
	var/list_as_special_role = TRUE	// If true, this entry will be listed as a special role in the character setup

	var/list/request_timeouts

/datum/ghosttrap/New()
	request_timeouts = list()
	..()

// Check for bans, proper atom types, etc.
/datum/ghosttrap/proc/assess_candidate(var/mob/abstract/observer/candidate, var/mob/target)
	if(!candidate.MayRespawn(1, respawn_check))
		return 0
	if(islist(ban_checks))
		for(var/bantype in ban_checks)
			if(jobban_isbanned(candidate, "[bantype]"))
				candidate << "You are banned from one or more required roles and hence cannot enter play as \a [object]."
				return 0
	return 1

// Print a message to all ghosts with the right prefs/lack of bans.
/datum/ghosttrap/proc/request_player(var/mob/target, var/request_string, var/request_timeout)
	if(request_timeout)
		request_timeouts[target] = world.time + request_timeout
		destroyed_event.register(target, src, /datum/ghosttrap/proc/target_destroyed)
	else
		request_timeouts -= target

	for(var/mob/abstract/observer/O in player_list)
		if(!O.MayRespawn())
			continue
		if(islist(ban_checks))
			for(var/bantype in ban_checks)
				if(jobban_isbanned(O, "[bantype]"))
					continue
		if(pref_check && !(pref_check in O.client.prefs.be_special_role))
			continue
		if(O.client)
			O << "[ghost_follow_link(target, O)] <span class='deadsay'><font size=3><b>[request_string] <a href='?src=\ref[src];candidate=\ref[O];target=\ref[target]'>(Occupy)</a></b></font></span>"

/datum/ghosttrap/proc/target_destroyed(var/destroyed_target)
	request_timeouts -= destroyed_target

// Handles a response to request_player().
/datum/ghosttrap/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["candidate"] && href_list["target"])
		var/mob/abstract/observer/candidate = locate(href_list["candidate"]) // BYOND magic.
		var/mob/target = locate(href_list["target"])                     // So much BYOND magic.
		if(!target || !candidate)
			return
		if(candidate != usr)
			return
		if(request_timeouts[target] && world.time > request_timeouts[target])
			candidate << "This occupation request is no longer valid."
			return
		if(target.key)
			candidate << "The target is already occupied."
			return
		if(assess_candidate(candidate, target))
			transfer_personality(candidate,target)
		return 1

// Shunts the ckey/mind into the target mob.
/datum/ghosttrap/proc/transfer_personality(var/mob/candidate, var/mob/target)
	if(!assess_candidate(candidate))
		return 0
	target.ckey = candidate.ckey
	if(target.mind)
		target.mind.assigned_role = "[ghost_trap_role]"
	announce_ghost_joinleave(candidate, 0, "[ghost_trap_message]")
	welcome_candidate(target)
	set_new_name(target)
	return 1

// Fluff!
/datum/ghosttrap/proc/welcome_candidate(var/mob/target)
	target << "<b>You are a positronic brain, brought into existence on [station_name()].</b>"
	target << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	target << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	target << "<b>Use say [target.get_language_prefix()]b to speak to other artificial intelligences.</b>"
	var/turf/T = get_turf(target)
	T.visible_message("<span class='notice'>\The [target] chimes quietly.</span>")
	var/obj/item/device/mmi/digital/posibrain/P = target.loc
	if(!istype(P)) //wat
		return
	P.searching = 0
	P.name = "positronic brain ([P.brainmob.name])"
	P.icon_state = "posibrain-occupied"

// Allows people to set their own name. May or may not need to be removed for posibrains if people are dumbasses.
/datum/ghosttrap/proc/set_new_name(var/mob/target)
	if(!can_set_own_name)
		return

	var/newname = sanitizeSafe(input(target,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
	if (newname != "")
		target.real_name = newname
		target.name = target.real_name

/***********************************
* Diona pods and walking mushrooms *
***********************************/
/datum/ghosttrap/plant
	object = "living plant"
	ban_checks = list("Dionaea")
	pref_check = BE_PLANT
	ghost_trap_message = "They are occupying a living plant now."
	ghost_trap_role = "Plant"

/datum/ghosttrap/plant/welcome_candidate(var/mob/target)
	target << "<span class='alium'><B>You awaken slowly, stirring into sluggish motion as the air caresses you.</B></span>"
	// This is a hack, replace with some kind of species blurb proc.
	if(istype(target,/mob/living/carbon/alien/diona))
		target << "<B>You are \a [target], one of a race of drifting interstellar plantlike creatures that sometimes share their seeds with human traders.</B>"
		target << "<B>Too much darkness will send you into shock and starve you, but light will help you heal.</B>"

/*****************
* Cortical Borer *
*****************/
/datum/ghosttrap/borer
	object = "cortical borer"
	ban_checks = list("Borer")
	pref_check = MODE_BORER
	ghost_trap_message = "They are occupying a borer now."
	ghost_trap_role = "Cortical Borer"
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/borer/welcome_candidate(var/mob/target)
	target << "<span class='notice'>You are a cortical borer!</span> You are a brain slug that worms its way \
	into the head of its victim. Use stealth, persuasion and your powers of mind control to keep you, \
	your host and your eventual spawn safe and warm."
	target << "You can speak to your victim with <b>say</b>, to other borers with <b>say [target.get_language_prefix()]x</b>, and use your Abilities tab to access powers."

/********************
* Maintenance Drone *
*********************/
/datum/ghosttrap/drone
	object = "maintenance drone"
	pref_check = BE_PAI
	ghost_trap_message = "They are occupying a maintenance drone now."
	ghost_trap_role = "Maintenance Drone"
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/drone/New()
	respawn_check = MINISYNTH
	..()

datum/ghosttrap/drone/assess_candidate(var/mob/abstract/observer/candidate, var/mob/target)
	. = ..()
	if(. && !target.can_be_possessed_by(candidate))
		return 0

datum/ghosttrap/drone/transfer_personality(var/mob/candidate, var/mob/living/silicon/robot/drone/drone)
	if(!assess_candidate(candidate))
		return 0
	drone.transfer_personality(candidate.client)

/********************
* Mining Drone *
*********************/
/datum/ghosttrap/mdrone
	object = "mining drone"
	pref_check = BE_PAI
	ghost_trap_message = "They are occupying a mining drone now."
	ghost_trap_role = "Mining Drone"
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/mdrone/New()
	respawn_check = MINISYNTH
	..()

/datum/ghosttrap/mdrone/assess_candidate(var/mob/abstract/observer/candidate, var/mob/target)
	. = ..()
	if(. && !target.can_be_possessed_by(candidate))
		return 0

datum/ghosttrap/drone/transfer_personality(var/mob/candidate, var/mob/living/silicon/robot/drone/drone)
	if(!assess_candidate(candidate))
		return 0
	drone.transfer_personality(candidate.client)
	var/tmp_health = drone.health
	drone.revive()
	drone.health = tmp_health
	drone.updatehealth()

/***********************************
* Syndicate Cyborg *
***********************************/

/datum/ghosttrap/syndicateborg
	object = "syndicate cyborg"
	ban_checks = list("Antagonist","AI","Cyborg")
	pref_check = BE_SYNTH
	ghost_trap_message = "They are occupying a syndicate cyborg now."
	ghost_trap_role = "Syndicate Cyborg"
	can_set_own_name = TRUE
	list_as_special_role = FALSE

/datum/ghosttrap/syndicateborg/welcome_candidate(var/mob/target)
	target << "<span class='notice'><B>You are a syndicate cyborg, bound to help and follow the orders of the mercenaries that are deploying you. Remember to speak to the other mercenaries to know more about their plans</B></span>"
	mercs.add_antagonist_mind(target.mind,1)

/**************
* pAI *
**************/
/datum/ghosttrap/pai
	object = "pAI"
	pref_check = BE_PAI
	ghost_trap_message = "They are occupying a pAI now."
	ghost_trap_role = "pAI"

datum/ghosttrap/pai/assess_candidate(var/mob/candidate, var/mob/target)
	return 0

datum/ghosttrap/pai/transfer_personality(var/mob/candidate, var/mob/living/silicon/robot/drone/drone)
	return 0

/**************
* Wizard Familiar *
**************/

/datum/ghosttrap/familiar
	object = "wizard familiar"
	pref_check = MODE_WIZARD
	ghost_trap_message = "They are occupying a familiar now."
	ghost_trap_role = "Wizard Familiar"
	ban_checks = list(MODE_WIZARD)
	list_as_special_role = FALSE

/datum/ghosttrap/familiar/welcome_candidate(var/mob/target)
	return 0

/**************
* Skeleton minion *
**************/

/datum/ghosttrap/skeleton
	object = "skeleton minion"
	pref_check = MODE_WIZARD
	ghost_trap_message = "They are occupying a skeleton minion."
	ghost_trap_role = "Skeleton Minion"
	ban_checks = list(MODE_WIZARD)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/skeleton/welcome_candidate(var/mob/target)
	return 0

//Gamemodes

/datum/ghosttrap/merc
	object = "Mercenary"
	pref_check = MODE_MERCENARY
	ghost_trap_message = "They are occupying a mercenary."
	ghost_trap_role = "Mercenary"
	ban_checks = list(MODE_MERCENARY)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/merc/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/raider
	object = "Raider"
	pref_check = MODE_RAIDER
	ghost_trap_message = "They are occupying a raider."
	ghost_trap_role = "Raider"
	ban_checks = list(MODE_RAIDER)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/raider/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/ninja
	object = "Ninja"
	pref_check = MODE_NINJA
	ghost_trap_message = "They are occupying a ninja."
	ghost_trap_role = "Ninja"
	ban_checks = list(MODE_NINJA)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/ninja/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/wizard
	object = "Wizard"
	pref_check = MODE_WIZARD
	ghost_trap_message = "They are occupying a wizard."
	ghost_trap_role = "Wizard"
	ban_checks = list(MODE_WIZARD)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/wizard/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/malf
	object = "AI Malfunction"
	pref_check = MODE_MALFUNCTION
	ghost_trap_message = "They are occupying a malfunctioning AI."
	ghost_trap_role = "Malfuntioning AI"
	ban_checks = list(MODE_MALFUNCTION)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/malf/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/ert
	object = "Emergency Responder"
	pref_check = MODE_ERT
	ghost_trap_message = "They are occupying an ERT member."
	ghost_trap_role = "ERT member"
	ban_checks = list(MODE_ERT)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/ert/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/changeling
	object = "Changeling"
	pref_check = MODE_CHANGELING
	ghost_trap_message = "They are occupying a changeling."
	ghost_trap_role = "Changeling"
	ban_checks = list(MODE_CHANGELING)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/changeling/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/cultist
	object = "Cult"
	pref_check = MODE_CULTIST
	ghost_trap_message = "They are occupying a cultist."
	ghost_trap_role = "Cultist"
	ban_checks = list(MODE_CULTIST)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/cultist/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/traitor
	object = "Traitor"
	pref_check = MODE_TRAITOR
	ghost_trap_message = "They are occupying a traitor."
	ghost_trap_role = "Traitor"
	ban_checks = list(MODE_TRAITOR)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/traitor/welcome_candidate(var/mob/target)
	target << "<span class ='notice'> Check your notes for your PDA code!</span>"
	return 1

/datum/ghosttrap/vampire
	object = "Vampire"
	pref_check = MODE_VAMPIRE
	ghost_trap_message = "They are occupying a vampire."
	ghost_trap_role = "Vampire"
	ban_checks = list(MODE_VAMPIRE)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/vampire/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/legion
	object = "Tau Ceti Foreign Legion"
	pref_check = MODE_LEGION
	ghost_trap_message = "They are occupying a Tau Ceti Foreign Legion volunteer."
	ghost_trap_role = "Tau Ceti Foreign Legion"
	ban_checks = list(MODE_LEGION)
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/legion/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/special
	object = "Special"
	pref_check = null
	ghost_trap_message = "They are occupying a person."
	ghost_trap_role = "person"
	ban_checks = list()
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/datum/ghosttrap/special/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/brainwashed
	object = "split personality"
	ghost_trap_message = "They are a split personality now."
	ghost_trap_role = "Split personality"
	can_set_own_name = TRUE
	list_as_special_role = TRUE

/datum/ghosttrap/brainwashed/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/friend
	object = "friend"
	ghost_trap_message = "They are an imaginary friend now."
	ghost_trap_role = "Imaginary friend"
	can_set_own_name = TRUE
	list_as_special_role = TRUE

/datum/ghosttrap/friend/welcome_candidate(var/mob/target)
	return 0
