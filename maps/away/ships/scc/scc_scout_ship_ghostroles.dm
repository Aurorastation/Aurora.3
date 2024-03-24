
// ---------------------- spawners

/datum/ghostspawner/human/scc_scout_ship_crew_captain
	short_name = "scc_scout_ship_captain"
	name = "SCC Scout Ship Captain"
	desc = "You are the captain. Pilot the ship, lead your crew, start expeditions, explore worlds."
	welcome_message = "You are the captain, ultimate authority on this ship, but that authority does not extend anywhere else so do not try to boss around other SCC ships. Your mission is to scout, survey, and explore the stars, and you have a crew that depends on you. But if another SCC ship needs help you may provide it, just remember your own ship is not equipped for combat at all."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_captain")
	max_count = 1

	outfit = /obj/outfit/admin/scc_scout_ship_crew/captain
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL,SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Scout Ship Captain"
	special_role = "SCC Scout Ship Captain"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew_orion
	short_name = "scc_scout_ship_orion"
	name = "SCC Scout Ship Orion Express Crew"
	desc = "You are a Orion Express crew member. Be the ship's mechanist, cargo and fuel technician, miner, chef, or a general crew/assistant who knows a tiny bit of everything."
	welcome_message = "You are a Orion Express crew member. Listen to your captain, do the job appropriate for your corporation, explore, survey, and scout the stars."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_orion")
	max_count = 1

	outfit = /obj/outfit/admin/scc_scout_ship_crew/orion
	possible_species = list(\
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, \
		SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_UNBRANDED, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, \
		SPECIES_DIONA, SPECIES_DIONA_COEUS, \
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, \
		SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, \
		SPECIES_UNATHI, \
		SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, \
	)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Scout Ship Crew (Orion)"
	special_role = "SCC Scout Ship Crew (Orion)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew_heph
	short_name = "scc_scout_ship_heph"
	name = "SCC Scout Ship Hephaestus Crew"
	desc = "You are a Hephaestus Industries crew member. Be the ship's engineer, cargo and fuel technician, a miner, or a general crew/assistant who knows a tiny bit of everything."
	welcome_message = "You are a Hephaestus Industries crew member. Listen to your captain, do the job appropriate for your corporation, explore, survey, and scout the stars."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_heph")
	max_count = 1

	outfit = /obj/outfit/admin/scc_scout_ship_crew/heph
	possible_species = list(\
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, \
		SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_UNBRANDED, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, \
		SPECIES_DIONA, SPECIES_DIONA_COEUS, \
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, \
		SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, \
		SPECIES_UNATHI, \
		SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, \
	)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Scout Ship Crew (Heph)"
	special_role = "SCC Scout Ship Crew (Heph)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew_zeng
	short_name = "scc_scout_ship_zeng"
	name = "SCC Scout Ship Zeng-Hu Crew"
	desc = "You are a Zeng-Hu Pharmaceuticals crew member. Be the ship's scientist, archeologist, physician, surgeon, or a general crew/assistant who knows a tiny bit of everything."
	welcome_message = "You are a Zeng-Hu Pharmaceuticals crew member. Listen to your captain, do the job appropriate for your corporation, explore, survey, and scout the stars."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_zeng")
	max_count = 1

	outfit = /obj/outfit/admin/scc_scout_ship_crew/zeng
	possible_species = list(\
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, \
		SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_UNBRANDED, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, \
		SPECIES_DIONA, SPECIES_DIONA_COEUS, \
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, \
		SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, \
	)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Scout Ship Crew (Zeng-Hu)"
	special_role = "SCC Scout Ship Crew (Zeng-Hu)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew_nanotrasen
	short_name = "scc_scout_ship_nanotrasen"
	name = "SCC Scout Ship NanoTrasen Crew"
	desc = "You are a NanoTrasen Corporation crew member. Be the ship's physician, surgeon, scientist, archeologist, or a general crew/assistant who knows a tiny bit of everything."
	welcome_message = "You are a NanoTrasen Corporation crew member. Listen to your captain, do the job appropriate for your corporation, explore, survey, and scout the stars."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_nanotrasen")
	max_count = 1

	outfit = /obj/outfit/admin/scc_scout_ship_crew/nanotrasen
	possible_species = list(\
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, \
		SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_UNBRANDED, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, \
		SPECIES_DIONA, SPECIES_DIONA_COEUS, \
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, \
		SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, \
		SPECIES_UNATHI, \
		SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, \
	)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Scout Ship Crew (NanoTrasen)"
	special_role = "SCC Scout Ship Crew (NanoTrasen)"
	respawn_flag = null

/datum/ghostspawner/human/scc_scout_ship_crew_zavod
	short_name = "scc_scout_ship_zavod"
	name = "SCC Scout Ship Zavod Crew"
	desc = "You are a Zavodskoi Interstellar crew member. Be the ship's engineer, scientist, archeologist, or a general crew/assistant who knows a tiny bit of everything."
	welcome_message = "You are a Zavodskoi Interstellar crew member. Listen to your captain, do the job appropriate for your corporation, explore, survey, and scout the stars."
	tags = list("External")

	spawnpoints = list("scc_scout_ship_zavod")
	max_count = 1

	outfit = /obj/outfit/admin/scc_scout_ship_crew/zavod
	possible_species = list(\
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, \
		SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_UNBRANDED, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, \
		SPECIES_DIONA, SPECIES_DIONA_COEUS, \
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, \
		SPECIES_UNATHI, \
		SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, \
	)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Scout Ship Crew (Zavod)"
	special_role = "SCC Scout Ship Crew (Zavod)"
	respawn_flag = null

