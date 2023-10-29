#define SIGNAL_OXYGEN 1
#define SIGNAL_PHORON 2
#define SIGNAL_NITROGEN 4
#define SIGNAL_CARBON_DIOXIDE 8
#define SIGNAL_HYDROGEN 16
#define SIGNAL_N2O 32
#define SIGNAL_HELIUM 64
#define SIGNAL_DEUTERIUM 128
#define SIGNAL_TRITIUM 256
#define SIGNAL_BORON 512

/obj/machinery/air_sensor
	name = "gas sensor"
	desc = "Measures the gas content of the atmosphere around the sensor."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	anchored = TRUE

	var/state = 0

	var/id_tag
	var/frequency = 1439

	var/on = 1
	var/output = 0
	var/output_pressure = TRUE
	var/output_temperature = TRUE
	//Flags:
	// 1 for oxygen concentration
	// 2 for phoron concentration
	// 4 for nitrogen concentration
	// 8 for carbon dioxide concentration
	// 16 for hydrogen concentration
	// 32 for nitrous oxide concentration
	// 64 for helium concentration
	// 128 for deuterium concentration
	// 256 for tritium concentration
	// 512 for boron concentration

	var/datum/radio_frequency/radio_connection

/obj/machinery/air_sensor/update_icon()
	icon_state = "gsensor[on]"

/obj/machinery/air_sensor/process()
	if(on)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		var/datum/gas_mixture/air_sample = return_air()

		if(output_pressure)
			signal.data["pressure"] = num2text(round(air_sample.return_pressure(),0.1),)
		if(output_temperature)
			signal.data["temperature"] = round(air_sample.temperature,0.1)

		if(output)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output&SIGNAL_OXYGEN)
					signal.data[GAS_OXYGEN] = round(100*air_sample.gas[GAS_OXYGEN]/total_moles,0.1)
				if(output&SIGNAL_PHORON)
					signal.data[GAS_PHORON] = round(100*air_sample.gas[GAS_PHORON]/total_moles,0.1)
				if(output&SIGNAL_NITROGEN)
					signal.data[GAS_NITROGEN] = round(100*air_sample.gas[GAS_NITROGEN]/total_moles,0.1)
				if(output&SIGNAL_CARBON_DIOXIDE)
					signal.data[GAS_CO2] = round(100*air_sample.gas[GAS_CO2]/total_moles,0.1)
				if(output&SIGNAL_HYDROGEN)
					signal.data[GAS_HYDROGEN] = round(100*air_sample.gas[GAS_HYDROGEN]/total_moles,0.1)
				if(output&SIGNAL_N2O)
					signal.data[GAS_N2O] = round(100*air_sample.gas[GAS_N2O]/total_moles,0.1)
				if(output&SIGNAL_HELIUM)
					signal.data[GAS_HELIUM] = round(100*air_sample.gas[GAS_HELIUM]/total_moles,0.1)
				if(output&SIGNAL_DEUTERIUM)
					signal.data[GAS_DEUTERIUM] = round(100*air_sample.gas[GAS_DEUTERIUM]/total_moles,0.1)
				if(output&SIGNAL_TRITIUM)
					signal.data[GAS_TRITIUM] = round(100*air_sample.gas[GAS_TRITIUM]/total_moles,0.1)
				if(output&SIGNAL_BORON)
					signal.data[GAS_BORON] = round(100*air_sample.gas[GAS_BORON]/total_moles,0.1)
			else
				signal.data[GAS_OXYGEN] = 0
				signal.data[GAS_PHORON] = 0
				signal.data[GAS_NITROGEN] = 0
				signal.data[GAS_CO2] = 0
				signal.data[GAS_HYDROGEN] = 0
				signal.data[GAS_N2O] = 0
				signal.data[GAS_HELIUM] = 0
				signal.data[GAS_DEUTERIUM] = 0
				signal.data[GAS_TRITIUM] = 0
				signal.data[GAS_BORON] = 0
		signal.data["sigtype"]="status"
		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)


/obj/machinery/air_sensor/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize()
	. = ..()
	set_frequency(frequency)

/obj/machinery/air_sensor/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/computer/general_air_control
	name = "atmosphere monitoring console"
	desc = "A console that gives an atmospheric condition readout of various sensors connected to it."
	icon_screen = "tank"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN

	var/frequency = 1439
	var/list/sensors = list()

	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection
	var/ui_type = "AtmosControl"
	circuit = /obj/item/circuitboard/air_management

