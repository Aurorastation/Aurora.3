/datum/ghostspawner/human/tret_industrial
	name = "Tret Industrial Worker"
	short_name = "tret_industrial"
	desc = "You are a Vaurca Worker of the Hive K'lax in one of the many industrial facilities of Tret. Mine, extract and process valuable materials for the glory of the Hive K'lax."
	tags = list("External")
	spawnpoints = list("tret_industrial")
	max_count = 4

	outfit = /obj/outfit/admin/tret_industrial
	possible_species = list(SPECIES_VAURCA_WORKER)
	uses_species_whitelist = FALSE
	assigned_role = "Tret Industrial Worker"
	special_role = "Tret Industrial Worker"
	respawn_flag = null

	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Pick a Vaurca Worker name."

	extra_languages = list(LANGUAGE_VAURCA)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	welcome_message = "You are a Vaurca Worker of the Hive K'lax in an industrial mining facility on the planet Tret. Remember, as a Worker you are generally averse to violence, and should rely on the protection of Warriors where possible. \
	IMPORTANT - Vaurca are a very alien species, and can be difficult to roleplay. It is recommended that you read the Aurorastation wiki page for the species, as well as the Vaurca Hives page for information on K'lax coloration."

/datum/ghostspawner/human/tret_industrial/bulwark
	name = "Tret Industrial Bulwark"
	short_name = "tret_industrial_bulwark"
	desc = "You are a Vaurca Bulwark of the Hive K'lax in one of the many industrial facilities of Tret. Mine, extract and process valuable materials for the glory of the Hive K'lax."
	max_count = 1
	possible_species = list(SPECIES_VAURCA_BULWARK)
	uses_species_whitelist = TRUE

	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Pick a Vaurca Bulwark name."
	welcome_message = "You are a Vaurca Bulwark of the Hive K'lax, working on an industrial facility on Tret. Remember, as a Bulwark you should not seek out conflict, but you may fight to defend yourself or the Workers beside you."

/datum/ghostspawner/human/tret_industrial/warrior
	name = "Tret Industrial Warrior"
	short_name = "tret_industrial_warrior"
	desc = "You are a Vaurca Warrior of the Hive K'lax, assigned to protecting one of the industrial facilities of Tret. Keep the Workers at this facility safe."
	max_count = 2
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/tret_industrial/warrior
	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Pick a Vaurca Warrior name."
	welcome_message = "You are a Vaurca Warrior of the Hive K'lax, assigned to protect an industrial facility on Tret. Your primary duty is to keep the Workers of the facility safe from any threats."

/obj/outfit/admin/tret_industrial
	uniform = /obj/item/clothing/under/vaurca
	shoes = /obj/item/clothing/shoes/vaurca
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	l_ear = null
	back = /obj/item/storage/backpack/cloak/cargo
	id = /obj/item/card/id

/obj/outfit/admin/tret_industrial/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/tret_industrial/warrior
	belt = /obj/item/melee/energy/vaurca
	back = /obj/item/storage/backpack/cloak/sec
	l_hand = /obj/item/martial_manual/vaurca

/obj/outfit/admin/tret_industrial/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	var/obj/item/organ/B = new /obj/item/organ/internal/augment/tool/drill(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	H.update_body()
