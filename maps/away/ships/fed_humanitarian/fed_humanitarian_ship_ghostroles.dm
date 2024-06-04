/datum/ghostspawner/human/fed_humanitarian
	short_name = "fed_humanitarian"
	name = "Nralakk Humanitarian Worker"
	desc = "You are a worker aboard a Nralakk Federation humanitarian vessel, sent to aid the Izweski Hegemony."
	tags = list("External")
	spawnpoints = list("fed_humanitarian")

	req_perms = null
	max_count = 3
	uses_species_whitelist = FALSE
	outfit = /obj/outfit/admin/fed_humanitarian
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nralakk Humanitarian Worker"
	special_role = "Nralakk Humanitarian Worker"
	respawn_flag = null
	extra_languages = list(LANGUAGE_SKRELLIAN)
	away_site = TRUE

/datum/ghostspawner/human/fed_humanitarian/security
	short_name = "fed_humanitarian_sec"
	name = "Nralakk Humanitarian Security Officer"
	desc = "You are a security guard aboard a Nralakk Federation humanitarian vessel, sent to aid the Izweski Hegemony."
	spawnpoints = list("fed_humanitarian_sec")
	max_count = 2
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WARRIOR, SPECIES_DIONA)
	outfit = /obj/outfit/admin/fed_humanitarian/security
	assigned_role = "Nralakk Security Officer"
	special_role = "Nralakk Security Officer"

/datum/ghostspawner/human/fed_humanitarian/captain
	short_name = "fed_humanitarian_captain"
	name = "Nralakk Humanitarian Captain"
	desc = "You are the captain aboard a Nralakk Federation humanitarian vessel, sent to aid the Izweski Hegemony."
	max_count = 1
	spawnpoints = list("fed_humanitarian_captain")
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	outfit = /obj/outfit/admin/fed_humanitarian/captain
	assigned_role = "Nralakk Humanitarian Captain"
	special_role = "Nralakk Humanitarian Captain"

/obj/outfit/admin/fed_humanitarian
	name = "Nralakk Humanitarian Worker"
	uniform = /obj/item/clothing/under/skrell/wetsuit
	shoes = /obj/item/clothing/shoes/workboots/dark
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/clothing/accessory/badge/passport/nralakk
	species_shoes = list(
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca,
		SPECIES_DIONA = null,
		SPECIES_DIONA_COEUS = null
	)

/obj/outfit/admin/fed_humanitarian/security
	name = "Nralakk Security Officer"
	uniform = /obj/item/clothing/under/skrell/nralakk/ix/security
	shoes = /obj/item/clothing/shoes/jackboots/kala
	gloves = /obj/item/clothing/gloves/combat
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/fedpistol = 1)

/obj/outfit/admin/fed_humanitarian/captain
	uniform = /obj/item/clothing/under/skrell/nralakk/oqi/security
	shoes = /obj/item/clothing/shoes/jackboots/kala
	suit = /obj/item/clothing/accessory/poncho/shouldercape/nationcapes
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/energy/fedpistol = 1)

/obj/outfit/admin/fed_humanitarian/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca, slot_wear_mask)
		if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
			var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
			H.internal = preserve
			H.internals.icon_state = "internal1"
		var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/cthur(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()

/obj/outfit/admin/fed_humanitarian/get_id_access()
	return list(ACCESS_SKRELL, ACCESS_EXTERNAL_AIRLOCKS)
