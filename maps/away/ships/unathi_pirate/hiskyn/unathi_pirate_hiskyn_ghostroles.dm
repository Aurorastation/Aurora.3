/datum/ghostspawner/human/hiskyn
	short_name = "hiskyn"
	name = "Hiskyn's Revanchist Crewman"
	desc = "Serve aboard a ship of the pirate fleet Hiskyn's Revanchists - former Kazhkz-Han'san Unathi who refused to join the Empire of Dominia. Obey your captain, defend your ship and crew, and keep an eye out for opportunities to shed some Kazhkz-Han'san blood! NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")
	welcome_message = "You are a pirate of Hiskyn's Revanchists, a fleet of former Kazhkz and Han'san Unathi who refused to join the Empire of Dominia. Obey your captain, search for opportunities to raid and plunder, and remember your fleet's deep hatred for Dominian Unathi. Though you are a pirate, remember that you are not an antagonist and should not be attacking the SCCV Horizon directly without a very good reason - though the Spark, Intrepid, Canary and any other ghostroles you might encounter are fair game."

	spawnpoints = list("hiskyn")
	max_count = 4

	outfit = /obj/outfit/admin/hiskyn_pirate
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hiskyn Crewman"
	special_role = "Hiskyn Crewman"
	respawn_flag = null
	extra_languages = list(LANGUAGE_AZAZIBA)

	uses_species_whitelist = FALSE

/datum/ghostspawner/human/hiskyn/captain
	short_name = "hiskyn_captain"
	name = "Hiskyn's Revanchist Captain"
	desc = "Command a ship of Hiskyn's Revanchists - lead your crew to plunder, glory, and revenge on the Kazhkz-Han'san traitors and their new human masters. NOT AN ANTAGONIST! Do not act as such."
	max_count = 1
	uses_species_whitelist = TRUE

	spawnpoints = list("hiskyn_captain")

	outfit = /obj/outfit/admin/hiskyn_pirate/captain


	assigned_role = "Hiskyn Captain"
	special_role = "Hiskyn Captain"

/obj/outfit/admin/hiskyn_pirate
	name = "Hiskyn Revanchist"
	uniform = /obj/item/clothing/under/unathi/hiskyn
	shoes = /obj/item/clothing/shoes/sandals/caligae
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/unathi
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1
	)

/obj/outfit/admin/hiskyn_pirate/get_id_access()
	return list(ACCESS_UNATHI_PIRATE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/hiskyn_pirate/captain
	gloves = /obj/item/clothing/gloves/black_leather/unathi
	suit = /obj/item/clothing/suit/storage/toggle/asymmetriccoat/hiskyn
