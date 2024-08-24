/mob/abstract/storyteller
	name = "Storyteller"
	desc = "Are you a Storyteller because you tell a story, or do you tell the story because you're the Storyteller?"
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

	/// Toggle darkness. Basically the same verb as the one observers have.
	var/see_darkness = FALSE
	/// Is the ghost able to see things humans can't?
	var/ghostvision = FALSE

/mob/abstract/storyteller/Initialize()
	. = ..()
	SSghostroles.add_spawn_atom("storyteller", src)

/mob/abstract/storyteller/Destroy()
	SSodyssey.remove_storyteller(src)
	return ..()

/mob/abstract/storyteller/LateLogin()
	. = ..()
	var/client/C = client

	// if there's no mind, the initial setup hasn't run
	if(C && !mind)

		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.current = src

		real_name = "Storyteller ([client.ckey])"
		SSodyssey.add_storyteller(src)
		GLOB.storytellers.add_antagonist(mind)

/mob/abstract/storyteller/ghostize(can_reenter_corpse, should_set_timer)
	. = ..()
	if(!can_reenter_corpse)
		SSodyssey.remove_storyteller(src)

/mob/abstract/storyteller/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	if (!message)
		return

	var/msg = sanitize(message)
	if(!msg)
		return

	log_ooc("(STORYTELLER) [name]/[key] : [msg]")

	var/list/messageturfs = list() //List of turfs we broadcast to.
	var/list/messagemobs = list() //List of living mobs nearby who can hear it

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
				admin_stuff += "(<A HREF='?src=\ref[target.holder];adminplayerobservejump=\ref[src]'>JMP</A>)"
		if(target.mob in messagemobs)
			prefix = ""
		if((target.mob in messagemobs) || display_remote)
			to_chat(target, "<span class='storyteller'>" + create_text_tag("STORY", target) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message linkify'>[msg]</span></span>")

/mob/abstract/storyteller/dust()
	return

/mob/abstract/storyteller/gib()
	return

/mob/abstract/storyteller/can_fall()
	return FALSE

/mob/abstract/storyteller/conveyor_act()
	return

/mob/abstract/storyteller/ex_act(var/severity = 2.0)
	return

/mob/abstract/storyteller/singularity_act()
	return

/mob/abstract/storyteller/singularity_pull()
	return

/mob/abstract/storyteller/singuloCanEat()
	return FALSE


/mob/abstract/storyteller/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Storyteller"

	see_darkness = !see_darkness
	update_sight()

/mob/abstract/storyteller/proc/update_sight()
	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	if (!see_darkness)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else
		set_see_invisible(ghostvision ? SEE_INVISIBLE_OBSERVER : SEE_INVISIBLE_LIVING)

/mob/abstract/storyteller/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set category = "Storyteller"
	set desc = "Toggles your ability to see things only ghosts can see, like ghosts."

	ghostvision = !ghostvision
	update_sight()
	to_chat(usr, SPAN_NOTICE("You [(ghostvision ? "now" : "no longer")] have ghost vision."))

/mob/abstract/storyteller/verb/odyssey_panel()
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
	spawn_mob = /mob/abstract/storyteller
	atom_add_message = "A Storyteller position is available!"
