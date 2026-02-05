//Speeds up chemical regeneration
/mob/proc/changeling_fastchemical()
	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	changeling.chem_recharge_rate *= 2.5
	return TRUE

//Increases maximum chemical storage
/mob/proc/changeling_engorgedglands()
	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	changeling.chem_storage += 50
	return TRUE

//removes the need to breathe, removes effects of very low pressure
/mob/proc/changeling_spaceadaption()
	ADD_TRAIT(src, TRAIT_PRESSURE_IMMUNITY, TRAIT_SOURCE_CHANGELING)
	return TRUE

/mob/proc/changeling_armor()
	AddComponent(/datum/component/armor, list(MELEE = ARMOR_MELEE_RESISTANT, BULLET = ARMOR_BALLISTIC_CARBINE, LASER = ARMOR_LASER_MEDIUM))
	return TRUE

//removes the need to breathe
/mob/proc/changeling_nobreathing()
	ADD_TRAIT(src, TRAIT_NO_BREATHE, TRAIT_SOURCE_CHANGELING)
	return TRUE

// HIVE MIND UPLOAD/DOWNLOAD DNA

GLOBAL_LIST_INIT_TYPED(hivemind_bank, /datum/absorbed_dna, list())

/mob/proc/changeling_hiveupload()
	set category = "Changeling"
	set name = "Hive Channel (10)"
	set desc = "Allows you to channel DNA in the airwaves to allow other changelings to absorb it."

	var/datum/changeling/changeling = changeling_power(10,1)
	if(!changeling)
		return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		var/valid = TRUE
		for(var/datum/absorbed_dna/DNB in GLOB.hivemind_bank)
			if(DNA.name == DNB.name)
				valid = FALSE
				break
		if(valid)
			names += DNA.name

	if(names.len <= 0)
		to_chat(src, SPAN_NOTICE("The airwaves already has all of our DNA."))
		return

	var/S = tgui_input_list(usr, "Select a DNA to channel.", "Channel DNA", names)
	if(!S)
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.use_charges(10)
	GLOB.hivemind_bank += chosen_dna
	to_chat(src, SPAN_NOTICE("We channel the DNA of [S] to the air."))
	feedback_add_details("changeling_powers", "HU")
	return TRUE

/mob/proc/changeling_hivedownload()
	set category = "Changeling"
	set name = "Hive Absorb (20)"
	set desc = "Allows you to absorb DNA that is being channeled in the airwaves."

	var/datum/changeling/changeling = changeling_power(20, 1)
	if(!changeling)
		return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in GLOB.hivemind_bank)
		if(!(changeling.GetDNA(DNA.name)))
			names[DNA.name] = DNA

	if(names.len <= 0)
		to_chat(src, SPAN_NOTICE("There's no new DNA to absorb from the air."))
		return

	var/S = tgui_input_list(src, "Select a DNA string to absorb.", "Absorb DNA", names)
	if(!S)
		return

	var/datum/dna/chosen_dna = names[S]
	if(!chosen_dna)
		return

	changeling.use_charges(20)
	absorbDNA(chosen_dna)
	to_chat(src, SPAN_NOTICE("We absorb the DNA of [S] from the air."))
	feedback_add_details("changeling_powers", "HD")
	return TRUE
