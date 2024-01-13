////////////////////////////////////////
//CONTAINS: Air Alarms and Fire Alarms//
////////////////////////////////////////

#define AALARM_MODE_SCRUBBING	1
#define AALARM_MODE_REPLACEMENT	2 //like scrubbing, but faster.
#define AALARM_MODE_PANIC		3 //constantly sucks all air
#define AALARM_MODE_CYCLE		4 //sucks off all air, then refill and switches to scrubbing
#define AALARM_MODE_FILL		5 //emergency fill
#define AALARM_MODE_OFF			6 //Shuts it all down.

#define AALARM_SCREEN_MAIN		1
#define AALARM_SCREEN_VENT		2
#define AALARM_SCREEN_SCRUB		3
#define AALARM_SCREEN_MODE		4
#define AALARM_SCREEN_SENSORS	5

#define AALARM_REPORT_TIMEOUT 100

#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

/**
 * Get the danger level of a zone
 *
 * * RETURN_VALUE - The variable to store the return value
 * * current_value - The current value to check the danger-ness against
 * * danger_levels - A list with the danger levels
 */
#define ALARM_GET_DANGER_LEVEL(RETURN_VALUE, current_value, danger_levels)\
	if((current_value > danger_levels[4] && danger_levels[4] > 0) || current_value < danger_levels[1]){\
		RETURN_VALUE = 2;\
	}\
	else if((current_value > danger_levels[3] && danger_levels[3] > 0) || current_value < danger_levels[2]){\
		RETURN_VALUE = 1;\
	}\
	else{\
		RETURN_VALUE = 0;\
	}

/**
 * Get the overall danger level of the environment
 *
 * * RETURN_VALUE - The variable to store the return value
 * * environment - A `/datum/gas_mixture` to perform the danger level calculation against
 */
#define ALARM_GET_OVERALL_DANGER_LEVEL(RETURN_VALUE, environment)\
	do {\
		var/partial_pressure = R_IDEAL_GAS_EQUATION*environment.temperature/environment.volume;\
		var/other_moles = 0;\
		for(var/g in trace_gas){\
			other_moles += environment.gas[g];\
		}\
		ALARM_GET_DANGER_LEVEL(pressure_dangerlevel, environment.return_pressure(), TLV["pressure"]);\
		ALARM_GET_DANGER_LEVEL(oxygen_dangerlevel, environment.gas[GAS_OXYGEN]*partial_pressure, TLV[GAS_OXYGEN]);\
		ALARM_GET_DANGER_LEVEL(co2_dangerlevel, environment.gas[GAS_CO2]*partial_pressure, TLV[GAS_CO2]);\
		ALARM_GET_DANGER_LEVEL(phoron_dangerlevel, environment.gas[GAS_PHORON]*partial_pressure, TLV[GAS_PHORON]);\
		ALARM_GET_DANGER_LEVEL(hydrogen_dangerlevel, environment.gas[GAS_HYDROGEN]*partial_pressure, TLV[GAS_HYDROGEN]);\
		ALARM_GET_DANGER_LEVEL(temperature_dangerlevel, environment.temperature, TLV["temperature"]);\
		ALARM_GET_DANGER_LEVEL(other_dangerlevel, other_moles*partial_pressure, TLV["other"]);\
		\
		RETURN_VALUE = max(\
		pressure_dangerlevel,\
		oxygen_dangerlevel,\
		co2_dangerlevel,\
		phoron_dangerlevel,\
		hydrogen_dangerlevel,\
		other_dangerlevel,\
		temperature_dangerlevel\
		);\
	} while (FALSE)

#define PRESET_NORTH \
dir = NORTH; \
pixel_y = 21;

#define PRESET_SOUTH \
dir = SOUTH; \
pixel_y = -3;

#define PRESET_WEST \
dir = WEST; \
pixel_x = -10;

#define PRESET_EAST \
dir = EAST; \
pixel_x = 10;

