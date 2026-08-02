//------------------------------------------
//Shockwaves
//------------------------------------------

/obj/effect/var/displacement_source_offset = null

/obj/effect/proc/update_displacement_source()
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		clear_displacement_source()
		return
	var/new_offset = GET_TURF_PLANE_OFFSET(current_turf)
	SET_PLANE_W_SCALAR(src, DISPLACEMENT_PLANE, new_offset)
	if(displacement_source_offset == new_offset)
		return
	if(!isnull(displacement_source_offset))
		REMOVE_TRAIT(GLOB, TRAIT_DISTORTION_IN_USE(displacement_source_offset), REF(src))
	displacement_source_offset = new_offset
	ADD_TRAIT(GLOB, TRAIT_DISTORTION_IN_USE(displacement_source_offset), REF(src))

/obj/effect/proc/clear_displacement_source()
	if(isnull(displacement_source_offset))
		return
	REMOVE_TRAIT(GLOB, TRAIT_DISTORTION_IN_USE(displacement_source_offset), REF(src))
	displacement_source_offset = null


/obj/effect/shockwave
	icon = 'icons/effects/light_overlays/shockwave.dmi'
	icon_state = "shockwave"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = DISPLACEMENT_PLANE
	pixel_x = -496
	pixel_y = -496
	vis_flags = 0

/obj/effect/shockwave/Initialize(mapload, radius, speed, easing_type = LINEAR_EASING, y_offset, x_offset)
	. = ..()
	update_displacement_source()
	if(!speed)
		speed = 1
	if(y_offset)
		pixel_y += y_offset
	if(x_offset)
		pixel_x += x_offset
	AddElement(/datum/element/temporary, 0.5 * radius * speed)
	transform = matrix().Scale(32 / 1024, 32 / 1024)
	animate(src, time = 0.5 * radius * speed, transform=matrix().Scale((32 / 1024) * radius * 1.5, (32 / 1024) * radius * 1.5), easing = easing_type)

/obj/effect/shockwave/Destroy()
	clear_displacement_source()
	return ..()

/obj/effect/shockwave/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents = TRUE)
	. = ..()
	if(same_z_layer)
		return
	update_displacement_source()