/obj/machinery/computer/general_air_control/Destroy()
	if(SSradio)
		SSradio.remove_object(src, frequency)
	return ..()

/obj/machinery/computer/general_air_control/ui_data(mob/user)
	var/list/data = list("sensors" = list())
	data["control"] = null
	for(var/id_tag in sensors)
		var/long_name = sensors[id_tag]
		var/list/sdata = sensor_information[id_tag]
		var/list/sensor_data = list("id_tag" = id_tag, "name" = long_name)
		sensor_data["datapoints"] = list()
		for(var/datapoint in list("pressure", "temperature", GAS_OXYGEN, GAS_NITROGEN, GAS_CO2, GAS_PHORON, GAS_HYDROGEN, GAS_N2O, GAS_HELIUM, GAS_DEUTERIUM, GAS_TRITIUM, GAS_BORON))
			var/unit
			if(datapoint == "pressure")
				unit = "kPa"
			else if(datapoint == "temperature")
				unit = "K"
			else
				unit = "%"
			sensor_data["datapoints"] += list(list("datapoint" = datapoint, "data" = sdata[datapoint], "unit" = unit))
		data["sensors"] += list(sensor_data)
		sensor_data = list()
	return data

/obj/machinery/computer/general_air_control/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/general_air_control/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_type, "Atmospherics Control", 460, 470)
		ui.open()

/obj/machinery/computer/general_air_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]
	if(!id_tag || !sensors.Find(id_tag)) return

	sensor_information[id_tag] = signal.data

/obj/machinery/computer/general_air_control/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/Initialize()
	. = ..()
	set_frequency(frequency)


/obj/machinery/computer/general_air_control/large_tank_control
	ui_type = "AtmosControlTank"
	frequency = 1441
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/default_input_flow_setting = 200
	var/default_pressure_setting = PRESSURE_ONE_THOUSAND * 2
	var/max_input_flow_setting = ATMOS_DEFAULT_VOLUME_PUMP + 500
	var/max_pressure_setting = MAX_VENT_PRESSURE
	circuit = /obj/item/circuitboard/air_management/tank_control

/obj/machinery/computer/general_air_control/large_tank_control/terminal
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "tank"
	icon_keyboard = "atmos_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/machinery/computer/general_air_control/large_tank_control/wall
	icon = 'icons/obj/modular_telescreen.dmi'
	icon_state = "telescreen"
	icon_screen = "engi"
	density = FALSE

/obj/machinery/computer/general_air_control/large_tank_control/ui_data(mob/user)
	. = ..()
	var/list/data = .
	data["maxrate"] = max_input_flow_setting
	data["maxpressure"] = max_pressure_setting
	if(input_info)
		LAZYINITLIST(data["input"])
		data["input"]["power"] = input_info["power"]
		data["input"]["rate"] = input_info["volume_rate"]
		data["input"]["setrate"] = default_input_flow_setting

	if(output_info)
		LAZYINITLIST(data["output"])
		data["output"]["power"] = output_info["power"]
		data["output"]["pressure"] = output_info["internal"]
		data["output"]["setpressure"] = default_pressure_setting
	return data

