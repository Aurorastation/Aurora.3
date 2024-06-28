/mob/abstract/storyteller
	name = "Storyteller"
	desc = "Are you a Storyteller because you tell a story, or do you tell the story because you're the Storyteller?"
	icon = 'icons/mob/mob.dmi'
	icon_state = "god"
	status_flags = GODMODE
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	layer = OBSERVER_LAYER
	incorporeal_move = INCORPOREAL_GHOST
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF

	density = FALSE
	mob_thinks = FALSE
	universal_speak = TRUE

/mob/abstract/storyteller/Initialize()
	. = ..()
	SSghostroles.add_spawn_atom("storyteller", src)

/mob/abstract/storyteller/Destroy()
	var/client/C = client
	if(C)
		if(C.holder.rights & R_STORYTELLER)
			// If the rights are ONLY R_STORYTELLER, then we need to remove the whole datum. Means they're a normal player.
			if(C.holder.rights == R_STORYTELLER)
				C.holder.disassociate()
				qdel(C.holder)
			else
				C.holder.rights &= ~R_STORYTELLER
				C.remove_admin_verbs()
				C.add_admin_verbs()
		SSodyssey.remove_storyteller(src)
	return ..()

/mob/abstract/storyteller/LateLogin()
	. = ..()
	var/client/C = client
	if(C)
		if(!(C.holder.rights & R_STORYTELLER) || !C.holder)
			if(!C.holder)
				var/datum/admins/D = new /datum/admins("Storyteller", R_STORYTELLER, C.ckey)
				D.associate(GLOB.directory[C.ckey])
			else
				C.holder.rights |= R_STORYTELLER
				C.remove_admin_verbs()
				C.add_admin_verbs()
		real_name = "Storyteller ([client.ckey])"
		SSodyssey.add_storyteller(src)

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

	log_ooc("(STORYTELLER) [name]/[key] : [msg]",ckey=key_name(src))

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

/mob/abstract/storyteller/Move(atom/newloc, direct)
	return

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

/datum/ghostspawner/storyteller
	name = "Storyteller"
	short_name = "storyteller"
	desc = "Tell your story to the world."
	tags = list("Odyssey")
	loc_type = GS_LOC_ATOM
	enabled = TRUE

	show_on_job_select = TRUE
	spawn_mob = /mob/abstract/storyteller
	atom_add_message = "A Storyteller position is available!"
