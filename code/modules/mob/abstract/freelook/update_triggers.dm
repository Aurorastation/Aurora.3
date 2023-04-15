//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

/proc/updateVisibility(atom/A, var/opacity_check = TRUE)
	if(SSticker.current_state >= GAME_STATE_PLAYING)
		for(var/datum/visualnet/VN in visual_nets)
			VN.update_visibility(A, opacity_check)

/atom/Destroy()
	if(opacity)
		updateVisibility(src)
	. = ..()

/atom/set_opacity()
	. = ..()
	if(.)
		updateVisibility(src, FALSE)

/atom/movable/Move()
	. = ..()
	if(opacity && .)
		updateVisibility(src)

/atom/movable/forceMove()
	. = ..()
	if(opacity && .)
		updateVisibility(src)

/turf/ChangeTurf()
	. = ..()
	if(.)
		updateVisibility(src, FALSE)
