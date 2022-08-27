/datum/ghostspawner/human/kataphract
	short_name = "kataphract_hop"
	name = "Kataphract-Hopeful"
	desc = "Display honour in everything you do. Be an excellent person. Listen to the Saa's (Knights). Remember, you serve the Izweski Hegemony."
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
	desc = "Display honour in everything you do. Be an excellent person. Learn how to be a proper Kataphract by your fellow Unathi. Remember, you serve the Izweski Hegemony on behalf of your K'laxan compatriots."
	max_count = 1
	uses_species_whitelist = TRUE

	spawnpoints = list("kataphract_klax")

	outfit = /datum/outfit/admin/kataphract/klax
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	extra_languages = list(LANGUAGE_VAURCA)

/datum/ghostspawner/human/kataphract/knight
	short_name = "kataphract_knight"
	name = "Kataphract Knight"
	desc = "Display honour in everything you do. Be an excellent person. Act as the leader of the Kataphract Chapter and Shipmaster of your vessel. You are a Knight and should act as an example to your subordinates."
	max_count = 1
	uses_species_whitelist = TRUE

	mob_name_prefix = "Saa "

	spawnpoints = list("kataphract_knight")

	outfit = /datum/outfit/admin/kataphract/knight

	assigned_role = "Kataphract Knight Captain"
	special_role = "Kataphract Knight Captain"

/datum/ghostspawner/human/kataphract/quartermaster
	short_name = "kataphract_quart"
	name = "Kataphract Quartermaster"
	desc = "Display honour in everything you do. Be an excellent person. Ensure the Kataphracts are well-stocked and ready for anything. You are a proper knight and should act as an example to your subordinates. Listen to the Shipmaster. Remember, you serve the Izweski Hegemony."
	max_count = 1

	mob_name_prefix = "Saa "

	spawnpoints = list("kataphract_quartermaster")

	outfit = /datum/outfit/admin/kataphract/quartermaster

	assigned_role = "Kataphract Quartermaster"
	special_role = "Kataphract Quartermaster"

// Kataphract who are not combat ready
/datum/outfit/admin/kataphract
	name = "Kataphract-Hopeful"

	uniform = /obj/item/clothing/under/unathi
	belt = /obj/item/melee/energy/sword/hegemony
	shoes = /obj/item/clothing/shoes/caligae/grey
	id = /obj/item/card/id/distress/kataphract
	back = /obj/item/storage/backpack/satchel

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
	back = /obj/item/storage/backpack/satchel

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

/datum/outfit/admin/kataphract/knight/get_id_access()
	return list(access_kataphract, access_kataphract_knight, access_kataphract_quartermaster, access_kataphract_trader, access_external_airlocks)

/datum/outfit/admin/kataphract/quartermaster
	name = "Kataphract Quartermaster"

/datum/outfit/admin/kataphract/quartermaster/get_id_access()
	return list(access_kataphract, access_kataphract_quartermaster, access_kataphract_trader, access_external_airlocks)

/datum/outfit/admin/kataphract/trader // Unused from an old trimmed out ghostrole, but handy to have still
	name = "Kataphract Trader"

/datum/outfit/admin/kataphract/trader/get_id_access()
	return list(access_kataphract, access_kataphract_trader, access_external_airlocks)