//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

/proc/updateVisibility(atom/A, var/opacity_check = TRUE)
	if(SSticker.current_state >= GAME_STATE_PLAYING)
		for(var/datum/visualnet/VN in GLOB.visual_nets)
			VN.update_visibility(A, opacity_check)

/atom/set_opacity()
	. = ..()
	if(.)
		updateVisibility(src, FALSE)

/atom/movable/forceMove()
	. = ..()
	if(opacity && .)
		updateVisibility(src)

/turf/ChangeTurf(N, tell_universe = TRUE, force_lighting_update = FALSE, ignore_override = FALSE, mapload = FALSE)
	. = ..()
	if(.)
		updateVisibility(src, FALSE)
