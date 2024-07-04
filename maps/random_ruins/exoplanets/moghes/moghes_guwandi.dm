/datum/map_template/ruin/exoplanet/moghes_guwandi
	name = "Guwandi"
	id = "moghes_guwandi"
	description = "A Guwandi warrior, seeking an honorable death"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_ALLOW_DUPLICATES
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffixes = list("moghes_guwandi.dmm")
	unit_test_groups = list(3)

/datum/ghostspawner/human/moghes_guwandi
	short_name = "moghes_guwandi"
	name = "Guwandi Warrior"
	desc = "Endure the harshness of the Wasteland, and regain your honor with a glorious death in combat."
	tags = list("External")
	mob_name_suffix = " Guwandi"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are Guwandi, clanless and honorless, exiled to the Wasteland. Your sole path to redemption is through seeking an honorable death in battle. NOT AN ANTAGONIST! Do not act as such."

	spawnpoints = list("moghes_guwandi")
	max_count = 1

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_guwandi
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Guwandi Warrior"
	special_role = "Guwandi Warrior"
	respawn_flag = null
	uses_species_whitelist = TRUE

/obj/outfit/admin/moghes_guwandi
	name = "Guwandi Warrior"

	uniform = /obj/item/clothing/under/unathi/zazali
	suit = /obj/item/clothing/suit/unathi/robe/kilt
	shoes = /obj/item/clothing/shoes/sandals/caligae
	l_ear = null
	id = null
	belt = /obj/item/material/sword/longsword
	head = /obj/item/clothing/accessory/sinta_hood
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	l_hand = /obj/item/martial_manual/swordsmanship

/obj/outfit/admin/moghes_guwandi/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = "#181a19"
	if(H?.wear_suit)
		H.wear_suit.color = "#d4d3ab"
	if(H?.head)
		H.head.color = "#d4d3ab"
