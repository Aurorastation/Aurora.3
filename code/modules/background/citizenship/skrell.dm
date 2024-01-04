/datum/citizenship/nralakk
	name = CITIZENSHIP_NRALAKK
	description = "Home of the Skrell, a centralized union of solar systems run by councilors of different ranks and positions. The capital of the Federation is located at the city of \
	Kal'lo on the core planet Nralakk IV, also known as Qerrbalak, within the Nralakk system. While the majority of Skrell live within the Nralakk Federation, a sizable portion live \
	abroad. The quality of life within Federation is considered to be the best in the galaxy due to their technological advances, allowing Federation Citizens access to a quality of \
	life almost unmatched anywhere else in the Spur. \
	A rogue artificial intelligence, Glorsh-Omega, has traumatized this nation for centuries to come. The Federation is very wary of humanity, who has acquired AI technology \
	after a Federation tech leak provided them with the research required to create their own AI, as well as allowing them to create IPCs."
	consular_outfit = /datum/outfit/job/representative/consular/nralakk

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
			SPECIES_DIONA_COEUS,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK
		)
	)

/datum/citizenship/nralakk/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			if(isvaurca(H))
				rep_objectives = pick("Collect evidence of the [current_map.boss_name] being unfair or bigoted to Federation employees, to be used as leverage in future hive labor negotiations",
								"Acquire information on dissidents towards the Federation, forwarding it to the embassy",
								"Convince the command of the [current_map.boss_name] of the advantages that Bound Vaurcae hold over synthetics.")
			else
				rep_objectives = pick("Some Skrell are not part of the Federation; attempt to convince them to become a citizen",
								"Acquire information on dissidents towards the Federation, forwarding it to the embassy",
								"Curtail the spreading of written literature or verbal notions that contain negative connotations towards the Federation")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			if(isvaurca(H))
				rep_objectives = pick("Legally curtail the advancements and liberal thinking towards synthetics.",
								"Remind C'thur Vaurcae aboard the [current_map.station_name] that they are representative of their hive-cell, and encourage them to increase their social credit",
								"Ensure the interests of Federation citizens are upheld by the vessel - whether Skrell, C'thur or Diona.")
			else
				rep_objectives = pick("Ensure the interests of Federation citizens are upheld by the vessel. This includes C'thur and Diona of Federation origin",
								"Legally curtail the advancements and liberal thinking towards synthetics.",
								"The [current_map.station_name] hosts some of the brightest minds in the galaxy; winning them over towards the Federation is a major victory",
								"Encourage Federation citizens with low social credit to work to increase their score.")
		else
			if(isvaurca(H))
				rep_objectives = pick("Consider assisting crew within the capacity of your role, an altruistic image is good PR towards both the Federation and the C'thur Hive.",
								"Question Non-Vaurca employees about Vaurca employees, looking for areas of improvement.",
								"Some Skrell are not part of the Federation; attempt to convince them to become a citizen.")
			else
				rep_objectives = pick("Consider assisting crew within the capacity of your role, an altruistic image is good PR towards the Federation",
								"Some Skrell are not part of the Federation; attempt to convince them to become a citizen.",
								"Promote Nralakk tourism among the non-citizen employees of the [current_map.boss_name] in order to build positive opinion.")

	return rep_objectives

/datum/outfit/job/representative/consular/nralakk
	name = "Nralakk Consular Officer"

	uniform = /obj/item/clothing/under/skrell
	backpack_contents = list(
		/obj/item/device/camera = 1
	)

/datum/outfit/job/representative/consular/nralakk/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H)
		if(isskrell(H))
			H.equip_to_slot_or_del(new /obj/item/gun/energy/fedpistol(H), slot_belt)
		if(isvaurca(H)) // there should be a system for this but for now this will have to do i guess
			H.equip_to_slot_or_del(new /obj/item/clothing/under/gearharness(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/vaurca_breeder/nralakk(H), slot_head)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca/breeder/nralakk(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/vaurca/breeder/nralakk(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/typec/cthur(H), slot_back)
			H.equip_to_slot_or_del(new /obj/item/gun/energy/fedpistol/nopsi(H), slot_belt)
		else
			H.equip_to_slot_or_del(new /obj/item/gun/energy/fedpistol/nopsi(H), slot_belt)
		if(!visualsOnly)
			addtimer(CALLBACK(src, PROC_REF(send_representative_mission), H), 5 MINUTES)
	return TRUE
