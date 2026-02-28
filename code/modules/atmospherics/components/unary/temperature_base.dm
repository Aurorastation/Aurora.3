ABSTRACT_TYPE(/obj/machinery/atmospherics/unary/temperature)
	name = "gas thermoregulation system"
	desc = DESC_PARENT
	layer = STRUCTURE_LAYER
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_OFF
	idle_power_usage = 5			//5 Watts for thermostat related circuitry
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_AUX

	var/max_temperature = T20C + 680
	var/internal_volume = 600	//L

	var/max_power_rating = 20000	//power rating when the usage is turned up to 100
	var/power_setting = 100

	var/set_temperature = T20C	//thermostat
	var/is_modifying_gas = FALSE //mainly for icon updates

	var/performance_multiplier = 1

	var/gas_temperature_bad_bottom = null
	var/gas_temperature_bad_top = (T20C + 40)
	var/gas_temperature_average_bottom = null
	var/gas_temperature_average_top = null

	component_types = list(
		/obj/item/circuitboard/unary_atmos/heater,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator,
		/obj/item/stack/cable_coil{amount = 5}
	)

	parts_power_mgmt = FALSE

/obj/machinery/atmospherics/unary/temperature/update_icon()
	if(!LAZYLEN(nodes_to_networks))
		icon_state = "[icon_state]_0"
	else if(use_power && is_modifying_gas)
		icon_state = "[icon_state]_1"
	else
		icon_state = icon_state

	build_device_underlays()

// Modify air_contents in this proc.
/obj/machinery/atmospherics/unary/temperature/proc/modify_gas()

/obj/machinery/atmospherics/unary/temperature/proc/should_modify_gas()
	return FALSE

/obj/machinery/atmospherics/unary/temperature/process(seconds_per_tick)
	..()

	is_modifying_gas = FALSE
	if(stat & (NOPOWER|BROKEN) || !use_power)
		update_icon()
		return

	if(LAZYLEN(nodes_to_networks) && air_contents.total_moles && should_modify_gas())
		modify_gas()
		is_modifying_gas = TRUE
		use_power_oneoff(power_rating)
		update_networks()

	update_icon()

/obj/machinery/atmospherics/unary/temperature/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Freezer", "[capitalize_first_letters(name)]", 440, 300)
		ui.open()

/obj/machinery/atmospherics/unary/temperature/ui_data(mob/user)
	var/list/data = list()

	data["on"] = !!use_power
	data["gasPressure"] = round(XGM_PRESSURE(air_contents))
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = 0
	data["maxGasTemperature"] = max_temperature + 100
	data["targetGasTemperature"] = round(set_temperature)
	data["powerSetting"] = power_setting

	data["gasTemperatureBadTop"] = (T20C + 40)
	data["gasTemperatureBadBottom"] = null
	data["gasTemperatureAvgTop"] = null
	data["gasTemperatureAvgBottom"] = null

	return data

/obj/machinery/atmospherics/unary/temperature/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("power")
			update_use_power(use_power ? POWER_USE_OFF : POWER_USE_ACTIVE)
			update_icon()
			. = TRUE
		if("temp")
			var/amount = text2num(params["temp"])
			set_temperature = between(0, amount, max_temperature)
			. = TRUE
		if("setPower") //setting power to 0 is redundant anyways
			var/new_setting = between(0, text2num(params["setPower"]), 100)
			set_power_level(new_setting)
			. = TRUE

	add_fingerprint(usr)

/obj/machinery/atmospherics/unary/temperature/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

	return ..()

/obj/machinery/atmospherics/unary/temperature/proc/set_power_level(new_power_setting)
	power_setting = new_power_setting
	power_rating = max_power_rating * (power_setting/100)
