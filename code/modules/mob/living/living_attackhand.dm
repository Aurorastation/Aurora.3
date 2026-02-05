/// We call parent attack_hands and only go to default_interaction handlers if they return falsy values
/mob/living/attack_hand(mob/user)
	if(user.can_use_hand() && buckled == user && user.a_intent == I_GRAB)
		return try_make_grab(user)
	return ..() || (user && default_interaction(user))

/mob/living/proc/default_interaction(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	switch(user.a_intent)
		if(I_HURT)
			. = default_hurt_interaction(user)
		if(I_HELP)
			. = default_help_interaction(user)
		if (I_DISARM)
			. = default_disarm_interaction(user)
		if(I_GRAB)
			. = default_grab_interaction(user)

/mob/living/proc/default_hurt_interaction(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_help_interaction(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(try_extinguish(user))
		return TRUE
	if(try_awaken(user))
		return TRUE
	return FALSE

/mob/living/proc/default_disarm_interaction(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return FALSE

/mob/living/proc/default_grab_interaction(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	return try_make_grab(user)

/mob/living/handle_grab_interaction(mob/user)
	return FALSE

/mob/living/proc/try_extinguish(mob/living/user)
	if(!on_fire || !istype(user))
		return FALSE

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

	if(user.on_fire)
		user.visible_message(SPAN_WARNING("\The [user] tries to pat out \the [src]'s flames, but to no avail!"), SPAN_WARNING("You try to pat out [src]'s flames, but to no avail! Put yourself out first!"))
		return TRUE

	user.visible_message(SPAN_WARNING("\The [user] tries to pat out \the [src]'s flames!"), SPAN_WARNING("You try to pat out \the [src]'s flames! Hot!"))

	if(!do_mob(user, src, 1.5 SECONDS))
		return TRUE

	if(user.IgniteMob(prob(10)))
		user.visible_message(SPAN_DANGER("The fire spreads from [src] to [user]!"), SPAN_DANGER("The fire spreads to you!"))
	else if (ExtinguishMob(1))
		user.visible_message(SPAN_WARNING("[user] successfully pats out [src]'s flames."), SPAN_WARNING("You successfully pat out [src]'s flames."))
	return TRUE

/mob/living/proc/try_awaken(mob/living/user)
	if(!istype(user))
		return FALSE

	var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
	if(uniform)
		uniform.add_fingerprint(user)

	var/mob/living/carbon/human/human_src = src
	var/mob/living/carbon/human/tapper = user
	var/show_ssd = TRUE
	if(istype(human_src))
		show_ssd = human_src.species.show_ssd

	if(!client && !teleop && show_ssd)
		if(human_src.bg)
			to_chat(src, SPAN_WARNING("You sense some disturbance to your physical body, like someone is trying to wake you up."))
		else if(!vr_mob)
			user.visible_message(SPAN_NOTICE("[user] shakes [src] trying to wake [get_pronoun("him")] up!"), \
								SPAN_NOTICE("You shake [src], but they do not respond... Maybe they have S.S.D?"))

	else if(lying)
		if(sleeping)
			if(sleeping_indefinitely)
				sleep_buffer += 5
			else
				AdjustSleeping(-5)
		else if(istype(tapper))
			tapper.help_up_offer = !tapper.help_up_offer
			if(tapper.help_up_offer)
				user.visible_message(SPAN_NOTICE("[user] holds a hand out to [src]."), SPAN_NOTICE("You hold a hand out to [src]."))
			else
				user.visible_message(SPAN_WARNING("[user] retracts their hand from [src]."), SPAN_WARNING("You retract your hand from [src]."))

	else
		if(user.resting && istype(human_src))
			if(human_src.help_up_offer)
				user.visible_message(SPAN_NOTICE("[user] grabs onto [src]'s hand and is hoisted up."), SPAN_NOTICE("You grab onto [src]'s hand and are hoisted up."))
				if(do_after(user, 0.5 SECONDS))
					user.resting = FALSE
					human_src.help_up_offer = FALSE
			else
				user.visible_message(SPAN_WARNING("[user] grabs onto [src], trying to pull themselves up."), SPAN_WARNING("You grab onto [src], trying to pull yourself up."))
				if(user.fire_stacks >= (fire_stacks + 3))
					adjust_fire_stacks(1)
					user.adjust_fire_stacks(-1)
				if(user.on_fire)
					IgniteMob()
				if(do_after(user, 4 SECONDS))
					user.resting = FALSE

		else if (istype(tapper))
			if(!on_fire)
				var/tapper_selected_zone = tapper.zone_sel.selecting
				for(var/list/body_part_key in tapper.species.overhead_emote_types)
					if(tapper_selected_zone in body_part_key)
						var/emote_type = tapper.species.overhead_emote_types[body_part_key]
						var/datum/component/overhead_emote/emote_component = GetComponent(/datum/component/overhead_emote)
						if(emote_component)
							var/singleton/overhead_emote/emote_singleton = GET_SINGLETON(emote_component.emote_type)
							emote_singleton.reciprocate_emote(tapper, src, emote_type)
						else
							tapper.AddComponent(/datum/component/overhead_emote, emote_type, src)
						return
			tapper.species.tap(tapper, src)
		else
			user.visible_message(SPAN_NOTICE("[user] taps [src] to get [get_pronoun("his")] attention!"), SPAN_NOTICE("You tap [src] to get [get_pronoun("his")] attention!"))

	if(stat != DEAD)
		AdjustParalysis(-3)
		AdjustStunned(-3)
		AdjustWeakened(-3)

	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

	return TRUE
