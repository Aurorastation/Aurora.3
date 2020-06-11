/mob/proc/changeling_sting(var/required_chems = 0, var/verb_path, var/stealthy = FALSE)
	var/datum/changeling/changeling = changeling_power(required_chems)
	if(!changeling)
		return

	var/list/victims = list()
	for(var/mob/living/carbon/C in oview(changeling.sting_range))
		victims += C
	var/mob/living/carbon/T = input(src, "Who will we sting?") as null|anything in victims

	if(!T)
		return
	if(!(T in view(changeling.sting_range)))
		return
	if(!sting_can_reach(T, changeling.sting_range))
		return
	if(!changeling_power(required_chems))
		return
	if(T.isSynthetic())
		to_chat(src, "<span class='warning'>[T] is not compatible with our biology.</span>")
		return

	changeling.chem_charges -= required_chems
	changeling.sting_range = 1
	src.verbs -= verb_path
	ADD_VERB_IN(src, 10, verb_path)

	if(stealthy)
		to_chat(src, "<span class='notice'>We stealthily sting [T].</span>")
		to_chat(T, "<span class='warning'>You feel a tiny prick.</span>")
	else
		src.visible_message(pick("<span class='danger'>[src]'s eyes balloon and burst out in a welter of blood, burrowing into [T]!</span>",
								"<span class='danger'>[src]'s arm rapidly shifts into a giant scorpion-stinger and stabs into [T]!</span>",
								"<span class='danger'>[src]'s throat lengthens and twists before vomiting a chunky red spew all over [T]!</span>",
								"<span class='danger'>[src]'s tongue stretches an impossible length and stabs into [T]!</span>",
								"<span class='danger'>[src] sneezes a cloud of shrieking spiders at [T]!</span>",
								"<span class='danger'>[src] erupts a grotesque tail and impales [T]!</span>",
								"<span class='danger'>[src]'s chin skin bulges and tears, launching a bone-dart at [T]!</span>"))

	if(!T.mind || !T.mind.changeling)
		return T	//T will be affected by the sting
	return


/mob/proc/changeling_hallucinate_sting()
	set category = "Changeling"
	set name = "Hallucination Sting (15)"
	set desc = "Causes target to begin hallucinating after five to fifteen seconds."

	var/mob/living/carbon/T = changeling_sting(15, /mob/proc/changeling_hallucinate_sting, stealthy = TRUE)
	if(!T)
		return FALSE
	spawn(rand(50, 150))
		if(T)
			T.hallucination += 200
	feedback_add_details("changeling_powers", "HS")
	return TRUE

/mob/proc/changeling_silence_sting()
	set category = "Changeling"
	set name = "Silence sting (10)"
	set desc = "Causes target to temporarily lose their voice."

	var/mob/living/carbon/T = changeling_sting(10, /mob/proc/changeling_silence_sting, stealthy = TRUE)
	if(!T)
		return FALSE
	T.silent += 30
	feedback_add_details("changeling_powers", "SS")
	return TRUE

/mob/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc = "Causes the target to temporarily go blind."

	var/mob/living/carbon/T = changeling_sting(20, /mob/proc/changeling_blind_sting, stealthy = FALSE)
	if(!T)
		return FALSE
	to_chat(T, "<span class='danger'>Your vision suddenly goes black!</span>")
	T.disabilities |= NEARSIGHTED
	spawn(300)
		T.disabilities &= ~NEARSIGHTED
	T.eye_blind = 10
	T.eye_blurry = 20
	feedback_add_details("changeling_powers", "BS")
	return TRUE

/mob/proc/changeling_deaf_sting()
	set category = "Changeling"
	set name = "Deaf sting (5)"
	set desc = "Causes the target to temporarily go deaf."

	var/mob/living/carbon/T = changeling_sting(5, /mob/proc/changeling_deaf_sting, stealthy = FALSE)
	if(!T)
		return FALSE
	to_chat(T, "<span class='danger'>Your ears pop and begin ringing loudly!</span>")
	T.sdisabilities |= DEAF
	spawn(300)
		T.sdisabilities &= ~DEAF
	feedback_add_details("changeling_powers","DS")
	return TRUE

/mob/proc/changeling_paralysis_sting()
	set category = "Changeling"
	set name = "Paralysis sting (30)"
	set desc = "Causes the target to temporarily get paralyzed."

	var/mob/living/carbon/T = changeling_sting(30, /mob/proc/changeling_paralysis_sting, stealthy = FALSE)
	if(!T)
		return FALSE
	to_chat(T, "<span class='danger'>Your muscles begin to painfully tighten.</span>")
	T.Weaken(20)
	feedback_add_details("changeling_powers", "PS")
	return TRUE

/mob/proc/changeling_transformation_sting()
	set category = "Changeling"
	set name = "Transformation sting (40)"
	set desc = "Causes the target to permanently transform into a collected DNA subject."

	var/datum/changeling/changeling = changeling_power(40)
	if(!changeling)
		return FALSE

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/mob/living/carbon/T = changeling_sting(40,/mob/proc/changeling_transformation_sting,stealthy = 1)
	if(!T)
		return FALSE
	if((HUSK in T.mutations) || (!ishuman(T) && !issmall(T)))
		to_chat(src, "<span class='warning'>Our sting appears ineffective against its DNA.</span>")
		return FALSE
	if(islesserform(T))
		to_chat(src, "<span class='warning'>Our sting appears ineffective against this creature.</span>")
		return FALSE
	if(T.stat != DEAD)
		to_chat(src, "<span class='warning'>Our sting can only be used against dead targets.</span>")
		return FALSE

	T.handle_changeling_transform(chosen_dna)

	feedback_add_details("changeling_powers", "TS")
	return TRUE

/mob/proc/changeling_death_sting()
	set category = "Changeling"
	set name = "Death Sting (40)"
	set desc = "Injects the target with a lethal dose of cyanide."

	var/mob/living/carbon/T = changeling_sting(40, /mob/proc/changeling_death_sting, stealthy = FALSE)
	if(!T)
		return FALSE
	to_chat(T, "<span class='danger'>You feel a small prick and your chest becomes tight.</span>")
	T.silent = 10
	T.Paralyse(10)
	T.make_jittery(1000)
	if(T.reagents)
		T.reagents.add_reagent(/datum/reagent/toxin/cyanide, 5)
	feedback_add_details("changeling_powers", "DTHS")
	return TRUE

/mob/proc/changeling_extract_dna_sting()
	set category = "Changeling"
	set name = "Extract DNA Sting (40)"
	set desc = "Stealthily sting a target to extract their DNA."

	var/datum/changeling/changeling = null
	if(src.mind && src.mind.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return FALSE

	var/mob/living/carbon/human/T = changeling_sting(40, /mob/proc/changeling_extract_dna_sting, stealthy = TRUE)
	if(!T)
		return FALSE

	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.get_cloning_variant(), T.languages)
	absorbDNA(newDNA)

	feedback_add_details("changeling_powers", "ED")
	return TRUE

//Boosts the range of your next sting attack by 1
/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc = "Your next sting ability can be used against targets 2 squares away."

	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)
		return FALSE
	changeling.chem_charges -= 10
	to_chat(src, "<span class='notice'>Your throat adjusts to launch the sting.</span>")
	changeling.sting_range = 2
	src.verbs -= /mob/proc/changeling_boost_range
	ADD_VERB_IN(src, 5, /mob/proc/changeling_boost_range)
	feedback_add_details("changeling_powers", "RS")
	return TRUE