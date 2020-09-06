/datum/computer_file/program/pai_atmos
	filename = "pai_atmos"
	filedesc = "Atmosphere Sensor"
	program_icon_state = "generic"
	extended_desc = "This program is for viewing local atmospheric data."
	size = 0

	usage_flags = PROGRAM_SILICON_PAI

/datum/computer_file/program/pai_atmos/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-pai-atmosphere", 400, 200, "pAI Atmosphere Sensor")
	ui.open()

/datum/computer_file/program/pai_atmos/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-pai-atmosphere", 400, 200, "pAI Atmosphere Sensor")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/pai_atmos/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	var/turf/T = get_turf_or_move(host.loc)

	
	if(T)
		var/datum/gas_mixture/env = T.return_air()
		VUEUI_SET_CHECK(data["read"], TRUE, ., data)
		VUEUI_SET_CHECK(data["press"], env.return_pressure(), ., data)
		VUEUI_SET_CHECK(data["temp"], env.temperature, ., data)
		VUEUI_SET_CHECK(data["tempC"], env.temperature-T0C, ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["gas"], list("_" = "_"), ., data)
		for(var/g in gas_data.gases)
			if(!(g in env.gas))
				VUEUI_SET_CHECK(data["gas"][g], null, ., data)
			else
				VUEUI_SET_CHECK(data["gas"][g], env.gas[g], ., data)
	else
		VUEUI_SET_CHECK(data["read"], FALSE, ., data)
		VUEUI_SET_CHECK(data["press"], 0, ., data)
		VUEUI_SET_CHECK(data["temp"], T0C, ., data)
		VUEUI_SET_CHECK(data["tempC"], 0, ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["gas"], list("_" = "_"), ., data)
		for(var/g in gas_data.gases)
			VUEUI_SET_CHECK(data["gas"][g], null, ., data)
