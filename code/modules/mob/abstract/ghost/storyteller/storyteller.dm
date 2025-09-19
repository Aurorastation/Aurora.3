/mob/abstract/ghost/storyteller
	name = "Storyteller"
	desc = "You wonder what story will be told today. Hopefully one where your character with 200 euros' worth of custom art doesn't die. That would be a shame. Wouldn't it?"
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	status_flags = GODMODE
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	layer = OBSERVER_LAYER
	incorporeal_move = INCORPOREAL_GHOST
	simulated = FALSE

	density = FALSE
	mob_thinks = FALSE
	universal_speak = TRUE

/mob/abstract/ghost/storyteller/Initialize()
	. = ..()
	SSghostroles.add_spawn_atom("storyteller", src)

/mob/abstract/ghost/storyteller/Destroy()
	SSodyssey.remove_storyteller(src)
	GLOB.storytellers.remove_antagonist(mind)
	SSghostroles.remove_spawn_atom("storyteller", src)
	return ..()

/mob/abstract/ghost/storyteller/LateLogin()
	. = ..()
	var/client/C = client

	// if there's no mind, the initial setup hasn't run
	if(C && !mind)

		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.current = src

		real_name = "Storyteller ([client.ckey])"
		name = "Storyteller ([client.ckey])"
		SSodyssey.add_storyteller(src)
		GLOB.storytellers.add_antagonist(mind)
		C.add_storyteller_verbs()

/mob/abstract/ghost/storyteller/ghostize(can_reenter_corpse, should_set_timer)
	. = ..()
	if(!can_reenter_corpse)
		SSodyssey.remove_storyteller(src)

/mob/abstract/ghost/storyteller/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	if (!message)
		return

	var/msg = sanitize(message)
	if(!msg)
		return

	log_ooc("(STORYTELLER) [name]/[key] : [msg]")

	var/list/turf/messageturfs = list() //List of turfs we broadcast to.
	var/list/mob/messagemobs = list() //List of living mobs nearby who can hear it

	for(var/turf in range(world.view, get_turf(src)))
		messageturfs += turf

	for(var/mob/M in GLOB.player_list)
		if(!M.client || istype(M, /mob/abstract/new_player))
			continue
		if(isAI(M))
			var/mob/living/silicon/ai/AI = M
			if(get_turf(AI.eyeobj) in messageturfs)
				messagemobs += M
				continue
		if(get_turf(M) in messageturfs)
			messagemobs += M

	var/display_name = key
	if(client.holder && client.holder.fakekey)
		display_name = client.holder.fakekey

	msg = process_chat_markup(msg, list("*"))

	var/prefix
	var/admin_stuff
	for(var/client/target in GLOB.clients)
		admin_stuff = ""
		var/display_remote = FALSE
		if (target.holder && ((R_MOD|R_ADMIN) & target.holder.rights))
			display_remote = TRUE
		if(display_remote)
			prefix = "(R)"
			admin_stuff += "/([key])"
			if(target != client)
				admin_stuff += "(<A href='byond://?src=[REF(target.holder)];adminplayerobservejump=[REF(src)]'>JMP</A>)"
		if(target.mob in messagemobs)
			prefix = ""
		if((target.mob in messagemobs) || display_remote)
			to_chat(target, SPAN_STORYTELLER("[create_text_tag("STORY", target)] [span("prefix", prefix)]<EM>[display_name][admin_stuff]:</EM> [span("message linkify", msg)]"))

/mob/abstract/ghost/storyteller/dust()
	return

/mob/abstract/ghost/storyteller/gib()
	return

/mob/abstract/ghost/storyteller/can_fall()
	return FALSE

/mob/abstract/ghost/storyteller/conveyor_act()
	return

/mob/abstract/ghost/storyteller/ex_act(var/severity = 2.0)
	return

/mob/abstract/ghost/storyteller/singularity_act()
	return

/mob/abstract/ghost/storyteller/singularity_pull()
	return

/mob/abstract/ghost/storyteller/singuloCanEat()
	return FALSE

/mob/abstract/ghost/storyteller/can_hear_radio(list/speaker_coverage)
	return TRUE

/mob/abstract/ghost/storyteller/get_speech_bubble_state_modifier()
	return "ghost"

/mob/abstract/ghost/storyteller/can_admin_interact()
	return TRUE

/mob/abstract/ghost/storyteller/on_restricted_level(var/check)
	return FALSE

/mob/abstract/ghost/storyteller/can_ztravel(direction)
	return TRUE

/mob/abstract/ghost/storyteller/verb/odyssey_panel()
	set name = "Odyssey Panel"
	set category = "Storyteller"

	SSodyssey.ui_interact(src)

/**
 * Currently whitelisted in the config behind the head of staff whitelist.
 * Let's see if they can play nice.
 */
/datum/ghostspawner/storyteller
	name = "Storyteller"
	short_name = "storyteller"
	desc = "As the Storyteller, you have creative direction over the current round. You are trusted to change, mix up and make interesting experiences for the \
			players. Use this power with responsibility!"
	tags = list("Odyssey")
	loc_type = GS_LOC_ATOM
	enabled = TRUE

	show_on_job_select = TRUE
	spawn_mob = /mob/abstract/ghost/storyteller
	atom_add_message = "A Storyteller position is available!"
