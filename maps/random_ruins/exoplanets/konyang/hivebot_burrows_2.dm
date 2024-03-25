/datum/map_template/ruin/exoplanet/hivebot_burrows_2
	name = "Derelict Archaelogy Outpost"
	id = "hivebot_burrows_2"
	description = "An archaeology outpost that's been overrun by a hivebot infestation."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/hivebot_burrows_2.dmm")

	ban_ruins = list(/datum/map_template/ruin/exoplanet/hivebot_burrows_1)

/area/hivebot_burrows_2
	name = "Derelict Archaelogy Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	base_turf = /turf/simulated/floor/exoplanet/basalt/cave
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	ambience = AMBIENCE_FOREBODING

/obj/machinery/door/airlock/hatch/broken
	name = "Broken Hatch"

/obj/machinery/door/airlock/hatch/broken/Initialize() // to make door start already broken and open
	. = ..()
	p_open = 1
	opacity = 0
	density = 0
	update_icon(AIRLOCK_OPEN)
	src.stat |= BROKEN

/obj/effect/landmark/corpse/scientist/hivebot_burrows
	name = "unidentifiable corpse"
	corpseid = 0
	corpseradio = null
	corpseuniform = /obj/item/clothing/under/pants/khaki
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat/accent
	corpseback = /obj/item/storage/backpack/satchel/leather
	corpseshoes = /obj/item/clothing/shoes/workboots/dark

/obj/effect/landmark/corpse/scientist/hivebot_burrows/do_extra_customization(var/mob/living/carbon/human/M)
	// combines husk and skeleton to look extra messed up
	M.ChangeToHusk()
	M.ChangeToSkeleton()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

	var/obj/item/clothing/under/U = M.w_uniform
	var/obj/item/clothing/accessory/dressshirt/shirt = new()
	U.attach_accessory(null, shirt)
