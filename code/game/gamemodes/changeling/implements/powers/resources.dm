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
	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	changeling.space_adapted = TRUE
	return TRUE

// HIVE MIND UPLOAD/DOWNLOAD DNA

var/list/datum/absorbed_dna/hivemind_bank = list()

/mob/proc/changeling_hiveupload()
	set category = "Changeling"
	set name = "Hive Channel (10)"
	set desc = "Allows you to channel DNA in the airwaves to allow other changelings to absorb it."

	var/datum/changeling/changeling = changeling_power(10,1)
	if(!changeling)
		return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA as anything in changeling.absorbed_dna)
		for(var/datum/absorbed_dna/DNB in hivemind_bank)
			if(DNA.target_ref == DNB.target_ref)
				continue
		names[DNA.name] = DNA.target_ref

	if(!length(names))
		to_chat(src, "<span class='notice'>The airwaves already has all of our DNA.</span>")
		return

	var/chosen_name = input("Select a DNA to channel: ", "Channel DNA", null) as null|anything in names
	if(!chosen_name)
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNAByWeakref(names[chosen_name])
	if(!chosen_dna)
		return

	changeling.chem_charges -= 10
	hivemind_bank += chosen_dna
	to_chat(src, "<span class='notice'>We channel the DNA of [chosen_name] to the air.</span>")
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
	for(var/datum/absorbed_dna/DNA in hivemind_bank)
		if(!changeling.GetDNAByWeakref(DNA.target_ref))
			names[DNA.name] = DNA

	if(names.len <= 0)
		to_chat(src, "<span class='notice'>There's no new DNA to absorb from the air.</span>")
		return

	var/S = input("Select a DNA absorb from the air: ", "Absorb DNA", null) as null|anything in names
	if(!S)
		return

	var/datum/dna/chosen_dna = names[S]
	if(!chosen_dna)
		return

	changeling.chem_charges -= 20
	absorbDNA(chosen_dna)
	to_chat(src, "<span class='notice'>We absorb the DNA of [S] from the air.</span>")
	feedback_add_details("changeling_powers", "HD")
	return TRUE