// ---------------------- outfits

/obj/outfit/admin/scc_scout_ship_crew
	name = "SCC Scout Ship Base Crew Uniform"

	id = /obj/item/card/id/orion_ship
	uniform = list(/obj/item/clothing/under/color/black, /obj/item/clothing/under/color/grey, /obj/item/clothing/under/color/white)
	shoes = /obj/item/clothing/shoes/jackboots
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

/obj/outfit/admin/scc_scout_ship_crew/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)
		var/list/fullname = splittext(H.name, " ")
		var/surname = fullname[fullname.len]
		switch(surname)
			if("K'lax")
				var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
			if("C'thur")
				var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/clothing/accessory/offworlder/bracer, slot_in_backpack)
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
		H.equip_or_collect(new /obj/item/rig/light/offworlder, slot_in_backpack)
	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/scc_scout_ship_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS,
		ACCESS_SECURITY, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_RESEARCH, ACCESS_CARGO,
	)

/obj/outfit/admin/scc_scout_ship_crew/captain
	name = "SCC Scout Ship Captain"

	id = /obj/item/card/id/gold
	uniform = /obj/item/clothing/under/rank/captain/white
	back = list(/obj/item/storage/backpack/messenger/com, /obj/item/storage/backpack/satchel/cap)
	head = /obj/item/clothing/head/caphat/cap/beret
	gloves = /obj/item/clothing/gloves/captain/white
	accessory = /obj/item/clothing/accessory/sleevepatch/scc

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

	implants = list(
		/obj/item/implant/mindshield
	)

/obj/outfit/admin/scc_scout_ship_crew/captain/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS,
		ACCESS_SECURITY, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_RESEARCH, ACCESS_CARGO,
		ACCESS_HEADS, ACCESS_CAPTAIN,
	)

/obj/outfit/admin/scc_scout_ship_crew/orion
	name = "SCC Scout Ship Orion Crew"

	id = /obj/item/card/id/orion
	uniform = list(/obj/item/clothing/under/color/white, /obj/item/clothing/under/color/black, /obj/item/clothing/under/service_overalls)
	back = list(/obj/item/storage/backpack/messenger/orion, /obj/item/storage/backpack/satchel/orion)
	head = list(/obj/item/clothing/head/beret/corporate/orion, /obj/item/clothing/head/hardhat/white, /obj/item/clothing/head/softcap/orion_custodian)
	accessory = /obj/item/clothing/accessory/pin/corporate/orion

/obj/outfit/admin/scc_scout_ship_crew/heph
	name = "SCC Scout Ship Hephaestus Crew"

	id = /obj/item/card/id/hephaestus
	uniform = list(/obj/item/clothing/under/color/brown, /obj/item/clothing/under/color/green, /obj/item/clothing/under/service_overalls)
	back = list(/obj/item/storage/backpack/messenger/heph, /obj/item/storage/backpack/satchel/heph)
	head = list(/obj/item/clothing/head/beret/corporate/heph, /obj/item/clothing/head/hardhat/green, /obj/item/clothing/head/sidecap/heph)
	accessory = /obj/item/clothing/accessory/pin/corporate/heph

/obj/outfit/admin/scc_scout_ship_crew/zeng
	name = "SCC Scout Ship Zeng-Hu Crew"

	id = /obj/item/card/id/zeng_hu
	uniform = list(/obj/item/clothing/under/color/purple, /obj/item/clothing/under/color/white, /obj/item/clothing/under/rank/medical/surgeon/zeng)
	back = list(/obj/item/storage/backpack/messenger/zeng, /obj/item/storage/backpack/satchel/zeng)
	head = list(/obj/item/clothing/head/beret/corporate/zeng, /obj/item/clothing/head/softcap/zeng, /obj/item/clothing/head/surgery/zeng)
	accessory = /obj/item/clothing/accessory/pin/corporate/zeng

/obj/outfit/admin/scc_scout_ship_crew/nanotrasen
	name = "SCC Scout Ship NanoTrasen Crew"

	id = /obj/item/card/id
	uniform = list(/obj/item/clothing/under/color/blue, /obj/item/clothing/under/color/lightblue, /obj/item/clothing/under/rank/medical/surgeon)
	back = list(/obj/item/storage/backpack/messenger/nt, /obj/item/storage/backpack/satchel/nt)
	head = list(/obj/item/clothing/head/beret/corporate, /obj/item/clothing/head/softcap/nt, /obj/item/clothing/head/surgery)
	accessory = /obj/item/clothing/accessory/pin/corporate

/obj/outfit/admin/scc_scout_ship_crew/zavod
	name = "SCC Scout Ship Zavodskoi Crew"

	id = /obj/item/card/id/zavodskoi
	uniform = list(/obj/item/clothing/under/color/red, /obj/item/clothing/under/color/brown, /obj/item/clothing/under/rank/medical/surgeon/zavod)
	back = list(/obj/item/storage/backpack/messenger/zavod, /obj/item/storage/backpack/satchel/zavod)
	head = list(/obj/item/clothing/head/beret/corporate/zavod, /obj/item/clothing/head/softcap/zavod, /obj/item/clothing/head/sidecap/zavod, /obj/item/clothing/head/surgery/zavod)
	accessory = /obj/item/clothing/accessory/pin/corporate/zavod

