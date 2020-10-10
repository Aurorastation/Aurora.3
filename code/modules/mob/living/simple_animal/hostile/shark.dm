

/mob/living/simple_animal/eventshark
	name = "shark"
	desc = "A ferocious, fang-bearing creature."
	icon = 'icons/mob/npc/shark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_rest = "shark_rest"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	organ_names = list("head", "chest", "tail", "left flipper", "right flipper")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 1
	meat_amount = 5
	maxHealth = 700
	health = 700
	mob_size = 15
	see_in_dark = 10
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 30
	resist_mod = 15 // LOL good luck pal
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "carp"

	flying = TRUE

	var/diving = FALSE
	var/mouth_open = TRUE

/mob/living/simple_animal/eventshark/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/eventshark/verb/dive()
	set category = "Shark"

	if(!diving)
		visible_message(SPAN_NOTICE("\The [src] dives down and vanishes from view."))
		invisibility = INVISIBILITY_MAXIMUM
		speed = 0.5
		density = FALSE
	else
		invisibility = 0
		visible_message(SPAN_NOTICE("\The [src] emerges from the depths."))
		speed = 1
		density = TRUE

	diving = !diving

/mob/living/simple_animal/eventshark/MiddleClickOn(var/atom/A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!Adjacent(H))
			return

		if(!health)
			return

		var/limblist = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
		while(length(limblist))
			var/limbname = pick(limblist)
			limblist -= limbname
			var/obj/item/organ/external/O = H.get_organ(limbname)
			if(!O)
				continue
			if(O.is_stump())
				continue
			O.droplimb(FALSE,DROPLIMB_BLUNT)
			visible_message(SPAN_WARNING("\The [src] bites off [H]'s [O]."))
			return
		var/obj/item/organ/external/O = H.get_organ(BP_HEAD)
		if(!O)
			return
		if(O.is_stump())
			return
		O.droplimb(FALSE,DROPLIMB_EDGE)
		visible_message(SPAN_WARNING("\The [src] bites off [H]'s [O]."))

	else if(istype(A,/obj/item))
		if(!Adjacent(A))
			return

		if(!health)
			return

		visible_message(SPAN_WARNING("\The [src] devours \the [A]"))
		qdel(A)

		return
	return

/**
 *  Attempt to devour victim
 *
 *  Returns TRUE on success, FALSE on failure

/mob/living/simple_animal/eventshark/proc/devour(atom/movable/victim)

	var/eat_speed = 100
	if(ismob(victim))
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

/mob/living/simple_animal/eventshark/proc/move_to_stomach(atom/movable/victim)
	return

// Snowflake procs for unathi. Because lore said so.

/mob/living/simple_animal/eventshark/proc/do_gradual_devour(var/mob/living/victim, var/eat_speed)
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
	var/datum/reagents/vessel = victim.get_vessel(1)
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
		if(do_mob(src, victim, bite_delay * 10, extra_checks = CALLBACK(src, .proc/devour_in_range, victim)))
			face_atom(victim)
			victim.apply_damage(damage_dealt, BRUTE)
			var/obj/item/organ/internal/stomach/S = internal_organs_by_name[BP_STOMACH]
			if(S)
				S.ingested.add_reagent(victim.composition_reagent, (victim.composition_reagent_quantity * 0.5) * PEPB)
			visible_message("<span class='danger'>[src] bites a chunk out of [victim]!</span>","<span class='danger'>[bitemessage(victim)]</span>")
			if(messes < victim.mob_size - 1 && prob(50))
				handle_devour_mess(src, victim, vessel)
			if(victim.getBruteLoss() >= victim_maxhealth)
				visible_message("<span class='danger'>[src] finishes devouring [victim].</span>","<span class='warning'>You finish devouring [victim].</span>")
				handle_devour_mess(src, victim, vessel, 1)
				qdel(victim)
		else
			if(nutrition >= (max_nutrition - 60))
				to_chat(src, "<span class='danger'>Your stomach is full!</span>")
			if (victim && !QDELETED(victim) && victimloc != victim.loc) //This procs when the victim gets moved to nullspace.
				to_chat(src, "<span class='danger'>[victim] moved away, you need to keep it still. Try grabbing, stunning or killing it first.</span>")
			else if (ourloc != src.loc)
				to_chat(src, "<span class='danger'>You moved! Devouring cancelled.</span>")
			break

/mob/living/simple_animal/eventshark/proc/devour_in_range(var/mob/victim)
	return victim in range(2, src)
 */
