/obj/machinery/computer/fusion/core_control
	name = "\improper INDRA fusion core control"
	ui_template = "FusionCoreControl"

/obj/machinery/computer/fusion/core_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/machinery/power/fusion_core/C = locate(params["machine"])
	if(!istype(C))
		return

	var/datum/local_network/lan = get_local_network()
	if(!lan || !lan.is_connected(C))
		return

	if(!C.check_core_status())
		return

	switch(action)
		if("toggle_active")
			if(!C.Startup()) //Startup() whilst the device is active will return null.
				if(!C.owned_field.is_shutdown_safe())
					if(alert(usr, "Shutting down this fusion core without proper safety procedures will cause serious damage, do you wish to continue?", "Shut Down?", "Yes", "No") == "No")
						return FALSE
				C.Shutdown()
			return TRUE

		if("strength")
			C.set_strength(params["strength"])
			return TRUE

/obj/machinery/computer/fusion/core_control/ui_data(mob/user)
	var/list/data = ..()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()

	var/list/cores = list()
	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/machinery/power/fusion_core)
		for(var/i = 1 to LAZYLEN(fusion_cores))
			var/list/core = list()
			var/obj/machinery/power/fusion_core/C = fusion_cores[i]
			core["id"] = "#[i]"
			core["ref"] = "\ref[C]"
			core["field"] = !isnull(C.owned_field)
			core["power"] = "[C.field_strength / 10]"
			core["field_strength"] = C.field_strength
			core["size"] =  C.owned_field ? C.owned_field.size : 0
			core["instability"] = C.owned_field ? C.owned_field.percent_unstable * 100 : -1 //%
			core["temperature"] = C.owned_field ? C.owned_field.plasma_temperature + 295 : -1 //K
			core["power_status"] = "[C.avail()]/[C.active_power_usage]"
			core["shutdown_safe"] = C.owned_field ? C.owned_field.is_shutdown_safe() : TRUE

			var/list/reactants = list()
			if(C.owned_field && LAZYLEN(C.owned_field.reactants))
				for(var/reactant in C.owned_field.reactants)
					reactants += list(list("name" = reactant, "amount" = C.owned_field.reactants[reactant]))
			core["reactants"] = reactants
			cores += list(core)
	data["cores"] = cores
	return data