//all air alarms in area are connected via magic
/area
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/machinery/alarm
	name = "alarm"
	desc = "A device that controls the local air regulation machinery and informs you when you're breathing vacuum."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarmp"
	anchored = 1
	idle_power_usage = 90
	active_power_usage = 1500 //For heating/cooling rooms. 1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
	power_channel = ENVIRON
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)
	clicksound = /singleton/sound_category/button_sound
	clickvol = 30
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

	var/alarm_id = null
	var/breach_detection = 1 // Whether to use automatic breach detection or not
	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = 0
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = 1
	var/wiresexposed = 0 // If it's been screwdrivered open.
	var/aidisabled = 0
	var/shorted = 0
	var/highpower = 0	// if true, power usage & temperature regulation power is increased

	var/datum/wires/alarm/wires

	var/mode = AALARM_MODE_SCRUBBING
	var/screen = AALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area
	var/buildstage = 2 //2 is built, 1 is building, 0 is frame.

	var/target_temperature = T0C+20
	var/regulating_temperature = 0

	var/datum/radio_frequency/radio_connection

	var/list/TLV = list()
	var/list/trace_gas = list(GAS_N2O) //list of other gases that this air alarm is able to detect

	var/danger_level = 0
	var/pressure_dangerlevel = 0
	var/oxygen_dangerlevel = 0
	var/co2_dangerlevel = 0
	var/phoron_dangerlevel = 0
	var/hydrogen_dangerlevel = 0
	var/temperature_dangerlevel = 0
	var/other_dangerlevel = 0

	var/report_danger_level = 1

	var/global/image/alarm_overlay

	//Used to cache the previous gas mixture result, and evaluate if we can skip processing or not
	var/previous_environment_group_multiplier = null
	var/previous_environment_temperature = null
	var/previous_environment_total_moles = null
	var/previous_environment_volume = null
	var/list/previous_environment_gas = list()

/obj/machinery/alarm/north
	PRESET_NORTH

/obj/machinery/alarm/east
	PRESET_EAST

/obj/machinery/alarm/west
	PRESET_WEST

/obj/machinery/alarm/south
	PRESET_SOUTH

/obj/machinery/alarm/nobreach
	breach_detection = 0
	desc = "A device that controls the local air regulation machinery."

/obj/machinery/alarm/nobreach/north
	PRESET_NORTH

/obj/machinery/alarm/nobreach/east
	PRESET_EAST

/obj/machinery/alarm/nobreach/west
	PRESET_WEST

/obj/machinery/alarm/nobreach/south
	PRESET_SOUTH

/obj/machinery/alarm/monitor
	report_danger_level = 0
	breach_detection = 0
	desc = "A device that controls the local air regulation machinery."

/obj/machinery/alarm/monitor/north
	PRESET_NORTH

/obj/machinery/alarm/monitor/east
	PRESET_EAST

/obj/machinery/alarm/monitor/west
	PRESET_WEST

/obj/machinery/alarm/monitor/south
	PRESET_SOUTH

/obj/machinery/alarm/server
	req_one_access = list(ACCESS_RD, ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)
	target_temperature = 80
	desc = "A device that controls the local air regulation machinery. This one is designed for use in small server rooms."
	highpower = 1

/obj/machinery/alarm/server/north
	PRESET_NORTH

/obj/machinery/alarm/server/east
	PRESET_EAST

/obj/machinery/alarm/server/west
	PRESET_WEST

/obj/machinery/alarm/server/south
	PRESET_SOUTH

/obj/machinery/alarm/tcom
	desc = "A device that controls the local air regulation machinery. This one is designed for use in server halls."
	req_access = list(ACCESS_TCOMSAT)
	highpower = 1

/obj/machinery/alarm/tcom/north
	PRESET_NORTH

/obj/machinery/alarm/tcom/east
	PRESET_EAST

/obj/machinery/alarm/tcom/west
	PRESET_WEST

/obj/machinery/alarm/tcom/south
	PRESET_SOUTH

/obj/machinery/alarm/freezer
	req_one_access = list(ACCESS_KITCHEN, ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)
	highpower = 1
	target_temperature = T0C - 20

/obj/machinery/alarm/freezer/north
	PRESET_NORTH

/obj/machinery/alarm/freezer/east
	PRESET_EAST

/obj/machinery/alarm/freezer/west
	PRESET_WEST

/obj/machinery/alarm/freezer/south
	PRESET_SOUTH

/obj/machinery/alarm/cold
	target_temperature = T0C + 5

/obj/machinery/alarm/cold/north
	PRESET_NORTH

/obj/machinery/alarm/cold/east
	PRESET_EAST

/obj/machinery/alarm/cold/west
	PRESET_WEST

/obj/machinery/alarm/cold/south
	PRESET_SOUTH

