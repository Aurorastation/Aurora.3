/datum/map_template/ruin/exoplanet/moghes_kung_fu
	name = "Kis-Khan Master"
	id = "moghes_kung_fu"
	description = "A master of the ancient Unathi martial art of Kis-Khan, living in seclusion in the Untouched Lands"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_kung_fu.dmm"

	unit_test_groups = list(3)

/datum/ghostspawner/human/moghes_kung_fu
	name = "Kis-Khan Master"
	short_name = "moghes_kung_fu"
	desc = "Meditate and practice the ancient martial art of Kis-Khan in the wilderness of the Untouched Lands."
	tags = list("External")
	welcome_message = "For decades, you have studied the art of Kis-Khan, honing your body into a deadly weapon. Now, you live a quiet and simple life in the wild, undisturbed by modern life. Practice your art, defend yourself, and should you judge another as worthy, pass your techniques onto them..."

	spawnpoints = list("moghes_kung_fu")
	max_count = 1

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_kung_fu
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kis-Khan Master"
	special_role = "Kis-Khan Master"
	respawn_flag = null
	uses_species_whitelist = TRUE

/obj/outfit/admin/moghes_kung_fu
	name = "Kis-Khan Master"

	uniform = /obj/item/clothing/under/unathi/zazali
	shoes = /obj/item/clothing/shoes/footwraps
	gloves = /obj/item/clothing/gloves/unathi
	l_ear = null
	id = null
	r_hand = /obj/item/martial_manual/unathi

/obj/outfit/admin/moghes_kung_fu/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = "#3a4b56"
	if(H.shoes)
		H.shoes.color = "#2a2b2c"
	if(H.gloves)
		H.gloves.color = "#2a2b2c"
