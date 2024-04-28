//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

/proc/updateVisibility(atom/A, var/opacity_check = TRUE)
	if(SSticker.current_state >= GAME_STATE_PLAYING)
		for(var/datum/visualnet/VN in GLOB.visual_nets)
			VN.update_visibility(A, opacity_check)
