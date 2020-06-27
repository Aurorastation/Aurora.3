/mob/proc/changeling_absorb_dna()
	set category = "Changeling"
	set name = "Absorb DNA"

	var/datum/changeling/changeling = changeling_power(0, 0, 100)
	if(!changeling)
		return

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, SPAN_WARNING("We must be grabbing a creature in our active hand to absorb them."))
		return
	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		to_chat(src, SPAN_WARNING("[T] is not compatible with our biology."))
		return
	if(T.species.flags & NO_SCAN)
		to_chat(src, SPAN_WARNING("We do not know how to parse this creature's DNA!"))
		return
	if(islesserform(T))
		to_chat(src, SPAN_WARNING("This creature DNA is not compatible with our form!"))
		return
	if(HUSK in T.mutations)
		to_chat(src, SPAN_WARNING("This creature's DNA is ruined beyond useability!"))
		return
	if(G.state != GRAB_KILL)
		to_chat(src, SPAN_WARNING("We must have a tighter grip to absorb this creature. It must struggle for breath under our grip to ensure a successful feast."))
		return
	for(var/datum/absorbed_dna/D in changeling.absorbed_dna)
		if(D.dna == T.dna)
			to_chat(src, SPAN_WARNING("We have already collected this creature's DNA!"))
			return
	if(changeling.isabsorbing)
		to_chat(src, SPAN_WARNING("We are already absorbing!"))
		return

	changeling.isabsorbing = TRUE
	for(var/stage = 1, stage <= 3, stage++)
		switch(stage)
			if(1)
				visible_message(SPAN_WARNING("[src]'s skin begins to shift and squirm!"),
						SPAN_NOTICE("This creature is compatible. We must hold still..."))
			if(2)
				visible_message(SPAN_WARNING("[src] extends a proboscis!"),
						SPAN_NOTICE("We extend our proboscis. Soon..."))
				playsound(get_turf(src), 'sound/effects/lingextends.ogg', 50, 1)
			if(3)
				visible_message(SPAN_DANGER("[src] stabs [T] with the proboscis!"),
						SPAN_NOTICE("We stab [T] with the proboscis. The feast begins."))
				to_chat(T, SPAN_DANGER("You feel a sharp stabbing pain!"))
				playsound(get_turf(src), 'sound/effects/lingstabs.ogg', 50, 1)
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(40, 0, damage_flags = DAM_SHARP|DAM_EDGE, used_weapon = "massive puncture wound"))
					T.UpdateDamageIcon()

		feedback_add_details("changeling_powers","A[stage]")
		if(!do_mob(src, T, 150))
			to_chat(src, SPAN_WARNING("Our absorption of [T] has been interrupted!"))
			changeling.isabsorbing = FALSE
			return

	visible_message(SPAN_DANGER("[src] sucks the fluids from [T]!"),
				SPAN_NOTICE("We have absorbed [T]! What an exquisite feast..."))
	playsound(get_turf(src), 'sound/effects/lingabsorbs.ogg', 50, 1)

	//Succ points and chems. You get less if it's not a player. Using is_client_active to prevent rageghosting screwing you.
	if(T.is_client_active(10))
		changeling.chem_charges += 50	
		changeling.geneticpoints += 3
		changeling.total_absorbed_genpoints += 3
	else
		if(changeling.inactives_absorbed >= 3)
			to_chat(src, SPAN_WARNING("We can evolve no further with these stale genes. We require fresh samples."))
			changeling.chem_charges += 10
		else
			to_chat(src, SPAN_NOTICE("These genes are stale from inactivity... Disgusting."))
			changeling.chem_charges += 25	
			changeling.geneticpoints += 1
			changeling.total_absorbed_genpoints += 1
		changeling.inactives_absorbed++

	update_ling_power()

	//Steal all of their languages!
	for(var/language in T.languages)
		if(!(language in changeling.absorbed_languages))
			changeling.absorbed_languages += language
	changeling_update_languages()

	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.get_cloning_variant(), T.languages)
	absorbDNA(newDNA)

	if(T.mind?.changeling)
		if(T.mind.changeling.absorbed_dna)
			for(var/datum/absorbed_dna/dna_data in T.mind.changeling.absorbed_dna)	//steal all their loot
				if(changeling.GetDNA(dna_data.name))
					continue
				absorbDNA(dna_data)
				changeling.absorbedcount++
			T.mind.changeling.absorbed_dna.len = TRUE

		if(T.mind.changeling.purchasedpowers)
			for(var/datum/power/changeling/P in T.mind.changeling.purchasedpowers) 
				if(P in changeling.purchasedpowers)
					continue
				else
					changeling.purchasedpowers += P
					if(!P.isVerb)
						call(P.verbpath)()
					else
						src.make_changeling()

		changeling.chem_charges += T.mind.changeling.chem_charges
		changeling.geneticpoints += T.mind.changeling.geneticpoints
		T.mind.changeling.chem_charges = 0
		T.mind.changeling.geneticpoints = 0
		T.mind.changeling.total_absorbed_genpoints = 0
		T.mind.changeling.absorbedcount = 0
		T.update_ling_power()

	changeling.absorbedcount++
	changeling.isabsorbing = FALSE

	admin_attack_log(usr, T, "absorbed the DNA of", "had their DNA absorbed by", "lethally absorbed DNA from")
	
	if(T.is_client_active(1)) //Only add players who are here to hivemind.
		var/mob/abstract/hivemind/hivemind = new /mob/abstract/hivemind(src)
		hivemind.icon = T.icon
		hivemind.icon_state = T.icon_state
		hivemind.add_to_hivemind(T, src)
	T.death(0)
	T.Drain()
	return TRUE