/obj/machinery/alarm/server/Initialize()
	. = ..()
	TLV[GAS_OXYGEN] =			list(-1.0, -1.0,-1.0,-1.0) // Partial pressure, kpa
	TLV[GAS_CO2] = 				list(-1.0, -1.0,   5,  10) // Partial pressure, kpa
	TLV[GAS_PHORON] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV[GAS_HYDROGEN] = 		list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(0,ONE_ATMOSPHERE*0.10,ONE_ATMOSPHERE*1.40,ONE_ATMOSPHERE*1.60) /* kpa */
	TLV["temperature"] =	list(20, 40, 140, 160) // K

//For colder alarms, allowing pressure to drop a bit below normal is necessary. Pressure fluctuates downwards
//While temperature stabilises.

//Kitchen freezer
/obj/machinery/alarm/freezer/Initialize()
	. = ..()
	TLV[GAS_OXYGEN] = list(16, 17, 135, 140) // Partial pressure, kpa
	TLV["pressure"] = list(ONE_ATMOSPHERE*0.50,ONE_ATMOSPHERE*0.70,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20)
	TLV["temperature"] = list(0, 0, 273, T0C+40) // No lower limits. Alarm above 0c. Major alarm at harmful heat

//Refridgerated area, cold but above-freezing
/obj/machinery/alarm/cold/Initialize()
	. = ..()
	TLV["pressure"] =		list(ONE_ATMOSPHERE*0.70,ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20) /* kpa */
	TLV["temperature"] =	list(247, 273, 288, T0C+40) // Shouldn't go below 0

/obj/machinery/alarm/Destroy()
	unregister_radio(src, frequency)
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/alarm/LateInitialize()
	apply_mode()

/obj/machinery/alarm/Initialize(mapload, var/dir, var/building = 0)
	. = ..()

	if(building)
		if(dir)
			src.set_dir(dir)
		buildstage = 0
		wiresexposed = 1

		update_icon()
		return

	first_run()

	set_frequency(frequency)

	if(!mapload)
		set_pixel_offsets()

	update_icon()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/alarm/set_pixel_offsets()
	pixel_x = ((src.dir & (NORTH|SOUTH)) ? 0 : (src.dir == EAST ? 10 : -10))
	pixel_y = ((src.dir & (NORTH|SOUTH)) ? (src.dir == NORTH ? 21 : -6) : 0)

/obj/machinery/alarm/proc/first_run()
	alarm_area = get_area(src)
	area_uid = alarm_area.uid
	if (name == "alarm")
		if (highpower)
			name = "[alarm_area.name] High-Power Air Alarm"
		else
			name = "[alarm_area.name] Air Alarm"

	if(!wires)
		wires = new(src)

	if (highpower)
		change_power_consumption(active_power_usage * 6, POWER_USE_ACTIVE)
		change_power_consumption(idle_power_usage * 3, POWER_USE_IDLE)

	// breathable air according to human/Life()
	TLV[GAS_OXYGEN] =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV[GAS_CO2] = 				list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV[GAS_PHORON] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV[GAS_HYDROGEN] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20) /* kpa */
	TLV["temperature"] =	list(T0C-26, T0C, T0C+40, T0C+66) // K

/obj/machinery/alarm/process(seconds_per_tick)
	if((stat & (NOPOWER|BROKEN)) || shorted || buildstage != 2)
		return

	var/turf/simulated/location = loc
	if(!istype(location))	return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	var/is_same_environment = TRUE
	for(var/k in environment.gas)
		if(environment.gas[k] != previous_environment_gas[k])
			is_same_environment = FALSE
			previous_environment_gas = environment.gas.Copy()
			break
	if(is_same_environment)
		if(	(environment.temperature != previous_environment_temperature) ||\
			(environment.group_multiplier != previous_environment_group_multiplier) ||\
			(environment.total_moles != previous_environment_total_moles) ||\
			(environment.volume != previous_environment_volume)
		)
			is_same_environment = FALSE
			previous_environment_group_multiplier = environment.group_multiplier
			previous_environment_temperature = environment.temperature
			previous_environment_total_moles = environment.total_moles
			previous_environment_volume = environment.volume

	if(is_same_environment)
		return

	//Handle temperature adjustment here.
	handle_heating_cooling(environment, seconds_per_tick)

	var/old_level = danger_level
	var/old_pressurelevel = pressure_dangerlevel
	ALARM_GET_OVERALL_DANGER_LEVEL(danger_level, environment)

	if (old_level != danger_level)
		apply_danger_level(danger_level)

	if (old_pressurelevel != pressure_dangerlevel)
		if (breach_detected())
			mode = AALARM_MODE_OFF
			apply_mode()

	if (mode==AALARM_MODE_CYCLE && environment.return_pressure()<ONE_ATMOSPHERE*0.05)
		mode=AALARM_MODE_FILL
		apply_mode()

	//atmos computer remote controll stuff
	switch(rcon_setting)
		if(RCON_NO)
			remote_control = 0
		if(RCON_AUTO)
			if(danger_level == 2)
				remote_control = 1
			else
				remote_control = 0
		if(RCON_YES)
			remote_control = 1

	return

