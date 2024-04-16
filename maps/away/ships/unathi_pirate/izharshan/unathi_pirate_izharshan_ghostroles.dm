/datum/ghostspawner/human/izharshan
	short_name = "izharshan_crew"
	name = "Izharshan Crewman"
	desc = "Quartermaster, Vesselhide, Gunner or mere Crew, whatever your role is, you will obey your captain, for your pirate clan and fleet, the Izharshan. NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")

	spawnpoints = list("izharshan_crew")
	max_count = 3

	outfit = /obj/outfit/admin/izharshan
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Izharshan Crewman"
	special_role = "Izharshan Crewman"
	respawn_flag = null
	extra_languages = list(LANGUAGE_AZAZIBA)

	uses_species_whitelist = FALSE

/datum/ghostspawner/human/izharshan/captain
	short_name = "izharshan_captain"
	name = "Izharshan Captain"
	desc = "Lead your ship for the honor and wealth of pirate clan and fleet Izharshan. Your ship has poor side armor, so be careful threatening ships with bigger guns, but your flechettes can intimidate the rest. If all else fails, you can bring the entire ship into boarding range. NOT AN ANTAGONIST! Do not act as such."
	max_count = 1
	uses_species_whitelist = TRUE

	spawnpoints = list("izharshan_captain")

	outfit = /obj/outfit/admin/izharshan/captain


	assigned_role = "Izharshan Captain"
	special_role = "Izharshan Captain"

/obj/item/clothing/under/unathi/izharshan
	color = "#f3840e"
	accent_color = "#f3840e"

/obj/item/clothing/suit/storage/toggle/asymmetriccoat/izharshan
	color = "#eed8c1"

/obj/outfit/admin/izharshan
	name = "Izharshan Crewman"

	uniform = /obj/item/clothing/under/unathi/izharshan
	shoes = /obj/item/clothing/shoes/sandals/caligae
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	accessory = /obj/item/clothing/accessory/storage/webbing
	gloves = /obj/item/clothing/gloves/unathi
	head = /obj/item/clothing/head/headbando/random


	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1
	)

/obj/outfit/admin/izharshan/get_id_access()
	return list(ACCESS_UNATHI_PIRATE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/izharshan/captain
	name = "Izharshan Captain"

	suit = /obj/item/clothing/suit/storage/toggle/asymmetriccoat/izharshan
	gloves = /obj/item/clothing/gloves/orange/unathi
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/projectile/pistol/spitter = 1)
	head = /obj/item/clothing/head/bandana/pirate

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/clothing/suit/space/void/unathi_pirate/captain = 1, //the best way to make sure only the captain takes his suit
		/obj/item/clothing/head/helmet/space/void/unathi_pirate/captain = 1,
		/obj/item/ammo_magazine/spitterpistol = 2
	)
