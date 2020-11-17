#define SIGNAL_OXYGEN 1
#define SIGNAL_PHORON 2
#define SIGNAL_NITROGEN 4
#define SIGNAL_CARBON_DIOXIDE 8
#define SIGNAL_HYDROGEN 16

/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	name = "gas Sensor"
	desc = "Measures the gas content of the atmosphere around the sensor."

	anchored = 1
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

	var/datum/radio_frequency/radio_connection

/obj/machinery/air_sensor/update_icon()
	icon_state = "gsensor[on]"

/obj/machinery/air_sensor/machinery_process()
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
			else
				signal.data[GAS_OXYGEN] = 0
				signal.data[GAS_PHORON] = 0
				signal.data[GAS_NITROGEN] = 0
				signal.data[GAS_CO2] = 0
				signal.data[GAS_HYDROGEN] = 0
		signal.data["sigtype"]="status"
		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)


/obj/machinery/air_sensor/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize()
	. = ..()
	set_frequency(frequency)

obj/machinery/air_sensor/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/computer/general_air_control
	name = "atmosphere monitoring console"
	desc = "A console that gives an atmospheric condition readout of various sensors connected to it."
	icon_screen = "tank"
	light_color = LIGHT_COLOR_CYAN

	var/frequency = 1439
	var/list/sensors = list()

	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection
	circuit = /obj/item/circuitboard/air_management

obj/machinery/computer/general_air_control/Destroy()
	if(SSradio)
		SSradio.remove_object(src, frequency)
	return ..()

/obj/machinery/computer/general_air_control/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list("sensors" = list())
	data["control"] = null
	for(var/id_tag in sensors)
		var/long_name = sensors[id_tag]
		var/list/sdata = sensor_information[id_tag]
		LAZYINITLIST(data["sensors"][id_tag])
		VUEUI_SET_CHECK(data["sensors"][id_tag]["name"], long_name, ., data)
		for(var/datapoint in list("pressure", "temperature", GAS_OXYGEN, GAS_NITROGEN, GAS_CO2, GAS_PHORON, GAS_HYDROGEN))
			VUEUI_SET_CHECK(data["sensors"][id_tag][datapoint], sdata[datapoint], ., data)

/obj/machinery/computer/general_air_control/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/general_air_control/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "console-atmocontrol-main", 460, 470, capitalize(src.name))
		ui.auto_update_content = TRUE
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

	frequency = 1441
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/default_input_flow_setting = 200
	var/default_pressure_setting = ONE_ATMOSPHERE * 45
	var/max_input_flow_setting = ATMOS_DEFAULT_VOLUME_PUMP + 500
	var/max_pressure_setting = 50 * ONE_ATMOSPHERE
	circuit = /obj/item/circuitboard/air_management/tank_control

/obj/machinery/computer/general_air_control/large_tank_control/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data
	data["control"] = "tank"
	data["maxrate"] = max_input_flow_setting
	data["maxpressure"] = max_pressure_setting
	if(input_info)
		LAZYINITLIST(data["input"])
		VUEUI_SET_CHECK(data["input"]["power"], input_info["power"], ., data)
		VUEUI_SET_CHECK(data["input"]["rate"], input_info["volume_rate"], ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["input"]["setrate"], default_input_flow_setting, ., data)

	if(output_info)
		LAZYINITLIST(data["output"])
		VUEUI_SET_CHECK(data["output"]["power"], output_info["power"], ., data)
		VUEUI_SET_CHECK(data["output"]["pressure"], output_info["internal"], ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["output"]["setpressure"], default_pressure_setting, ., data)


/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/large_tank_control/Topic(href, href_list)
	if(..())
		return 1

	if(!radio_connection)
		return 0
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	if(href_list["in_refresh_status"])
		input_info = null
		signal.data = list ("tag" = input_tag, "status" = 1)

	if(href_list["in_toggle_injector"])
		input_info = null
		signal.data = list ("tag" = input_tag, "power_toggle" = 1)

	if(href_list["in_set_flowrate"] != null)
		var/setrate = between(0, text2num(href_list["in_set_flowrate"]), max_input_flow_setting)
		input_info = null
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[setrate]")

	if(href_list["out_refresh_status"])
		output_info = null
		signal.data = list ("tag" = output_tag, "status" = 1)

	if(href_list["out_toggle_power"])
		output_info = null
		signal.data = list ("tag" = output_tag, "power_toggle" = 1)

	if(href_list["out_set_pressure"] != null)
		var/setpressure = between(0, text2num(href_list["out_set_pressure"]), max_pressure_setting)
		output_info = null
		signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[setpressure]")

	signal.data["sigtype"] = "command"
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	addtimer(CALLBACK(SSvueui, /datum/controller/subsystem/processing/vueui/proc/check_uis_for_change, src), 5) //Just in case we get no new data

