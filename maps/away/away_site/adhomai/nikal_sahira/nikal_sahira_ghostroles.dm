#define CREVUS_GENERIC_SPECIES list(\
	SPECIES_TAJARA, \
	 SPECIES_TAJARA_ZHAN, \
	 SPECIES_TAJARA_MSAI, \
	 SPECIES_HUMAN \
)

// ---------- Chef

/datum/ghostspawner/human/crevus_chef
	short_name = "crevus_chef"
	name = "Placeholder Chef"
	desc = "Run placeholder's kitchen, cook whatever your guests request. Complain when your guests know all about pacojet."
	tags = list("External")
	spawnpoints = list("crevus_chef")
	max_count = 2
	outfit = /obj/outfit/admin/crevus_chef
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Placeholder Chef"
	special_role = "Placeholder Chef"
	respawn_flag = null

/obj/outfit/admin/crevus_chef
	name = "Crevus Chef"
	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	suit = /obj/item/clothing/suit/chef_jacket/nt
	r_pocket = /obj/item/storage/wallet/random

// ---------- Attendant

/datum/ghostspawner/human/crevus_attendant
	short_name = "crevus_attendant"
	name = "Placeholder Attendant"
	desc = "Serve the guests of Placeholder, either run the bar or serve the orders - or do both. Give dead eye to the non-tippers."
	tags = list("External")
	spawnpoints = list("crevus_attendant")
	max_count = 3
	outfit = /obj/outfit/admin/konyang/zh
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Placeholder Attendant"
	special_role = "Placeholder Attendant"
	respawn_flag = null


#undef CREVUS_GENERIC_SPECIES
