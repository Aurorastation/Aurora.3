/datum/changeling_sting
	var/name = "Abstract Sting"
	var/feedback_tag = "AS"
	var/mob/living/carbon/owner
	var/verb_path
	var/required_chems
	var/stealthy

/datum/changeling_sting/New(var/mob/set_owner, var/set_verb_path, var/set_required_chems, var/set_stealthy)
	..()
	owner = set_owner
	verb_path = set_verb_path
	required_chems = set_required_chems
	stealthy = set_stealthy

/datum/changeling_sting/proc/can_sting(var/mob/living/target)
	if(!target || !owner.mind)
		return FALSE
	var/datum/changeling/changeling = owner.mind.antag_datums[MODE_CHANGELING]
	if(!changeling)
		return FALSE
	if(!(target in view(changeling.sting_range)))
		return FALSE
	if(!owner.sting_can_reach(target, changeling.sting_range))
		to_chat(owner, SPAN_WARNING("Our sting can't reach here!"))
		return FALSE
	if(!owner.changeling_power(required_chems))
		to_chat(owner, SPAN_WARNING("We don't have enough chemicals for this sting!"))
		return FALSE
	if(target.isSynthetic())
		to_chat(owner, SPAN_WARNING("[target] is not compatible with our biology."))
		return FALSE
	return TRUE

/datum/changeling_sting/proc/do_sting(var/mob/living/target)
	var/datum/changeling/changeling = owner.mind.antag_datums[MODE_CHANGELING]
	changeling.chem_charges -= required_chems
	changeling.sting_range = 1
	owner.verbs -= verb_path
	ADD_VERB_IN(owner, 10, verb_path)

	if(stealthy)
		to_chat(owner, SPAN_NOTICE("We stealthily sting [target]."))
		to_chat(target, SPAN_WARNING("You feel a tiny prick."))
	else
		var/list/possible_messages = list(
			"[owner]'s eyes balloon and burst out in a welter of blood, burrowing into [target]!",
			"[owner]'s arm rapidly shifts into a giant scorpion-stinger and stabs into [target]!",
			"[owner]'s throat lengthens and twists before vomiting a chunky red spew all over [target]!",
			"[owner]'s tongue stretches an impossible length and stabs into [target]!",
			"[owner] sneezes a cloud of shrieking spiders at [target]!",
			"[owner] erupts a grotesque tail and impales [target]!",
			"[owner]'s chin skin bulges and tears, launching a bone-dart at [target]!"
		)
		owner.visible_message(SPAN_DANGER("[pick(possible_messages)]"))

	feedback_add_details("changeling_powers", feedback_tag)

/mob/proc/changeling_sting(var/required_chems = 0, var/verb_path, var/datum_path, var/stealthy = FALSE)
	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	if(istype(changeling.prepared_sting, datum_path))
		to_chat(src, SPAN_NOTICE("You unprepare the <b>[changeling.prepared_sting.name]</b>."))
		QDEL_NULL(changeling.prepared_sting)
		return

	changeling = changeling_power(required_chems)
	if(!changeling)
		return FALSE

	changeling.prepared_sting = new datum_path(src, verb_path, required_chems, stealthy)
	to_chat(src, SPAN_NOTICE("You prepare to fire the <b>[changeling.prepared_sting.name]</b>."))
	return TRUE

/mob/proc/changeling_hallucinate_sting()
	set category = "Changeling"
	set name = "Hallucination Sting (15)"
	set desc = "Causes target to begin hallucinating after a few seconds."

	changeling_sting(15, /mob/proc/changeling_hallucinate_sting, /datum/changeling_sting/hallucinate, TRUE)

/datum/changeling_sting/hallucinate
	name = "Hallucinate Sting"
	feedback_tag = "HS"

/datum/changeling_sting/hallucinate/do_sting(mob/living/target)
	..()
	if(target.reagents)
		addtimer(target.reagents.add_reagent(/singleton/reagent/mindbreaker, 3), rand(5 SECONDS, 15 SECONDS))

/mob/proc/changeling_silence_sting()
	set category = "Changeling"
	set name = "Silence Sting (10)"
	set desc = "Causes target to temporarily lose their voice."

	changeling_sting(10, /mob/proc/changeling_silence_sting, /datum/changeling_sting/silence, TRUE)

/datum/changeling_sting/silence
	name = "Silence Sting"
	feedback_tag = "SS"

/datum/changeling_sting/silence/do_sting(mob/living/target)
	..()
	target.silent += 30

/mob/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind Sting (20)"
	set desc = "Causes the target to temporarily go blind."

	changeling_sting(20, /mob/proc/changeling_blind_sting, /datum/changeling_sting/blind, FALSE)

/datum/changeling_sting/blind
	name = "Blind Sting"
	feedback_tag = "BS"

/datum/changeling_sting/blind/do_sting(mob/living/target)
	..()
	to_chat(target, SPAN_DANGER("Your vision suddenly goes black!"))
	target.disabilities |= NEARSIGHTED
	target.eye_blind = 10
	target.eye_blurry = 20
	addtimer(CALLBACK(target, /mob.proc/remove_nearsighted), 30 SECONDS)

/mob/proc/changeling_deaf_sting()
	set category = "Changeling"
	set name = "Deaf Sting (5)"
	set desc = "Causes the target to temporarily go deaf."

	changeling_sting(5, /mob/proc/changeling_deaf_sting, /datum/changeling_sting/deaf, stealthy = FALSE)

