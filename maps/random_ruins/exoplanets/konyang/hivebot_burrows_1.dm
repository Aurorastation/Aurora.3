/datum/map_template/ruin/exoplanet/hivebot_burrows_1
	name = "Abandoned Mineshaft"
	id = "hivebot_burrows_1"
	description = "A mineshaft that's long been overrun by a hivebot infestation."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/hivebot_burrows_1.dmm")

	ban_ruins = list(/datum/map_template/ruin/exoplanet/hivebot_burrows_2)

/area/hivebot_burrows_1
	name = "Abandoned Mineshaft"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	base_turf = /turf/simulated/floor/exoplanet/basalt/cave
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	ambience = AMBIENCE_FOREBODING

/obj/effect/landmark/corpse/miner/hivebot_burrows
	name = "unidentifiable corpse"
	corpseid = 0
	corpseradio = null
	corpseuniform = /obj/item/clothing/under/service_overalls
	corpsegloves = /obj/item/clothing/gloves/black
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/workboots/dark
	corpsehelmet = /obj/item/clothing/head/hardhat

/obj/effect/landmark/corpse/miner/hivebot_burrows/do_extra_customization(var/mob/living/carbon/human/M)
	// combines husk and skeleton to look extra messed up
	M.ChangeToHusk()
	M.ChangeToSkeleton()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

	var/obj/item/clothing/under/U = M.w_uniform
	var/obj/item/clothing/accessory/storage/overalls/mining/overalls = new()
	U.attach_accessory(null, overalls)

