/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = TRUE

	var/datum/progressbar/resist_bar
	var/resist_start_time = 0

/mob/living/captive_brain/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	if(istype(src.loc,/mob/living/simple_animal/borer))
		if(!message)
			return
		log_say("[key_name(src)] : [message]", ckey=key_name(src))
		if(stat == DEAD)
			return say_dead(message)

		var/mob/living/simple_animal/borer/B = src.loc
		to_chat(src, "You whisper silently, \"[message]\"")
		to_chat(B.host, "The captive mind of [src] whispers, \"[message]\"")

		for(var/mob/M in player_list)
			if(istype(M, /mob/abstract/new_player))
				continue
			else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
				to_chat(M, "The captive mind of [src] whispers, \"[message]\"")

/mob/living/captive_brain/Destroy()
	QDEL_NULL(resist_bar)
	return ..()

/mob/living/captive_brain/emote(var/message)
	return

/mob/living/captive_brain/Life()
	if(resist_bar)
		resist_bar.update(world.time - resist_start_time)
	return ..()

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(resist_bar)
		to_chat(src, SPAN_WARNING("You're already resisting the alien control!"))
		return

	if(istype(src.loc,/mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, SPAN_DANGER("You begin doggedly resisting the parasite's control."))
		to_chat(B.host, SPAN_DANGER("You feel the captive mind of [src] begin to resist your control."))

		var/resist_time = rand(40 SECONDS, 1 MINUTE)
		addtimer(CALLBACK(src, .proc/eject_borer, B, H), resist_time)
		resist_bar = new /datum/progressbar/autocomplete(src, resist_time, B.host)
		resist_start_time = world.time
		resist_bar.update(0)
		return

	..()

/mob/living/captive_brain/proc/eject_borer(var/mob/living/simple_animal/borer/borer, var/mob/living/captive_brain/host)
	if(!borer?.controlling)
		return

	to_chat(host, SPAN_DANGER("With an immense exertion of will, you regain control of your body!"))
	to_chat(borer.host, SPAN_DANGER("You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you."))
	borer.detach()
	verbs -= /mob/living/carbon/proc/release_control
	verbs -= /mob/living/carbon/proc/punish_host
	verbs -= /mob/living/carbon/proc/spawn_larvae