/obj/machinery/alarm/proc/handle_heating_cooling(datum/gas_mixture/environment, seconds_per_tick)
	var/danger_level = null
	ALARM_GET_DANGER_LEVEL(danger_level, target_temperature, TLV["temperature"])

	if (!regulating_temperature)
		//check for when we should start adjusting temperature
		if(!danger_level && abs(environment.temperature - target_temperature) > 2.0)
			update_use_power(POWER_USE_ACTIVE)
			regulating_temperature = 1
			visible_message("\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click and a faint electronic hum.")
			update_icon()
	else
		//check for when we should stop adjusting temperature
		if (danger_level || abs(environment.temperature - target_temperature) <= 0.5)
			update_use_power(POWER_USE_IDLE)
			regulating_temperature = 0
			visible_message("\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click as a faint electronic humming stops.")
			update_icon()

	if (regulating_temperature)
		//Unnecessary checks removed, duplication of effort

		var/datum/gas_mixture/gas
		gas = environment.remove(seconds_per_tick * 0.25*environment.total_moles)
		if(gas)

			if (gas.temperature <= target_temperature)	//gas heating
				var/energy_used = min( gas.get_thermal_energy_change(target_temperature) , active_power_usage * seconds_per_tick)

				gas.add_thermal_energy(energy_used)
				//use_power(energy_used, ENVIRON) //handle by update_use_power instead
			else	//gas cooling
				var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), active_power_usage * seconds_per_tick)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				//none of this is really proper thermodynamics but whatever

				var/cop = gas.temperature/T20C	//coefficient of performance -> power used = heat_transfer/cop

				heat_transfer = min(heat_transfer, cop * active_power_usage * seconds_per_tick)	//this ensures that we don't use more than active_power_usage amount of power

				heat_transfer = -gas.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

				//use_power(heat_transfer / cop, ENVIRON)	//handle by update_use_power instead

			environment.merge(gas)


// Returns whether this air alarm thinks there is a breach, given the sensors that are available to it.
/obj/machinery/alarm/proc/breach_detected()
	var/turf/simulated/location = loc

	if(!istype(location))
		return 0

	if(breach_detection	== 0)
		return 0

	var/datum/gas_mixture/environment = location.return_air()
	var/environment_pressure = environment.return_pressure()
	var/pressure_levels = TLV["pressure"]

	if (environment_pressure <= pressure_levels[1])		//low pressures
		if (!(mode == AALARM_MODE_PANIC || mode == AALARM_MODE_CYCLE))
			return 1

	return 0

/obj/machinery/alarm/update_icon()
	cut_overlays()
	icon_state = "alarmp"

	if(wiresexposed)
		icon_state = "alarmx"

	if((stat & (NOPOWER|BROKEN)) || shorted)
		add_overlay("alarm_fan_off")
		set_light(0)
		return

	var/icon_level = danger_level
	if (alarm_area.atmosalm)
		icon_level = max(icon_level, 1)	//if there's an atmos alarm but everything is okay locally, no need to go past yellow

	alarm_overlay = make_screen_overlay(icon, "alarm[icon_level]")
	add_overlay(alarm_overlay)

	var/new_color = null
	switch(icon_level)
		if (0)
			new_color = COLOR_LIME
		if (1)
			new_color = COLOR_SUN
		if (2)
			new_color = COLOR_RED_LIGHT

	set_light(l_range = L_WALLMOUNT_RANGE, l_power = L_WALLMOUNT_POWER, l_color = new_color)

	if(regulating_temperature)
		add_overlay("alarm_fan_on")
	else
		add_overlay("alarm_fan_off")

