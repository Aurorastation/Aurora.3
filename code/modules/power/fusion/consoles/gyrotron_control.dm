/obj/machinery/computer/fusion/gyrotron
	name = "gyrotron control console"
	desc = "A terminal for controlling an INDRA Mk.II Tokamak Fusion core using Hephaestus software."
	icon_keyboard = "yellow_key"
	icon_screen = "power_monitor"
	light_color = COLOR_ORANGE
	ui_template = "FusionGyrotronControl"

/obj/machinery/computer/fusion/gyrotron/terminal
	name = "gyrotron control terminal"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "rust_screen"
	icon_keyboard = "generic_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/machinery/computer/fusion/gyrotron/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/machinery/power/emitter/gyrotron/G = locate(params["machine"])
	if(!istype(G))
		return

	var/datum/local_network/lan = get_local_network()
	var/list/gyrotrons = lan.get_devices(/obj/machinery/power/emitter/gyrotron)
	if(!lan || !gyrotrons || !gyrotrons[G])
		return

	switch(action)
		if("modifypower")
			G.mega_energy = clamp(params["modifypower"], 1, 50)
			G.change_power_consumption(G.mega_energy * GYRO_POWER, POWER_USE_ACTIVE)
			return TRUE

		if("modifyrate")
			G.rate = clamp(params["modifyrate"], 2, 10)
			return TRUE

		if("toggle")
			G.activate(usr)
			return TRUE

/obj/machinery/computer/fusion/gyrotron/ui_data(mob/user)
	var/list/data = ..()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()

	var/list/gyrotrons = list()
	if(lan && gyrotrons)
		var/list/lan_gyrotrons = lan.get_devices(/obj/machinery/power/emitter/gyrotron)
		for(var/i = 1 to LAZYLEN(lan_gyrotrons))
			var/list/gyrotron = list()
			var/obj/machinery/power/emitter/gyrotron/G = lan_gyrotrons[i]
			gyrotron["id"] = "#[i]"
			gyrotron["ref"] = "\ref[G]"
			gyrotron["active"] = G.active
			gyrotron["firedelay"] = G.rate
			gyrotron["energy"] = G.mega_energy
			gyrotrons += list(gyrotron)
	data["gyro_power_constant"] = GYRO_POWER
	data["gyrotrons"] = gyrotrons
	return data
