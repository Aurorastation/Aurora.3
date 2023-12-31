/datum/map_template/ruin/exoplanet/konyang_telecomms_outpost
	name = "Konyang Telecomms Outpost"
	id = "konyang_telecomms_outpost"
	description = "A remote telecommunications relay, operated by two particularly bored soldiers of the Konyang Armed Forces."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/telecomms_outpost.dmm")

/area/konyang_telecomms_outpost
	name = "Konyang Telecomms Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/datum/ghostspawner/human/konyang_telecomms
	short_name = "konyang_telecomms"
	name = "Konyang Army Telecomm Operator"
	desc = "Man a telecommunications relay on Konyang. (OOC Note: All characters must be of Konyang ethnic origin and background, this is enforceable by admin/moderator action.)"
	tags = list("External")
	mob_name_prefix = "SPC. "
	welcome_message = "You are a soldier of the Konyang Army, monitoring and operating a remote telecommunications relay."

	spawnpoints = list("konyang_telecomms")
	max_count = 2

	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /datum/outfit/admin/konyang_army
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Konyang Army Telecomm Operator"
	special_role = "Konyang Army Telecomm Operator"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/solarian)
	origin_restriction = list(/singleton/origin_item/origin/konyang)

/datum/outfit/admin/konyang_army
	name = "Konyang Army"
	uniform = /obj/item/clothing/under/rank/konyang
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/konyang/army
	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/device/radio
	back = /obj/item/storage/backpack/rucksack/green
	id = /obj/item/card/id/konyang_army

/datum/outfit/admin/konyang_army/get_id_access()
	return list(ACCESS_KONYANG_POLICE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/item/card/id/konyang_army
	name = "konyang army id"
	access = list(ACCESS_KONYANG_POLICE, ACCESS_EXTERNAL_AIRLOCKS)