/obj/machinery/alarm/proc/refresh_all()
	for(var/id_tag in alarm_area.air_vent_names)
		var/list/I = alarm_area.air_vent_info[id_tag]
		if (I && I["timestamp"]+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_signal(id_tag, list("status") )
	for(var/id_tag in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info[id_tag]
		if (I && I["timestamp"]+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_signal(id_tag, list("status"))

/obj/machinery/alarm/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_TO_AIRALARM)

/obj/machinery/alarm/proc/send_signal(var/target, var/list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)

	return 1

/obj/machinery/alarm/proc/apply_mode()
	//propagate mode to other air alarms in the area
	//TODO: make it so that players can choose between applying the new mode to the room they are in (related area) vs the entire alarm area
	for (var/obj/machinery/alarm/AA in alarm_area)
		AA.mode = mode

	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "co2_scrub"= 1, "scrubbing"= 1, "panic_siphon"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0) )

		if(AALARM_MODE_REPLACEMENT)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_FILL)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_OFF)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0) )

/obj/machinery/alarm/proc/apply_danger_level(var/new_danger_level)
	if (report_danger_level && alarm_area.atmosalert(new_danger_level, src))
		post_alert(new_danger_level)

	update_icon()

/obj/machinery/alarm/proc/post_alert(alert_level)
	var/datum/radio_frequency/frequency = SSradio.return_frequency(alarm_frequency)
	if(!frequency)
		return

	var/datum/signal/alert_signal = new
	alert_signal.source = src
	alert_signal.transmission_method = TRANSMISSION_RADIO
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if (alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if (alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)

/obj/machinery/alarm/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	return interact(user)

/obj/machinery/alarm/interact(mob/user)
	ui_interact(user)
	wires.interact(user)

/obj/machinery/alarm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, var/master_ui = null, var/datum/ui_state/state = default_state)
	var/data = list()
	var/remote_connection = 0
	var/remote_access = 0
	if(state)
		var/list/href = state.href_list(user)
		remote_connection = href["remote_connection"]	// Remote connection means we're non-adjacent/connecting from another computer
		remote_access = href["remote_access"]			// Remote access means we also have the privilege to alter the air alarm.

	data["locked"] = locked && !issilicon(user)
	data["remote_connection"] = remote_connection
	data["remote_access"] = remote_access
	data["rcon"] = rcon_setting
	data["screen"] = screen

	populate_status(data)

	if(!(locked && !remote_connection) || remote_access || issilicon(user))
		populate_controls(data)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "air_alarm.tmpl", src.name, 325, 625, master_ui = master_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/alarm/proc/populate_status(var/data)
	var/turf/location = get_turf(src)
	if(!istype(location)) return
	var/datum/gas_mixture/environment = location.return_air()
	var/total = environment.total_moles

	var/list/environment_data = new
	data["has_environment"] = total
	if(total)
		var/pressure = environment.return_pressure()
		environment_data[++environment_data.len] = list("name" = "Pressure", "value" = pressure, "unit" = "kPa", "danger_level" = pressure_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "Oxygen", "value" = environment.gas[GAS_OXYGEN] / total * 100, "unit" = "%", "danger_level" = oxygen_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "Carbon Dioxide", "value" = environment.gas[GAS_CO2] / total * 100, "unit" = "%", "danger_level" = co2_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "Phoron", "value" = environment.gas[GAS_PHORON] / total * 100, "unit" = "%", "danger_level" = phoron_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "Hydrogen", "value" = environment.gas[GAS_HYDROGEN] / total * 100, "unit" = "%", "danger_level" = hydrogen_dangerlevel)
		environment_data[++environment_data.len] = list("name" = "Temperature", "value" = environment.temperature, "unit" = "K ([round(environment.temperature - T0C, 0.1)]C)", "danger_level" = temperature_dangerlevel)
	data["total_danger"] = danger_level
	data["environment"] = environment_data
	data["atmos_alarm"] = alarm_area.atmosalm
	data["fire_alarm"] = alarm_area.fire != null
	data["target_temperature"] = "[target_temperature - T0C]C"

