//This file contains variables and helper functions for mobs that can eat other mobs

//There are two ways to eat a mob:
	//Swallowing whole can only be done if the mob is sufficiently small
		//It will place the mob inside you, and slowly digest it,
			//Digesting deals brute+fire damage to the victim and adds protein to your stomach based on the damage dealt.
			//Mob will be deleted from your contents when fully digested.
				//Mob is fully digested when it has taken fire+brute damage equal to its max health plus 50% (calculated after death)

	//Devouring eats the mob piece by piece. Taking a bite periodically
		//Each bite deals genetic damage, and drains blood.
			//Adds protein to your stomach based on quantities.
		//Mob is fully digested when it has taken genetic damage equal to its max health.  This continues past death if necessary
		//Devouring is interrupted if you or the mob move away from each other, or if the eater gets disabled.

#define PPM 9	//Protein per meat, used for calculating the quantity of protein in an animal

/mob/living
	var/mob/living/devouring	// The mob we're currently eating, if any.

/mob/living/proc/attempt_devour(var/mob/living/victim, var/eat_types, var/mouth_size = null)

	//This function will attempt to eat the victim,
	//either by swallowing them if they're small enough, or starting to devour them otherwise
		//If a mouth_size is passed in, it will be used instead of this mob's size, for determining whether the victim is small enough to swallow
	//This function is the main gateway to devouring, and will have all the safety checks
	if (!victim)
		return 0

	face_atom(victim)

	if (victim == src)
		to_chat(src, "<span class='warning'>You can't eat yourself!</span>")
		return 0

	if (devouring == victim)
		to_chat(src, span("notice","You stop eating [victim]."))
		devouring = null
		return

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(src, "<span class='warning'>\The [blocked] is in the way!</span>")
			return

	//This check is exploit prevention.
	//Nymphs have seperate mechanics for gaining biomass from other diona
	//This check prevents the exploit of almost-devouring a nymph, and then absorbing it to gain double biomass
	if (victim.is_diona() && src.is_diona())
		to_chat(src, "<span class='warning'>You can't eat other diona!</span>")
		return 0

	if (!src.Adjacent(victim))
		to_chat(src, "<span class='warning'>That creature is too far away, move closer!</span>")
		return 0

	if (!is_valid_for_devour(victim, eat_types))
		to_chat(src, "<span class='warning'>You can't eat that type of creature!</span>")
		return 0

	if (!victim.mob_size || !src.mob_size)
		to_chat(src, "<span class='danger'>Error, no mob size defined for [victim.type]! You have encountered a bug, report it on github </span>")
		return 0

	if (!mouth_size)
		mouth_size = src.mob_size

	if (victim.mob_size <= mouth_size)
		swallow(victim, mouth_size)
	else
		devour_gradual(victim,mouth_size)

/mob/living/proc/swallow(var/mob/living/victim, var/mouth_size)
	set waitfor = FALSE
	//This function will move the victim inside the eater's contents.. There they will be digested over time

	var/swallow_time = max(3 + (victim.mob_size * victim.mob_size) - mouth_size, 3)
	src.visible_message("[src] starts swallowing \the [victim]!","You start swallowing \the [victim], this will take approximately [swallow_time] seconds.")
	var/turf/ourloc = src.loc
	var/turf/victimloc = victim.loc
	devouring = victim
	if (do_mob(src, victim, swallow_time*10, extra_checks = CALLBACK(src, .proc/devouring_equals, victim)))
		victim.forceMove(src)
		LAZYADD(stomach_contents, victim)
	else if (victimloc != victim.loc)
		to_chat(src, "[victim] moved away, you need to keep it still. Try grabbing, stunning or killing it first.")
	else if (ourloc != src.loc)
		to_chat(src, "You moved! Can't eat if you move away from the victim")
	else if (devouring)
		to_chat(src, "Swallowing failed!")//reason unknown, maybe the eater got stunned?)

	devouring = null

