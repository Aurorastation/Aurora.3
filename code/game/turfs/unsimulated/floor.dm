/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "new_steel"

/turf/unsimulated/floor/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/unsimulated/floor/xmas
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	footstep_sound = "snow"

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/mask/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	if (!N)
		return

	new N(src)

/turf/unsimulated/chasm_mask
	name = "chasm mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "alienvault"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB


// It's a placeholder turf, don't do anything special.
// These shouldn't exist by the time SSatoms runs.
/turf/unsimulated/mask/New()
	return

/turf/unsimulated/mask/Initialize()
	initialized = TRUE
	return

/turf/unsimulated/chasm_mask/New()
	return

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"
