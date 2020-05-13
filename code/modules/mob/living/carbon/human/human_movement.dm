/mob/living/carbon/human/movement_delay()

	var/tally = 0
	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if (isopenturf(loc)) //open space checks
		if(!(locate(/obj/structure/lattice, loc) || locate(/obj/structure/stairs, loc) || locate(/obj/structure/ladder, loc)))
			return -1

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if(can_feel_pain())
		if(get_shock() >= 10) tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it

	for(var/obj/item/I in list(wear_suit, w_uniform, back, gloves, head))
		tally += I.slowdown

	if(species)
		tally += species.get_species_tally(src)

	if (nutrition < (max_nutrition * 0.2))
		tally++
		if (nutrition < (max_nutrition * 0.1))
			tally++

	if (hydration < (max_hydration * 0.2))
		tally++
		if (hydration < (max_hydration * 0.1))
			tally++

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		if(shoes)
			tally += shoes.slowdown

		for(var/organ_name in list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if (can_feel_pain())
		if(shock_stage >= 10)
			tally += 3

	if(is_asystole())
		tally += 10  //heart attacks are kinda distracting

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if (drowsyness) tally += 6

	if (!(species.flags & IS_MECHANICAL))	// Machines don't move slower when cold.
		if(FAT in src.mutations)
			tally += 1.5
		if (bodytemperature < 283.222)
			tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow
	if(mRun in mutations)
		tally = 0

	tally += move_delay_mod

	if(tally > 0 && (CE_SPEEDBOOST in chem_effects))
		tally = max(0, tally-3)

	var/turf/T = get_turf(src)
	if(T)
		tally += T.movement_cost

	tally += config.human_delay

	tally = round(tally,1)

	return tally


/mob/living/carbon/human/Allow_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/tank/jetpack/thrust = GetJetpack(src)

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

	//If no working jetpack then use the other checks
	. = ..()


/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= 1

	return prob_slip

/mob/living/carbon/human/Check_Shoegrip(checkSpecies = TRUE)
	if(checkSpecies && (species.flags & NO_SLIP))
		return 1
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

/mob/living/carbon/human/set_dir(var/new_dir)
	. = ..()
	if(. && species.tail)
		update_tail_showing(1)

/mob/living/carbon/human/Move()
	. = ..()

	var/turf/T = loc
	var/footsound
	var/top_layer = 0
	for(var/obj/structure/S in T)
		if(S.layer > top_layer && S.footstep_sound)
			top_layer = S.layer
			footsound = S.footstep_sound
	if(!footsound)
		footsound = T.footstep_sound

	if (client)
		var/turf/B = GetAbove(T)
		up_hint.icon_state = "uphint[(B ? !!B.is_hole : 0)]"

	if (is_noisy && !stat && !lying)
		if ((x == last_x && y == last_y) || !footsound)
			return
		last_x = x
		last_y = y
		if (m_intent == "run")
			playsound(src, footsound, 70, 1, required_asfx_toggles = ASFX_FOOTSTEPS)
		else
			footstep++
			if (footstep % 2)
				playsound(src, footsound, 40, 1, required_asfx_toggles = ASFX_FOOTSTEPS)

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!. && mob_negates_gravity())
		. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return (shoes && shoes.negates_gravity())
