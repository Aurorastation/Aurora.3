/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "LEFT+50%:-224,BOTTOM+50%:-224"
	plane = PLANE_SKYBOX
	//	blend_mode = BLEND_MULTIPLY

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
			skybox.overlays += SSskybox.get_skybox()
			screen |= skybox
	if(skybox)
		skybox.screen_loc = "CENTER:[-224 - T.x],CENTER:[-224 - T.y]"

/mob/LateLogin()
	..()
	if(client)
		client.update_skybox(TRUE)
