/obj/machinery/computer/fusion/fuel_control
	name = "fuel injection control computer"
	icon_keyboard = "yellow_key"
	icon_screen = "explosive"
	ui_template = "FusionInjectorControl"
	var/global_rate = 100

/obj/machinery/computer/fusion/fuel_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/local_network/lan = get_local_network()
	var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)
	if(!lan || !fuel_injectors)
		return

	switch(action)
		if("global_toggle")
			for(var/obj/machinery/fusion_fuel_injector/F in fuel_injectors)
				if(F.injecting)
					F.StopInjecting()
				else
					F.BeginInjecting()
			return TRUE

		if("global_rate")
			if(!lan || !fuel_injectors)
				return
			var/new_injection_clamped = clamp(params["global_rate"], 1, 100) / 100
			for(var/obj/machinery/fusion_fuel_injector/F in fuel_injectors)
				F.injection_rate = new_injection_clamped
			global_rate = new_injection_clamped * 100
			return TRUE

		if("toggle_injecting")
			var/obj/machinery/fusion_fuel_injector/I = locate(params["machine"])
			if(!istype(I) || !fuel_injectors[I])
				return

			if(I.injecting)
				I.StopInjecting()
			else
				I.BeginInjecting()
			return TRUE

		if("injection_rate")
			var/obj/machinery/fusion_fuel_injector/I = locate(params["machine"])
			if(!istype(I))
				return
			I.injection_rate = clamp(params["new_injection_rate"], 1, 100) / 100
			return TOPIC_REFRESH

/obj/machinery/computer/fusion/fuel_control/ui_data(mob/user)
	var/list/data = ..()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()

	data["global_rate"] = global_rate
	var/list/injectors = list()
	if(lan)
		var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)
		for(var/i = 1 to LAZYLEN(fuel_injectors))
			var/list/injector = list()
			var/obj/machinery/fusion_fuel_injector/I = fuel_injectors[i]
			injector["id"] = "#[i]"
			injector["ref"] = "\ref[I]"
			injector["injecting"] =  I.injecting
			injector["fueltype"] = "[I.cur_assembly ? I.cur_assembly.fuel_type : "No fuel inserted."]"
			injector["depletion"] = I.cur_assembly ? (I.cur_assembly.percent_depleted * 100) : -1 //%
			injector["injection_rate"] = I.injection_rate * 100 //%
			injectors += list(injector)
	data["injectors"] = injectors
	return data
