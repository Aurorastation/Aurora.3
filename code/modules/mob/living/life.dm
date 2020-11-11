/mob/living/Life()
	set background = BACKGROUND_ENABLED

	if (QDELETED(src))	// If they're being deleted, why bother?
		return

	..()

	if (transforming)
		return

	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()
	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

	blinded = 0 // Placing this here just show how out of place it is.

	if(handle_regular_status_updates())
		handle_status_effects()

	if(stat != DEAD)
		aura_check(AURA_TYPE_LIFE)
		if(!InStasis())
			//Mutations and radiation
			handle_mutations_and_radiation()

	//Check if we're on fire
	handle_fire()

	update_pulling()

	for(var/obj/item/grab/G in src)
		G.process()

	handle_actions()

	update_canmove()

	handle_regular_hud_updates()

	if(languages.len == 1 && default_language != languages[1])
		default_language = languages[1]

	return 1

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return

/mob/living/proc/update_pulling()
	if(pulling)
		if(incapacitated())
			stop_pulling()

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()
	updatehealth()
	if(stat != DEAD)
		if(paralysis)
			stat = UNCONSCIOUS
		else if (status_flags & FAKEDEATH)
			stat = UNCONSCIOUS
		else
			stat = CONSCIOUS
		return 1

/mob/living/proc/handle_status_effects()
	if(paralysis)
		paralysis = max(paralysis-1,0)
	if(stunned)
		stunned = max(stunned-1,0)
		if(!stunned)
			update_icon()

	if(weakened)
		weakened = max(weakened-1,0)
		if(!weakened)
			update_icon()

	if(confused)
		confused = max(0, confused - 1)

/mob/living/proc/handle_disabilities()
	//Eyes
	if(sdisabilities & BLIND || stat)	//blindness from disability or unconsciousness doesn't get better on its own
		eye_blind = max(eye_blind, 1)
	else if(eye_blind)			//blindness, heals slowly over time
		eye_blind = max(eye_blind-1,0)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

	//Ears
	handle_hearing()

	if((is_pacified()) && a_intent == I_HURT)
		to_chat(src, "<span class='notice'>You don't feel like harming anybody.</span>")
		a_intent_change(I_HELP)

//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/proc/handle_regular_hud_updates()
	if(!client || QDELETED(src))	return 0

	handle_hud_icons()
	handle_vision()

	return 1

/mob/living/proc/handle_vision()
	update_sight()

	if(stat == DEAD)
		return

	if(eye_blind)
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else
		clear_fullscreen("blind")
		set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
		set_fullscreen(eye_blurry, "blurry", /obj/screen/fullscreen/blurry)

	set_fullscreen(stat == UNCONSCIOUS, "blackout", /obj/screen/fullscreen/blackout)

	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			sight |= viewflags
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else if(!client.adminobs)
		reset_view(null)

/mob/living/proc/handle_hearing()
	// deafness heals slowly over time, unless ear_damage is over HEARING_DAMAGE_LIMIT
	if(ear_damage < HEARING_DAMAGE_LIMIT)
		adjustEarDamage(-0.05, -1)
	if(sdisabilities & DEAF) //disabled-deaf, doesn't get better on its own
		setEarDamage(-1, max(ear_deaf, 1))

/mob/living/proc/update_sight()
	if(stat == DEAD || eyeobj)
		update_dead_sight()
	else
		sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		if (is_ventcrawling)
			sight |= SEE_TURFS|BLIND

		if (!stop_sight_update) //If true, it won't reset the mob vision flags to the initial ones
			see_in_dark = initial(see_in_dark)
			see_invisible = initial(see_invisible)
		var/list/vision = get_accumulated_vision_handlers()
		sight|= vision[1]
		see_invisible = (max(vision[2], see_invisible))

/mob/living/proc/update_dead_sight()
	sight |= SEE_TURFS
	sight |= SEE_MOBS
	sight |= SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health()
	handle_hud_glasses()

/mob/living/proc/handle_hud_icons_health()
	return
