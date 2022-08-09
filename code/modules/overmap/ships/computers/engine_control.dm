//Engine control and monitoring console

/obj/machinery/computer/ship/engines
	name = "engine control console"
	icon_screen = "enginecontrol"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/ship/engines
	var/display_state = "status"

/obj/machinery/computer/ship/engines/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!connected)
		display_reconnect_dialog(user, "ship control systems")
		return


	var/data[0]
	data["state"] = display_state
	data["global_state"] = connected.engines_state
	data["global_limit"] = round(connected.thrust_limit*100)
	var/total_thrust = 0

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in connected.engines)
		var/list/rdata[0]
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		rdata["eng_status"] = E.get_status()
		rdata["eng_reference"] = "\ref[E]"
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo
	data["total_thrust"] = total_thrust

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "engines_control.tmpl", "[connected.get_real_name()] Engines Control", 390, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/engines/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["state"])
		display_state = href_list["state"]
		return TOPIC_REFRESH

	if(href_list["global_toggle"])
		connected.engines_state = !connected.engines_state
		for(var/datum/ship_engine/E in connected.engines)
			if(connected.engines_state == !E.is_on())
				E.toggle()
		return TOPIC_REFRESH

	if(href_list["set_global_limit"])
		var/newlim = input("Input new thrust limit (0..100%)", "Thrust limit", connected.thrust_limit*100) as num
		if(!CanInteract(usr, physical_state))
			return TOPIC_NOACTION
		connected.thrust_limit = Clamp(newlim/100, 0, 1)
		for(var/datum/ship_engine/E in connected.engines)
			E.set_thrust_limit(connected.thrust_limit)
		return TOPIC_REFRESH

	if(href_list["global_limit"])
		connected.thrust_limit = Clamp(connected.thrust_limit + text2num(href_list["global_limit"]), 0, 1)
		for(var/datum/ship_engine/E in connected.engines)
			E.set_thrust_limit(connected.thrust_limit)
		return TOPIC_REFRESH

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
			if(!CanInteract(usr, physical_state))
				return
			var/limit = Clamp(newlim/100, 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			return TOPIC_REFRESH
		if(href_list["limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/limit = Clamp(E.get_thrust_limit() + text2num(href_list["limit"]), 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			return TOPIC_REFRESH

		if(href_list["toggle"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			if(istype(E))
				E.toggle()
			return TOPIC_REFRESH
		return TOPIC_REFRESH
	return TOPIC_NOACTION
