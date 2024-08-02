/datum/map_template/ruin/exoplanet/ouerea_autakh
	name = "Ouerea Aut'akh Compound"
	id = "ouerea_autakh"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_autakh.dmm"
	unit_test_groups = list(3)

/area/ouerea_autakh
	name = "Aut'akh Compound"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "An oddly fortified settlement, resting in the Ouerean wilderness. High fences and a checkpoint at the gate indicate that few visitors are expected to this place."

/datum/ghostspawner/human/ouerea_autakh
	name = "Aut'akh Faithful"
	short_name = "ouerea_autakh"
	desc = "Survive against religious persecution in your commune on Ouerea."
	tags = list("External")
	welcome_message = "You are a follower of the Aut'akh faith, living in a hidden commune on Ouerea. Practice your faith in secret, away from the eyes of the Hegemony."

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	max_count = 3
	spawnpoints = list("ouerea_autakh")
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/autakh

	assigned_role = "Aut'akh Commune Resident"
	special_role = "Aut'akh Commune Resident"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/ouerea_autakh/shaman
	name = "Aut'akh Shaman"
	short_name = "ouerea_autakh_shaman"
	desc = "Lead your commune to prosper in secret, as a teacher of the Aut'akh faith."
	welcome_message = "You are a shaman of the Aut'akh faith, trained in both theology and cybernetic surgery. Help lead your commune members to a greater understanding, protect them from religious persecution, and spread the beliefs of the Aut'akh."
	max_count = 1
	outfit = /obj/outfit/admin/autakh/shaman
	assigned_role = "Aut'akh Shaman"
	special_role = "Aut'akh Shaman"
	uses_species_whitelist = TRUE

/obj/outfit/admin/autakh
	name = "Aut'akh"

	uniform = list(/obj/item/clothing/under/unathi, /obj/item/clothing/under/unathi/himation, /obj/item/clothing/under/unathi/zozo)
	shoes = /obj/item/clothing/shoes/sandals/caligae
	l_ear = null
	id = /obj/item/card/id

/obj/outfit/admin/autakh/get_id_access()
	return list(ACCESS_AUTAKH)

/obj/outfit/admin/autakh/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/organ/A = new /obj/item/organ/internal/anchor(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	H.update_body()

/obj/outfit/admin/autakh/shaman
	suit = /obj/item/clothing/suit/unathi/wrapping
	mask = /obj/item/clothing/mask/gas/unathi

/obj/outfit/admin/autakh/shaman/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/organ/A = new /obj/item/organ/internal/anchor(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	var/obj/item/organ/B = new /obj/item/organ/external/hand/right/autakh/tool/nullrod(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	H.update_body()
