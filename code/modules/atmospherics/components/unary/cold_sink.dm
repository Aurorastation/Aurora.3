//TODO: Put this under a common parent type with heaters to cut down on the copypasta
#define FREEZER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/freezer
	name = "gas cooling system"
	desc = "Cools gas when connected to pipe network."
	desc_info = "Cools down the gas of the pipe it is connected to.  It uses massive amounts of electricity while on. \
	It can be upgraded by replacing the capacitors, manipulators, and matter bins.  It can be deconstructed by screwing the maintenance panel open with a \
	screwdriver, and then using a crowbar."
	icon = 'icons/obj/machinery/sleeper.dmi'
	icon_state = "freezer_0"
	density = 1
	anchored = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 5			// 5 Watts for thermostat related circuitry

	var/heatsink_temperature = T20C	// The constant temperature reservoir into which the freezer pumps heat. Probably the hull of the station or something.
	var/internal_volume = 600		// L

	var/max_power_rating = 20000	// Power rating when the usage is turned up to 100
	var/power_setting = 100

	var/set_temperature = T20C		// Thermostat
	var/cooling = 0

	component_types = list(
		/obj/item/circuitboard/unary_atmos/cooler,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/stock_parts/manipulator,
		/obj/item/stack/cable_coil{amount = 2}
	)

/obj/machinery/atmospherics/unary/freezer/Initialize()
	initialize_directions = dir
	. = ..()

/obj/machinery/atmospherics/unary/freezer/atmos_init()
	if(node)
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

	//copied from pipe construction code since heaters/freezers don't use fittings and weren't doing this check - this all really really needs to be refactored someday.
	//check that there are no incompatible pipes/machinery in our own location
	for(var/obj/machinery/atmospherics/M in src.loc)
		if(M != src && (M.initialize_directions & node_connect) && M.check_connect_types(M,src))	// matches at least one direction on either type of pipe & same connection type
			node = null
			break

	update_icon()

/obj/machinery/atmospherics/unary/freezer/update_icon()
	if(node)
		if(use_power && cooling)
			icon_state = "freezer_1"
		else
			icon_state = "freezer"
	else
		icon_state = "freezer_0"
	return

/obj/machinery/atmospherics/unary/freezer/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/atmospherics/unary/freezer/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/atmospherics/unary/freezer/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Freezer", "Gas Cooling System", 440, 300)
		ui.open()

/obj/machinery/atmospherics/unary/freezer/ui_data(mob/user)
	var/list/data = list()

	data["on"] = !!use_power
	data["gasPressure"] = round(air_contents.return_pressure())
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = 0
	data["maxGasTemperature"] = round(T20C+500)
	data["targetGasTemperature"] = round(set_temperature)
	data["powerSetting"] = power_setting

	data["gasTemperatureBadTop"] = (T0C - 20)
	data["gasTemperatureBadBottom"] = null
	data["gasTemperatureAvgTop"] = (T0C - 20)
	data["gasTemperatureAvgBottom"] = (T0C - 100)

	return data

/obj/machinery/atmospherics/unary/freezer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
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
			set_temperature = between(0, amount, 1000)
			. = TRUE
		if("setPower") //setting power to 0 is redundant anyways
			var/new_setting = between(0, text2num(params["setPower"]), 100)
			set_power_level(new_setting)
			. = TRUE

	add_fingerprint(usr)

/obj/machinery/atmospherics/unary/freezer/process(seconds_per_tick)
	..()

	if(stat & (NOPOWER|BROKEN) || !use_power)
		cooling = 0
		update_icon()
		return

	if(network && air_contents.temperature > set_temperature)
		cooling = 1

		var/heat_transfer = max( -air_contents.get_thermal_energy_change(set_temperature - 5), 0 )

		//Assume the heat is being pumped into the hull which is fixed at heatsink_temperature
		//not /really/ proper thermodynamics but whatever
		var/cop = FREEZER_PERF_MULT * air_contents.temperature/heatsink_temperature	//heatpump coefficient of performance from thermodynamics -> power used = heat_transfer/cop
		heat_transfer = min(heat_transfer, cop * power_rating)	//limit heat transfer by available power

		var/removed = -air_contents.add_thermal_energy(-heat_transfer*seconds_per_tick)		//remove the heat
		if(debug)
			visible_message("[src]: Removing [removed] W.")

		use_power_oneoff(power_rating*seconds_per_tick)

		network.update = 1
	else
		cooling = 0

	update_icon()

//upgrading parts
/obj/machinery/atmospherics/unary/freezer/RefreshParts()
	..()
	var/cap_rating = 0
	var/manip_rating = 0
	var/bin_rating = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			cap_rating += P.rating
		else if(ismanipulator(P))
			manip_rating += P.rating
		else if(ismatterbin(P))
			bin_rating += P.rating

	power_rating = initial(power_rating) * cap_rating / 2			//more powerful
	heatsink_temperature = initial(heatsink_temperature) / ((manip_rating + bin_rating) / 2)	//more efficient
	air_contents.volume = max(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/freezer/proc/set_power_level(var/new_power_setting)
	power_setting = new_power_setting
	power_rating = max_power_rating * (power_setting/100)

/obj/machinery/atmospherics/unary/freezer/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

	return ..()

/obj/machinery/atmospherics/unary/freezer/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(panel_open)
		. += "The maintenance hatch is open."
