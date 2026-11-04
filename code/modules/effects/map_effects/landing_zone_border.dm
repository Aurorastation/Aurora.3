/// An assoc list of turf reference -> TRUE, populated by `/obj/effect/map_effect/marker/landing_zone_border`.
GLOBAL_LIST_EMPTY(landing_zone_borders)

// Doesn't do anything on its own, if detected by `check_collision()` it'll be considered as an obstacle and make the landing zone invalid.
// Useful if you're mapping a large open area landing zones without any walls but prefer the shuttles respect the spaces intended by design.
/obj/effect/map_effect/marker/landing_zone_border
	name = "landing zone border marker"
	icon_state = "landing_zone_border"

/obj/effect/map_effect/marker/landing_zone_border/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(!T)
		return // no turf found, something is very wrong

	GLOB.landing_zone_borders[T] = TRUE

/obj/effect/map_effect/marker/landing_zone_border/Destroy()
	var/turf/T = get_turf(src)
	if(!T)
		return ..()

	GLOB.landing_zone_borders -= T
	return ..()
