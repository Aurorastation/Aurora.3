/mob/living/carbon/human/movement_delay()

	var/tally = 0
	if(species.slowdown)
		tally = species.slowdown

	if(lying) //Crawling, it's slower
		tally += (8 + ((weakened * 3) + (confused * 2)))

	tally += get_pulling_movement_delay()

	if (istype(loc, /turf/space) || isopenturf(loc))
		if(!(locate(/obj/structure/lattice, loc) || locate(/obj/structure/stairs, loc) || locate(/obj/structure/ladder, loc)))
			return 0

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	var/health_deficiency = maxHealth - health
	if(health_deficiency >= 40)
		tally += (health_deficiency / 25)

	var/shock = get_shock()
	if(shock >= 10)
		tally += (shock / 30) //get_shock checks if we can feel pain

	tally += ClothesSlowdown()

	if(species)
		tally += species.get_species_tally(src)

	tally += species.handle_movement_tally(src)

	if(is_asystole())
		tally += 10  //heart attacks are kinda distracting

	if(aiming && aiming.aiming_at)
		tally += 5 // Iron sights make you slower, it's a well-known fact.

	if (is_drowsy())
		tally += 6

	if (!(species.flags & NO_COLD_SLOWDOWN))	// Bugs and machines don't move slower when cold.
		if((mutations & FAT))
			tally += 1.5
		if (bodytemperature < 283.222)
			tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow
	if((mutations & mRun))
		tally = 0

	tally = max(-2, tally + move_delay_mod)

	var/obj/item/AH = get_active_hand()
	if(istype(AH))
		tally += AH.slowdown

	var/obj/item/IH = get_inactive_hand()
	if(istype(IH))
		tally += IH.slowdown

	if(isitem(pulling))
		var/obj/item/P = pulling
		tally += P.slowdown

	if(tally > 0 && (CE_SPEEDBOOST in chem_effects))
		tally = max(-2, tally - 3)

	var/turf/T = get_turf(src)
	if(T) // changelings don't get movement costs
		var/datum/changeling/changeling
		if(mind)
			changeling = mind.antag_datums[MODE_CHANGELING]
		if(!changeling)
			tally += T.movement_cost
		if(species && istype(T, /turf/simulated/floor/exoplanet/water))
			if(species.can_breathe_water())
				tally -= T.movement_cost

	tally += GLOB.config.human_delay

	if(!isnull(facing_dir) && facing_dir != dir)
		tally += 3

	tally = round(tally, 0.1)

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
	if(shoes && (shoes.item_flags & ITEM_FLAG_NO_SLIP) && istype(shoes, /obj/item/clothing/shoes/magboots) && !lying && !buckled_to && !length(grabbed_by))  //magboots + dense_object = no floating. Doesn't work if lying. Grabbedby and buckled_to are for mob carrying, wheelchairs, roller beds, etc.
		return TRUE
	return FALSE

/mob/living/carbon/human/set_dir(var/new_dir, ignore_facing_dir = FALSE)
	. = ..()
	if(. && tail_style)
		update_tail_showing(1)
	if(lying)
		update_icon(forceDirUpdate = TRUE)

/mob/living/carbon/human/Move()
	. = ..()
	if(.) //We moved
		handle_leg_damage()

	var/turf/T = loc
	var/footsound
	var/top_layer = 0
	if(istype(T))
		for(var/obj/structure/S in T)
			if(S.layer > top_layer && S.footstep_sound)
				top_layer = S.layer
				footsound = S.footstep_sound
		if(!footsound)
			footsound = T.footstep_sound

	if (client)
		var/turf/B = GetAbove(T)
		if(up_hint)
			up_hint.icon_state = "uphint[(B ? !!B.is_hole : 0)]"

	if (!stat && !lying)
		if ((x == last_x && y == last_y) || !footsound)
			return
		last_x = x
		last_y = y
		if(shoes)
			var/obj/item/clothing/shoes/S = shoes
			if(S.do_special_footsteps(m_intent))
				return
		if (m_intent == M_RUN)
			playsound(src, (is_noisy ? footsound : species.footsound), 70, TRUE, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE, required_asfx_toggles = ASFX_FOOTSTEPS)
		else
			footstep++
			if (footstep % 2)
				playsound(src, (is_noisy ? footsound : species.footsound), 40, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, required_asfx_toggles = ASFX_FOOTSTEPS)

/mob/living/carbon/human/proc/handle_leg_damage()
	if(!can_feel_pain())
		return
	var/crutches = 0
	for (var/obj/item/cane/C as anything in get_type_in_hands(/obj/item/cane))
		if(istype(C) && (C?.can_support))
			crutches++
	for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = get_organ(organ_name)
		if(E && (ORGAN_IS_DISLOCATED(E)|| E.is_broken()))
			if(crutches)
				crutches--
			else
				E.add_pain(10)

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!. && mob_negates_gravity())
		. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return (shoes && shoes.negates_gravity())

/mob/living/carbon/human/proc/ClothesSlowdown()
	for(var/obj/item/I in list(wear_suit, w_uniform, back, gloves, head, wear_mask, shoes, l_ear, r_ear, glasses, belt))
		. += I.slowdown
		. += I.slowdown_accessory

/mob/living/carbon/human/get_pulling_movement_delay()
	. = ..()

	if(ishuman(pulling))
		var/mob/living/carbon/human/H = pulling
		if(H.species.slowdown > species.slowdown)
			. += H.species.slowdown - species.slowdown
		. += H.ClothesSlowdown()
