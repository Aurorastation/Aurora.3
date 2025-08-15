/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen(category, type, severity, animated = 0)
	var/atom/movable/screen/fullscreen/screen = screens[category]

	if(screen)
		if(screen.type != type)
			clear_fullscreen(category, FALSE)
			screen = null
		else if(!severity || severity == screen.severity)
			return null

	if(!screen)
		screen = new type()
		if(animated)
			screen.alpha = 0

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity

	screens[category] = screen
	if(client && (stat != DEAD || screen.allstate))
		client.screen += screen
		if(animated)
			animate(screen, alpha = initial(screen.alpha), time = animated)
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
			client.screen |= screens[category]

/atom/movable/screen/fullscreen
	icon = 'icons/mob/screen/full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = FULLSCREEN_PLANE
	layer = FULLSCREEN_LAYER
	var/severity = 0
	var/allstate = 0 //shows if it should show up for dead people too

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
	icon = 'icons/mob/screen/effects.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "blurry"
	alpha = 100

/atom/movable/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0

/atom/movable/screen/fullscreen/flash
	icon = 'icons/mob/screen/effects.dmi'
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
	icon = 'icons/mob/screen/effects.dmi'
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
