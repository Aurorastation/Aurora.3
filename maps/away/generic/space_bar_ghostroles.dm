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

	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/clothing/accessory/wcoat = 1)

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
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/datum/outfit/admin/space_bar_chef/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/space_bar_patron
	short_name = "space_bar_patron"
	name = "Space Bar Patron"
	desc = "Enjoy the space bar."
	tags = list("External")

	spawnpoints = list("space_bar_patron")
	max_count = 3

	outfit = /datum/outfit/admin/random/space_bar
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Space Bar Patron"
	special_role = "Space Bar Patron"
	respawn_flag = null

/datum/outfit/admin/random/space_bar
	l_ear = /obj/item/device/radio/headset/ship