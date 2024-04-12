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

/mob/living/storyteller/assign_player(mob/user)
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

	log_say("Ghost/[key] : [message]", ckey = key_name(src))

	if (client)
		if(client.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
			to_chat(src, "<span class='warning'>You cannot talk in deadchat (muted).</span>")
			return

	. = say_dead(message)

/mob/living/storyteller/Move(atom/newloc, direct)
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

// TODOMATT: move this to the eye folder
/mob/abstract/eye/storyteller
	name = "Storyteller Eye"
	see_invisible = SEE_INVISIBLE_OBSERVER
