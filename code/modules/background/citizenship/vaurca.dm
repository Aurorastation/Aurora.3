/datum/citizenship/zora
	name = CITIZENSHIP_ZORA
	description = "Zo'ra, the largest and most powerful hive, and also the first one discovered by Humanity following their Hive-ship 'Titan Prime.' Information gained through contact \
	with Vaurca present in Tau Ceti has lead to unconfirmed projections putting their population in Vaurca space at 77 billion (17.1 million in known space). Zo'ra believe themselves to \
	be the Alpha of the Vaurca and the face of their species. They make up the majority of the Vaurca present in Tau Ceti and human space.Zo'ra have cold relations with other hives. In \
	Tau Ceti, this has lead to confrontations between them and other hives arriving in the system. The Zo'ra are the most politically developed hive, recently helping in the funding of \
	the Tau Ceti Foreign Legion, and making active progress to spread their influence."
	consular_outfit = /datum/outfit/job/representative/consular/zora

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_SKRELL,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI
		)
	)

/datum/citizenship/zora/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of Nanotrasen being unfair or bigoted to Vaurca employees, to be used as leverage in future hive labor negotiations",
							"Begin the TCFL enlistment process for an individual, completing an Enlistment form to be turned in by the individual",
							"Develop a metric to grade the performance of different Vaurca broods that share a job")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Assist Zo'ra Nanotrasen personnel in their avowal process",
							"Promote [rand(3,6)] amount of Zo'rane products, be it energy drinks or merchandise",
							"Sell [rand(3,6)] copies of the Tau Ceti Foreign Legion pamphlets, 10 credits each")
		else
			rep_objectives = pick("Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement",
							"Protect and promote the public image of the Zo'ra hive to all Nanotrasen employees",
							"Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement")

	return rep_objectives

/datum/outfit/job/representative/consular/zora
	name = "Zo'ra Consular Officer"

	uniform = /obj/item/clothing/under/gearharness

	glasses = null
	l_hand =  null

	backpack_contents = list()


/datum/outfit/job/representative/consular/zora/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H && !visualsOnly)
		if(isvaurca(H))
			var/r = H.r_skin
			var/g = H.g_skin
			var/b = H.b_skin

			H.set_species(SPECIES_VAURCA_BREEDER)

			H.unEquip(H.back)
			H.unEquip(H.shoes)
			qdel(H.wear_mask)

			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
			var/obj/item/organ/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
			H.internal = preserve
			H.internals.icon_state = "internal1"
			H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/storage/box/tcfl_pamphlet(H), slot_in_backpack)

			H.change_skin_color(r, g, b)
			H.update_dna()
		addtimer(CALLBACK(src, .proc/send_representative_mission, H), 5 MINUTES)
	return TRUE
