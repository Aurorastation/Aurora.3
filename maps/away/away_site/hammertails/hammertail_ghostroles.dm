/datum/ghostspawner/human/hammertail
	name = "Hammertail Smith"
	short_name = "hammertail"
	desc = "Crew a Hammertail Smiths manufacturing station, hidden within a local asteroid. Sell guns, make money, stay alive."
	tags = list("External")
	spawnpoints = list("hammertail")
	max_count = 4
	outfit = /obj/outfit/admin/hammertail
	possible_species = list(SPECIES_UNATHI)
	uses_species_whitelist = FALSE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hammertail Smith"
	special_role = "Hammertail Smith"
	respawn_flag = null
	welcome_message = "You are a member of the Hammertail Smiths, a criminal guild of smugglers and arms dealers, aboard one of your guild's manufacturing stations. Produce and sell weapons, equipment and other illegal goods - preferably without getting caught."

/obj/outfit/admin/hammertail
	name = "Hammertail Smith"
	uniform = /obj/item/clothing/under/syndicate/hammertail
	shoes = /obj/item/clothing/shoes/workboots/toeless/brown
	l_ear = /obj/item/device/radio/headset/ship
	r_pocket = /obj/item/storage/wallet/random
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel/eng
	backpack_contents = list(
		/obj/item/storage/box/survival = 1
	)
	gloves = /obj/item/clothing/gloves/yellow/specialu
	belt = /obj/item/storage/belt/utility/very_full

/obj/outfit/admin/hammertail/get_id_access()
	return list(ACCESS_HAMMERTAILS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/hammertail/overseer
	name = "Hammertail Overseer"
	short_name = "hammertail_boss"
	desc = "Command a Hammertail Smiths manufacturing station, hidden within a local asteroid. Sell guns, make money, stay alive."
	spawnpoints = list("hammertail_boss")
	max_count = 1
	uses_species_whitelist = TRUE
	assigned_role = "Hammertail Overseer"
	special_role = "Hammertail Overseer"
	welcome_message = "You are a senior member of the Hammertail Smiths, a criminal guild of smugglers and arms dealers, in command of a manufacturing station in the sector. Produce and sell weapons, equipment and other illegal goods - preferably without getting caught."
