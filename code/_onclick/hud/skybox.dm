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
	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = TRUE

	var/turf/T = get_turf(eye)
	if(T)
		if(rebuild)
			skybox.overlays.Cut()
			skybox.overlays += SSskybox.get_skybox(T.z)
			screen |= skybox
		if(skybox)
			skybox.screen_loc = "CENTER:[-224 - T.x],CENTER:[-224 - T.y]"

/mob/Move(atom/newloc, direct, glide_size_override, update_dir)
	var/old_z = GET_Z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != GET_Z(src))
