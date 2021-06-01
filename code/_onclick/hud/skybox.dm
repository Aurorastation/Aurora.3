/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER:-224,CENTER:-224"
	plane = PLANE_SKYBOX
	//	blend_mode = BLEND_MULTIPLY

/client
	var/obj/skybox/skybox

/client/proc/update_skybox(rebuild)
	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = 1

	var/turf/T = get_turf(eye)
	if(T)
		if(rebuild)
			skybox.overlays.Cut()
			skybox.overlays += SSskybox.get_skybox()
			screen |= skybox
	skybox.screen_loc = "CENTER:[-224 - T.x],CENTER:[-224 - T.y]"

/mob/Login()
	..()
	client.update_skybox(TRUE)
