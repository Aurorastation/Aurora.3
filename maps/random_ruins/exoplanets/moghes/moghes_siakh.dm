/datum/map_template/ruin/exoplanet/moghes_siakh
	name = "Si'akh Warriors of the Flame"
	id = "moghes_siakh"
	description = "A group of Si'akh warriors in the Wasteland."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffixes = list("moghes_siakh.dmm")
	unit_test_groups = list(3)

/datum/ghostspawner/human/moghes_siakh
	name = "Si'akh Knight-Hopeful"
	short_name = "moghes_siakh"
	desc = "Wander the Wasteland, seeking opportunities to prove your devotion as a holy warrior. Live by the words of the Prophet Si'akh."
	tags = list("External")
	welcome_message = "You are an initiate of the Si'akh Order of the Flame, wandering the Wasteland as your Prophet once did. Defend the innocent and your fellow faithful from the cruelty and violence of the ruined world."

	max_count = 2
	spawnpoints = list("moghes_siakh")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_siakh
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Knight-Hopeful of the Flame"
	special_role = "Knight-Hopeful of the Flame"
	respawn_flag = null

/datum/ghostspawner/human/moghes_siakh/knight
	name = "Si'akh Knight"
	short_name = "moghes_siakh_knight"
	desc = "Wander the Wasteland as a holy warrior, commanded by the Prophet Si'akh to defend the innocent from the wickedness of the ruined world. Live by the words of the Prophet and lead your Knight-Hopefuls through the harsh wastes."
	tags = list("External")
	welcome_message = "You are a knight of the Order of the Flame, absolved of sin and called to a higher purpose by the Prophet Si'akh himself. Defend the innocent, escort your initiates through the harsh Wasteland, and fall upon those who would harm them with the fury of Sk'akh."

	max_count = 2
	spawnpoints = list("moghes_siakh_knight")
	uses_species_whitelist = TRUE

	assigned_role = "Knight of the Flame"
	special_role = "Knight of the Flame"
	respawn_flag = null

/obj/outfit/admin/moghes_siakh
	name = "Si'akh Knight"
	uniform = list(/obj/item/clothing/under/unathi, /obj/item/clothing/under/unathi/zazali)
	suit = /obj/item/clothing/accessory/poncho/unathimantle
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	back = /obj/item/storage/backpack/satchel/leather
	shoes = /obj/item/clothing/shoes/sandals/caligae
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/spitter = 1)
	backpack_contents = list(
		/obj/item/ammo_magazine/spitterpistol = 1,
		/obj/item/device/versebook/siakh = 1,
		/obj/item/clothing/suit/armor/unathi = 1,
		/obj/item/clothing/head/helmet/unathi = 1
	)
	belt = /obj/random/sword
	id = null
	l_ear = null

/obj/outfit/admin/moghes_siakh/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#42330f", "#DBC684")
	if(H.wear_suit)
		H.wear_suit.color = pick("#42330f", "#DBC684")