/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/large_tank_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!radio_connection)
		return FALSE
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	switch(action)
		if("in_refresh_status")
			input_info = null
			signal.data = list("tag" = input_tag, "status" = 1)
			. = TRUE

		if("in_toggle_injector")
			input_info = null
			signal.data = list("tag" = input_tag, "power_toggle" = 1)
			. = TRUE

		if("in_set_flowrate")
			if(params["in_set_flowrate"] != null)
				var/setrate = between(0, text2num(params["in_set_flowrate"]), max_input_flow_setting)
				input_info = null
				signal.data = list ("tag" = input_tag, "set_volume_rate" = "[setrate]")
				. = TRUE

		if("out_refresh_status")
			output_info = null
			signal.data = list ("tag" = output_tag, "status" = 1)
			. = TRUE

		if("out_toggle_power")
			output_info = null
			signal.data = list ("tag" = output_tag, "power_toggle" = 1)
			. = TRUE

		if("out_set_pressure")
			if(params["out_set_pressure"] != null)
				var/setpressure = between(0, text2num(params["out_set_pressure"]), max_pressure_setting)
				output_info = null
				signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[setpressure]")
				. = TRUE

	signal.data["sigtype"] = "command"
	INVOKE_ASYNC(radio_connection, TYPE_PROC_REF(/datum/radio_frequency, post_signal), src, signal, filter = RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/supermatter_core
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "tank"
	icon_keyboard = "atmos_key"
	ui_type = "AtmosControlSupermatter"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

	frequency = 1438
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/default_input_flow_setting = 700
	var/default_pressure_setting = 100
	var/max_input_flow_setting = ATMOS_DEFAULT_VOLUME_PUMP + 500
	var/max_pressure_setting = PRESSURE_ONE_THOUSAND
	circuit = /obj/item/circuitboard/air_management/supermatter_core

/obj/machinery/computer/general_air_control/supermatter_core/ui_data(mob/user)
	. = ..()
	var/list/data = .
	data["maxrate"] = max_input_flow_setting
	data["maxpressure"] = max_pressure_setting
	if(input_info)
		LAZYINITLIST(data["input"])
		data["input"]["power"] = input_info["power"]
		data["input"]["rate"] = input_info["volume_rate"]
		data["input"]["setrate"] = default_input_flow_setting

	if(output_info)
		LAZYINITLIST(data["output"])
		data["output"]["power"] = output_info["power"]
		data["output"]["pressure"] = output_info["external"]
		data["output"]["setpressure"] = default_pressure_setting
	return data

/obj/machinery/computer/general_air_control/supermatter_core/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/supermatter_core/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!radio_connection)
		return
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	switch(action)
		if("in_refresh_status")
			input_info = null
			signal.data = list ("tag" = input_tag, "status" = 1)
			. = TRUE

		if("in_toggle_injector")
			input_info = null
			signal.data = list ("tag" = input_tag, "power_toggle" = 1)
			. = TRUE

		if("in_set_flowrate")
			if(params["in_set_flowrate"] != null)
				var/setrate = between(0, text2num(params["in_set_flowrate"]), max_input_flow_setting)
				input_info = null
				signal.data = list ("tag" = input_tag, "set_volume_rate" = "[setrate]")
				. = TRUE

		if("out_refresh_status")
			output_info = null
			signal.data = list ("tag" = output_tag, "status" = 1)
			. = TRUE

		if("out_toggle_power")
			output_info = null
			signal.data = list ("tag" = output_tag, "power_toggle" = 1)
			. = TRUE

		if("out_set_pressure")
			if(params["out_set_pressure"] != null)
				var/setpressure = between(0, text2num(params["out_set_pressure"]), max_pressure_setting)
				output_info = null
				signal.data = list ("tag" = output_tag, "set_external_pressure" = "[setpressure]", "checks" = 1)
				. = TRUE

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/fuel_injection
	icon_screen = "alert:0"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	ui_type = "AtmosControlInjector"

	var/device_tag
	var/list/device_info

	var/automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/circuitboard/air_management/injector_control

/obj/machinery/computer/general_air_control/fuel_injection/process()
	if(automation)
		if(!radio_connection)
			return 0

		var/injecting = 0
		for(var/id_tag in sensor_information)
			var/list/data = sensor_information[id_tag]
			if(data["temperature"])
				if(data["temperature"] >= cutoff_temperature)
					injecting = 0
					break
				if(data["temperature"] <= on_temperature)
					injecting = 1

		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.source = src

		signal.data = list(
			"tag" = device_tag,
			"power" = injecting,
			"sigtype"="command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/general_air_control/fuel_injection/ui_data(mob/user)
	. = ..()
	var/list/data = .
	if(device_info)
		LAZYINITLIST(data["device"])
		data["device"]["power"] = device_info["power"]
		data["device"]["rate"] = device_info["volume_rate"]
		data["device"]["automation"] = automation
	return data

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("refresh_status")
			device_info = null
			if(!radio_connection)
				return 0

			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"status" = 1,
				"sigtype"="command"
			)
			radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)
			. = TRUE

		if("toggle_automation")
			automation = !automation
			. = TRUE

		if("toggle_injector")
			device_info = null
			if(!radio_connection)
				return 0

			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"power_toggle" = 1,
				"sigtype"="command"
			)

			radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)
			. = TRUE

		if("injection")
			if(!radio_connection)
				return 0

			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			signal.source = src
			signal.data = list(
				"tag" = device_tag,
				"inject" = 1,
				"sigtype"="command"
			)

			radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)
			. = TRUE

#undef SIGNAL_OXYGEN
#undef SIGNAL_PHORON
#undef SIGNAL_NITROGEN
#undef SIGNAL_CARBON_DIOXIDE
#undef SIGNAL_HYDROGEN
#undef SIGNAL_N2O
#undef SIGNAL_HELIUM
#undef SIGNAL_DEUTERIUM
#undef SIGNAL_TRITIUM
#undef SIGNAL_BORON
