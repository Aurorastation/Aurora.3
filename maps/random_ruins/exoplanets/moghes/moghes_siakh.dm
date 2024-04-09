/datum/map_template/ruin/exoplanet/moghes_siakh
	name = "Si'akh Pilgrims"
	id = "moghes_siakh"
	description = "A group of Si'akh pilgrims in the Wasteland."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	suffixes = list("moghes/moghes_siakh.dmm")

/datum/ghostspawner/human/moghes_siakh
	name = "Si'akh Pilgrim"
	short_name = "moghes_siakh"
	desc = "Wander the Wasteland, in search of repentance for the sins of the Unathi."
	tags = list("External")
	welcome_message = "You are a follower of the Si'akh faith, wandering the Wasteland as your Prophet once did. Survive, and seek repentance for the sins of the Contact War, as the Prophet Si'akh commands."

	max_count = 2
	spawnpoints = list("moghes_siakh")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_siakh
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Si'akh Pilgrim"
	special_role = "Si'akh Pilgrim"
	respawn_flag = null

/datum/ghostspawner/human/moghes_siakh/reaver
	name = "Si'akh Reaver of the Flame"
	short_name = "moghes_siakh_reaver"
	desc = "Wander the Wasteland, in search of repentance for the sins of the Unathi."
	tags = list("External")
	welcome_message = "You are a Reaver of the Flame, absolved of sin and called to a higher purpose by the Prophet Si'akh himself. Fall upon the corrupt and the wicked with righteous fury, and defend the pilgrims you are escorting. NOT AN ANTAGONIST! Do not act as such."

	max_count = 2
	spawnpoints = list("moghes_siakh")
	uses_species_whitelist = TRUE

	assigned_role = "Si'akh Reaver of the Flame"
	special_role = "Si'akh Reaver of the Flame"
	respawn_flag = null

/obj/outfit/admin/moghes_siakh
	name = "Si'akh"
	uniform = /obj/item/clothing/under/unathi
	suit = list(/obj/item/clothing/suit/unathi/robe, /obj/item/clothing/suit/unathi/robe/kilt)
	back = /obj/item/storage/backpack/satchel/leather
	shoes = /obj/item/clothing/shoes/sandal
	id = null
	l_ear = null

/obj/outfit/admin/moghes_siakh/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/uniform_color = "[pick("#42330f", "#DBC684")]"
	if(H?.w_uniform)
		H.w_uniform.color = uniform_color
	if(H?.wear_suit)
		H.wear_suit.color = uniform_color
