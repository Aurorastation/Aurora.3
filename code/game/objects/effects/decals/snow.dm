/obj/effect/floor_decal/snow
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/obj/effect/floor_decal/snow/corner
	icon_state = "snow_corner"

/obj/effect/floor_decal/snow/surround
	icon_state = "snow_surround"

/obj/effect/floor_decal/snowdrift
	name = "snow drift"
	icon = 'icons/turf/snow.dmi'
	icon_state = "drift"

/obj/effect/floor_decal/snowdrift/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	supplied_dir = pick(cardinal)
	return ..()

/obj/effect/floor_decal/snowdrift/large
	name = "snow drift (large)"
	icon = 'icons/turf/decals/snow64x32.dmi'
	pixel_x = -16

/obj/effect/floor_decal/snowdrift/large/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	supplied_dir = pick(cardinal)
	return ..()
