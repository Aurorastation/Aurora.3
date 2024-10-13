/datum/map_template/ruin/exoplanet/moghes_wasteland_klax
	name = "K'lax Terraforming Outpost"
	description = "A research outpost located in the Wasteland."
	id = "moghes_klax"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_klax.dmm"
	unit_test_groups = list(1)

/area/moghes_klax
	name = "K'laxan Research Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "This place is dark and silent, with only the low hum of machinery audible."

/datum/ghostspawner/human/moghes_wasteland_klax
	name = "K'laxan Scientist"
	short_name = "moghes_klax"
	desc = "Study the Wasteland to further terraforming efforts."
	tags = list("External")
	welcome_message = "You are a Worker of the Hive K'lax, sent to analyse the Wasteland to assist in terraforming. Gather data, run experiments, and stay alive. \
	IMPORTANT - Vaurca are a very alien species, and can be difficult to roleplay. It is recommended that you read the Aurorastation wiki page for the species, as well as the Vaurca Hives page for information on K'lax coloration."

	max_count = 3
	uses_species_whitelist = FALSE
	spawnpoints = list("moghes_wasteland_klax")

	outfit = /obj/outfit/admin/moghes_wasteland_klax
	possible_species = list(SPECIES_VAURCA_WORKER)
	extra_languages = list(LANGUAGE_VAURCA)
	mob_name_pick_message = "Pick a Vaurca Worker name."

	assigned_role = "K'laxan Geo-Engineer"
	special_role = "K'laxan Geo-Engineer"
	respawn_flag = null

/datum/ghostspawner/human/moghes_wasteland_klax/warrior
	name = "K'laxan Security"
	short_name = "moghes_klax_warrior"
	desc = "Defend the K'lax terraforming outpost in the Wasteland"
	welcome_message = "You are a Warrior of the Hive K'lax, assigned to guard the Workers of the science team as they study the Wasteland."

	outfit = /obj/outfit/admin/moghes_wasteland_klax/warrior
	max_count = 2
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_ATTENDANT)
	mob_name_pick_message = "Pick a Vaurca Warrior name."

	assigned_role = "K'laxan Warrior"
	special_role = "K'laxan Warrior"
	respawn_flag = null

/obj/outfit/admin/moghes_wasteland_klax
	name = "K'laxan Outpost"

	uniform = /obj/item/clothing/under/vaurca
	shoes = /obj/item/clothing/shoes/vaurca
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	back = /obj/item/storage/backpack/cloak/sci
	l_ear = null
	id = /obj/item/card/id

/obj/outfit/admin/moghes_wasteland_klax/warrior
	name = "K'laxan Outpost Warrior"
	back = /obj/item/storage/backpack/cloak/sec
	belt = /obj/item/melee/energy/vaurca
	l_hand = /obj/item/martial_manual/vaurca

/obj/outfit/admin/moghes_wasteland_klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	H.update_body()
