//Methods that need to be cleaned.
/* INFORMATION
Put (mob/proc)s here that are in dire need of a code cleanup.
*/

/mob/proc/has_disease(var/datum/disease/virus)
	for(var/datum/disease/D in viruses)
		if(D.IsSame(virus))
			//error("[D.name]/[D.type] is the same as [virus.name]/[virus.type]")
			return 1
	return 0

// This proc has some procs that should be extracted from it. I believe we can develop some helper procs from it - Rockdtben
/mob/proc/contract_disease(var/datum/disease/virus, var/skip_this = 0, var/force_species_check=1, var/spread_type = -5)
	if(stat >=2)
		return
	if(istype(virus, /datum/disease/advance))
		var/datum/disease/advance/A = virus
		if(A.GetDiseaseID() in resistances)
			return
		if(count_by_type(viruses, /datum/disease/advance) >= 3)
			return

	else
		if(src.resistances.Find(virus.type))
			return


	if(has_disease(virus))
		return


	if(force_species_check)
		var/fail = 1
		for(var/name in virus.affected_species)
			if(istype(src, /mob/living/carbon))
				var/mob/living/carbon/C = src
				if(C.species.name == name)
					fail = 0
					break
		if(fail) return

	if(skip_this == 1)
		var/datum/disease/v = new virus.type(1, virus, 0)
		src.viruses += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(v.can_carry && prob(5))
			v.carrier = 1
		return

	if(prob(15/virus.permeability_mod)) return //the power of immunity compels this disease! but then you forgot resistances
	var/obj/item/clothing/Cl = null
	var/passed = 1

	//chances to target this zone
	var/head_ch
	var/body_ch
	var/hands_ch
	var/feet_ch

	if(spread_type == -5)
		spread_type = virus.spread_type

	switch(spread_type)
		if(CONTACT_HANDS)
			head_ch = 0
			body_ch = 0
			hands_ch = 100
			feet_ch = 0
		if(CONTACT_FEET)
			head_ch = 0
			body_ch = 0
			hands_ch = 0
			feet_ch = 100
		else
			head_ch = 100
			body_ch = 100
			hands_ch = 25
			feet_ch = 25


	var/target_zone = pick(head_ch;1,body_ch;2,hands_ch;3,feet_ch;4)//1 - head, 2 - body, 3 - hands, 4- feet

	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src

		switch(target_zone)
			if(1)
				if(isobj(H.head) && !istype(H.head, /obj/item/paper))
					Cl = H.head
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(H.wear_mask))
					Cl = H.wear_mask
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(2)//arms and legs included
				if(isobj(H.wear_suit))
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)
				if(passed && isobj(slot_w_uniform))
					Cl = slot_w_uniform
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(3)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&HANDS)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.gloves))
					Cl = H.gloves
					passed = prob((Cl.permeability_coefficient*100) - 1)
			if(4)
				if(isobj(H.wear_suit) && H.wear_suit.body_parts_covered&FEET)
					Cl = H.wear_suit
					passed = prob((Cl.permeability_coefficient*100) - 1)

				if(passed && isobj(H.shoes))
					Cl = H.shoes
					passed = prob((Cl.permeability_coefficient*100) - 1)
			else
				to_chat(src, "Something strange's going on, something's wrong.")

	if(!passed && spread_type == AIRBORNE && !internals)
		passed = (prob((50*virus.permeability_mod) - 1))

	if(passed)
		var/datum/disease/v = new virus.type(1, virus, 0)
		src.viruses += v
		v.affected_mob = src
		v.strain_data = v.strain_data.Copy()
		v.holder = src
		if(v.can_carry && prob(5))
			v.carrier = 1