/datum/changeling_sting/deaf
	name = "Deaf Sting"
	feedback_tag = "DS"

/datum/changeling_sting/deaf/do_sting(mob/living/target)
	..()
	to_chat(target, SPAN_DANGER("Your ears pop and begin ringing loudly!"))
	target.sdisabilities |= DEAF
	addtimer(CALLBACK(target, /mob.proc/remove_deaf), 30 SECONDS)

/mob/proc/changeling_paralysis_sting()
	set category = "Changeling"
	set name = "Paralysis Sting (30)"
	set desc = "Causes the target to temporarily get paralyzed."

	changeling_sting(30, /mob/proc/changeling_paralysis_sting, /datum/changeling_sting/paralysis, FALSE)

/datum/changeling_sting/paralysis
	name = "Paralysis Sting"
	feedback_tag = "PS"

/datum/changeling_sting/paralysis/do_sting(mob/living/target)
	..()
	to_chat(target, SPAN_DANGER("Your muscles begin to painfully tighten."))
	target.Weaken(20)

/mob/proc/changeling_transformation_sting()
	set category = "Changeling"
	set name = "Transformation Sting (40)"
	set desc = "Causes the target to permanently transform into a collected DNA subject."

	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	if(!length(changeling.absorbed_dna))
		to_chat(src, SPAN_WARNING("You have no DNA to load this sting with!"))
		return

	var/successful = changeling_sting(40, /mob/proc/changeling_transformation_sting, /datum/changeling_sting/transformation, TRUE)
	if(!successful)
		return

	var/list/names = list()
	for(var/thing in changeling.absorbed_dna)
		var/datum/absorbed_dna/DNA = thing
		names += "[DNA.name]"

	var/S = input(src, "Select the target DNA:", "Target DNA") as null|anything in names
	if(!S)
		QDEL_NULL(changeling.prepared_sting)
		to_chat(src, SPAN_NOTICE("With no DNA chosen, you unprepare the sting."))
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		QDEL_NULL(changeling.prepared_sting)
		to_chat(src, SPAN_WARNING("Something went wrong, you do not possess the DNA of this person."))
		return

	var/datum/changeling_sting/transformation/T = changeling.prepared_sting
	T.dna_payload = chosen_dna

/datum/changeling_sting/transformation
	name = "Transformation Sting"
	feedback_tag = "TS"
	var/datum/absorbed_dna/dna_payload

/datum/changeling_sting/transformation/can_sting(mob/living/target)
	. = ..()
	if(.)
		if(HAS_FLAG(target.mutations, HUSK) || (!ishuman(target) && !issmall(target)))
			to_chat(owner, SPAN_WARNING("Our sting appears ineffective against its DNA."))
			return FALSE
		if(islesserform(target))
			to_chat(owner, SPAN_WARNING("Our sting appears ineffective against this creature."))
			return FALSE
		if(target.stat != DEAD)
			to_chat(owner, SPAN_WARNING("Our sting can only be used against dead targets."))
			return FALSE

/datum/changeling_sting/transformation/do_sting(mob/living/target)
	..()
	target.handle_changeling_transform(dna_payload)

/mob/proc/changeling_death_sting()
	set category = "Changeling"
	set name = "Death Sting (40)"
	set desc = "Injects the target with a lethal dose of cyanide."

	changeling_sting(40, /mob/proc/changeling_death_sting, /datum/changeling_sting/death, FALSE)

/datum/changeling_sting/death
	name = "Death Sting"
	feedback_tag = "DTHS"

/datum/changeling_sting/death/do_sting(mob/living/target)
	..()
	to_chat(target, SPAN_DANGER("You feel a small prick and your chest becomes tight."))
	target.silent = 10
	target.Paralyse(10)
	target.make_jittery(1000)
	if(target.reagents)
		target.reagents.add_reagent(/singleton/reagent/toxin/cyanide, 5)

/mob/proc/changeling_extract_dna_sting()
	set category = "Changeling"
	set name = "Extract DNA Sting (40)"
	set desc = "Stealthily sting a target to extract their DNA."

	changeling_sting(40, /mob/proc/changeling_extract_dna_sting, /datum/changeling_sting/dna_extract, TRUE)

/datum/changeling_sting/dna_extract
	name = "DNA Extract Sting"
	feedback_tag = "ED"

/datum/changeling_sting/dna_extract/can_sting(mob/living/target)
	. = ..()
	if(.)
		if(!ishuman(target))
			to_chat(owner, SPAN_WARNING("This sting only works on humanoids!"))
			return FALSE

/datum/changeling_sting/dna_extract/do_sting(mob/living/carbon/human/target)
	..()
	var/datum/absorbed_dna/newDNA = new(target.real_name, target.dna, target.species.get_cloning_variant(), target.languages)
	owner.absorbDNA(newDNA)

//Boosts the range of your next sting attack by 1
/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc = "Your next sting ability can be used against targets 2 squares away."

	var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
	if(changeling.sting_range > 1)
		to_chat(src, SPAN_WARNING("The range of your sting has already been boosted!"))
		return

	changeling = changeling_power(10, 0, 100)
	if(!changeling)
		return FALSE
	changeling.chem_charges -= 10
	to_chat(src, SPAN_NOTICE("Your throat adjusts to launch the sting."))
	changeling.sting_range = 2
	src.verbs -= /mob/proc/changeling_boost_range
	ADD_VERB_IN(src, 5, /mob/proc/changeling_boost_range)
	feedback_add_details("changeling_powers", "RS")
	return TRUE