/mob/living/proc/devour_gradual(var/mob/living/victim, var/mouth_size)
	set waitfor = FALSE
	//This function will start consuming the victim by taking bites out of them.
	//Victim or attacker moving will interrupt it
	//A bite will be taken every 4 seconds
	devouring = victim
	var/bite_delay = 4
	var/bite_size = mouth_size * 0.5
	var/num_bites_needed = (victim.mob_size*victim.mob_size)/bite_size//total bites needed to eat it from full health
	var/PEPB = 1/num_bites_needed//Percentage eaten per bite
	var/turf/ourloc = src.loc
	var/turf/victimloc = victim.loc
	var/messes = 0//number of bloodstains we've placed
	var/datum/reagents/vessel = victim.get_vessel(1)
	if(!victim.composition_reagent_quantity)
		victim.calculate_composition()

	var/victim_maxhealth = victim.maxHealth//We cache this here incase we need to edit it, for example, for humans and anything else that doesn't die until negative health

	//Now, incase we're resuming an earlier feeding session on the same creature
	//We calculate the actual bites needed to fully eat it based on how eaten it already is
	if (victim.cloneloss)
		var/percentageDamaged = victim.cloneloss / victim_maxhealth
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


	src.visible_message("<span class='danger'>[src] starts devouring [victim]</span>","<span class='danger'>You start devouring [victim], this will take approximately [time_needed_string]. You and the victim must remain still to continue, but you can interrupt feeding anytime and leave with what you've already eaten.</span>")

	for (var/i = 0 to num_bites_needed)
		if(do_mob(src, victim, bite_delay*10, extra_checks = CALLBACK(src, .proc/devouring_equals, victim)))
			face_atom(victim)
			victim.apply_damage(victim_maxhealth*PEPB,HALLOSS)
			victim.apply_damage(victim_maxhealth*PEPB*5,CLONE)
			ingested.add_reagent(victim.composition_reagent, victim.composition_reagent_quantity*PEPB)
			visible_message("<span class='danger'>[src] bites a chunk out of [victim]</span>","<span class='danger'>[bitemessage(victim)]</span>")
			if (messes < victim.mob_size - 1 && prob(50))
				handle_devour_mess(src, victim, vessel)
			if (victim.cloneloss >= victim_maxhealth)
				visible_message("[src] finishes devouring [victim].","You finish devouring [victim].")
				handle_devour_mess(src, victim, vessel, 1)
				qdel(victim)
				devouring = null
				break
		else
			devouring = null
			if (victim && victimloc != victim.loc)
				to_chat(src, "<span class='danger'>[victim] moved away, you need to keep it still. Try grabbing, stunning or killing it first.</span>")
			else if (ourloc != src.loc)
				to_chat(src, "<span class='danger'>You moved! Devouring cancelled.</span>")
			else
				to_chat(src, "Devouring Cancelled.")//reason unknown, maybe the eater got stunned?)
				//This can also happen if you start devouring something else
			break

/mob/living/proc/devouring_equals(target)
	return target && devouring == target

//this function gradually digests things inside the mob's contents.
//It is called from life.dm. Any creatures that don't want to digest their contents simply don't call it
/mob/living/proc/handle_stomach()
	if (stomach_contents)
		for(var/thing in stomach_contents)
			var/mob/living/M = thing
			if(M.loc != src)//if something somehow escaped the stomach, then we remove it
				LAZYREMOVE(stomach_contents, M)
				continue

			if(!M.composition_reagent_quantity)
				M.calculate_composition()

			var/dmg_factor = 2*log(M.mob_size)	// log(n) is natural log in BYOND.
			if (dmg_factor <= 0)
				dmg_factor = 0.5

			M.adjustBruteLoss(round(dmg_factor * 0.33, 0.1) || 0.1)
			M.adjustFireLoss(round(dmg_factor * 0.66, 0.1) || 0.1)

			ingested.add_reagent(M.composition_reagent, M.composition_reagent_quantity * dmg_factor)

			if (M.stat == DEAD && !stomach_contents[M])	// If the mob has died, poke the consuming mob about it.
				to_chat(src, "Your stomach feels a little more relaxed as \the [M] finally stops fighting.")
				stomach_contents[M] = TRUE	// So the message doesn't play more than once.
				continue

			var/damage_dealt = (M.getFireLoss() * 0.66) + (M.getBruteLoss() * 0.33)
			if (stomach_contents[M] && (damage_dealt >= M.maxHealth * 1.5))	//If we've consumed all of it (plus a bit), then digestion is finished.
				LAZYREMOVE(stomach_contents, M)
				to_chat(src, "Your stomach feels a little more empty as you finish digesting \the [M].")
				qdel(M)

