GLOBAL_LIST_INIT(possible_changeling_IDs, list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega"))

/datum/changeling //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
	var/list/datum/absorbed_dna/absorbed_dna = list()
	var/list/absorbed_languages = list()
	var/list/hivemind_members = list()
	var/datum/changeling_sting/prepared_sting
	var/absorbedcount = 0
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/sting_range = 1
	var/using_thermals = FALSE
	var/changelingID = "Changeling"
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/geneticpoints = 10
	var/list/purchasedpowers = list()
	var/mimicing = ""
	var/mimiced_accent = "Biesellite"
	var/justate
	var/can_respec = FALSE
	/// if they've entered stasis before, then we don't want to give them stasis again
	var/has_entered_stasis = FALSE

/datum/changeling/New(var/gender=FEMALE)
	..()
	var/honorific = (gender == FEMALE) ? "Ms." : "Mr."
	if(GLOB.possible_changeling_IDs.len)
		changelingID = pick(GLOB.possible_changeling_IDs)
		GLOB.possible_changeling_IDs -= changelingID
		changelingID = "[honorific] [changelingID]"
	else
		changelingID = "[honorific] [rand(1,999)]"

/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges + chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage - 1)

/datum/changeling/proc/GetDNA(var/dna_owner)
	for(var/datum/absorbed_dna/DNA in absorbed_dna)
		if(dna_owner == DNA.name)
			return DNA

/datum/changeling/proc/use_charges(var/charges_used)
	chem_charges = max(0, chem_charges - charges_used)

/mob/proc/absorbDNA(var/datum/absorbed_dna/newDNA)
	var/datum/changeling/changeling = null
	if(mind)
		changeling = mind.antag_datums[MODE_CHANGELING]
	if(!changeling)
		return

	for(var/language in newDNA.languages)
		changeling.absorbed_languages |= language

	changeling_update_languages(changeling.absorbed_languages)

	if(!changeling.GetDNA(newDNA.name)) // Don't duplicate - I wonder if it's possible for it to still be a different DNA? DNA code could use a rewrite
		changeling.absorbed_dna += newDNA

//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling(var/datum/mind/changeling_mind)
	if(!changeling_mind)
		changeling_mind = mind
	if(!changeling_mind)
		return
	if(!changeling_mind.antag_datums[MODE_CHANGELING])
		changeling_mind.antag_datums[MODE_CHANGELING] = new /datum/changeling(gender)

	add_verb(src, /datum/changeling/proc/EvolutionMenu)
	add_language(LANGUAGE_CHANGELING)

	var/lesser_form = !ishuman(src)

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	var/datum/changeling/changeling = changeling_mind.antag_datums[MODE_CHANGELING]

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in powerinstances)
		if(!P.genomecost) // Is it free?
			if(!(P in changeling.purchasedpowers)) // Do we not have it already?
				changeling.purchasePower(changeling_mind, P.name, 0) // Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in changeling.purchasedpowers)
		if(P.isVerb)
			if(lesser_form && !P.allowduringlesserform)	continue
			if(!(P in src.verbs))
				add_verb(src, P.verbpath)

	for(var/language in languages)
		changeling.absorbed_languages |= language

	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/datum/hair_gradient/newGradient = new(H.g_style, H.r_grad, H.g_grad, H.b_grad)
		var/datum/absorbed_dna/newDNA = new(H.real_name, H.dna, H.species.get_cloning_variant(), H.languages, H.height, H.gender, H.pronouns, H.accent, newGradient)
		absorbDNA(newDNA)
		changeling.mimiced_accent = H.accent

	if(changeling.has_entered_stasis)
		remove_verb(src, /mob/proc/changeling_fakedeath)

	return TRUE

/**
 * Resets a changeling to the point where they were when they first became a changeling.
 */
/mob/proc/changeling_respec()
	var/datum/changeling/changeling = null
	if(mind)
		changeling = mind.antag_datums[MODE_CHANGELING]
	if(!changeling)
		return
	remove_changeling_powers(TRUE)
	changeling.prepared_sting = null
	changeling.absorbedcount = initial(changeling.absorbedcount)
	changeling.chem_charges = initial(changeling.chem_charges)
	changeling.sting_range = initial(changeling.sting_range)
	changeling.chem_recharge_rate = initial(changeling.chem_recharge_rate)
	changeling.chem_storage = initial(changeling.chem_storage)
	changeling.chem_charges = min(changeling.chem_charges, changeling.chem_storage)
	changeling.geneticpoints = initial(changeling.geneticpoints)
	changeling.mimicing = null
	changeling.mimiced_accent = initial(changeling.mimiced_accent)

