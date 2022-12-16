/datum/ghostspawner/human/kataphract
	short_name = "kataphract_hop"
	name = "Kataphract-Hopeful"
	desc = "A Zo'saa (squire) of the traveling Kataphract Guild. Display honour in everything you do. Be an excellent person. Listen to the Saa's (Knights). Remember, you serve the Izweski Hegemony."
	tags = list("External")

	spawnpoints = list("kataphract")
	req_perms = null
	max_count = 3
	uses_species_whitelist = FALSE

	mob_name_prefix = "Zosaa "
	mob_name_pick_message = "Pick an Unathi last name."

	outfit = /datum/outfit/admin/kataphract
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kataphract-Hopeful"
	special_role = "Kataphract-Hopeful"
	respawn_flag = null
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	away_site = TRUE

/datum/ghostspawner/human/kataphract/klax
	short_name = "kataphract_hop_klax"
	name = "Kataphract-Hopeful Klaxan"
	desc = "A Zo'saa (squire) from the K'lax hive, here to learn what it means to be honourable. Remember, you serve the Izweski Hegemony on behalf of your K'laxan compatriots."
	max_count = 1
	uses_species_whitelist = TRUE

	spawnpoints = list("kataphract_klax")

	outfit = /datum/outfit/admin/kataphract/klax
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	extra_languages = list(LANGUAGE_VAURCA)

/datum/ghostspawner/human/kataphract/knight
	short_name = "kataphract_knight"
	name = "Kataphract Knight Captain"
	desc = "A Saa (Knight) of the traveling Kataphract Guild. Display honour in everything you do. Be an excellent person. You are the foremost authority on your vessel. Lead by example."
	max_count = 1
	uses_species_whitelist = TRUE

	mob_name_prefix = "Saa "

	spawnpoints = list("kataphract_knight")

	outfit = /datum/outfit/admin/kataphract/knight
	

	assigned_role = "Kataphract Knight Captain"
	special_role = "Kataphract Knight Captain"

/datum/ghostspawner/human/kataphract/specialist
	short_name = "kataphract_specialist"
	name = "Kataphract Specialist"
	desc = "A Saa (Knight) of the traveling Kataphract Guild. Display honour in everything you do. Support your Knight Captain and lead by example. Remember, you serve the Izweski Hegemony."
	max_count = 1

	mob_name_prefix = "Saa "

	spawnpoints = list("kataphract_specialist")

	outfit = /datum/outfit/admin/kataphract/specialist

	assigned_role = "Kataphract Specialist"
	special_role = "Kataphract Specialist"

// Kataphract who are not combat ready
/datum/outfit/admin/kataphract
	name = "Kataphract-Hopeful"

	uniform = /obj/item/clothing/under/unathi
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/caligae
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel/hegemony


	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/donkpockets = 1
	)

/datum/outfit/admin/kataphract/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#1f8c3c", "#ab7318", "#1846ba")

/datum/outfit/admin/kataphract/get_id_access()
	return list(access_kataphract, access_external_airlocks)

/datum/outfit/admin/kataphract/klax

	uniform = /obj/item/clothing/under/vaurca
	mask = /obj/item/clothing/mask/breath/vaurca/filter
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/vaurca
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel/hegemony

	l_hand = /obj/item/martial_manual/vaurca


	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 3
	)

/datum/outfit/admin/kataphract/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/uniform_colour = pick("#1f8c3c", "#ab7318", "#1846ba")
	if(H?.w_uniform)
		H.w_uniform.color = uniform_colour
	if(H?.shoes)
		H.shoes.color = uniform_colour

	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()

/datum/outfit/admin/kataphract/knight
	name = "Kataphract Knight"

	suit = /obj/item/clothing/accessory/poncho/red
	back = /obj/item/storage/backpack/satchel/hegemony
	

/datum/outfit/admin/kataphract/knight/get_id_access()
	return list(access_kataphract, access_kataphract_knight, access_external_airlocks)

/datum/outfit/admin/kataphract/specialist
	name = "Kataphract Specialist"
	
	back = /obj/item/storage/backpack/satchel/hegemony

/datum/outfit/admin/kataphract/quartermaster/get_id_access()
	return list(access_kataphract, access_kataphract_knight, access_external_airlocks)