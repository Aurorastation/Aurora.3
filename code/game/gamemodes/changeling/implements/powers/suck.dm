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
	if(!src.get_pressure_weakness())
		to_chat(src, SPAN_WARNING("We cannot absorb this creature from inside a sealed environment."))
		return
	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		to_chat(src, SPAN_WARNING("[T] is not compatible with our biology."))
		return
	if(T.species.flags & NO_SCAN)
		to_chat(src, SPAN_WARNING("We do not know how to parse this creature's DNA!"))
		return
	if(islesserform(T))
		to_chat(src, SPAN_WARNING("This creature's DNA is not compatible with our form!"))
		return
	if((T.mutations & HUSK))
		to_chat(src, SPAN_WARNING("This creature's DNA is ruined beyond useability!"))
		return
	if(G.state != GRAB_KILL)
		to_chat(src, SPAN_WARNING("We must have a tighter grip to absorb this creature."))
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
				to_chat(src, SPAN_NOTICE("This creature is compatible. We must hold still.."))
				src.visible_message(SPAN_WARNING("[src]'s skin begins to shift and squirm!"))
			if(2)
				to_chat(src, SPAN_NOTICE("We extend a proboscis."))
				src.visible_message(SPAN_WARNING("[src] extends a proboscis!"))
				playsound(get_turf(src), 'sound/effects/lingextends.ogg', 50, 1)
			if(3)
				to_chat(src, SPAN_NOTICE("We stab [T] with the proboscis."))
				src.visible_message(SPAN_DANGER("[src] stabs [T] with the proboscis!"))
				to_chat(T, SPAN_DANGER("You feel a sharp stabbing pain!"))
				playsound(get_turf(src), 'sound/effects/lingstabs.ogg', 50, 1)
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(40, 0, damage_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE, used_weapon = "massive puncture wound"))
					T.UpdateDamageIcon()

		feedback_add_details("changeling_powers","A[stage]")
		if(!do_mob(src, T, 150))
			to_chat(src, SPAN_WARNING("Our absorption of [T] has been interrupted!"))
			changeling.isabsorbing = FALSE
			return

	to_chat(src, SPAN_NOTICE("We have absorbed [T]!"))
	src.visible_message(SPAN_DANGER("[src] sucks the fluids from [T]!"))
	to_chat(T, SPAN_DANGER("You have been absorbed by the changeling!"))
	playsound(get_turf(src), 'sound/effects/lingabsorbs.ogg', 50, 1)

	changeling.chem_charges += 50
	changeling.can_respec = TRUE

	//Steal all of their languages!
	for(var/language in T.languages)
		if(!(language in changeling.absorbed_languages))
			changeling.absorbed_languages += language

	changeling_update_languages(changeling.absorbed_languages)

	var/datum/hair_gradient/newGradient = new(T.g_style, T.r_grad, T.g_grad, T.b_grad)
	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.get_cloning_variant(), T.languages, T.height, T.gender, T.pronouns, T.accent, newGradient)
	absorbDNA(newDNA)

	var/datum/changeling/changeling_check = T.get_antag_datum(MODE_CHANGELING)
	if(changeling_check)
		if(changeling_check.absorbed_dna)
			for(var/datum/absorbed_dna/dna_data in changeling_check.absorbed_dna)	//steal all their loot
				if(changeling.GetDNA(dna_data.name))
					continue
				absorbDNA(dna_data)
				changeling.absorbedcount++
			changeling_check.absorbed_dna.len = TRUE

		if(changeling_check.purchasedpowers)
			for(var/datum/power/changeling/Tp in changeling_check.purchasedpowers) //who the fuck named these variables?
				if(Tp in changeling.purchasedpowers)
					continue
				else
					changeling.purchasedpowers += Tp
					if(!Tp.isVerb)
						call(Tp.verbpath)()
					else
						src.make_changeling()

		changeling.chem_charges += changeling_check.chem_charges
		changeling.geneticpoints += changeling_check.geneticpoints
		changeling_check.chem_charges = 0
		changeling_check.geneticpoints = 0
		changeling_check.absorbedcount = 0

	changeling.absorbedcount++
	changeling.isabsorbing = FALSE

	admin_attack_log(usr, T, "absorbed the DNA of", "had their DNA absorbed by", "lethally absorbed DNA from")

	var/mob/abstract/hivemind/hivemind = new /mob/abstract/hivemind(src)
	hivemind.add_to_hivemind(T, src)

	T.death(0)
	T.Drain()
	return TRUE
