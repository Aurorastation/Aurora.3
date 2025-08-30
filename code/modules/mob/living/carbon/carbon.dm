/mob/living/carbon/Initialize()
	//setup reagent holders
	bloodstr = new/datum/reagents/metabolism(1000, src, CHEM_BLOOD)
	touching = new/datum/reagents/metabolism(1000, src, CHEM_TOUCH)
	breathing = new/datum/reagents/metabolism(1000, src, CHEM_BREATHE)
	reagents = bloodstr

	. = ..()

	if(species && species.indefinite_sleep)
		add_verb(src, /verb/toggle_indefinite_sleep)

/mob/living/carbon/Life(seconds_per_tick, times_fired)
	if(!..())
		return

	UpdateStasis()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

	if(stat != DEAD && !InStasis())
		//Breathing, if applicable
		handle_breathing()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Random events (vomiting etc)
		handle_random_events()

		// eye, ear, brain damages
		handle_disabilities()

		//all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc
		handle_statuses()

		. = 1

/mob/living/carbon/Destroy()
	QDEL_NULL(touching)
	QDEL_NULL(bloodstr)
	QDEL_NULL(dna)
	QDEL_NULL(breathing)
	for(var/guts in internal_organs)
		qdel(guts)
	return ..()

/mob/living/carbon/rejuvenate()
	bloodstr.clear_reagents()
	touching.clear_reagents()
	var/datum/reagents/R = get_ingested_reagents()
	if(istype(R))
		R.clear_reagents()
	breathing.clear_reagents()
	intoxication = 0
	..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()

	if(.)
		if(src.stat != 2)
			if(src.nutrition)
				adjustNutritionLoss(nutrition_loss*0.1)
			if(src.hydration)
				adjustHydrationLoss(hydration_loss*0.1)

		if((mutations & FAT) && src.m_intent == M_RUN && src.bodytemperature <= 360)
			src.bodytemperature += 2

		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++

		src.help_up_offer = 0

/mob/living/carbon/relaymove(mob/living/user, direction)
	. = ..()

	if((user in contents) && istype(user))
		if(user.last_special <= world.time)
			user.last_special = world.time + 50
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/organ = H.get_organ(BP_CHEST)
					if (istype(organ))
						if(organ.take_damage(d, 0))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				user.visible_message(SPAN_DANGER("[user] attacks [src]'s stomach wall with the [I.name]!"))
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					src.gib()

/mob/living/carbon/gib()
	for(var/mob/M in contents)
		M.dropInto(loc)
		visible_message(SPAN_DANGER("\The [M] bursts out of \the [src]!"))
	..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon))
		return
	if(!M.can_use_hand())
		return

	if(M.a_intent != I_HELP)
		var/action
		switch(M.a_intent)
			if(I_GRAB)
				action = "grabbed"
			if(I_DISARM)
				action = "pushed"
			if(I_HURT)
				action = "punched"
		var/show_ssd
		var/mob/living/carbon/human/H
		if(ishuman(src))
			H = src
			show_ssd = H.species.show_ssd
		if(H && show_ssd && !client && !teleop)
			if(H.bg)
				to_chat(H, SPAN_DANGER("You sense some disturbance to your physical body!"))
			else if(!vr_mob)
				visible_message(SPAN_NOTICE("[M] [action] [src], but they do not respond... Maybe they have S.S.D?"))
		else if(client && willfully_sleeping)
			visible_message(SPAN_NOTICE("[M] [action] [src] waking [get_pronoun("him")] up!"))
			sleeping = 0
			willfully_sleeping = FALSE

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/tesla_shock = 0, var/ground_zero)
	if(status_flags & GODMODE)
		return 0	//godmode
	if(!tesla_shock)
		shock_damage *= siemens_coeff
	if(shock_damage<1)
		return 0

	src.apply_damage(shock_damage, DAMAGE_BURN, def_zone, used_weapon="Electrocution")
	playsound(loc, /singleton/sound_category/spark_sound, 50, 1, -1)
	if(shock_damage > 15 || tesla_shock)
		src.visible_message(
			SPAN_WARNING("[src] was shocked by the [source]!"), \
			SPAN_DANGER("You feel a powerful shock course through your body!"), \
			SPAN_WARNING("You hear a heavy electrical crack.") \
		)
		Stun(10)//This should work for now, more is really silly and makes you lay there forever
		Weaken(10)
	else
		src.visible_message(
			SPAN_WARNING("[src] was mildly shocked by the [source]."), \
			SPAN_WARNING("You feel a mild shock course through your body."), \
			SPAN_WARNING("You hear a light zapping.") \
		)
	spark(loc, 5, GLOB.alldirs)
	return shock_damage

