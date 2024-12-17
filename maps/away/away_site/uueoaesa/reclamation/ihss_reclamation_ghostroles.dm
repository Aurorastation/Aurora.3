/datum/ghostspawner/human/ihss_reclamation
	name = "IHSS Reclamation Crew"
	short_name = "ihss_reclamation"
	desc = "Crew the IHSS Reclamation"
	tags = list("External")
	spawnpoints = list("ihss_crew")
	req_perms = null
	max_count = 4
	uses_species_whitelist = FALSE
	possible_species = list(SPECIES_UNATHI, SPECIES_VAURCA_WORKER, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	welcome_message = "You are a crewmember aboard the IHSS Reclamation, an Izweski Hegemony ecological monitoring and terraforming station for coordinating the restoration of the Moghes Wasteland.\
	IMPORTANT - If you choose to play a Vaurca, know that they are a very alien species, and difficult to roleplay. Reading the wiki page for the species is highly encouraged."
	assigned_role = "IHSS Reclamation Crewmember"
	special_role = "IHSS Reclamation Crewmember"
	extra_languages = list(LANGUAGE_UNATHI)
	respawn_flag = null

	outfit = /obj/outfit/admin/ihss_reclamation

/obj/outfit/admin/ihss_reclamation
	name = "IHSS Reclamation Crew"
	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/sandals/caligae/socks
	uniform = /obj/item/clothing/under/unathi
	l_ear = /obj/item/device/radio/headset/ship
	r_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/ihss_reclamation/get_id_access()
	return list(ACCESS_KATAPHRACT, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/ihss_reclamation/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/vaurca(H), slot_shoes)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()
	if(H.is_diona())
		H.equip_or_collect(new /obj/item/device/uv_light, slot_in_backpack)

/datum/ghostspawner/human/ihss_reclamation/security
	short_name = "ihss_security"
	name = "IHSS Reclamation Security"
	desc = "Protect the crew of the IHSS Reclamation"
	spawnpoints = list("ihss_security")
	max_count = 3
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	welcome_message = "You are security personnel aboard the IHSS Reclamation, an Izweski Hegemony ecological monitoring and terraforming station for coordinating the restoration of the Moghes Wasteland."
	assigned_role = "IHSS Reclamation Security"
	special_role = "IHSS Reclamation Security"
	outfit = /obj/outfit/admin/ihss_reclamation/security

/obj/outfit/admin/ihss_reclamation/security
	name = "IHSS Reclamation Security"
	belt = /obj/item/storage/belt/security/full
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = /obj/item/gun/energy/pistol/hegemony

/datum/ghostspawner/human/ihss_reclamation/captain
	short_name = "ihss_captain"
	name = "IHSS Reclamation Captain"
	desc = "Command the IHSS Reclamation"
	spawnpoints = list("ihss_captain")
	max_count = 1
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_UNATHI)
	welcome_message = "You are the captain of the IHSS Reclamation, an Izweski Hegemony ecological monitoring and terraforming station for coordinating the restoration of the Moghes Wasteland."
	assigned_role = "IHSS Reclamation Captain"
	special_role = "IHSS Reclamation Captain"
	outfit = /obj/outfit/admin/ihss_reclamation/captain

/obj/outfit/admin/ihss_reclamation/captain
	name = "IHSS Reclamation Captain"
	belt = /obj/item/melee/energy/sword/hegemony
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = /obj/item/gun/energy/pistol/hegemony

/obj/outfit/admin/ihss_reclamation/captain/get_id_access()
	return list(ACCESS_KATAPHRACT, ACCESS_KATAPHRACT_KNIGHT, ACCESS_EXTERNAL_AIRLOCKS)
