/datum/map_template/ruin/exoplanet/moghes_wasteland_mikuetz
	name = "Mi'kuetz Caravan"
	id = "moghes_wasteland_mikuetz"
	description = "A caravan of Queenless K'lax, wandering the Wastelands of Moghes"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_mikuetz.dmm"
	unit_test_groups = list(2)

/area/moghes_mikuetz
	name = "Mi'kuetz Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "There is a campsite here, seemingly set up not too long ago. A pen has been erected, to hold some kind of animal. The air carries a faint scent of sulfur."

/datum/ghostspawner/human/moghes_wasteland_mikuetz
	name = "Mi'kuetz Wanderer"
	short_name = "moghes_mikuetz"
	desc = "Wander the Wasteland as a Queenless Vaurca."
	tags = list("External")
	spawnpoints = list("moghes_mikuetz")
	welcome_message = "You are a Vaurca of the group known as the Mi'kuetz, merry traders and wanderers in the Wasteland of Moghes."
	mob_name_pick_message = "Pick a Vaurca name."

	max_count = 4
	uses_species_whitelist = TRUE

	extra_languages = list(LANGUAGE_VAURCA)
	outfit = /obj/outfit/admin/moghes_mikuetz
	possible_species = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Mi'kuetz Wanderer"
	special_role = "Mi'kuetz Wanderer"
	respawn_flag = null

/obj/outfit/admin/moghes_mikuetz
	uniform = list(/obj/item/clothing/under/unathi, /obj/item/clothing/under/vaurca)
	suit = /obj/item/clothing/suit/vaurca/brown
	shoes = /obj/item/clothing/shoes/vaurca
	head = /obj/item/clothing/head/shroud/brown
	back = null
	l_ear = null
	id = null
	l_pocket = /obj/item/reagent_containers/food/snacks/koisbar_clean
	mask = /obj/item/clothing/mask/gas/vaurca/filter

/obj/outfit/admin/moghes_mikuetz/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"

	var/uniform_colour = "[pick("#42330f", "#DBC684")]"
	if(H?.w_uniform)
		H.w_uniform.color = uniform_colour
	if(H?.shoes)
		H.shoes.color = uniform_colour
	var/obj/item/organ/B = new /obj/item/organ/internal/augment/language/mikuetz(H)
	var/obj/item/organ/external/affected = H.get_organ(B.parent_organ)
	B.replaced(H, affected)
	H.update_body()
