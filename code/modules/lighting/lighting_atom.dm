/atom
	var/light_power = 1 // intensity of the light
	var/light_range = 0 // range in tiles of the light
	var/light_color		// RGB string representing the colour of the light

	var/datum/light_source/light
	var/list/light_sources

	//If this var is set, and this object casts light, and the object is worn/held on a mob
	//Then the light source will be offset this many tiles in the mob's facing direction
	//To make this work, must make sure this object is set as the source atom of any lightsource it creates
	//For now, this will only offset one tile, regardless of the value set, but this can be expanded in future
	var/offset_light = 0

	//If this object emits light and is worn/held on a mob
	//The light applied to the owner's tile is multiplied by this value
	//This is a means to simulate directional light and is only used with offset_light
	var/owner_light_mult = 0.5

	//If 1, this light has reduced effect on diona
	//It won't stack with other restricted light sources
	var/diona_restricted_light = 0


/atom/proc/set_light(l_range, l_power, l_color)
	if(l_power != null) light_power = l_power
	if(l_range != null) light_range = l_range
	if(l_color != null) light_color = l_color

	update_light()

/atom/proc/update_light()
	if(!light_power || !light_range)
		if(light)
			light.destroy()
			light = null
	else
		if(!istype(loc, /atom/movable))
			. = src
		else
			. = loc

		if(light)
			light.update(.)
		else
			light = new /datum/light_source(src, .)

/atom/New()
	. = ..()
	if(light_power && light_range)
		update_light()

/atom/Destroy()
	if(light)
		light.destroy()
		light = null
	return ..()

/atom/movable/Destroy()
	var/turf/T = loc
	if(opacity && istype(T))
		T.reconsider_lights()
	return ..()

/atom/Entered(atom/movable/obj, atom/prev_loc)
	. = ..()

	if(obj && prev_loc != src)
		for(var/datum/light_source/L in obj.light_sources)
			L.source_atom.update_light()

/atom/proc/set_opacity(new_opacity)
	var/old_opacity = opacity
	opacity = new_opacity
	var/turf/T = loc
	if(old_opacity != new_opacity && istype(T))
		T.reconsider_lights()

/obj/item/equipped()
	. = ..()
	update_light()

/obj/item/pickup()
	. = ..()
	update_light()

/obj/item/dropped()
	. = ..()
	update_light()
