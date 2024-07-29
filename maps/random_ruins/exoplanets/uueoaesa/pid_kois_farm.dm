/datum/map_template/ruin/exoplanet/pid_kois_farm
	name = "K'lax K'ois Farm"
	id = "pid-kois_farm"
	description = "A farm on the moon Pid, operated by K'laxan Vaurca."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "pid_kois_farm.dmm"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(3)

/area/pid_kois_farm
	name = "K'lax Farm"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED
	ambience = AMBIENCE_EXPOUTPOST

/datum/ghostspawner/human/pid_kois_farmer
	name = "K'laxan Farmer"
	short_name = "pid_vaurca"
	desc = "Farm k'ois on the moon Pid."

	max_count = 3
	spawnpoints = list("pid_vaurca")
	welcome_message = "You are a Worker of the Hive K'lax, tasked with k'ois farming on Pid. Produce the deadly fungus to feed your Hive. \
	IMPORTANT - Vaurca are a very alien species, and can be difficult to roleplay. It is recommended that you read the Aurorastation wiki page for the species, as well as the Vaurca Hives page for information on K'lax coloration."
	uses_species_whitelist = FALSE

	outfit = /obj/outfit/admin/pid_farmer
	possible_species = list(SPECIES_VAURCA_WORKER)
	extra_languages = list(LANGUAGE_VAURCA)
	mob_name_pick_message = "Pick a Vaurca Worker name."

/datum/ghostspawner/human/pid_kois_farmer/bulwark
	name = "K'laxan Bulwark Farmer"
	short_name = "pid_bulwark"

	max_count = 1
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_VAURCA_BULWARK)
	mob_name_pick_message = "Pick a Vaurca Bulwark name."
	welcome_message = "You are a Bulwark of the Hive K'lax, tasked with k'ois farming on Pid. Produce the deadly fungus to feed your Hive."

/datum/ghostspawner/human/pid_kois_farmer/warrior
	name = "K'laxan Farm Security"
	short_name = "pid_warrior"

	max_count = 1
	uses_species_whitelist = TRUE
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	mob_name_pick_message = "Pick a Vaurca Warrior name."
	welcome_message = "You are a Warrior of the Hive K'lax, tasked with protecting a k'ois farm on Pid. Ensure the safety of the Workers and Bulwarks at this location."

/obj/outfit/admin/pid_farmer
	name = "Pid K'ois Farmer"
	uniform = /obj/item/clothing/under/vaurca
	shoes = /obj/item/clothing/shoes/vaurca
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	l_ear = null
	id = /obj/item/card/id

/obj/outfit/admin/pid_farmer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()