/obj/machinery/computer/general_air_control/supermatter_core
	icon = 'icons/obj/computer.dmi'

	frequency = 1438
	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/default_input_flow_setting = 700
	var/default_pressure_setting = 100
	var/max_input_flow_setting = ATMOS_DEFAULT_VOLUME_PUMP + 500
	var/max_pressure_setting = 10 * ONE_ATMOSPHERE
	circuit = /obj/item/circuitboard/air_management/supermatter_core

/obj/machinery/computer/general_air_control/supermatter_core/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data
	data["control"] = "supermatter"
	data["maxrate"] = max_input_flow_setting
	data["maxpressure"] = max_pressure_setting
	if(input_info)
		LAZYINITLIST(data["input"])
		VUEUI_SET_CHECK(data["input"]["power"], input_info["power"], ., data)
		VUEUI_SET_CHECK(data["input"]["rate"], input_info["volume_rate"], ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["input"]["setrate"], default_input_flow_setting, ., data)

	if(output_info)
		LAZYINITLIST(data["output"])
		VUEUI_SET_CHECK(data["output"]["power"], output_info["power"], ., data)
		VUEUI_SET_CHECK(data["output"]["pressure"], output_info["external"], ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["output"]["setpressure"], default_pressure_setting, ., data)

/obj/machinery/computer/general_air_control/supermatter_core/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/supermatter_core/Topic(href, href_list)
	if(..())
		return

	if(!radio_connection)
		return
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	if(href_list["in_refresh_status"])
		input_info = null
		signal.data = list ("tag" = input_tag, "status" = 1)

	if(href_list["in_toggle_injector"])
		input_info = null
		signal.data = list ("tag" = input_tag, "power_toggle" = 1)

	if(href_list["in_set_flowrate"] != null)
		var/setrate = between(0, text2num(href_list["in_set_flowrate"]), max_input_flow_setting)
		input_info = null
		signal.data = list ("tag" = input_tag, "set_volume_rate" = "[setrate]")

	if(href_list["out_refresh_status"])
		output_info = null
		signal.data = list ("tag" = output_tag, "status" = 1)

	if(href_list["out_toggle_power"])
		output_info = null
		signal.data = list ("tag" = output_tag, "power_toggle" = 1)

	if(href_list["out_set_pressure"] != null)
		var/setpressure = between(0, text2num(href_list["out_set_pressure"]), max_pressure_setting)
		output_info = null
		signal.data = list ("tag" = output_tag, "set_external_pressure" = "[setpressure]", "checks" = 1)

	signal.data["sigtype"]="command"
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	addtimer(CALLBACK(SSvueui, /datum/controller/subsystem/processing/vueui/proc/check_uis_for_change, src), 5) //Just in case we get no new data

/obj/machinery/computer/general_air_control/fuel_injection
	icon_screen = "alert:0"

	var/device_tag
	var/list/device_info

	var/automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/circuitboard/air_management/injector_control

/obj/machinery/computer/general_air_control/fuel_injection/machinery_process()
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

/obj/machinery/computer/general_air_control/fuel_injection/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data
	data["control"] = "injector"
	if(device_info)
		LAZYINITLIST(data["device"])
		VUEUI_SET_CHECK(data["device"]["power"], device_info["power"], ., data)
		VUEUI_SET_CHECK(data["device"]["rate"], device_info["volume_rate"], ., data)
		VUEUI_SET_CHECK(data["device"]["automation"], automation, ., data)

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection/Topic(href, href_list)
	if(..())
		return

	if(href_list["refresh_status"])
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

	if(href_list["toggle_automation"])
		automation = !automation
		SSvueui.check_uis_for_change(src)

	if(href_list["toggle_injector"])
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

	if(href_list["injection"])
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

#undef SIGNAL_OXYGEN
#undef SIGNAL_PHORON
#undef SIGNAL_NITROGEN
#undef SIGNAL_CARBON_DIOXIDE
#undef SIGNAL_HYDROGEN