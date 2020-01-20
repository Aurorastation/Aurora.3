/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = TRUE

/mob/living/captive_brain/say(var/message)
	if(istype(src.loc,/mob/living/simple_animal/borer))
		message = sanitize(message)
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

/mob/living/captive_brain/emote(var/message)
	return

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(istype(src.loc,/mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, span("danger", "You begin doggedly resisting the parasite's control (this will take approximately sixty seconds)."))
		to_chat(B.host, span("danger", "You feel the captive mind of [src] begin to resist your control."))

		addtimer(CALLBACK(src, .proc/eject_borer, B, H), rand(200, 250) + B.host.getBrainLoss())
		return

	..()

/mob/living/captive_brain/proc/eject_borer(var/mob/living/simple_animal/borer/borer, var/mob/living/captive_brain/host)
	if(!borer?.controlling)
		return

	to_chat(host, span("danger", "With an immense exertion of will, you regain control of your body!"))
	to_chat(borer.host, span("danger", "You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you."))
	borer.detach()
	verbs -= /mob/living/carbon/proc/release_control
	verbs -= /mob/living/carbon/proc/punish_host
	verbs -= /mob/living/carbon/proc/spawn_larvae
