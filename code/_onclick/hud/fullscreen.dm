/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen(category, type, severity, animated = 0)
	var/atom/movable/screen/fullscreen/screen = screens[category]

	if(!screen || screen.type != type)
		clear_fullscreen(category, FALSE)
		screens[category] = screen = new type()
		if(animated)
			screen.alpha = 0
	else if(!severity || severity == screen.severity)
		if(client && screen.should_show_to(src))
			screen.update_for_view(client.view)
			client.screen |= screen
		if(screen.needs_offsetting)
			SET_PLANE_EXPLICIT(screen, PLANE_TO_TRUE(screen.plane), src)
		return screen

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity

	if(client && screen.should_show_to(src))
		screen.update_for_view(client.view)
		client.screen += screen
		if(animated)
			animate(screen, alpha = initial(screen.alpha), time = animated)

	if(screen.needs_offsetting)
		SET_PLANE_EXPLICIT(screen, PLANE_TO_TRUE(screen.plane), src)

	return screen

/mob/proc/clear_fullscreen(category, animated = 10)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(!QDELETED(src) && animated)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, PROC_REF(clear_fullscreen_after_animate), screen), animated, TIMER_CLIENT_TIME)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreen_after_animate(atom/movable/screen/fullscreen/screen)
	if(client)
		client.screen -= screen
	qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in screens)
			client.screen -= screens[category]

/mob/proc/reload_fullscreen()
	if(client)
		for(var/category in screens)
			var/atom/movable/screen/fullscreen/screen = screens[category]
			if(screen.should_show_to(src))
				screen.update_for_view(client.view)
				client.screen |= screen
			else
				client.screen -= screen

/mob/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents = TRUE)
	. = ..()
	if(!same_z_layer)
		relayer_fullscreens()

/mob/proc/relayer_fullscreens()
	var/turf/current_turf = get_turf(src)
	var/offset = GET_TURF_PLANE_OFFSET(current_turf)
	for(var/category in screens)
		var/atom/movable/screen/fullscreen/screen = screens[category]
		if(screen.needs_offsetting)
			screen.plane = GET_NEW_PLANE(initial(screen.plane), offset)

/atom/movable/screen/fullscreen
	icon = 'icons/hud/mob/full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FULLSCREEN_PLANE
	layer = FULLSCREEN_LAYER
	var/view = 7
	var/severity = 0
	var/allstate = 0 //shows if it should show up for dead people too
	var/needs_offsetting = TRUE

/atom/movable/screen/fullscreen/proc/update_for_view(client_view)
	if(screen_loc == "CENTER-7,CENTER-7" && view != client_view)
		var/list/actualview = getviewsize(client_view)
		view = client_view
		transform = matrix(actualview[1]/FULLSCREEN_OVERLAY_RESOLUTION_X, 0, 0, 0, actualview[2]/FULLSCREEN_OVERLAY_RESOLUTION_Y, 0)

/atom/movable/screen/fullscreen/proc/should_show_to(mob/mymob)
	if(!allstate && mymob.stat == DEAD)
		return FALSE
	return TRUE

/atom/movable/screen/fullscreen/Destroy()
	severity = 0
	return ..()

/atom/movable/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = DAMAGE_LAYER

/atom/movable/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = DAMAGE_LAYER

/atom/movable/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/atom/movable/screen/fullscreen/strong_pain
	icon_state = "strong_pain"
	layer = CRIT_LAYER

/atom/movable/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/blackout
	icon_state = "blackout"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/impaired
	icon_state = "impairedoverlay"

/atom/movable/screen/fullscreen/closet_impaired
	icon_state = "impairedoverlay2"

/atom/movable/screen/fullscreen/blurry
	icon = 'icons/hud/mob/effects.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "blurry"
	alpha = 100

/atom/movable/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0

/atom/movable/screen/fullscreen/robot_pain
	icon = 'icons/hud/mob/robot_pain.dmi'
	alpha = 255

/atom/movable/screen/fullscreen/flash
	icon = 'icons/hud/mob/effects.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/atom/movable/screen/fullscreen/flash/noise
	icon_state = "noise"
	alpha = 127

/atom/movable/screen/fullscreen/noise
	icon = 'icons/effects/static.dmi'
	icon_state = "1 light"
	screen_loc = ui_entire_screen
	alpha = 127

/atom/movable/screen/fullscreen/fadeout
	icon = 'icons/hud/mob/effects.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	alpha = 0
	allstate = 1

/atom/movable/screen/fullscreen/fadeout/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 10)

/atom/movable/screen/fullscreen/scanline
	icon = 'icons/effects/static.dmi'
	icon_state = "scanlines"
	screen_loc = ui_entire_screen
	alpha = 50

/atom/movable/screen/fullscreen/frenzy
	icon_state = "frenzyoverlay"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/teleport
	icon_state = "teleport"

/atom/movable/screen/fullscreen/blueprints
	icon = 'icons/effects/blueprints.dmi'
	icon_state = "base"
	screen_loc = ui_entire_screen
	alpha = 100

/atom/movable/screen/fullscreen/blueprints/less_alpha
	alpha = 35

/atom/movable/screen/fullscreen/cinematic_backdrop
	icon = 'icons/hud/mob/white.dmi'
	icon_state = "flash"
	screen_loc = ui_entire_screen
	plane = SPLASHSCREEN_PLANE
	layer = CINEMATIC_LAYER
	color = COLOR_BLACK
	allstate = 1

/atom/movable/screen/fullscreen/lighting_backdrop
	icon = 'icons/hud/mob/white.dmi'
	icon_state = "flash"
	screen_loc = ui_entire_screen
	plane = LIGHTING_PLANE
	layer = LIGHTING_ABOVE_ALL
	blend_mode = BLEND_OVERLAY
	allstate = 1
	needs_offsetting = FALSE

//Provides darkness to the back of the lighting plane
/atom/movable/screen/fullscreen/lighting_backdrop/lit_secondary
	invisibility = INVISIBILITY_LIGHTING
	layer = BACKGROUND_LAYER + LIGHTING_ABOVE_ALL + 1
	color = "#000"

/atom/movable/screen/fullscreen/lighting_backdrop/backplane
	layer = BACKGROUND_LAYER + LIGHTING_ABOVE_ALL

/atom/movable/screen/fullscreen/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	layer = LIGHTING_PRIMARY_LAYER
	blend_mode = BLEND_ADD
