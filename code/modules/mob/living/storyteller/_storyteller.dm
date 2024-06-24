/mob/living/storyteller
	name = "Storyteller"
	desc = "Are you a Storyteller because you tell a story, or do you tell the story because you're the Storyteller?"
	icon = 'icons/mob/mob.dmi'
	icon_state = "god"
	status_flags = GODMODE
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	layer = OBSERVER_LAYER

	density = FALSE
	anchored = TRUE
	simulated = FALSE

	mob_thinks = FALSE

/mob/living/storyteller/Initialize()
	. = ..()
	eyeobj = new /mob/abstract/eye/storyteller(get_turf(src))
	eyeobj.possess(src)

/mob/living/storyteller/Destroy()
	QDEL_NULL(eyeobj)
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
	return ..()

/mob/living/storyteller/LateLogin()
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

/mob/living/storyteller/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
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

/mob/living/storyteller/Move(atom/newloc, direct)
	return

/mob/living/storyteller/update_dead_sight()
	return

/mob/living/storyteller/apply_damage(damage, damagetype, def_zone, blocked, used_weapon, damage_flags, armor_pen, silent)
	return

/mob/living/storyteller/dust()
	return

/mob/living/storyteller/gib()
	return

/mob/living/storyteller/can_fall()
	return FALSE

/mob/living/storyteller/conveyor_act()
	return

/mob/living/storyteller/ex_act(var/severity = 2.0)
	return

/mob/living/storyteller/singularity_act()
	return

/mob/living/storyteller/singularity_pull()
	return

/mob/living/storyteller/singuloCanEat()
	return FALSE

/mob/abstract/eye/storyteller
	name = "Storyteller Eye"
	see_invisible = SEE_INVISIBLE_OBSERVER

/datum/ghostspawner/storyteller
	name = "Storyteller"
	desc = "Tell your story to the world."
	tags = list("Odyssey")
	loc_type = GS_LOC_POS
	enabled = TRUE

	show_on_job_select = TRUE
	landmark_name = "storyteller"
	spawn_mob = /mob/living/storyteller
