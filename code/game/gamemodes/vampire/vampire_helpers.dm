// Make a vampire, add initial powers.
/mob/proc/make_vampire()
	if (!mind)
		return
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if(!vampire)
		mind.antag_datums[MODE_VAMPIRE] = new /datum/vampire()
		vampire = mind.antag_datums[MODE_VAMPIRE]
	// No powers to thralls. Ew.
	if(vampire.status & VAMP_ISTHRALL)
		return

	vampire.blood_usable += 30

	if(client)
		vampire.blood_hud = new /atom/movable/screen/vampire/blood()
		vampire.frenzy_hud = new /atom/movable/screen/vampire/frenzy()
		client.screen += vampire.blood_hud
		client.screen += vampire.frenzy_hud

	add_verb(src, /datum/antagonist/vampire/proc/vampire_help)

	for(var/datum/power/vampire/P in GLOB.vampirepowers)
		if(!(P in vampire.purchased_powers))
			if(!P.blood_cost)
				vampire.add_power(mind, P, 0)
		else if(P.isVerb && P.verbpath)
			add_verb(src,  P.verbpath)

	return TRUE

// Checks the vampire's bloodlevel and unlocks new powers based on that.
/mob/proc/check_vampire_upgrade()
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if(!vampire)
		return

	for (var/datum/power/vampire/P in GLOB.vampirepowers)
		if (P.blood_cost <= vampire.blood_total)
			if (!(P in vampire.purchased_powers))
				vampire.add_power(mind, P, 1)

	if (!(vampire.status & VAMP_FULLPOWER) && vampire.blood_total >= 650)
		vampire.status |= VAMP_FULLPOWER
		to_chat(src, SPAN_NOTICE("You've gained full power. Some abilities now have bonus functionality, or work faster."))

// Runs the checks for whether or not we can use a power.
/mob/proc/vampire_power(var/required_blood = 0, var/max_stat = 0, var/ignore_holder = 0, var/disrupt_healing = 1, var/required_vampire_blood = 0)
	if (!mind)
		return
	if (!ishuman(src))
		return

	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if (!vampire)
		LOG_DEBUG("[src] has a vampire power but is not a vampire.")
		return
	if (vampire.holder && !ignore_holder)
		to_chat(src, SPAN_WARNING("You cannot use this power while walking through the Veil."))
		return
	if (stat > max_stat)
		to_chat(src, SPAN_WARNING("You are incapacitated."))
		return
	if (required_blood > vampire.blood_usable)
		to_chat(src, SPAN_WARNING("You do not have enough usable blood. [required_blood] needed."))
		return

	if ((vampire.status & VAMP_HEALING) && disrupt_healing)
		vampire.status &= ~VAMP_HEALING

	return vampire

// Checks whether or not the target can be affected by a vampire's abilities.
/mob/proc/vampire_can_affect_target(var/mob/living/carbon/human/T, var/notify = 1, var/account_loyalty_implant = 0, var/ignore_thrall = FALSE, var/affect_ipc = TRUE)
	if (!T || !istype(T))
		return FALSE
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	// How did you even get here?
	if (!vampire)
		return FALSE
	var/datum/vampire/vampire_check
	if(T.mind)
		if(T.mind.assigned_role == "Chaplain")
			if(notify)
				to_chat(src, SPAN_WARNING("Your connection with the Veil is not strong enough to affect a man as devout as them."))
			return FALSE
		vampire_check = T.mind.antag_datums[MODE_VAMPIRE]
		if(vampire_check)
			if(!(vampire_check.status & VAMP_ISTHRALL && ignore_thrall))
				if(notify)
					to_chat(src, SPAN_WARNING("You lack the power required to affect another creature of the Veil."))
				return FALSE
	if(vampire_check)
		if((vampire.status & VAMP_FULLPOWER) && !(vampire_check.status & VAMP_FULLPOWER))
			return TRUE
	if(!affect_ipc && isipc(T))
		if (notify)
			to_chat(src, SPAN_WARNING("You lack the power to interact with mechanical constructs."))
		return FALSE
	if(is_special_character(T) && (!(vampire_check?.status & VAMP_ISTHRALL)))
		if (notify)
			to_chat(src, SPAN_WARNING("\The [T]'s mind is too strong to be affected by our powers!"))
		return FALSE
	if (account_loyalty_implant)
		for (var/obj/item/implant/mindshield/I in T)
			if (I.implanted)
				if (notify)
					to_chat(src, SPAN_WARNING("You feel that [T]'s mind is protected from our powers."))
				return FALSE

	return TRUE

// Plays the vampire phase in animation.
/mob/proc/vampire_phase_in(var/turf/T = null)
	if (!T)
		return
	anim(T, src, 'icons/mob/mob.dmi', , "bloodify_in", , dir)

// Plays the vampire phase out animation.
/mob/proc/vampire_phase_out(var/turf/T = null)
	if (!T)
		return
	anim(T, src, 'icons/mob/mob.dmi', , "bloodify_out", , dir)

// Make a vampire thrall
/mob/proc/vampire_make_thrall()
	if (!mind)
		return

	var/datum/vampire/thrall/thrall = new()
	mind.antag_datums[MODE_VAMPIRE] = thrall

/mob/proc/vampire_check_frenzy(var/force_frenzy = 0)
	if(!mind)
		return
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if(!vampire)
		return
	// Thralls don't frenzy.
	if (vampire.status & VAMP_ISTHRALL)
		return