/obj/machinery/alarm/proc/populate_controls(var/list/data)
	switch(screen)
		if(AALARM_SCREEN_MAIN)
			data["mode"] = mode
		if(AALARM_SCREEN_VENT)
			var/vents[0]
			for(var/id_tag in alarm_area.air_vent_names)
				var/long_name = alarm_area.air_vent_names[id_tag]
				var/list/info = alarm_area.air_vent_info[id_tag]
				if(!info)
					continue
				vents[++vents.len] = list(
						"id_tag"	= id_tag,
						"long_name" = sanitize(long_name),
						"power"		= info["power"],
						"checks"	= info["checks"],
						"direction"	= info["direction"],
						"external"	= info["external"]
					)
			data["vents"] = vents
		if(AALARM_SCREEN_SCRUB)
			var/scrubbers[0]
			for(var/id_tag in alarm_area.air_scrub_names)
				var/long_name = alarm_area.air_scrub_names[id_tag]
				var/list/info = alarm_area.air_scrub_info[id_tag]
				if(!info)
					continue
				scrubbers[++scrubbers.len] = list(
						"id_tag"	= id_tag,
						"long_name" = sanitize(long_name),
						"power"		= info["power"],
						"scrubbing"	= info["scrubbing"],
						"panic"		= info["panic"],
						"filters"	= list()
					)
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Oxygen",			"command" = "o2_scrub",	"val" = info["filter_o2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Nitrogen",		"command" = "n2_scrub",	"val" = info["filter_n2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Carbon Dioxide", "command" = "co2_scrub","val" = info["filter_co2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Phoron", 		"command" = "tox_scrub","val" = info["filter_phoron"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Hydrogen",		"command" = "h2_scrub","val" = info["filter_h2"]))
				scrubbers[scrubbers.len]["filters"] += list(list("name" = "Nitrous Oxide",	"command" = "n2o_scrub","val" = info["filter_n2o"]))
			data["scrubbers"] = scrubbers
		if(AALARM_SCREEN_MODE)
			var/modes[0]
			modes[++modes.len] = list("name" = "Filtering - Scrubs out contaminants", 			"mode" = AALARM_MODE_SCRUBBING,		"selected" = mode == AALARM_MODE_SCRUBBING, 	"danger" = 0)
			modes[++modes.len] = list("name" = "Replace Air - Siphons out air while replacing", "mode" = AALARM_MODE_REPLACEMENT,	"selected" = mode == AALARM_MODE_REPLACEMENT,	"danger" = 0)
			modes[++modes.len] = list("name" = "Panic - Siphons air out of the room", 			"mode" = AALARM_MODE_PANIC,			"selected" = mode == AALARM_MODE_PANIC, 		"danger" = 1)
			modes[++modes.len] = list("name" = "Cycle - Siphons air before replacing", 			"mode" = AALARM_MODE_CYCLE,			"selected" = mode == AALARM_MODE_CYCLE, 		"danger" = 1)
			modes[++modes.len] = list("name" = "Fill - Shuts off scrubbers and opens vents", 	"mode" = AALARM_MODE_FILL,			"selected" = mode == AALARM_MODE_FILL, 			"danger" = 0)
			modes[++modes.len] = list("name" = "Off - Shuts off vents and scrubbers", 			"mode" = AALARM_MODE_OFF,			"selected" = mode == AALARM_MODE_OFF, 			"danger" = 0)
			data["modes"] = modes
			data["mode"] = mode
		if(AALARM_SCREEN_SENSORS)
			var/list/selected
			var/thresholds[0]

			var/list/gas_names = list(
				GAS_OXYGEN    = "O<sub>2</sub>",
				GAS_CO2       = "CO<sub>2</sub>",
				GAS_PHORON    = "Phoron",
				GAS_HYDROGEN  = "Hydrogen",
				"other"       = "Other")
			for (var/g in gas_names)
				thresholds[++thresholds.len] = list("name" = gas_names[g], "settings" = list())
				selected = TLV[g]
				for(var/i = 1, i <= 4, i++)
					thresholds[thresholds.len]["settings"] += list(list("env" = g, "val" = i, "selected" = selected[i]))

			selected = TLV["pressure"]
			thresholds[++thresholds.len] = list("name" = "Pressure", "settings" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = i, "selected" = selected[i]))

			selected = TLV["temperature"]
			thresholds[++thresholds.len] = list("name" = "Temperature", "settings" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = i, "selected" = selected[i]))


			data["thresholds"] = thresholds

/obj/machinery/alarm/CanUseTopic(var/mob/user, var/datum/ui_state/state, var/href_list = list())
	if(buildstage != 2)
		return STATUS_CLOSE

	if(aidisabled && isAI(user))
		to_chat(user, "<span class='warning'>AI control for \the [src] interface has been disabled.</span>")
		return STATUS_CLOSE

	. = shorted ? STATUS_DISABLED : STATUS_INTERACTIVE

	if(. == STATUS_INTERACTIVE)
		var/extra_href = QDELETED(state) ? list() : state.href_list(user ? user : usr)
		// Prevent remote users from altering RCON settings unless they already have access
		if(href_list["rcon"] && extra_href["remote_connection"] && !extra_href["remote_access"])
			. = STATUS_UPDATE

	return min(..(), .)

