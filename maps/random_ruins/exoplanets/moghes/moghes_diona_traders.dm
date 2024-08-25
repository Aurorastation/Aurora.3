/datum/map_template/ruin/exoplanet/moghes_diona_traders
	name = "Diona Trader Outpost"
	id = "moghes_diona_traders"
	description = "An office of an Unathi merchant who has become involved in the Diona trade."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_diona_traders.dmm"

	unit_test_groups = list(2)

/area/moghes_diona_traders
	name = "Diona Trader Office"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS

/datum/ghostspawner/human/moghes_diona_trader
	name = "Unathi Diona Trader"
	short_name = "moghes_diona_trader"
	desc = "As an independent merchant, try and make a living in the lucrative Diona trade."
	tags = list("External")

	max_count = 1
	spawnpoints = list("moghes_diona_trader")

	extra_languages = list(LANGUAGE_UNATHI)
	outfit = /obj/outfit/admin/moghes_diona_trader
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Independent Merchant"
	special_role = "Independent Merchant"
	respawn_flag = null

/obj/outfit/admin/moghes_diona_trader
	name = "Unathi Diona Trader"
	uniform = /obj/item/clothing/under/unathi/mogazali
	suit = /obj/item/clothing/suit/unathi/robe/robe_coat/orange
	shoes = /obj/item/clothing/shoes/sandals/caligae/socks
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	backpack_contents = list(
		/obj/item/storage/box/donkpockets = 1
	)
	l_ear = null

/datum/ghostspawner/human/moghes_diona
	name = "Diona Servant"
	desc = "Be a diona gestalt grown to be bought and sold. Go along with this fate, or try to escape it."
	short_name = "moghes_diona"
	tags = list("External")
	spawnpoints = list("moghes_diona")
	extra_languages = list(LANGUAGE_UNATHI)
	outfit = /obj/outfit/admin/moghes_diona
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE
	max_count = 2

	assigned_role = "Diona Servant"
	special_role = "Diona Servant"
	respawn_flag = null

/obj/outfit/admin/moghes_diona
	name = "Diona Servant"
	uniform = /obj/item/clothing/under/gearharness
	belt = /obj/item/device/flashlight/lantern
	back = /obj/item/storage/backpack/satchel/leather
	id = null
	l_ear = null

/datum/ghostspawner/human/moghes_diona/assistant
	name = "Diona Assistant"
	short_name = "moghes_diona_assistant"
	desc = "Assist the Unathi merchant who grew you in their work - or try and free your fellow gestalts."
	spawnpoints = list("moghes_diona_assistant")
	outfit = /obj/outfit/admin/moghes_diona/assistant
	uses_species_whitelist = TRUE
	max_count = 1
	assigned_role = "Merchant's Assistant"
	special_role = "Merchant's Assistant"
	respawn_flag = null

/obj/outfit/admin/moghes_diona/assistant
	name = "Diona Assistant"
	uniform = /obj/item/clothing/under/unathi/himation
	suit = /obj/item/clothing/accessory/poncho/unathimantle/mountain
	id = /obj/item/card/id
	backpack_contents = list(
		/obj/item/device/uv_light = 1
	)
	r_pocket = /obj/item/storage/wallet

/obj/outfit/admin/moghes_diona/assistant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = "#EAEAEA"
		H.w_uniform.accent_color = "#EAEAEA"
	if(H.wear_suit)
		H.wear_suit.color = "#42330f"

/obj/item/paper/fluff/moghes_diona_ad
	name = "Diona gestalts - get one TODAY!"
	desc = "A handwriten pamphlet of some kind. The Merchants' Guild symbol has been stamped at the bottom of the paper, and hastily crossed out."
	info = "Tired of getting all that work done by yourself? Getting on in years and not catching the fish you used to? Why not invest in a diona gestalt?<br>\
	Diona gestalts never grow tired, only need sunlight and water, and can easily learn all the tricks of the trade that you've picked up over years! Don't be behind the times, buy yours TODAY!"
	language = LANGUAGE_UNATHI
