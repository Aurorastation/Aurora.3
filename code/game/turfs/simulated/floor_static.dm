// This type of flooring cannot be altered short of being destroyed and rebuilt.
// Use this to bypass the flooring system entirely ie. event areas, holodeck, etc.

/turf/simulated/floor/fixed
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled_preview"
	initial_flooring = null

/turf/simulated/floor/fixed/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack) && !attacking_item.iscoil())
		return
	return ..()

/turf/simulated/floor/fixed/update_icon()
	return

/turf/simulated/floor/fixed/is_plating()
	return 0

/turf/simulated/floor/fixed/set_flooring()
	return