/obj/machinery/alarm/Topic(href, href_list, var/datum/ui_state/state)
	if(..(href, href_list, state))
		return 1

	// hrefs that can always be called -walter0o
	if(href_list["rcon"])
		var/attempted_rcon_setting = text2num(href_list["rcon"])

		switch(attempted_rcon_setting)
			if(RCON_NO)
				rcon_setting = RCON_NO
			if(RCON_AUTO)
				rcon_setting = RCON_AUTO
			if(RCON_YES)
				rcon_setting = RCON_YES
		return 1

	if(href_list["temperature"])
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
		var/input_temperature = tgui_input_number(usr, "What temperature would you like the system to mantain?", "Thermostat Controls", target_temperature - T0C, max_temperature, min_temperature)
		if(isnum(input_temperature))
			var/temp = Clamp(input_temperature, min_temperature, max_temperature)
			if(input_temperature > max_temperature || input_temperature < min_temperature)
				to_chat(usr, "Temperature must be between [min_temperature]C and [max_temperature]C. Target temperature clamped to [temp]C.")
			target_temperature = Clamp(input_temperature + T0C, selected[2],  selected[3])
		else
			to_chat(usr, "Error, input not recognised. Temperature unchanged.")

		return 1

	// hrefs that need the AA unlocked -walter0o
	var/extra_href = QDELETED(state) ? list() : state.href_list(usr)
	if(!(locked && !extra_href["remote_connection"]) || extra_href["remote_access"] || issilicon(usr))
		if(href_list["command"])
			var/device_id = href_list["id_tag"]
			switch(href_list["command"])
				if("set_external_pressure")
					var/input_pressure = tgui_input_number(usr, "What pressure you like the system to mantain?", "Pressure Controls")
					if(isnum(input_pressure))
						send_signal(device_id, list(href_list["command"] = input_pressure))
					return 1

				if("reset_external_pressure")
					send_signal(device_id, list(href_list["command"] = ONE_ATMOSPHERE))
					return 1

				if( "power",
					"adjust_external_pressure",
					"checks",
					"o2_scrub",
					"n2_scrub",
					"co2_scrub",
					"tox_scrub",
					"h2_scrub",
					"n2o_scrub",
					"panic_siphon",
					"scrubbing")

					send_signal(device_id, list(href_list["command"] = text2num(href_list["val"]) ) )
					return 1

				if("set_threshold")
					var/env = href_list["env"]
					var/threshold = text2num(href_list["var"])
					var/list/selected = TLV[env]
					var/list/thresholds = list("lower bound", "low warning", "high warning", "upper bound")
					var/newval = tgui_input_number(usr, "Enter [thresholds[threshold]] for [env].", "Alarm Triggers", selected[threshold])
					if (isnull(newval))
						return 1
					if (newval<0)
						selected[threshold] = -1.0
					else if (env=="temperature" && newval>5000)
						selected[threshold] = 5000
					else if (env=="pressure" && newval>50*ONE_ATMOSPHERE)
						selected[threshold] = 50*ONE_ATMOSPHERE
					else if (env!="temperature" && env!="pressure" && newval>200)
						selected[threshold] = 200
					else
						newval = round(newval,0.01)
						selected[threshold] = newval

					switch (threshold)
						if (1)
							if(selected[1] > selected[2])
								selected[2] = selected[1]
							if(selected[1] > selected[3])
								selected[3] = selected[1]
							if(selected[1] > selected[4])
								selected[4] = selected[1]
						if (2)
							if(selected[1] > selected[2])
								selected[1] = selected[2]
							if(selected[2] > selected[3])
								selected[3] = selected[2]
							if(selected[2] > selected[4])
								selected[4] = selected[2]
						if (3)
							if(selected[1] > selected[3])
								selected[1] = selected[3]
							if(selected[2] > selected[3])
								selected[2] = selected[3]
							if(selected[3] > selected[4])
								selected[4] = selected[3]
						if (4)
							if(selected[1] > selected[4])
								selected[1] = selected[4]
							if(selected[2] > selected[4])
								selected[2] = selected[4]
							if(selected[3] > selected[4])
								selected[3] = selected[4]

					apply_mode()
					return 1

		if(href_list["screen"])
			screen = text2num(href_list["screen"])
			return 1

		if(href_list["atmos_unlock"])
			switch(href_list["atmos_unlock"])
				if("0")
					alarm_area.air_doors_close()
				if("1")
					alarm_area.air_doors_open()
			return 1

		if(href_list["atmos_alarm"])
			if (alarm_area.atmosalert(2, src))
				apply_danger_level(2)
			update_icon()
			return 1

		if(href_list["atmos_reset"])
			if (alarm_area.atmosalert(0, src))
				apply_danger_level(0)
			update_icon()
			return 1

		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			apply_mode()
			return 1

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/forensics))
		src.add_fingerprint(user)

	switch(buildstage)
		if(2)
			if(W.isscrewdriver())  // Opening that Air Alarm up.
				wiresexposed = !wiresexposed
				to_chat(user, "<span class='notice'>You [wiresexposed ? "open" : "close"] the maintenance panel.</span>")
				update_icon()
				return TRUE

			if (wiresexposed && W.iswirecutter())
				user.visible_message("<span class='warning'>[user] has cut the wires inside \the [src]!</span>", "You cut the wires inside \the [src].")
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				new/obj/item/stack/cable_coil(get_turf(src), 5)
				buildstage = 1
				update_icon()
				return TRUE

			if (W.GetID())// trying to unlock the interface with an ID card
				if(stat & (NOPOWER|BROKEN))
					to_chat(user, "<span class='notice'>Nothing happens.</span>")
					return TRUE
				else
					if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
						locked = !locked
						to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the Air Alarm interface.</span>")
					else
						to_chat(user, "<span class='warning'>Access denied.</span>")
				return TRUE

		if(1)
			if(W.iscoil())
				var/obj/item/stack/cable_coil/C = W
				if (C.use(5))
					to_chat(user, "<span class='notice'>You wire \the [src].</span>")
					buildstage = 2
					update_icon()
					first_run()
					set_frequency(frequency)
				else
					to_chat(user, "<span class='warning'>You need 5 pieces of cable to do wire \the [src].</span>")
				return TRUE

			else if(W.iscrowbar())
				to_chat(user, "You start prying out the circuit.")
				if(W.use_tool(src, user, 20, volume = 50))
					to_chat(user, "You pry out the circuit!")
					var/obj/item/airalarm_electronics/circuit = new /obj/item/airalarm_electronics()
					circuit.forceMove(user.loc)
					buildstage = 0
					update_icon()
				return TRUE

		if(0)
			if(istype(W, /obj/item/airalarm_electronics))
				to_chat(user, "You insert the circuit!")
				qdel(W)
				buildstage = 1
				update_icon()
				return TRUE

			else if(W.iswrench())
				to_chat(user, "You remove the air alarm assembly from the wall!")
				new /obj/item/frame/air_alarm(get_turf(user))
				playsound(src.loc, W.usesound, 50, 1)
				qdel(src)
				return TRUE

	return ..()

