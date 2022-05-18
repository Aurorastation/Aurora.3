//space bar

/datum/ghostspawner/human/space_bar_bartender
	short_name = "space_bar_bartender"
	name = "Space Bar Bartender"
	desc = "Tender the space bar."
	tags = list("External")

	spawnpoints = list("space_bar_bartender")
	max_count = 1

	outfit = /datum/outfit/admin/space_bar_bartender
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Space Bar Bartender"
	special_role = "Space Bar Bartender"
	respawn_flag = null

/datum/outfit/admin/space_bar_bartender
	name = "Space Bar Bartender"

	uniform = /obj/item/clothing/under/rank/bartender/idris
	head = /obj/item/clothing/head/flatcap/bartender/idris
	suit = /obj/item/clothing/suit/storage/bartender/idris
	shoes = /obj/item/clothing/shoes/brown
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR =/obj/item/clothing/shoes/workboots/toeless
	)

	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/clothing/accessory/wcoat = 1)

/datum/outfit/admin/space_bar_bartender/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/space_bar_bartender/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/space_bar_chef
	short_name = "space_bar_chef"
	name = "Space Bar Chef"
	desc = "Cook for the space bar."
	tags = list("External")

	spawnpoints = list("space_bar_chef")
	max_count = 1

	outfit = /datum/outfit/admin/space_bar_chef
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Space Bar Chef"
	special_role = "Space Bar Chef"
	respawn_flag = null

/datum/outfit/admin/space_bar_chef
	name = "Space Bar Chef"

	uniform = /obj/item/clothing/under/rank/chef/idris
	suit = /obj/item/clothing/suit/chef/idris
	head = /obj/item/clothing/head/chefhat/idris
	shoes = /obj/item/clothing/shoes/brown
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR =/obj/item/clothing/shoes/workboots/toeless
	)

	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/datum/outfit/admin/space_bar_chef/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)

	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/space_bar_chef/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/space_bar_patron
	short_name = "space_bar_patron"
	name = "Space Bar Patron"
	desc = "Enjoy the space bar."
	tags = list("External")

	spawnpoints = list("space_bar_patron")
	max_count = 3

	outfit = /datum/outfit/admin/random/space_bar_patron
	species_outfits = list(SPECIES_VAURCA_WORKER = /datum/outfit/admin/random/space_bar_patron/vaurca,
					SPECIES_VAURCA_WARRIOR = /datum/outfit/admin/random/space_bar_patron/vaurca,
					SPECIES_HUMAN_OFFWORLD = /datum/outfit/admin/random/space_bar_patron/offworlder)
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Space Bar Patron"
	special_role = "Space Bar Patron"
	respawn_flag = null

/datum/outfit/admin/random/space_bar_patron
	l_ear = /obj/item/device/radio/headset/ship
	l_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/random/space_bar_patron/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H.shoes) //If they didn't get shoes, it's because they can't fit in them. Find something that works.
		var/obj/item/clothing/shoes/S = pick(/obj/item/clothing/shoes/sandal, /obj/item/clothing/shoes/footwraps, /obj/item/clothing/shoes/workboots/toeless, /obj/item/clothing/shoes/jackboots/toeless)
		H.equip_to_slot_or_del(new S, slot_shoes)

/datum/outfit/admin/random/space_bar_patron/vaurca
	mask = /obj/item/clothing/mask/breath/vaurca/filter
	r_pocket = /obj/item/reagent_containers/inhaler/phoron_special

/datum/outfit/admin/random/space_bar_patron/vaurca/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
	H.internal = preserve
	H.internals.icon_state = "internal1"

/datum/outfit/admin/random/space_bar_patron/offworlder
	r_pocket = /obj/item/storage/pill_bottle/rmt