/*
 * Misc info:
 * 100 points ~= 3.5 minutes.
 * Average duration should be around 4 minutes of frenzy.
 * Trigger at 120 points or higher.
 */

	if (vampire.status & VAMP_FRENZIED)
		if (vampire.frenzy < 10)
			vampire_stop_frenzy()
	else
		var/next_alert = 0
		var/message = ""

		switch (vampire.frenzy)
			if (0)
				return
			if (1 to 20)
				// Pass function would be amazing here.
				next_alert = 0
				message = ""
			if (21 to 40)
				next_alert = 600
				message = SPAN_WARNING("You feel the power of the Veil bubbling in your veins.")
			if (41 to 60)
				next_alert = 500
				message = SPAN_WARNING("The corruption within your blood is seeking to take over, you can feel it.")
			if (61 to 80)
				next_alert = 400
				message = SPAN_DANGER("Your rage is growing ever greater. You are having to actively resist it.")
			if (81 to 120)
				next_alert = 300
				message = SPAN_DANGER("The corruption of the Veil is about to take over. You have little time left.")
			else
				vampire_start_frenzy(force_frenzy)

		if (next_alert && message)
			if (!vampire.last_frenzy_message || vampire.last_frenzy_message + next_alert < world.time)
				to_chat(src, message)
				vampire.last_frenzy_message = world.time

/mob/proc/vampire_start_frenzy(var/force_frenzy = 0)
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if (vampire.status & VAMP_FRENZIED)
		return TRUE

	var/probablity = force_frenzy ? 100 : vampire.frenzy * 0.5

	if (prob(probablity))
		vampire.status |= VAMP_FRENZIED
		visible_message(SPAN_DANGER("A dark aura manifests itself around [src.name], their eyes turning red and their composure changing to be more beast-like."),
						SPAN_DANGER("You can resist no longer. The power of the Veil takes control over your mind: you are unable to speak or think. In people, you see nothing but prey to be feasted upon. You are reduced to an animal."))

		overlay_fullscreen("frenzy", /atom/movable/screen/fullscreen/frenzy)
		mutations |= HULK
		update_mutations()

		sight |= SEE_MOBS

		add_verb(src, /mob/living/carbon/human/proc/grapple)

		return TRUE

/mob/living/carbon/human/vampire_start_frenzy()
	. = ..()
	if(.)
		update_body(force_base_icon = TRUE)

/mob/proc/vampire_stop_frenzy(var/force_stop = 0)
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]

	if (!(vampire.status & VAMP_FRENZIED))
		return TRUE

	if (prob(force_stop ? 100 : vampire.blood_usable))
		vampire.status &= ~VAMP_FRENZIED

		mutations &= ~HULK
		update_mutations()

		clear_fullscreen("frenzy")
		sight &= ~SEE_MOBS

		visible_message(SPAN_DANGER("[src.name]'s eyes no longer glow with violent rage, their form reverting to resemble that of a normal person's."),
						SPAN_DANGER("The beast within you retreats. You gain control over your body once more."))

		remove_verb(src, /mob/living/carbon/human/proc/grapple)
		regenerate_icons()

		return TRUE

/mob/living/carbon/human/vampire_stop_frenzy()
	. = ..()
	if(.)
		update_body(force_base_icon = TRUE)

// Removes all vampire powers.
/mob/proc/remove_vampire_powers()
	if(!mind)
		return
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if(!vampire)
		return
	for (var/datum/power/vampire/P in vampire.purchased_powers)
		if (P.isVerb)
			remove_verb(src, P.verbpath)

	if (vampire.status & VAMP_FRENZIED)
		vampire_stop_frenzy(1)

/mob/proc/handle_vampire()
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if(vampire.status & VAMP_ISTHRALL)
		return

	// Apply frenzy while in the chapel.
	if (istype(get_area(loc), /area/horizon/service/chapel))
		vampire.frenzy += 3

	if (vampire.blood_usable < 10)
		vampire.frenzy += 2
	else if (vampire.frenzy > 0)
		vampire.frenzy = max(0, vampire.frenzy -= clamp(vampire.blood_usable * 0.1, 1, 10))

	vampire.frenzy = round(min(vampire.frenzy, 450))

	vampire_check_frenzy()

	if(client)
		if(!vampire.blood_hud)
			vampire.blood_hud = new /atom/movable/screen/vampire/blood()
			client.screen += vampire.blood_hud
		if(!vampire.frenzy_hud)
			vampire.frenzy_hud = new /atom/movable/screen/vampire/frenzy()
			client.screen += vampire.frenzy_hud
		if(!vampire.blood_suck_hud)
			vampire.blood_suck_hud = new /atom/movable/screen/vampire/suck()
			client.screen += vampire.blood_suck_hud

		vampire.blood_hud.maptext = SMALL_FONTS(7, vampire.blood_usable)
		if(vampire.frenzy)
			if(!vampire.frenzy_hud.alpha)
				animate(vampire.frenzy_hud, 1 SECOND, alpha = 255, LINEAR_EASING)
			vampire.frenzy_hud.maptext = SMALL_FONTS(7, vampire.frenzy)
		else
			if(vampire.frenzy_hud.alpha)
				animate(vampire.frenzy_hud, 1 SECOND, alpha = 0, LINEAR_EASING)
			vampire.frenzy_hud.maptext = null

/mob/living/carbon/human/proc/finish_vamp_timeout(vamp_flags = 0)
	if(!mind)
		return FALSE
	var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
	if(!vampire)
		return FALSE
	if (vamp_flags && !(vampire.status & vamp_flags))
		return FALSE
	return TRUE
