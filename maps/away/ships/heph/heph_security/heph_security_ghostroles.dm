/datum/ghostspawner/human/heph_security
	name = "Hephaestus Asset Protection Agent"
	short_name = "hephsec"
	desc = "Crew a Hephaestus asset protection vessel. Ensure the company's operations in the sector stay secure and profitable."
	tags = list("External")

	welcome_message = "You are an asset protection agent for Hephaestus Industries, assigned to keeping the company's assets in this sector in one piece. Follow your leader's orders, and make sure nothing impacts the bottom line. Remember, you are not SCC/Horizon crew. While you can help them with problems if they ask you are under no obligation to, and you hsoud not be showing up uncalled for to act as Security+ for the Horizon."

	spawnpoints = list("hephsec")
	max_count = 4

	outfit = /obj/outfit/admin/heph_security
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Asset Protection Agent"
	special_role = "Hephaestus Asset Protection Agent"
	respawn_flag = null

/obj/outfit/admin/heph_security
	name = "Hephaestus Asset Protection"
	uniform = /obj/item/clothing/under/ert/hephaestus
	head = /obj/item/clothing/head/hephaestus_military
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel/heph
	id = /obj/item/card/id/hephaestus
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/sandals/caligae/socks,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/vaurca
	)
	species_suit = list(
		SPECIES_UNATHI = /obj/item/clothing/accessory/poncho/unathimantle/hephaestus
	)

/obj/outfit/admin/heph_security/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
	if(H?.wear_suit)
		H.wear_suit.color = pick("#4f3911", "#292826")
	if(isipc(H))
		var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
		if(istype(tag))
			tag.modify_tag_data()

/obj/outfit/admin/heph_security/get_id_access()
	return list(ACCESS_HEPHAESTUS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/heph_security/captain
	name = "Hephaestus Asset Protection Squad Leader"
	short_name = "hephsec_boss"
	desc = "Command a Hephaestus asset protection vessel. Ensure that your crew keeps the company's investments in the sector safe, secure and profitable. Keep an eye out for any unions."
	welcome_message = "You are the leader of a Hephaestus Industries asset protection squad, assigned to keeping the company's assets in this sector in one piece. Keep your team in line, and make sure nothing impacts the bottom line. Remember, you are not SCC/Horizon crew. While you can help them with problems if they ask you are under no obligation to, and you hsoud not be showing up uncalled for to act as Security+ for the Horizon."
	spawnpoints = list("hephsec_boss")

	outfit = /obj/outfit/admin/heph_security/captain
	max_count = 1
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_UNATHI)
	assigned_role = "Hephaestus Asset Protection Squad Leader"
	special_role = "Hephaestus Asset Protection Squad Leader"

/obj/outfit/admin/heph_security/captain
	name = "Hephaestus Asset Protection Squad Leader"
	uniform = /obj/item/clothing/under/ert/hephaestus/leader
	head = /obj/item/clothing/head/caphat/cap/hephaestus
