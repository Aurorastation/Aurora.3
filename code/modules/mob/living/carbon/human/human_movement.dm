/mob/living/carbon/human/movement_delay()

	var/tally = 0
	var/messagechance = 5 // Base chance for a message to appear when you move. Decreases by half every time a message appears to prevent 10 messages from showing up at once.

	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if (isopenturf(loc) && !has_gravity(src, loc)) //open space checks
		if(!(locate(/obj/structure/lattice, loc) || locate(/obj/structure/stairs, loc) || locate(/obj/structure/ladder, loc)))
			return -1

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 40)
		tally += (health_deficiency / 25)
		if(prob(messagechance + health_deficiency*0.1))
			messagechance = messagechance*0.5
			src << "<span class='warning'>You limp as your low vitality makes movement difficult...</span>"

	if (!(species && (species.flags & NO_PAIN)))
		if(halloss >= 10)
			tally += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it
			if(prob(messagechance + halloss))
				messagechance = messagechance*0.5
				src << "<span class='warning'>The pain hinders your movement...</span>"

	// Hunger edits used to be here.

	if(wear_suit)
		tally += wear_suit.slowdown
		if(prob(messagechance*0.1*wear_suit.slowdown)) //This is more obvious and should happen less, with modifiers to the suit movement.
			messagechance = messagechance*0.5
			src << "<span class='average'>Your [wear_suit.name] restricts your movement.</span>"

	// People in wheelchairs don't need reminders.
	// Possible TODO: Implement some sort of memory system where users are reminded of their missing limb if the limb was removed during the round.
	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list("l_hand","r_hand","l_arm","r_arm"))
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
			if(prob(messagechance*0.1*shoes.slowdown)) //This is more obvious and should happen less, with modifiers to the shoe movement.
				messagechance = messagechance*0.5
				src << "<span class='average'>Your [shoes.name] makes walking tedious.</span>"
		//See wheelchair message. People like roleplaying as characters with missing legs and I don't think that they require constant reminders.
		for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg"))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10)
		tally += 3
		if(prob(messagechance*5)) //Higher chance because it's important
			messagechance = messagechance*0.5
			src << "<span class='warning'>Your leg muscle spasms from your recent shock!</span>"

	//No message required. See message below.
	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if (drowsyness)
		tally += 6
		if(prob(messagechance))
			messagechance = messagechance*0.5
			src << "<span class='average'>Your fatigue slows you down.</span>"

	if(FAT in src.mutations)
		tally += 1.5
		if(prob(messagechance*0.5)) // Being fat is more obvious so less the chance.
			messagechance = messagechance*0.5
			src << "<span class='average'>Your fat thighs chaff together, restricting your movement.</span>"

	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75
		if(prob(messagechance*0.5)) // Being hot is more obvious so less the chance.
			messagechance = messagechance*0.5
			src << "<span class='average'>You break out into a sweat and slow yourself down.</span>"

	// Players don't need to be reminded of missing feat.
	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	//  Players don't need to be reminded of mutations as it is probably handled elsewhere.
	if(mRun in mutations)
		tally = 0

	tally += move_delay_mod

	//  Players don't need to be reminded of chem effects as messages are handled elsewhere.
	if(tally > 0 && (CE_SPEEDBOOST in chem_effects))
		tally = max(0, tally-3)

	// Messaging should be handled elsewhere as tiles have different reasons as to why you're being slowed down.
	var/turf/T = get_turf(src)
	if(T)
		tally += T.movement_cost

	// Putting the hunger system here so being starving is MUCH more noticable as it now considers movement speed penalties
	//Simpler hunger slowdown calculations, this should be a little faster due to no division, and more scaleable
	if (nutrition < (max_nutrition * 0.4))
		tally++
		if(prob(messagechance))
			messagechance = messagechance*0.5
			src << "<span class='warning'>Your lack of nutrition makes movement difficult...</span>"
	else if (nutrition < (max_nutrition * 0.1))
		tally+= tally*2 //Yell at me if there is a *= function or something
		if(prob(messagechance*4)) // Multiplying this by two because im a biased piece of shit who hates seeing malnourished kids who don't eat.
			messagechance = messagechance*0.5
			src << "<span class='bad'>Walking becomes next to impossible as malnourshment weakens your muscles...</span>"

	return (tally+config.human_delay)


/mob/living/carbon/human/Allow_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

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

/mob/living/carbon/human/Move()
	. = ..()
	if (is_noisy && !stat && !lying)
		var/turf/T = loc
		if ((x == last_x && y == last_y) || !T.footstep_sound)
			return
		last_x = x
		last_y = y
		if (m_intent == "run")
			playsound(src, T.footstep_sound, 70, 1)
		else
			footstep++
			if (footstep % 2)
				playsound(src, T.footstep_sound, 40, 1)

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!. && mob_negates_gravity())
		. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return (shoes && shoes.negates_gravity())
