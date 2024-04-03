/mob
	var/list/screens = list()

/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen(category, type, severity, animated = 0)
	var/obj/screen/fullscreen/screen = screens[category]

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
	var/obj/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		spawn(0)
			animate(screen, alpha = 0, time = animated)
			sleep(animated)
			if(client)
				client.screen -= screen
			qdel(screen)
	else
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

/obj/screen/fullscreen
	icon = 'icons/mob/screen/full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FULLSCREEN_LAYER
	var/severity = 0
	var/allstate = 0 //shows if it should show up for dead people too

/obj/screen/fullscreen/Destroy()
	severity = 0
	return ..()

/obj/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/obj/screen/fullscreen/strong_pain
	icon_state = "strong_pain"
	layer = CRIT_LAYER

/obj/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER

/obj/screen/fullscreen/blackout
	icon_state = "blackout"
	layer = BLIND_LAYER

/obj/screen/fullscreen/impaired
	icon_state = "impairedoverlay"

/obj/screen/fullscreen/blurry
	icon = 'icons/mob/screen/effects.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "blurry"
	alpha = 100

/obj/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0

/obj/screen/fullscreen/flash
	icon = 'icons/mob/screen/effects.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/obj/screen/fullscreen/flash/noise
	icon_state = "noise"
	alpha = 127

/obj/screen/fullscreen/noise
	icon = 'icons/effects/static.dmi'
	icon_state = "1 light"
	screen_loc = ui_entire_screen
	alpha = 127

/obj/screen/fullscreen/fadeout
	icon = 'icons/mob/screen/effects.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	alpha = 0
	allstate = 1

/obj/screen/fullscreen/fadeout/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 10)

/obj/screen/fullscreen/scanline
	icon = 'icons/effects/static.dmi'
	icon_state = "scanlines"
	screen_loc = ui_entire_screen
	alpha = 50

/obj/screen/fullscreen/frenzy
	icon_state = "frenzyoverlay"
	layer = BLIND_LAYER

/obj/screen/fullscreen/teleport
	icon_state = "teleport"
