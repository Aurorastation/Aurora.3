#define EVIDENCE_TYPE_BLOOD "Blood"
#define EVIDENCE_TYPE_GSR "Gunshot Residue"
#define EVIDENCE_TYPE_SALIVA "Saliva"
#define EVIDENCE_TYPE_ADDITIONAL "Additional"

/obj/item/forensics/swab
	name = "swab kit"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	desc_info = "Swab kits can be used to gather blood with DNA attached to it by clicking the blood. \
	If it fails to collect a sample, it means that particular bit of blood has no associated DNA. \
	\nThey can also collect DNA samples directly from people by targetting their mouth to take a saliva sample. \
	\nGunshot Residue (GSR) can be collected from someones hands by targetting them. If they are wearing gloves, \
	the residue will be taken from the gloves instead. \
	\n\nGSR samples are put in a slide and examined in a microscope. \
	\nBlood and DNA samples are checked in the DNA analyzer"
	icon_state = "swab"
	var/list/gsr
	var/list/dna
	var/used
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/forensics/swab/proc/is_used()
	return used

/obj/item/forensics/swab/attack(var/mob/living/M, var/mob/user, var/target_zone)

	if(!ishuman(M))
		return ..()

	if(is_used())
		return

	var/mob/living/carbon/human/H = M
	var/sample_type

	if(!H.dna || !H.dna.unique_enzymes)
		to_chat(user, SPAN_WARNING("They don't seem to have DNA!"))
		return

	if(user != H && H.a_intent != "help" && !H.lying)
		user.visible_message(SPAN_DANGER("\The [user] tries to take a swab sample from \the [H], but they move away."))
		return

	if(target_zone == BP_MOUTH)
		if(!H.organs_by_name[BP_HEAD])
			to_chat(user, SPAN_WARNING("They don't have a head."))
			return
		if(!H.check_has_mouth())
			to_chat(user, SPAN_WARNING("They don't have a mouth."))
			return
		if(H.wear_mask)
			to_chat(user, SPAN_WARNING("\The [H] is wearing a mask."))
			return
		user.visible_message("[user] swabs \the [H]'s mouth for a saliva sample.")
		dna = list(H.dna.unique_enzymes)
		sample_type = "DNA"

	else if(target_zone == BP_R_HAND || target_zone == BP_L_HAND)
		var/has_hand
		var/obj/item/organ/external/O = H.organs_by_name[BP_R_HAND]
		if(istype(O) && !O.is_stump())
			has_hand = 1
		else
			O = H.organs_by_name[BP_L_HAND]
			if(istype(O) && !O.is_stump())
				has_hand = 1
		if(!has_hand)
			to_chat(user, SPAN_WARNING("They don't have any hands."))
			return
		if(H.gloves)
			var/obj/item/clothing/B = H.gloves
			if(!LAZYLEN(B.gunshot_residue))
				to_chat(user, SPAN_WARNING("There is no residue on [H]'s [B]."))
				return
			user.visible_message("[user] swabs [H]'s [B] for a sample.")
			LAZYADD(gsr, B.gunshot_residue)
		else
			if(!LAZYLEN(H.gunshot_residue))
				to_chat(user, SPAN_WARNING("There is no residue on [H]'s palms."))
				return
			user.visible_message("[user] swabs [H]'s palm for a sample.")
			LAZYADD(gsr, H.gunshot_residue)
		sample_type = "GSR"
	else
		return

	if(sample_type)
		set_used(sample_type, H)
		return
	return 1

/obj/item/forensics/swab/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity || istype(A, /obj/item/forensics/slide) || istype(A, /obj/machinery/dnaforensics) || ismob(A) || istype(A, /obj/structure/filingcabinet))
		return

	if(is_used())
		to_chat(user, SPAN_WARNING("This swab has already been used."))
		return

	add_fingerprint(user)

	var/list/choices = list()
	if(A.blood_DNA)
		choices |= EVIDENCE_TYPE_BLOOD
	if(istype(A, /obj/item/clothing))
		choices |= EVIDENCE_TYPE_GSR
	if(LAZYLEN(A.other_DNA) && A.other_DNA_type == "saliva")
		choices |= EVIDENCE_TYPE_SALIVA
	var/list/list/additional_evidence = A.get_additional_forensics_swab_info()
	if(additional_evidence && additional_evidence["type"] != "")
		choices |= EVIDENCE_TYPE_ADDITIONAL + " - " + additional_evidence["type"]

	var/choice
	if(!choices.len)
		to_chat(user, SPAN_WARNING("There is no evidence on \the [A]."))
		return
	else if(choices.len == 1)
		choice = choices[1]
	else
		choice = input("What kind of evidence are you looking for?","Evidence Collection") as null|anything in choices

	if(!choice)
		return

	var/sample_type
	var/sample_message
	switch (choice)
		if (EVIDENCE_TYPE_BLOOD)
			if(!A.blood_DNA || !A.blood_DNA.len) return
			dna = A.blood_DNA.Copy()
			sample_type = "blood"

		if (EVIDENCE_TYPE_GSR)
			var/obj/item/clothing/B = A
			if(!istype(B) || !LAZYLEN(B.gunshot_residue))
				to_chat(user, SPAN_WARNING("There is no residue on \the [A]."))
				return
			LAZYADD(gsr, B.gunshot_residue)
			sample_type = "residue"

		if (EVIDENCE_TYPE_SALIVA)
			if (!LAZYLEN(A.other_DNA)) return
			dna = A.other_DNA.Copy()
			sample_type = "saliva"

		else //additional evidence
			if(additional_evidence["dna"].len)
				dna = additional_evidence["dna"].Copy()
			if(additional_evidence["gsr"])
				gsr = additional_evidence["gsr"]
			sample_type = additional_evidence["sample_type"]
			if(!sample_type)
				crash_with("[user] swabbed \the [A.name] for additional evidence but there was no sample_type defined!")
			sample_message = additional_evidence["sample_message"]

	if(sample_type)
		user.visible_message("\The [user] swabs \the [A] for a sample.", sample_message || "You swab \the [A] for a sample.")
		set_used(sample_type, A)

/obj/item/forensics/swab/proc/set_used(var/sample_str, var/atom/source)
	name = "[initial(name)] ([sample_str] - [source])"
	desc = "[initial(desc)] The label on the vial reads 'Sample of [sample_str] from [source].'."
	icon_state = "swab_used"
	used = 1
