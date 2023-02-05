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
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK
		)
	)

/datum/citizenship/zora/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of the [current_map.boss_name] being unfair or bigoted to Vaurca employees, to be used as leverage in future hive labor negotiations",
							"Begin the TCFL enlistment process for an individual, completing an Enlistment form to be turned in by the individual",
							"Develop a metric to grade the performance of different Vaurca broods that share a job")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Promote [rand(3,6)] amount of Zo'rane products, be it energy drinks or merchandise",
							"Sell [rand(3,6)] copies of the Tau Ceti Foreign Legion pamphlets 10 credits each")
		else
			rep_objectives = pick("Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement",
							"Protect and promote the public image of the Zo'ra hive to all SCC employees")

	return rep_objectives

/datum/outfit/job/representative/consular/zora
	name = "Zo'ra Consular Officer"

	uniform = /obj/item/clothing/under/gearharness

	glasses = null
	head = /obj/item/clothing/head/vaurca_breeder
	shoes = /obj/item/clothing/shoes/vaurca/breeder
	mask = /obj/item/clothing/mask/breath/vaurca/filter
	suit = /obj/item/clothing/suit/vaurca/breeder

/datum/outfit/job/representative/consular/zora/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H && !visualsOnly)
		if(isvaurca(H))

			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/storage/box/tcfl_pamphlet(H), slot_in_backpack)

		addtimer(CALLBACK(src, PROC_REF(send_representative_mission), H), 5 MINUTES)
	return TRUE

/datum/citizenship/klax
	name = CITIZENSHIP_KLAX
	description = "The second Hive discovered by humanity,  Hiveship, Klo'zxera, appeared in the Skrellian system of Glorashi. \
	K'lax is known as a client state of the Zo'ra, but since the Exodus from Sedantis they have struggled for political independence. \
	Now parting their own ways, both Hives have developed differently.  the K'lax became the newest vassal of the Izweski Nation, and have largely settled in Tret. \
	They maintain subtly warm, if terse relations with the Hegemony as a whole, and have committed to its terraforming agenda, being instrumental in the implementation of such a monumental undertaking. \
	The K'lax are the most technologically developed Hive, and are leading the way in reconstructing the species' superior technology."
	consular_outfit = /datum/outfit/job/representative/consular/klax

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
			SPECIES_SKRELL_AXIORI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK
		)
	)

/datum/citizenship/klax/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of the [current_map.boss_name] being unfair or bigoted to Vaurca employees, to be used as leverage in future hive labor negotiations",
							"Develop a metric to grade the performance of different Vaurca broods that share a job")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Promote [rand(3,6)] amount of K'laxan products, be it energy drinks or merchandise")
		else
			rep_objectives = pick("Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement",
							"Protect and promote the public image of the K'lax hive to all [current_map.boss_name] employees")

	return rep_objectives

/datum/outfit/job/representative/consular/klax
	name = "K'lax Consular Officer"

	uniform = /obj/item/clothing/under/gearharness

	glasses = null
	head = /obj/item/clothing/head/vaurca_breeder/klax
	shoes = /obj/item/clothing/shoes/vaurca/breeder/klax
	mask = /obj/item/clothing/mask/breath/vaurca/filter
	suit = /obj/item/clothing/suit/vaurca/breeder/klax

/datum/outfit/job/representative/consular/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H && !visualsOnly)
		if(isvaurca(H))

			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/klax(H), slot_back)

		addtimer(CALLBACK(src, PROC_REF(send_representative_mission), H), 5 MINUTES)
	return TRUE

/datum/citizenship/cthur
	name = CITIZENSHIP_CTHUR
	description = "They are the third Hive that has developed relationships with other sophonts of the Orion Spur. \
	While their arrival was kept in secret by the Nralakk Federation, the revelation has reignited diplomatic disputes between K'lax and C'thur, with outright hostility met by the K'lax towards the C'thur. \
	Unlike all other hives, the C'thur are led by their original Hive Queen, who, with a council of three other Lesser Queens, leads the Hive in this new age. \
	In this effort, the Hive has begun dealing with the multitude of governments and corporations of the galaxy, all under the auspices of their Skrellian saviors. \
	The C'thur are the most economically developed hive, having stakes in Einstein Engines and Zeng-Hu Pharmaceuticals."
	consular_outfit = /datum/outfit/job/representative/consular/cthur

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
			SPECIES_SKRELL_AXIORI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK
		)
	)

/datum/citizenship/cthur/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of the [current_map.boss_name] being unfair or bigoted to Vaurca employees, to be used as leverage in future hive labor negotiations",
							"Develop a metric to grade the performance of different Vaurca broods that share a job")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Promote [rand(3,6)] amount of C'thuric products, be it energy drinks or merchandise")

		else
			rep_objectives = pick("Question Non-Vaurcan employees about Vaurcan employees, looking for areas of improvement",
							"Protect and promote the public image of the C'thur hive to all [current_map.boss_name] employees")

	return rep_objectives

/datum/outfit/job/representative/consular/cthur
	name = "C'thur Consular Officer"

	uniform = /obj/item/clothing/under/gearharness

	glasses = null
	head = /obj/item/clothing/head/vaurca_breeder/cthur
	shoes = /obj/item/clothing/shoes/vaurca/breeder/cthur
	mask = /obj/item/clothing/mask/breath/vaurca/filter
	suit = /obj/item/clothing/suit/vaurca/breeder/cthur

/datum/outfit/job/representative/consular/cthur/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H && !visualsOnly)
		if(isvaurca(H))
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/cthur(H), slot_back)
		addtimer(CALLBACK(src, PROC_REF(send_representative_mission), H), 5 MINUTES)
	return TRUE
