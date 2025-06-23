/obj/effect/bmode
	name = "Build Mode"
	density = 1
	anchored = 1
	layer = HUD_BASE_LAYER
	plane = HUD_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	icon = 'icons/misc/buildmode.dmi'
	var/datum/click_handler/build_mode/host

/obj/effect/bmode/New(var/host)
	..()
	src.host = host

/obj/effect/bmode/Destroy()
	host = null
	. = ..()

/obj/effect/bmode/proc/OnClick(var/list/params)
	return

/obj/effect/bmode/dir
	name = "Modify Dir"
	icon_state = "build"
	screen_loc = "NORTH,WEST"

/obj/effect/bmode/dir/New()
	..()
	set_dir(host.dir)

/obj/effect/bmode/dir/OnClick(var/list/parameters)
	switch(dir)
		if(SOUTH)
			set_dir(WEST)
		if(WEST)
			set_dir(NORTH)
		if(NORTH)
			set_dir(EAST)
		if(EAST)
			set_dir(NORTHWEST)
		else
			set_dir(SOUTH)
	host.dir = dir

/obj/effect/bmode/help
	name = "Help"
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"

/obj/effect/bmode/help/OnClick()
	host.current_build_mode.Help()

/obj/effect/bmode/mode
	name = "Select Mode"
	screen_loc = "NORTH,WEST+2"

/obj/effect/bmode/mode/New()
	..()
	icon_state = host.current_build_mode.icon_state

/obj/effect/bmode/mode/OnClick(var/list/parameters)
	if(parameters["left"])
		var/datum/build_mode/build_mode = input("Select build mode", "Select build mode", host.current_build_mode) as null|anything in host.build_modes
		if(build_mode && host && (build_mode in host.build_modes))
			host.current_build_mode = build_mode
			icon_state = build_mode.icon_state
			to_chat(usr, SPAN_NOTICE("Build mode '[host.current_build_mode]' selected."))
	else if(parameters["right"])
		host.current_build_mode.Configurate()

/obj/effect/bmode/quit
	name = "Quit"
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

/obj/effect/bmode/quit/OnClick()
	var/datum/click_handler/handler = usr.GetClickHandler()
	if(handler.type == /datum/click_handler/build_mode)
		usr.RemoveClickHandler(/datum/click_handler/build_mode)
