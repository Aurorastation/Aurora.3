//Engine control and monitoring console

/obj/machinery/computer/ship/engines
	name = "engine control console"
	icon_screen = "enginecontrol"
	icon_keyboard = "cyan_key"
	icon_keyboard_emis = "cyan_key_mask"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/ship/engines
	var/display_state = "status"

/obj/machinery/computer/ship/engines/cockpit
	density = FALSE
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "engine"
	icon_keyboard = null
	circuit = null

/obj/machinery/computer/ship/engines/terminal
	name = "engine control terminal"
	icon = 'icons/obj/modular_computers/modular_terminal.dmi'
	icon_screen = "engines"
	icon_keyboard = "tech_key"
	icon_keyboard_emis = "tech_key_mask"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/machinery/computer/ship/engines/ui_interact(mob/user, datum/tgui/ui)
	if(!connected)
		display_reconnect_dialog(user, "ship control systems")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EnginesControl", "[connected.get_real_name()] Engines Control")
		ui.open()

/obj/machinery/computer/ship/engines/ui_data(mob/user)
	var/list/data = list()

	if(!connected)
		return

	data["state"] = display_state
	data["global_state"] = !!connected.engines_state
	data["global_limit"] = round(connected.thrust_limit * 100)

	var/total_thrust = 0
	var/list/enginfo = list()

	for(var/datum/ship_engine/E in connected.engines)
		var/list/edata = list()
		edata["eng_type"] = E.name
		edata["eng_on"] = !!E.is_on()
		edata["eng_thrust"] = E.get_thrust() * 10
		edata["eng_thrust_limiter"] = round(E.get_thrust_limit() * 100)
		edata["eng_status"] = E.get_status()
		edata["eng_reference"] = "[REF(E)]"
		total_thrust += E.get_thrust()
		enginfo += list(edata)

	data["engines_info"] = enginfo
	data["total_thrust"] = total_thrust

	return data

/obj/machinery/computer/ship/engines/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(!connected)
		return FALSE

	if(use_check_and_message(usr))
		return FALSE

	switch(action)
		if("set_state")
			var/new_state = params["state"]
			if(new_state in list("status", "engines"))
				display_state = new_state
				return TRUE
			return FALSE

		if("global_toggle")
			connected.engines_state = !connected.engines_state
			for(var/datum/ship_engine/E in connected.engines)
				if(connected.engines_state == !E.is_on())
					E.toggle()
			return TRUE

		if("set_global_limit")
			var/newlim = tgui_input_number(usr, "Input the new thrust limit.", "Thrust Limit", connected.thrust_limit * 100, 100, 0)
			if(isnull(newlim))
				return FALSE

			connected.thrust_limit = clamp(newlim / 100, 0, 1)
			for(var/datum/ship_engine/E in connected.engines)
				E.set_thrust_limit(connected.thrust_limit)
			return TRUE

		if("global_limit_delta")
			var/delta = text2num(params["delta"])
			connected.thrust_limit = round(clamp(connected.thrust_limit + delta, 0, 1),0.1)
			for(var/datum/ship_engine/E in connected.engines)
				E.set_thrust_limit(connected.thrust_limit)
			return TRUE

		if("engine_set_limit")
			var/datum/ship_engine/E = locate(params["engine"])
			if(!istype(E))
				return FALSE
			var/newlim = tgui_input_number(usr, "Input the new thrust limit.", "Thrust Limit", E.get_thrust_limit() * 100, 100, 0)
			if(isnull(newlim))
				return FALSE

			var/limit = clamp(newlim / 100, 0, 1)
			E.set_thrust_limit(limit)
			return TRUE

		if("engine_limit_delta")
			var/datum/ship_engine/E = locate(params["engine"])
			if(!istype(E))
				return FALSE

			var/delta = text2num(params["delta"])
			var/limit = clamp(E.get_thrust_limit() + delta, 0, 1)
			E.set_thrust_limit(limit)
			return TRUE

		if("engine_toggle")
			var/datum/ship_engine/E = locate(params["engine"])
			if(!istype(E))
				return FALSE

			E.toggle()
			return TRUE

	return FALSE
