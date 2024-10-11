//rangers

/datum/ghostspawner/human/ranger
	short_name = "ranger"
	name = "Coalition Ranger"
	desc = "Crew the Ranger gunboat. Protect the interests of the Coalition of Colonies and your member-state."
	tags = list("External")

	spawnpoints = list("ranger")
	max_count = 4

	outfit = /obj/outfit/admin/ranger
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Frontier Ranger"
	special_role = "Frontier Ranger"
	faction = "Frontier Protection Bureau"
	respawn_flag = null

/obj/outfit/admin/ranger
	name = "Coalition Ranger"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/ranger_ship

	l_ear = /obj/item/device/radio/headset/ship/coalition_navy

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/ranger/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_COALITION, ACCESS_COALITION_NAVY)

// Only one role, to represent that synthetics are uncommon in the Rangers. As of 13/09/2024, Tajara or Skrell being available here isn't wanted by lore.
/datum/ghostspawner/human/ranger/ranger_synthetic
	short_name = "ranger_synthetic"
	name = "Coalition Ranger Synthetic"
	desc = "You are a self-owned synthetic serving with the Frontier Protection Bureau, one of few in the human-dominated organization. Protect the interests of the Coalition of Colonies and your member-state."
	uses_species_whitelist = TRUE

	spawnpoints = list("ranger_synthetic")
	max_count = 1

	outfit = /obj/outfit/admin/ranger
	possible_species = list(SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Frontier Ranger"
	special_role = "Frontier Ranger"

/obj/outfit/admin/ranger/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isipc(H)) // All Ranger synthetics are tagged, self-owned, and have Coalition citizenship.
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
			tag.ownership_info = IPC_OWNERSHIP_SELF
			tag.citizenship_info = CITIZENSHIP_COALITION

/datum/ghostspawner/human/ranger/captain
	short_name = "ranger_leader"
	name = "Coalition Ranger Leader"
	desc = "Lead the Ranger gunboat. Protect the interests of the Coalition of Colonies and your member-state."

	spawnpoints = list("ranger_leader")
	max_count = 1

	outfit = /obj/outfit/admin/ranger/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Frontier Ranger Leader"
	special_role = "Frontier Ranger Leader"

/obj/outfit/admin/ranger/captain
	name = "Coalition Ranger Leader"

	accessory = /obj/item/clothing/accessory/sash/red

/obj/item/card/id/ranger_ship
	name = "ranger ship id"
	access = list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_COALITION, ACCESS_COALITION_NAVY)
