/obj/skybox
	name = "skybox"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER:-224,CENTER:-224"
	plane = SKYBOX_PLANE

/client
	var/obj/skybox/skybox

/client/proc/update_skybox(rebuild)
	// TG_PLANE_CUBE_TEMP: compatibility shim while old skybox callsites are converted to direct parallax refreshes.
	if(skybox)
		screen -= skybox
		QDEL_NULL(skybox)

	if(rebuild)
		refresh_parallax_skybox()
	else
		mob?.hud_used?.update_parallax()

/mob/Move(atom/newloc, direct, glide_size_override, update_dir)
	var/old_z = GET_Z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != GET_Z(src))
