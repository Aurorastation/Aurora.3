/datum/ghostspawner/human/idris_cruiser_crew
	name = "Idris Cruise Crew Member"
	short_name = "idriscrew"
	desc = "Serve as the waiters, stewards, and maintenance crew of an Idris cruiser."
	tags = list("External")

	welcome_message = "You're a crewmember for an Idris cruise vessel. Keep your clients happy, your ship in tip-top shape, and your smile uniquely Idris!"

	spawnpoints = list("idriscrew")
	max_count = 4

	outfit = /datum/outfit/admin/idris_cruiser_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC_SHELL)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Idris Cruise Crew Member"
	special_role = "Idris Cruise Crew Member"
	respawn_flag = null

/datum/outfit/admin/idris_cruiser_crew
	name = "Idris Cruise Crew Member"
	uniform = /obj/item/clothing/under/librarian/idris
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/combat
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel/heph
	id = /obj/item/card/id/hephaestus
	backpack_contents = list(/obj/item/storage/box/survival = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/sandals/caligae/socks,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca
	)
	species_suit = list(
		SPECIES_UNATHI = /obj/item/clothing/accessory/poncho/unathimantle/hephaestus
	)