/obj/machinery/alarm/power_change()
	..()
	queue_icon_update()

/obj/machinery/alarm/examine(mob/user)
	. = ..()
	if (buildstage < 2)
		to_chat(user, "It is not wired.")
	if (buildstage < 1)
		to_chat(user, "The circuit is missing.")
/*
AIR ALARM CIRCUIT
Just a object used in constructing air alarms
*/
/obj/item/airalarm_electronics
	name = "air alarm electronics"
	icon = 'icons/obj/device.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)

// Fire Alarms moved to firealarm.dm

#undef AALARM_MODE_SCRUBBING
#undef AALARM_MODE_REPLACEMENT
#undef AALARM_MODE_PANIC
#undef AALARM_MODE_CYCLE
#undef AALARM_MODE_FILL
#undef AALARM_MODE_OFF
#undef AALARM_SCREEN_MAIN
#undef AALARM_SCREEN_VENT
#undef AALARM_SCREEN_SCRUB
#undef AALARM_SCREEN_MODE
#undef AALARM_SCREEN_SENSORS
#undef AALARM_REPORT_TIMEOUT
#undef MAX_TEMPERATURE
#undef MIN_TEMPERATURE

#undef ALARM_GET_DANGER_LEVEL
#undef ALARM_GET_OVERALL_DANGER_LEVEL
#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST
