 #define PPM 9	//Protein per meat, used for calculating the quantity of protein in an animal

/**
 *  Attempt to devour victim
 *
 *  Returns TRUE on success, FALSE on failure
 */
/mob/living/carbon/human/proc/devour(atom/movable/victim)
	var/can_eat = can_devour(victim)
	if(!can_eat)
		return FALSE

	var/eat_speed = 100
	if(can_eat == DEVOUR_FAST)
		eat_speed = 30
	if((species?.gluttonous & GLUT_MESSY) && ismob(victim))
		eat_speed *= 3 //We want our bites to take a lot so as to not spam the chat.
		do_gradual_devour(victim, eat_speed)
		return
	src.visible_message("<span class='danger'>\The [src] is attempting to devour \the [victim] whole!</span>")
	var/mob/target = victim
	if(isobj(victim))
		target = src
	if(!do_mob(src,target,eat_speed))
		return FALSE
	src.visible_message("<span class='danger'>\The [src] devours \the [victim] whole!</span>")
	if(ismob(victim))
		admin_attack_log(src, victim, "Devoured.", "Was devoured by.", "devoured")
	else
		src.drop_from_inventory(victim)
	move_to_stomach(victim)

	return TRUE

/mob/living/carbon/human/proc/move_to_stomach(atom/movable/victim)
	return

// Snowflake procs for unathi. Because lore said so.

/mob/living/carbon/human/proc/do_gradual_devour(var/mob/living/victim, var/eat_speed)
	set waitfor = FALSE

	//This function will start consuming the victim by taking bites out of them.
	//Victim or attacker moving will interrupt it
	//A bite will be taken every 4 seconds
	var/bite_delay = 4
	var/bite_size = mouth_size * 0.5
	var/num_bites_needed = (victim.mob_size * 2)/bite_size //Total bites needed to eat it from full health
	var/PEPB = 1/num_bites_needed //Percentage eaten per bite
	var/turf/ourloc = src.loc
	var/turf/victimloc = victim.loc
	var/messes = 0 //Number of bloodstains we've placed
	if(!victim.composition_reagent_quantity)
		victim.calculate_composition()
	var/dam_multiplier = 1

	var/victim_maxhealth = victim.maxHealth //We cache this here in case we need to edit it.

	var/damage_dealt = victim_maxhealth * PEPB * dam_multiplier

	//Now, incase we're resuming an earlier feeding session on the same creature
	//We calculate the actual bites needed to fully eat it based on how eaten it already is
	if(victim.getBruteLoss())
		var/percentageDamaged = victim.getBruteLoss() / victim_maxhealth
		var/percentageRemaining = 1 - percentageDamaged
		num_bites_needed = percentageRemaining / PEPB

	var/time_needed_seconds = num_bites_needed*bite_delay//in seconds for now
	var/time_needed_minutes
	var/time_needed_string
	if (time_needed_seconds > 60)
		time_needed_minutes = round((time_needed_seconds/60))
		time_needed_seconds = time_needed_seconds % 60
		time_needed_string = "[time_needed_minutes] minutes and [time_needed_seconds] seconds"
	else
		time_needed_string = "[time_needed_seconds] seconds"

	src.visible_message("<span class='danger'>[src] starts to devour [victim]</span>!", \
						"<span class='danger'>You start devouring [victim], this will take approximately [time_needed_string]. You and the victim must remain still to continue, \
						but you can interrupt feeding anytime and leave with what you've already eaten.</span>")

	for (var/i = 0 to num_bites_needed)
		if(do_mob(src, victim, bite_delay * 10, extra_checks = CALLBACK(src, .proc/devouring_equals, victim)))
			face_atom(victim)
			victim.apply_damage(damage_dealt, BRUTE)
			var/obj/item/organ/internal/stomach/S = internal_organs_by_name[BP_STOMACH]
			if(S)
				S.ingested.add_reagent(victim.composition_reagent, (victim.composition_reagent_quantity * 0.5) * PEPB)
			visible_message("<span class='danger'>[src] bites a chunk out of [victim]!</span>","<span class='danger'>[bitemessage(victim)]</span>")
			if(messes < victim.mob_size - 1 && prob(50))
				handle_devour_mess(src, victim)
			if(victim.getBruteLoss() >= victim_maxhealth)
				visible_message("<span class='danger'>[src] finishes devouring [victim].</span>","<span class='warning'>You finish devouring [victim].</span>")
				handle_devour_mess(src, victim, TRUE)
				qdel(victim)
		else
			if(nutrition >= (max_nutrition - 60))
				to_chat(src, "<span class='danger'>Your stomach is full!</span>")
			if (victim && !QDELETED(victim) && victimloc != victim.loc) //This procs when the victim gets moved to nullspace.
				to_chat(src, "<span class='danger'>[victim] moved away, you need to keep it still. Try grabbing, stunning or killing it first.</span>")
			else if (ourloc != src.loc)
				to_chat(src, "<span class='danger'>You moved! Devouring cancelled.</span>")
			break

/mob/living/carbon/human/proc/devouring_equals(var/mob/victim)
	for(var/obj/item/grab/G in victim.grabbed_by)
		if(G && G.state >= GRAB_NECK)
			return TRUE
	return FALSE

//Helpers
/proc/bitemessage(var/mob/living/victim)
	return pick(
		"You take a bite out of \the [victim].",
		"You rip a chunk off of \the [victim].",
		"You consume a piece of \the [victim].",
		"You feast upon your prey.",
		"You chow down on \the [victim].",
		"You gobble \the [victim]'s flesh.")

/proc/handle_devour_mess(var/mob/user, var/mob/living/victim, var/finish = 0)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.add_blood(victim)
	if (!turf_hasblood(get_turf(victim)))
		blood_splatter(get_turf(victim), victim, TRUE)

	if (finish)
		//A bigger victim makes more gibs
		if (victim.mob_size >= MOB_TINY)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		if (victim.mob_size >= MOB_SMALL)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		if (victim.mob_size >= MOB_MEDIUM)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		if (victim.mob_size >= MOB_LARGE)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		return TRUE
	return FALSE

/proc/turf_hasblood(var/turf/test)
	for (var/obj/effect/decal/cleanable/blood/b in test)
		return TRUE
	return FALSE

#undef PPM
