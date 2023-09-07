/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_screen = "area_atmos"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/area_atmos

	var/list/connectedscrubbers = new()
	var/status = ""

	var/range = 15

	//Simple variable to prevent me from doing attack_hand in both this and the child computer
	var/zone = "This computer is working on a wireless range, the range is currently limited to 25 meters."

/obj/machinery/computer/area_atmos/Initialize()
	. = ..()

	scanscrubbers()

/obj/machinery/computer/area_atmos/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/area_atmos/attack_hand(var/mob/user as mob)
	ui_interact(user)
	return

/obj/machinery/computer/area_atmos/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AreaAtmos", ui_x=500, ui_y=300)
		ui.open()

/obj/machinery/computer/area_atmos/ui_data(mob/user)
	var/list/data = list()
	var/list/scrubberdata = list()
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
		scrubberdata += list(list(
			"id" = scrubber.name,
			"status" = scrubber.on ? 1 : 0,
			"pressure" = round(scrubber.air_contents.return_pressure(), 0.01),
			"flowrate" = round(scrubber.last_flow_rate, 0.1),
			"load" = round(scrubber.last_power_draw)
		))

	data["scrubbers"] = scrubberdata
	
	return data

/obj/machinery/computer/area_atmos/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	
	if(action=="cmode")
		on = !on
		update_icon()
		.= TRUE

/obj/machinery/computer/area_atmos/proc/validscrubber( var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
	if(!isobj(scrubber) || get_dist(scrubber.loc, src.loc) > src.range || scrubber.loc.z != src.loc.z)
		return 0

	return 1

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers = new()

	var/found = 0
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
		if(istype(scrubber))
			found = 1
			connectedscrubbers += scrubber

	if(!found)
		status = "ERROR: No scrubber found!"

	//src.updateUsrDialog()


/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."

/obj/machinery/computer/area_atmos/area/validscrubber( var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj )
	if(!isobj(scrubber))
		return 0

	/*
	wow this is stupid, someone help me
	*/
	var/turf/T_src = get_turf(src)
	if(!T_src.loc) return 0
	var/area/A_src = T_src.loc

	var/turf/T_scrub = get_turf(scrubber)
	if(!T_scrub.loc) return 0
	var/area/A_scrub = T_scrub.loc

	if(A_scrub != A_src)
		return 0

	return 1

/obj/machinery/computer/area_atmos/area/scanscrubbers()
	connectedscrubbers = new()

	var/found = 0

	var/turf/T = get_turf(src)
	if(!T.loc) return
	var/area/A = T.loc
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in world )
		var/turf/T2 = get_turf(scrubber)
		if(T2 && T2.loc)
			var/area/A2 = T2.loc
			if(istype(A2) && A2 == A)
				connectedscrubbers += scrubber
				found = 1


	if(!found)
		status = "ERROR: No scrubber found!"

	src.updateUsrDialog()
