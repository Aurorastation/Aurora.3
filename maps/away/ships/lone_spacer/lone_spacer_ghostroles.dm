/datum/ghostspawner/human/lone_spacer
	short_name = "lone_spacer"
	name = "Lone Spacer"
	desc = "You never did mind the quiet. By whatever path your life has taken, you have found yourself the captain and sole crew of a small warp-capable vessel, scratching out a meek living from the stars. Are you a scientist, exploring the great unknown, or an opportunist scavenger? Are you a vicious pirate, or a hounded fugitive? You have only to decide for yourself."
	tags = list("External")

	spawnpoints = list("lone_spacer")
	max_count = 1

	outfit = /obj/outfit/admin/lone_spacer
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Independent Spacer"
	respawn_flag = null

/obj/outfit/admin/lone_spacer
	name = "Lone Spacer"

	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/industrial
	accessory = /obj/item/clothing/accessory/scarf/lone_spacer_green

	id = /obj/item/card/id/lone_spacer_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/jackboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/jackboots/toeless
	)

/obj/outfit/admin/lone_spacer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data(TRUE) // Allows for untagged synthetics.

/obj/outfit/admin/lone_spacer/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_LONE_SPACER)

/obj/item/card/id/lone_spacer_ship
	name = "independent ship id"
	access = list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_LONE_SPACER)