//Helpers
/proc/bitemessage(var/mob/living/victim)
	return pick(
		"You take a bite out of \the [victim].",
		"You rip a chunk off of \the [victim].",
		"You consume a piece of \the [victim].",
		"You feast upon your prey.",
		"You chow down on \the [victim].",
		"You gobble \the [victim]'s flesh.")

/proc/handle_devour_mess(var/mob/user, var/mob/living/victim, var/datum/reagents/vessel, var/finish = 0)
	//The maximum number of blood placements is equal to the mob size of the victim
	//We will use one blood placement on each of the following, in this order
		//Bloodying the victim's tile
		//Bloodying the attacker, if possible
		//Bloodying the attacker's tile
	//After that, we will allocate the remaining blood placements to random tiles around the victim and attacker, until either all are used or victim is dead
	var/datum/reagent/blood/B = vessel.get_master_reagent()

	if (!turf_hasblood(get_turf(victim)))
		devour_add_blood(victim, get_turf(victim), vessel)
		return 1

	else if (istype(user, /mob/living/carbon/human) && !user.blood_DNA)
		//if this blood isn't already in the list, add it
		user.blood_DNA = list(B.data["blood_DNA"])
		user.blood_color = B.data["blood_color"]
		user.update_inv_gloves()	//handles bloody hands overlays and updating
		user.verbs += /mob/living/carbon/human/proc/bloody_doodle
		return 1

	else if (!turf_hasblood(get_turf(user)))
		devour_add_blood(victim, get_turf(user), vessel)
		return 1

	if (finish)
		//A bigger victim makes more gibs
		if (victim.mob_size >= 3)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		if (victim.mob_size >= 5)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		if (victim.mob_size >= 7)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		if (victim.mob_size >= 9)
			new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
		return 1
	return 0

/proc/devour_add_blood(var/mob/living/M, var/turf/location, var/datum/reagents/vessel)
	for(var/datum/reagent/blood/source in vessel.reagent_list)
		var/obj/effect/decal/cleanable/blood/B = new /obj/effect/decal/cleanable/blood(location)

		// Update appearance.
		if(source.data["blood_colour"])
			B.basecolor = source.data["blood_colour"]
			B.update_icon()

		// Update blood information.
		if(source.data["blood_DNA"])
			B.blood_DNA = list()
			if(source.data["blood_type"])
				B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				B.blood_DNA[source.data["blood_DNA"]] = "O+"

		// Update virus information.
		if(source.data["virus2"])
			B.virus2 = virus_copylist(source.data["virus2"])

		B.fluorescent  = 0
		B.invisibility = 0

/proc/turf_hasblood(var/turf/test)
	for (var/obj/effect/decal/cleanable/blood/b in test)
		return 1
	return 0

/proc/is_valid_for_devour(var/mob/living/test, var/eat_types)
	//eat_types must contain all types that the mob has. For example we need both humanoid and synthetic to eat an IPC.
	var/test_types = test.find_type()
	. = (eat_types & test_types) == test_types

/mob/living/proc/calculate_composition()
	if (!composition_reagent)//if no reagent has been set, then we'll set one
		var/type = find_type(src)
		if (type & TYPE_SYNTHETIC)
			src.composition_reagent = "iron"
		else
			src.composition_reagent = "protein"

	//if the mob is a simple animal with a defined meat quantity
	if (istype(src, /mob/living/simple_animal))
		var/mob/living/simple_animal/SA = src
		if (SA.meat_amount)
			src.composition_reagent_quantity = SA.meat_amount*2*PPM

		//The quantity of protein is based on the meat_amount, but multiplied by 2

	var/size_reagent = (src.mob_size * src.mob_size) * 3//The quantity of protein is set to 3x mob size squared
	if (size_reagent > src.composition_reagent_quantity)//We take the larger of the two
		src.composition_reagent_quantity = size_reagent

#undef PPM
