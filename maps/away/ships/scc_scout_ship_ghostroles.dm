
// ---------------------- spawners
// /datum/ghostspawner/human/scc_scout_ship_crew
// 	short_name = "scc_scout_ship_crew"
// 	name = "SCCV XYZ Scout Ship Crew"
// 	desc = "SCCV XYZ Scout Ship Crew desc"
// 	tags = list("External")

// 	spawnpoints = list("scc_scout_ship_crew")
// 	max_count = 0

// 	outfit = /datum/outfit/admin/scc_scout_ship_crew
// 	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
// 	allow_appearance_change = APPEARANCE_PLASTICSURGERY

// 	assigned_role = "SCCV XYZ Crew"
// 	special_role = "SCCV XYZ Crew"
// 	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew/captain
	short_name = "scc_scout_ship_captain"
	name = "SCCV XYZ Scout Ship Captain"
	desc = "You are the captain. Pilot the ship, lead your crew, start expeditions, explore worlds."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_captain")
	max_count = 1

	outfit = /datum/outfit/admin/scc_scout_ship_crew/captain
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCCV XYZ Captain"
	special_role = "SCCV XYZ Captain"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew/heph
	short_name = "scc_scout_ship_heph"
	name = "SCCV XYZ Scout Ship Hephaestus Crewman"
	desc = "You are a Hephaestus Industries crewman. Be the ship's engineer, or a cargo and fuel technician, or a miner, or a general crewman/assistant who knows a tiny bit of everything."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_heph")
	max_count = 1

	outfit = /datum/outfit/admin/scc_scout_ship_crew/heph
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCCV XYZ Crewman (Heph)"
	special_role = "SCCV XYZ Crewman (Heph)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew/zeng
	short_name = "scc_scout_ship_zeng"
	name = "SCCV XYZ Scout Ship Zeng-Hu Crewman"
	desc = "You are a Zeng-Hu Pharmaceuticals crewman. Be the ship's scientist, or a archeologist, or a physician, or a surgeon, or a general crewman/assistant who knows a tiny bit of everything."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_zeng")
	max_count = 1

	outfit = /datum/outfit/admin/scc_scout_ship_crew/zeng
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCCV XYZ Crewman (Zeng-Hu)"
	special_role = "SCCV XYZ Crewman (Zeng-Hu)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew/nanotrasen
	short_name = "scc_scout_ship_nanotrasen"
	name = "SCCV XYZ Scout Ship NanoTrasen Crewman"
	desc = "You are a NanoTrasen Corporation crewman. Be the ship's physician, or a surgeon, or a scientist, or a archeologist, or a general crewman/assistant who knows a tiny bit of everything."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_nanotrasen")
	max_count = 1

	outfit = /datum/outfit/admin/scc_scout_ship_crew/nanotrasen
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCCV XYZ Crewman (NanoTrasen)"
	special_role = "SCCV XYZ Crewman (NanoTrasen)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew/zavod
	short_name = "scc_scout_ship_zavod"
	name = "SCCV XYZ Scout Ship Zavod Crewman"
	desc = "You are a Zavodskoi Interstellar crewman. Be the ship's engineer, or a scientist, or a archeologist, or a general crewman/assistant who knows a tiny bit of everything."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_zavod")
	max_count = 1

	outfit = /datum/outfit/admin/scc_scout_ship_crew/zavod
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCCV XYZ Crewman (Zavod)"
	special_role = "SCCV XYZ Crewman (Zavod)"
	respawn_flag = null

// ---------------------- outfits

/datum/outfit/admin/scc_scout_ship_crew
	name = "SCCV XYZ Scout Ship Base Crew Uniform"

	id = /obj/item/card/id/orion_ship
	uniform = list(/obj/item/clothing/under/color/black, /obj/item/clothing/under/color/grey, /obj/item/clothing/under/color/white)
	shoes = /obj/item/clothing/shoes/jackboots
	back = list(/obj/item/storage/backpack/messenger, /obj/item/storage/backpack/duffel)
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless
	)

/datum/outfit/admin/scc_scout_ship_crew/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/clothing/accessory/offworlder/bracer, slot_in_backpack)
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
		H.equip_or_collect(new /obj/item/rig/light/offworlder, slot_in_backpack)

/datum/outfit/admin/scc_scout_ship_crew/get_id_access()
	return list(access_external_airlocks)

/datum/outfit/admin/scc_scout_ship_crew/captain
	name = "SCCV XYZ Scout Ship Captain"

	id = /obj/item/card/id/gold
	uniform = /obj/item/clothing/under/rank/captain/white
	back = list(/obj/item/storage/backpack/messenger/com, /obj/item/storage/backpack/duffel/cap)
	head = /obj/item/clothing/head/caphat/cap/beret
	gloves = /obj/item/clothing/gloves/captain/white
	accessory = /obj/item/clothing/accessory/sleevepatch/scc

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

	implants = list(
		/obj/item/implant/mindshield
	)

/datum/outfit/admin/scc_scout_ship_crew/heph
	name = "SCCV XYZ Scout Ship Hephaestus Crewman"

	id = /obj/item/card/id/hephaestus
	uniform = list(/obj/item/clothing/under/color/brown, /obj/item/clothing/under/color/green, /obj/item/clothing/under/serviceoveralls)
	head = list(/obj/item/clothing/head/beret/corporate/heph, /obj/item/clothing/head/hardhat/green)
	accessory = /obj/item/clothing/accessory/pin/corporate/heph

/datum/outfit/admin/scc_scout_ship_crew/zeng
	name = "SCCV XYZ Scout Ship Zeng-Hu Crewman"

	id = /obj/item/card/id/zeng_hu
	uniform = list(/obj/item/clothing/under/color/purple, /obj/item/clothing/under/color/white, /obj/item/clothing/under/rank/medical/surgeon/zeng)
	head = list(/obj/item/clothing/head/beret/corporate/zeng, /obj/item/clothing/head/softcap/zeng, /obj/item/clothing/head/surgery/zeng)
	accessory = /obj/item/clothing/accessory/pin/corporate/zeng

/datum/outfit/admin/scc_scout_ship_crew/nanotrasen
	name = "SCCV XYZ Scout Ship NanoTrasen Crewman"

	id = /obj/item/card/id
	uniform = list(/obj/item/clothing/under/color/blue, /obj/item/clothing/under/color/lightblue, /obj/item/clothing/under/rank/medical/surgeon)
	head = list(/obj/item/clothing/head/beret/corporate, /obj/item/clothing/head/softcap/nt, /obj/item/clothing/head/surgery)
	accessory = /obj/item/clothing/accessory/pin/corporate

/datum/outfit/admin/scc_scout_ship_crew/zavod
	name = "SCCV XYZ Scout Ship Zavodskoi Crewman"

	id = /obj/item/card/id/zavodskoi
	uniform = list(/obj/item/clothing/under/color/red, /obj/item/clothing/under/color/brown, /obj/item/clothing/under/rank/medical/surgeon/zavod)
	head = list(/obj/item/clothing/head/beret/corporate/zavod, /obj/item/clothing/head/softcap/zavod, /obj/item/clothing/head/beret/red, /obj/item/clothing/head/surgery/zavod)
	accessory = /obj/item/clothing/accessory/pin/corporate/zavod

