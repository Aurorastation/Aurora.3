/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_screen = "area_atmos"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/area_atmos

	var/list/connectedscrubbers = new()

	var/range = 15

/obj/machinery/computer/area_atmos/Initialize()
	. = ..()

	scanscrubbers()

/obj/machinery/computer/area_atmos/attack_ai(var/mob/user as mob)
	ui_interact(user)
	return

/obj/machinery/computer/area_atmos/attack_hand(var/mob/user as mob)
	ui_interact(user)
	return

/obj/machinery/computer/area_atmos/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AreaAtmos")
		ui.open()

/obj/machinery/computer/area_atmos/ui_data(mob/user)
	var/list/data = list()
	var/list/scrubberdata = list()
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
		scrubberdata += list(list(
			"id" = scrubber.id,
			"name" = scrubber.name,
			"status" = scrubber.on ? 1 : 0,
			"pressure" = round(scrubber.air_contents.return_pressure(), 0.01),
			"flowrate" = round(scrubber.last_flow_rate, 0.1)
		))

	data["scrubbers"] = scrubberdata

	return data

/obj/machinery/computer/area_atmos/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action=="scan")
		scanscrubbers()
		return TRUE

	if(action=="cmode")
		for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in connectedscrubbers)
			if(scrubber.id == text2num(params["cmode"]))
				scrubber.on = !(scrubber.on)
				scrubber.update_icon()
				break

		return TRUE

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers = new()

	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
		if(istype(scrubber) && scrubber.loc.z == src.loc.z)
			connectedscrubbers += scrubber
