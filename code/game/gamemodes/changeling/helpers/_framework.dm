// Ling power, based on total genomes absorbed. Affects various status and life handling.
#define LING_LEVEL_LOW 1
#define LING_LEVEL_MED 2
#define LING_LEVEL_HIGH 3

var/global/list/possible_changeling_IDs = list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")

/datum/changeling //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
	var/list/datum/absorbed_dna/absorbed_dna = list()
	var/list/absorbed_languages = list()
	var/list/mob/abstract/hivemind/hivemind = list()
	var/absorbedcount = 0
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/sting_range = 1
	var/changelingID = "Changeling"
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/geneticpoints = 6
	var/total_absorbed_genpoints = 0	//How many points have we earned? Determines ling power level.
	var/purchasedpowers = list()
	var/mimicing = ""
	var/justate
	var/ling_level = LING_LEVEL_LOW

/datum/changeling/New(var/gender=FEMALE)
	..()
	var/honorific = (gender == FEMALE) ? "Ms." : "Mr."
	if(possible_changeling_IDs.len)
		changelingID = pick(possible_changeling_IDs)
		possible_changeling_IDs -= changelingID
		changelingID = "[honorific] [changelingID]"
	else
		changelingID = "[honorific] [rand(1,999)]"

/proc/ischangeling(var/mob/player)
	if(player.mind?.changeling)
		return TRUE
	return FALSE

/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges + chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage - 1)

/datum/changeling/proc/GetDNA(var/dna_owner)
	for(var/datum/absorbed_dna/DNA in absorbed_dna)
		if(dna_owner == DNA.name)
			return DNA

/mob/proc/absorbDNA(var/datum/absorbed_dna/newDNA)
	var/datum/changeling/changeling = null
	if(mind?.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return

	for(var/language in newDNA.languages)
		changeling.absorbed_languages |= language

	changeling_update_languages(changeling.absorbed_languages)

	if(!changeling.GetDNA(newDNA.name)) // Don't duplicate - I wonder if it's possible for it to still be a different DNA? DNA code could use a rewrite
		changeling.absorbed_dna += newDNA

//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()

	if(!mind)
		return
	if(!mind.changeling)
		mind.changeling = new /datum/changeling(gender)

	verbs += /datum/changeling/proc/EvolutionMenu
	add_language("Changeling")

	var/lesser_form = !ishuman(src)

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in powerinstances)
		if(!P.genomecost) // Is it free?
			if(!(P in mind.changeling.purchasedpowers)) // Do we not have it already?
				mind.changeling.purchasePower(mind, P.name, 0) // Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			if(lesser_form && !P.allowduringlesserform)	
				continue
			if(!(P in src.verbs))
				src.verbs += P.verbpath

	for(var/language in languages)
		mind.changeling.absorbed_languages |= language

	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/datum/absorbed_dna/newDNA = new(H.real_name, H.dna, H.species.get_cloning_variant(), H.languages)
		absorbDNA(newDNA)

	//H.adjust_species()

	return TRUE

//removes our changeling verbs
/mob/proc/remove_changeling_powers()
	if(!mind || !mind.changeling)
		return
	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			verbs -= P.verbpath


//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(var/required_chems=0, var/required_dna=0, var/max_genetic_damage=100, var/max_stat=0)

	if(!mind)
		return
	if(!iscarbon(src))
		return

	var/datum/changeling/changeling = src.mind.changeling
	if(!changeling)
		to_chat(world.log, "[src] has the changeling_transform() verb but is not a changeling.")
		return
	if(stat > max_stat)
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

/mob/proc/get_ling_level(var/min_level)
	if(mind?.changeling)
		if(!min_level)
			return mind.changeling.ling_level
		else
			return mind.changeling.ling_level >= min_level

/datum/changeling/proc/update_ling_power()
	var/message
	var/current_level = ling_level
	var/list/message_picks_med = list("Even in this form, our power grows...", "Yes, these genes make us stronger...", "Our evolution continues, but we may yet grow stronger.", "Good... this is just what we needed to grow.")
	var/list/message_picks_high = list("Finally, we have maximized the potential of this host's frail form!", "We have reached the apex of this host's strength. We have no equal.", "This host's pathetic form has achieved peak evolution; it is finally worthy of us.")
	switch(total_absorbed_genpoints)
		if(0 to 2)
			ling_level = LING_LEVEL_LOW
		if(3 to 9)
			ling_level = LING_LEVEL_MED
			message = pick(message_picks_med)
		else
			ling_level = LING_LEVEL_HIGH
			message = pick(message_picks_high)
	if(ling_level > LING_LEVEL_LOW && ling_level > current_level)
		to_chat(src, FONT_LARGE(SPAN_NOTICE(message)))

//Making you better than others of your species
/*/mob/living/carbon/human/proc/adjust_species()
	if(!species)
		return FALSE
	if(!(mind?.changeling))
		return FALSE

	species.brute_mod = initial(species.brute_mod) - 0.05	//Lings are slightly hardier
	species.burn_mod = initial(species.burn_mod) + 0.25	//Fire is their weakness
	species.oxy_mod = initial(species.oxy_mod) * 0.9	//Less issues with atmosphere
	species.toxins_mod = initial(species.toxins_mod) * 0.5	//They have such a weird biology, toxins shouldn't affect them much
	species.stamina = initial(species.stamina) * 1.1		//Slightly more endurance
	species.grab_mod = max(initial(species.grab_mod) * 0.75, 0.4)	//Subtle form-shifting makes them harder to hold onto
	species.resist_mod = min(initial(species.resist_mod) * 1.25, 2.75)	//Much stronger than they appear

	if(!(species.flags & NO_SLIP))
		species.flags |= NO_SLIP	//Can balance

	if(!mind.changeling.ling_level) //If somehow your level went away?
		mind.changeling.ling_level = LING_LEVEL_LOW

	return TRUE*/

//DNA related datums

/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages

/datum/absorbed_dna/New(var/newName, var/newDNA, var/newSpecies, var/newLanguages)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages

//Helper for stingcode

/mob/proc/sting_can_reach(mob/M, sting_range = 1)
	if(get_turf(M) == get_turf(src))
		return TRUE //target and source are in the same thing
	if(!isturf(src.loc) || !isturf(M.loc))
		to_chat(src, SPAN_WARNING("We cannot reach \the [M] with our sting!"))
		return FALSE //One is inside, the other is outside something.
	// Maximum queued turfs set to 25; I don't *think* anything raises sting_range above 2, but if it does the 25 may need raising
	if(!AStar(src.loc, M.loc, /turf/proc/AdjacentTurfs, /turf/proc/Distance, max_nodes=25, max_node_depth=sting_range)) //If we can't find a path, fail
		to_chat(src, SPAN_WARNING("We cannot find a path to sting \the [M] by!"))
		return FALSE
	return TRUE