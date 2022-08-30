
// ---------------------- spawners
/datum/ghostspawner/human/scc_scout_ship_crew
	short_name = "scc_scout_ship_crew"
	name = "SCCV XYZ Scout Ship Crew"
	desc = ""
	tags = list("External")

	spawnpoints = list("scc_scout_ship_crew")
	max_count = 3

	outfit = /datum/outfit/admin/scc_scout_ship_crew
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCCV XYZ Crew"
	special_role = "SCCV XYZ Crew"
	respawn_flag = null

// /datum/ghostspawner/human/scc_scout_ship_crew/captain
// 	short_name = "scc_scout_ship_captain"
// 	name = "SCCV XYZ Scout Ship Captain"
// 	desc = ""
// 	tags = list("External")

// 	spawnpoints = list("scc_scout_ship_captain")
// 	max_count = 3

// 	outfit = /datum/outfit/admin/scc_scout_ship_crew/captain
// 	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
// 	allow_appearance_change = APPEARANCE_PLASTICSURGERY

// 	assigned_role = "SCCV XYZ Captain"
// 	special_role = "SCCV XYZ Captain"
// 	respawn_flag = null

// /datum/ghostspawner/human/scc_scout_ship_crew/engineer
// 	short_name = "scc_scout_ship_engineer"
// 	name = "SCCV XYZ Scout Ship Engineer"
// 	desc = ""
// 	tags = list("External")

// 	spawnpoints = list("scc_scout_ship_engineer")
// 	max_count = 3

// 	outfit = /datum/outfit/admin/scc_scout_ship_crew/engineer
// 	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI)
// 	allow_appearance_change = APPEARANCE_PLASTICSURGERY

// 	assigned_role = "SCCV XYZ Crew"
// 	special_role = "SCCV XYZ Crew"
// 	respawn_flag = null

// /datum/ghostspawner/human/scc_scout_ship_crew/scientist
// 	short_name = "scc_scout_ship_scientist"
// 	name = "SCCV XYZ Scout Ship Scientist"
// 	desc = ""
// 	tags = list("External")

// 	spawnpoints = list("scc_scout_ship_scientist")
// 	max_count = 1

// 	outfit = /datum/outfit/admin/scc_scout_ship_crew/scientist
// 	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI)
// 	allow_appearance_change = APPEARANCE_PLASTICSURGERY

// 	assigned_role = "SCCV XYZ Crew"
// 	special_role = "SCCV XYZ Crew"
// 	respawn_flag = null

// ---------------------- outfits

/datum/outfit/admin/scc_scout_ship_crew
	name = "SCCV XYZ Scout Ship Crew"

	uniform = list(/obj/item/clothing/under/color/black, /obj/item/clothing/under/color/grey, /obj/item/clothing/under/color/white)
	suit = /obj/item/clothing/suit/storage/toggle/brown_jacket/scc
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/messenger

	//id = /obj/item/card/id/orion_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR =/obj/item/clothing/shoes/jackboots/toeless
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
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/scc_scout_ship_crew/get_id_access()
	return list(access_external_airlocks)

// /datum/outfit/admin/scc_scout_ship_crew/captain
// 	name = "SCCV XYZ Scout Ship Captain"

// 	uniform = list(/obj/item/clothing/under/rank/captain/white, /obj/item/clothing/under/rank/captain)
// 	suit = list(/obj/item/clothing/suit/storage/toggle/brown_jacket/scc, /obj/item/clothing/suit/captunic/capjacket)
// 	shoes = /obj/item/clothing/shoes/jackboots
// 	back = /obj/item/storage/backpack/messenger/com
// 	head = list(/obj/item/clothing/head/caphat/cap, /obj/item/clothing/head/caphat/cap/white, /obj/item/clothing/head/caphat/cap/beret)
// 	gloves = /obj/item/clothing/gloves/black

// 	//id = /obj/item/card/id/orion_ship

// 	l_ear = /obj/item/device/radio/headset/ship

// 	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

