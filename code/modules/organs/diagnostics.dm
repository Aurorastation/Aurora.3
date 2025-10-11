/singleton/diagnostic_sign
	var/name = "Some symptom"
	var/descriptor
	var/explanation
	// var/hint_min_skill = SKILL_BASIC (we don't have skills pain)

//Checks conditions for this sign to appear
/singleton/diagnostic_sign/proc/manifested_in(obj/item/organ/external/victim)

/singleton/diagnostic_sign/proc/get_description(mob/user)
	. = descriptor
	if(user)
		. += "<small><a href='byond://?src=\ref[src];show_diagnostic_hint=1'>(?)</a></small>"

/singleton/diagnostic_sign/Topic(var/href, var/list/href_list)
	. = ..()
	if(.)
		return
	if(href_list["show_diagnostic_hint"])
		to_chat(usr, SPAN_NOTICE("[name] - [explanation]"))
		return TOPIC_HANDLED

/singleton/diagnostic_sign/shock
	name = "Clammy skin"
	descriptor = "clammy and cool to the touch"
	explanation = "Patient is in shock from severe pain."

/singleton/diagnostic_sign/shock/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.shock_stage >= 30

/singleton/diagnostic_sign/liver
	name = "Jaundice"
	descriptor = "jaundiced"
	explanation = "Patient has internal organ damage."

/singleton/diagnostic_sign/liver/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.getToxLoss() >= 25

/singleton/diagnostic_sign/oxygenation
	name = "Cyanosis"
	descriptor = "turning blue"
	explanation = "Patient has low blood oxygenation."

/singleton/diagnostic_sign/oxygenation/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.get_blood_oxygenation() <= 50

/singleton/diagnostic_sign/circulation
	name = "Paleness"
	descriptor = "very pale"
	explanation = "Patient has issues with blood circulaion or volume."

/singleton/diagnostic_sign/circulation/manifested_in(obj/item/organ/external/victim)
	return victim.owner && victim.owner.get_blood_circulation() <= 60

/singleton/diagnostic_sign/gangrene
	name = "Rot"
	descriptor = "rotting"
	explanation = "Patient has lost this bodypart to an irreversible bacterial infection."

/singleton/diagnostic_sign/gangrene/manifested_in(obj/item/organ/external/victim)
	return victim.status & ORGAN_DEAD


/obj/item/organ/external/proc/inspect(mob/user)
	user.visible_message(SPAN_NOTICE("[user] starts inspecting [owner]'s [name] carefully."))
	// for(var/ailment in has_diagnosable_ailments(user, scanner = FALSE))
	// 	if(!do_mob(user, owner, 5))
	// 		return
	// 	to_chat(user, SPAN_NOTICE(ailment))

	if(!do_mob(user, owner, 5))
		return
	var/list/stuff
	for(var/obj/O in implants)
		if(!istype(O, /obj/item/implant))
			LAZYADD(stuff, O)

	if(LAZYLEN(wounds) || LAZYLEN(stuff))
		if(LAZYLEN(wounds))
			to_chat(user, SPAN_WARNING("You find [get_wounds_desc()]"))
		if(LAZYLEN(stuff))
			to_chat(user, SPAN_WARNING("There's [english_list(stuff)] sticking out of [owner]'s [name]."))
	else
		to_chat(user, SPAN_NOTICE("You find no visible wounds."))

	to_chat(user, SPAN_NOTICE("You start checking [owner]'s skin..."))
	if(!do_mob(user, owner, 1 SECOND))
		to_chat(user, SPAN_NOTICE("You must stand still to check [owner]'s skin for abnormalities."))
		return

	var/list/badness = list()
	var/list/symptoms = GET_SINGLETON_SUBTYPE_LIST(/singleton/diagnostic_sign)
	for(var/S in symptoms)
		var/singleton/diagnostic_sign/sign = symptoms[S]
		if(sign.manifested_in(src))
			badness += sign.get_description(user)
	if(!badness.len)
		to_chat(user, SPAN_NOTICE("[owner]'s skin is normal."))
	else
		to_chat(user, SPAN_WARNING("[owner]'s skin is [english_list(badness)]."))

	to_chat(user, SPAN_NOTICE("You start checking [owner]'s bones..."))
	if(!do_mob(user, owner, 1 SECOND))
		to_chat(user, SPAN_NOTICE("You must stand still to feel [src] for fractures."))
		return

	if(status & ORGAN_BROKEN)
		to_chat(user, SPAN_WARNING("The [encased ? encased : "bone in \the [src]"] moves slightly when you poke it!"))
		owner.custom_pain("Your [name] hurts where it's poked.",40, affecting = src)
	else
		to_chat(user, SPAN_NOTICE("The [encased ? encased : "bones in \the [src]"] seem to be fine."))

	if(status & TENDON_CUT)
		to_chat(user, SPAN_WARNING("The tendons in [name] are severed!"))
	if(ORGAN_IS_DISLOCATED(src))
		to_chat(user, SPAN_WARNING("The [joint] is dislocated!"))
	return TRUE

/obj/item/organ/external/proc/get_injury_status(include_pain = TRUE, include_visible = TRUE)
	. = list()
	if(include_pain && ORGAN_CAN_FEEL_PAIN(src))
		var/feels = 1 + round(get_pain()/100, 0.1)
		var/feels_brute = brute_dam * feels
		if(feels_brute > 0)
			switch(feels_brute / max_damage)
				if(0 to 0.35)
					. += "slightly sore"
				if(0.35 to 0.65)
					. += "very sore"
				if(0.65 to INFINITY)
					. += "throbbing with agony"

		var/feels_burn = burn_dam * feels
		if(feels_burn > 0)
			switch(feels_burn / max_damage)
				if(0 to 0.35)
					. += "tingling"
				if(0.35 to 0.65)
					. += "stinging"
				if(0.65 to INFINITY)
					. += "burning fiercely"

		if(status & ORGAN_BROKEN)
			. += "painful to the touch"

	if(include_visible && !owner?.is_blind())
		if(status & ORGAN_MUTATED)
			. += "misshapen"
		if(status & ORGAN_BLEEDING)
			. += SPAN_DANGER("bleeding")
		if(ORGAN_IS_DISLOCATED(src))
			. += "dislocated"
		if(status & ORGAN_DEAD)
			if(BP_IS_ROBOTIC(src))
				. += "irrecoverably damaged"
			else
				. += "grey and necrotic"
		else if ((brute_dam + burn_dam) >= max_damage && germ_level >= INFECTION_LEVEL_TWO)
			. += "likely beyond saving and decay has set in"

	if(is_stump())
		. += SPAN_DANGER("MISSING")

	if(LAZYLEN(implants))
		. += (include_visible && !(is_list_containing_type(implants, /obj/item/implant))) ? SPAN_DANGER("impaled by something") : "itching due to something inside"

	if(!is_usable() || ORGAN_IS_DISLOCATED(src))
		. += (!include_visible || owner?.is_blind()) ? "completely limp" : "dangling uselessly"
