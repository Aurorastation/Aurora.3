/datum/ghostspawner/human/air_konyang
	name = "Air Konyang Crew"
	short_name = "air_konyang"
	desc = "Crew an Air Konyang passenger liner."
	tags = list("External")
	spawnpoints = list("air_konyang")
	max_count = 2

	outfit = /obj/outfit/admin/konyang/air_konyang
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Air Konyang Crew"
	special_role = "Air Konyang Crew"
	respawn_flag = null
	away_site = TRUE

/datum/ghostspawner/human/air_konyang/pilot
	name = "Air Konyang Pilot"
	short_name = "air_konyang_pilot"
	desc = "Pilot an Air Konyang passenger liner."
	max_count = 1
	assigned_role = "Air Konyang Pilot"
	special_role = "Air Konyang Pilot"

/datum/ghostspawner/human/air_konyang/passenger
	name = "Air Konyang Passenger"
	short_name = "air_konyang_passenger"
	desc = "Travel aboard an Air Konyang passenger liner"
	max_count = 4
	assigned_role = "Air Konyang Passenger"
	special_role = "Air Konyang Passenger"
	outfit = /obj/outfit/admin/konyang/civ

/obj/outfit/admin/konyang/air_konyang
	name = "Air Konyang Crew"
	uniform = /obj/item/clothing/under/sl_suit //placeholder until we get uniforms
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	l_ear = /obj/item/device/radio/headset/ship

/obj/outfit/admin/konyang/civ
	name = "Konyanger Civilian"
	uniform = list(
		/obj/item/clothing/under/konyang,
		/obj/item/clothing/under/konyang/male,
		/obj/item/clothing/under/konyang/blue,
		/obj/item/clothing/under/konyang/pink
	)
	shoes = list(
		/obj/item/clothing/shoes/sneakers/hitops/black,
		/obj/item/clothing/shoes/konyang
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/konyang,
		/obj/item/clothing/suit/storage/toggle/konyang/blue,
		/obj/item/clothing/suit/storage/toggle/konyang/dbjacket,
		/obj/item/clothing/suit/storage/toggle/konyang/orange,
		/obj/item/clothing/suit/storage/toggle/konyang/pants
	)
	back = /obj/item/storage/backpack/satchel/leather
	id = null
	l_pocket = /obj/item/storage/wallet/random
	l_ear = null