/mob/proc/swap_hand()
	return

/mob/living/carbon/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand && !item_in_hand.can_swap_hands(src)) //this segment checks if the item in your hand is twohanded.
		to_chat(src, SPAN_WARNING("Your other hand is too busy holding \the [item_in_hand]!"))
		return
	src.hand = !src.hand
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"

/mob/living/carbon/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.
	if(istext(selhand))
		selhand = lowertext(selhand)
		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if (on_fire)
		playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if (M.on_fire)
			M.visible_message(SPAN_WARNING("[M] tries to pat out [src]'s flames, but to no avail!"),
			SPAN_WARNING("You try to pat out [src]'s flames, but to no avail! Put yourself out first!"))
		else
			M.visible_message(SPAN_WARNING("[M] tries to pat out [src]'s flames!"),
			SPAN_WARNING("You try to pat out [src]'s flames! Hot!"))
			if(do_mob(M, src, 1.5 SECONDS))
				if (M.IgniteMob(prob(10)))
					M.visible_message(SPAN_DANGER("The fire spreads from [src] to [M]!"),
					SPAN_DANGER("The fire spreads to you as well!"))
				else
					if (src.ExtinguishMob(1))
						M.visible_message(SPAN_WARNING("[M] successfully pats out [src]'s flames."),
						SPAN_WARNING("You successfully pat out [src]'s flames."))
	else if (!is_asystole())
		if(src == M && istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			src.visible_message(
				SPAN_NOTICE("[src] examines [src.get_pronoun("himself")]."), \
				SPAN_NOTICE("You check yourself for injuries.") \
				)

			for(var/obj/item/organ/external/org in H.organs)
				var/list/status = list()
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam
				switch(brutedamage)
					if(1 to 20)
						status += "bruised"
					if(20 to 40)
						status += "wounded"
					if(40 to INFINITY)
						status += "mangled"

				switch(burndamage)
					if(1 to 10)
						status += "numb"
					if(10 to 40)
						status += "blistered"
					if(40 to INFINITY)
						status += "peeling away"

				if(org.is_stump())
					status += SPAN_DANGER("MISSING")
				if(org.status & ORGAN_MUTATED)
					status += "weirdly shapen"
				if(org.dislocated == 2)
					status += "dislocated"
				if(org.status & ORGAN_BROKEN)
					status += "hurts when touched"
				if(org.status & ORGAN_DEAD)
					status += "is necrotic"
				if(!org.is_usable())
					status += "dangling uselessly"
				if(org.status & ORGAN_BLEEDING)
					status += SPAN_DANGER("bleeding")
				var/output = ""
				if(length(status))
					output = "My [org.name] is [SPAN_WARNING("[english_list(status)].")]"
				else
					output = "My [org.name] feels [SPAN_NOTICE("OK.")]"
				if(length(org.implants))
					output += " [SPAN_WARNING("I can feel something inside it.")]"
				to_chat(src, output)

			if((isskeleton(H)) && (!H.w_uniform) && (!H.wear_suit))
				H.play_xylophone()
		else
			if (istype(src,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = src
				if(H.w_uniform)
					H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/mob/living/carbon/human/H
			if(ishuman(src))
				H = src
				show_ssd = H.species.show_ssd
			if(H && show_ssd && !client && !teleop)
				if(H.bg)
					to_chat(H, SPAN_WARNING("You sense some disturbance to your physical body, like someone is trying to wake you up."))
				else if(!vr_mob)
					M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [get_pronoun("him")] up!"), \
										SPAN_NOTICE("You shake [src], but they do not respond... Maybe they have S.S.D?"))
			else if(lying)
				if(sleeping)
					if(sleeping_indefinitely)
						sleep_buffer += 5
					else
						AdjustSleeping(-5)
					M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [get_pronoun("him")] up!"), \
										SPAN_NOTICE("You shake [src] trying to wake [get_pronoun("him")] up!"))
				else
					M.help_up_offer = !M.help_up_offer
					if(M.help_up_offer)
						M.visible_message(SPAN_NOTICE("[M] holds a hand out to [src]."), \
											SPAN_NOTICE("You hold a hand out to [src]."))
					else
						M.visible_message(SPAN_WARNING("[M] retracts their hand from [src]'s direction."), \
											SPAN_WARNING("You retract your hand from [src]'s direction."))
			else
				var/mob/living/carbon/human/tapper = M
				if(M.resting)
					if(src.help_up_offer)
						M.visible_message(SPAN_NOTICE("[M] grabs onto [src]'s hand and is hoisted up."), \
											SPAN_NOTICE("You grab onto [src]'s hand and are hoisted up."))
						if(do_after(M, 0.5 SECONDS))
							M.resting = 0
							src.help_up_offer = 0
					else
						M.visible_message(SPAN_WARNING("[M] grabs onto [src], trying to pull themselves up."), \
										SPAN_WARNING("You grab onto [src], trying to pull yourself up."))
						if(M.fire_stacks >= (src.fire_stacks + 3))
							src.adjust_fire_stacks(1)
							M.adjust_fire_stacks(-1)
						if(M.on_fire)
							src.IgniteMob()
						if(do_after(M, 4 SECONDS))
							M.resting = 0

				else if(istype(tapper))
					var/skip_emote_check = on_fire
					if(!skip_emote_check)
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
					tapper.species.tap(tapper,src)
				else
					M.visible_message("<b>[M]</b> taps [src] to get their attention!", \
								SPAN_NOTICE("You tap [src] to get their attention!"))

			if(stat != DEAD)
				AdjustParalysis(-3)
				AdjustStunned(-3)
				AdjustWeakened(-3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/**
 * Checks the carbon's get_heat_protection (bitflags of covered areas). The maximum temp increase per tick is BODYTEMP_HEATING_MAX, so it
 * compares how
 * Limited per tick by BODYTEMP_HEATING_MAX.
 * Only uses exposed_temperature param.
 */
/mob/living/carbon/fire_act(exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled_to && ! istype(buckled_to, /obj/structure/bed/stool/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()
		if(buckled_to && buckled_to.buckle_require_restraints)
			buckled_to.unbuckle()

	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
		..()

	return

//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		to_chat(usr, SPAN_WARNING("You are already asleep."))
		return
	if(alert(src,"Are you sure you want to sleep for a while?", "Sleep", "Yes", "No") == "Yes")
		willfully_sleeping = TRUE
		usr.sleeping = 20 // Short nap.
		usr.eye_blurry = 20

/mob/living/carbon/sleeps_horizontal()
	if(species && species.sleeps_upright)
		return FALSE
	return ..()

/verb/toggle_indefinite_sleep()
	set name = "Toggle Indefinite Sleep"
	set category = "IC"
	if(ismob(usr))
		var/mob/M = usr
		M.sleeping_indefinitely = !M.sleeping_indefinitely
		to_chat(M, SPAN_NOTICE("You will [M.sleeping_indefinitely ? "now" : "no longer"] sleep indefinitely."))

		if(!M.sleeping_indefinitely)
			M.AdjustSleeping(-1*M.sleep_buffer)
			M.sleep_buffer = 0

/mob/living/carbon/Collide(atom/A)
	if(now_pushing)
		return
	. = ..()

/mob/living/carbon/cannot_use_vents()
	return

/mob/living/carbon/slip(var/slipped_on,stun_duration=8)
	if(buckled_to)
		return 0
	stop_pulling()
	to_chat(src, SPAN_WARNING("You slipped on [slipped_on]!"))
	playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	Stun(stun_duration)
	Weaken(FLOOR(stun_duration/2, 1))
	return 1

/**
 * Adds an amount of a chemical effect to the mob
 *
 * * effect - A string indicative of the effect, as per `CE_*` defines in `code\__DEFINES\chemistry.dm`
 * * magnitude - The magnitude/quantity/amount of the effect to add
 */
/mob/living/carbon/proc/add_chemical_effect(var/effect, var/magnitude = 1)
	SHOULD_NOT_SLEEP(TRUE)

	if(effect in chem_effects)
		chem_effects[effect] += magnitude
	else
		chem_effects[effect] = magnitude

/**
 * Adds _up to_ an amount of a chemical effect to the mob
 *
 * Makes a chemical effect have _at least_ the specified `magnitude`
 *
 * * effect - A string indicative of the effect, as per `CE_*` defines in `code\__DEFINES\chemistry.dm`
 * * magnitude - The magnitude/quantity/amount of the effect to reach, if lacking
 */
/mob/living/carbon/proc/add_up_to_chemical_effect(var/effect, var/magnitude = 1)
	SHOULD_NOT_SLEEP(TRUE)

	if(effect in chem_effects)
		chem_effects[effect] = max(magnitude, chem_effects[effect])
	else
		chem_effects[effect] = magnitude

/**
 * Removes an amount of a chemical effect from the mob
 *
 * Prevents the magnitude to go negative
 *
 * * effect - A string indicative of the effect, as per `CE_*` defines in `code\__DEFINES\chemistry.dm`
 * * magnitude - The magnitude/quantity/amount of the effect to remove
 */
/mob/living/carbon/proc/remove_chemical_effect(var/effect, var/magnitude = 1)
	SHOULD_NOT_SLEEP(TRUE)

	if(effect in chem_effects)
		chem_effects[effect] -= max(magnitude, chem_effects[effect])


/mob/living/carbon/get_default_language()
	if(default_language)
		return default_language

	if(!species)
		return null
	return species.default_language ? GLOB.all_languages[species.default_language] : null

/mob/living/carbon/is_berserk()
	return (CE_BERSERK in chem_effects)

/mob/living/carbon/is_pacified()
	if(disabilities & PACIFIST)
		return TRUE
	if(CE_PACIFIED in chem_effects)
		return TRUE

/mob/living/carbon/proc/get_metabolism(metabolism)
	return metabolism

/mob/living/carbon/proc/can_feel_pain()
	if (species && (species.flags & NO_PAIN))
		return FALSE
	if ((mutations & HULK))
		return FALSE
	if (analgesic > 100)
		return FALSE
	if(pain_immune)
		return FALSE

	return TRUE

/mob/living/carbon/get_shock()
	if(can_feel_pain())
		return ..()

/mob/living/carbon/proc/need_breathe()
	return

/**
 *  Return FALSE if victim can't be devoured, DEVOUR_FAST if they can be devoured quickly, DEVOUR_SLOW for slow devour
 */
/mob/living/carbon/proc/can_devour(atom/movable/victim)
	return FALSE

/mob/living/carbon/proc/get_ingested_reagents()
	return reagents

/mob/living/carbon/proc/should_have_organ(var/organ_check)
	return 0

/mob/living/carbon/proc/SetStasis(var/factor, var/source = "misc")
	if((species && (species.flags & NO_SCAN)) || isSynthetic())
		return
	stasis_sources[source] = factor

/mob/living/carbon/InStasis()
	if(!stasis_value)
		return FALSE
	return life_tick % stasis_value

// call only once per run of life
/mob/living/carbon/proc/UpdateStasis()
	stasis_value = 0
	if((species && (species.flags & NO_SCAN)) || isSynthetic())
		return
	for(var/source in stasis_sources)
		stasis_value += stasis_sources[source]
	stasis_sources.Cut()

/mob/living/carbon/get_contained_external_atoms()
	. = contents - internal_organs

/mob/living/carbon/proc/is_drowsy()
	return (drowsiness >= 5)

/mob/living/carbon/proc/should_have_limb(var/organ_check)
	return FALSE

/mob/living/carbon/get_equipped_speed_mod_items()
	return ..() + get_equipped_items()