/**
 * Removes a changeling's abilities
 */
/mob/proc/remove_changeling_powers(reset_powers = FALSE)
	var/datum/changeling/changeling
	if(mind)
		changeling = mind.antag_datums[MODE_CHANGELING]
	if(!changeling)
		return
	for(var/datum/power/changeling/P in changeling.purchasedpowers)
		if(P.isVerb && !reset_powers)
			remove_verb(src, P.verbpath)
		else if(reset_powers && (P.genomecost != 0))
			if(P.isVerb)
				remove_verb(src, P.verbpath)
			changeling.purchasedpowers -= P
			qdel(P)
	if(!reset_powers)
		remove_language(LANGUAGE_CHANGELING)


//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(var/required_chems=0, var/required_dna=0, var/max_genetic_damage=100, var/max_stat=0)

	if(!src.mind)
		return
	if(!iscarbon(src))
		return

	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	if(!changeling)
		return
	if(src.stat > max_stat)
		to_chat(src, SPAN_WARNING("We are incapacitated."))
		return
	if(changeling.absorbed_dna.len < required_dna)
		to_chat(src, SPAN_WARNING("We require at least [required_dna] samples of compatible DNA."))
		return
	if(changeling.chem_charges < required_chems)
		to_chat(src, SPAN_WARNING("We require at least [required_chems] units of chemicals to do that!"))
		return
	if(changeling.geneticdamage > max_genetic_damage)
		to_chat(src, SPAN_WARNING("Our genomes are still reassembling. We need time to recover first."))
		return
	return changeling

//Used to dump the languages from the changeling datum into the actual mob.
/mob/proc/changeling_update_languages(var/updated_languages)
	languages = list()
	for(var/language in updated_languages)
		languages += language
	//This isn't strictly necessary but just to be safe...
	add_language(LANGUAGE_CHANGELING)
	return

/mob/proc/changeling_try_respec()
	set category = "Changeling"
	set name = "Re-evolve"

	var/datum/changeling/changeling
	if(mind)
		changeling = mind.antag_datums[MODE_CHANGELING]
	if(!changeling)
		return FALSE
	if(changeling.can_respec)
		to_chat(src, SPAN_NOTICE("We have removed our evolutions in this form, and are now ready to re-adapt."))
		changeling_respec()
		changeling.can_respec = FALSE
		return TRUE
	else
		to_chat(src, SPAN_WARNING("You lack the power to re-adapt your evolutions!"))
		return FALSE

//DNA related datums

/datum/hair_gradient
	var/style
	var/red
	var/green
	var/blue

/datum/hair_gradient/New(var/newStyle, var/newRed, var/newGreen, var/newBlue)
	style = newStyle
	red = newRed
	green = newGreen
	blue = newBlue

/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages
	var/height
	var/gender
	var/pronouns
	var/accent
	var/datum/hair_gradient/hairGradient

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages, var/newHeight, var/newGender, var/newPronouns, var/newAccent, var/newGradient)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
	height = newHeight
	gender = newGender
	pronouns = newPronouns
	accent = newAccent
	hairGradient = newGradient
//Helper for stingcode

/mob/proc/sting_can_reach(mob/M, sting_range = 1)
	if(M.loc == src.loc)
		return TRUE //target and source are in the same thing
	var/target_distance = get_dist(src, M)
	if(target_distance < sting_range)
		to_chat(src, SPAN_WARNING("\The [M] is too far for our sting!"))
		return FALSE //Too far, don't bother pathfinding
	if(!isturf(src.loc) || !isturf(M.loc))
		to_chat(src, SPAN_WARNING("We cannot reach \the [M] with a sting!"))
		return FALSE //One is inside, the other is outside something.
	// Maximum queued turfs set to 25; I don't *think* anything raises sting_range above 2, but if it does the 25 may need raising
	if(!AStar(get_turf(src), get_turf(M), /turf/proc/AdjacentTurfsRanged, /turf/proc/Distance, max_nodes = 25, max_node_depth = sting_range)) //If we can't find a path, fail
		to_chat(src, SPAN_WARNING("We cannot find a path to sting \the [M] by!"))
		return FALSE
	return TRUE
