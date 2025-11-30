/*
Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.

node1, air1, network1 correspond to input
node2, air2, network2 correspond to output

Thus, the two variables affect pump operation are set in New():
	air1.volume
		This is the volume of gas available to the pump that may be transferred to the output
	air2.volume
		Higher quantities of this cause more air to be perfected later
			but overall network volume is also increased as this increases...
*/

/obj/machinery/atmospherics/binary/pump
	name = "gas pump"
	desc = "A pump."
	icon = 'icons/atmos/pump.dmi'
	icon_state = "map_off"
	level = 1
	var/base_icon = "pump"

	var/target_pressure = ONE_ATMOSPHERE

	//var/max_volume_transfer = 10000

	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000			//30000 W ~ 40 HP

	var/max_pressure_setting = ATMOS_PUMP_MAX_PRESSURE	//kPa

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	var/broadcast_status_next_process = FALSE

/obj/machinery/atmospherics/binary/pump/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This moves gas from one pipe to another. A higher target pressure demands more energy."
	. += "The side with the colored end is the output."

/obj/machinery/atmospherics/binary/pump/Initialize()
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP

/obj/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"
	use_power = POWER_USE_IDLE

/obj/machinery/atmospherics/binary/pump/fuel
	icon_state = "map_off-fuel"
	base_icon = "pump-fuel"
	icon_connect_type = "-fuel"
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/binary/pump/fuel/on
	icon_state = "map_on-fuel"
	use_power = POWER_USE_IDLE

/obj/machinery/atmospherics/binary/pump/aux
	icon_state = "map_off-aux"
	base_icon = "pump-aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX

/obj/machinery/atmospherics/binary/pump/aux/on
	icon_state = "map_on-aux"
	use_power = POWER_USE_IDLE

/obj/machinery/atmospherics/binary/pump/supply
	icon_state = "map_off-supply"
	base_icon = "pump-supply"
	icon_connect_type = "-supply"
	connect_types = CONNECT_TYPE_SUPPLY

/obj/machinery/atmospherics/binary/pump/supply/on
	icon_state = "map_on-supply"
	use_power = POWER_USE_IDLE

/obj/machinery/atmospherics/binary/pump/scrubber
	icon_state = "map_off-scrubber"
	base_icon = "pump-scrubber"
	icon_connect_type = "-scrubber"
	connect_types = CONNECT_TYPE_SCRUBBER

/obj/machinery/atmospherics/binary/pump/scrubber/on
	icon_state = "map_on-scrubber"
	use_power = POWER_USE_IDLE


/obj/machinery/atmospherics/binary/pump/update_icon()
	if(!powered())
		icon_state = "[base_icon]-off"
	else
		icon_state = "[use_power ? "[base_icon]-on" : "[base_icon]-off"]"

/obj/machinery/atmospherics/binary/pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, -180), node1?.icon_connect_type)
		add_underlay(T, node2, dir, node2?.icon_connect_type)

/obj/machinery/atmospherics/binary/pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/pump/process()
	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	if (broadcast_status_next_process)
		broadcast_status()
		broadcast_status_next_process = FALSE

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how much gas to transfer to meet the target pressure.
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0)
		power_draw = pump_gas(src, air1, air2, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1

//Radio remote control

/obj/machinery/atmospherics/binary/pump/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = use_power,
		"target_output" = target_pressure,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPump", capitalize_first_letters(name))
		ui.open()

/obj/machinery/atmospherics/binary/pump/ui_data()
	var/data = list()
	data["on"] = use_power
	data["pressure"] = round(target_pressure)
	data["max_pressure"] = max_pressure_setting
	data["power_draw"] = round(last_power_draw)
	data["max_power_draw"] = power_rating
	data["flow_rate"] = round(last_flow_rate)
	return data

/obj/machinery/atmospherics/binary/pump/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			update_use_power(!use_power)
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "max")
				pressure = ATMOS_PUMP_MAX_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = clamp(pressure, 0, ATMOS_PUMP_MAX_PRESSURE)
	update_icon()

/obj/machinery/atmospherics/binary/pump/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"])
		if(text2num(signal.data["power"]))
			update_use_power(POWER_USE_IDLE)
		else
			update_use_power(POWER_USE_OFF)

	if("power_toggle" in signal.data)
		update_use_power(!use_power)

	if(signal.data["set_output_pressure"])
		target_pressure = clamp(
			text2num(signal.data["set_output_pressure"]),
			0,
			ATMOS_PUMP_MAX_PRESSURE
		)

	if(signal.data["status"])
		broadcast_status_next_process = TRUE
		return //do not update_icon

	broadcast_status_next_process = TRUE
	update_icon()

/obj/machinery/atmospherics/binary/pump/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/pump/Topic(href,href_list)
	if(..()) return 1

	if(href_list["power"])
		update_use_power(!use_power)

	switch(href_list["set_press"])
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure = max_pressure_setting
		if ("set")
			var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure control",src.target_pressure) as num
			src.target_pressure = between(0, new_pressure, max_pressure_setting)

	usr.set_machine(src)
	src.add_fingerprint(usr)

	src.update_icon()

/obj/machinery/atmospherics/binary/pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/pump/attackby(obj/item/attacking_item, mob/user)
	if (!attacking_item.iswrench() && !istype(attacking_item, /obj/item/pipewrench))
		return ..()
	if (!(stat & NOPOWER) && use_power)
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], turn it off first."))
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if (!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > PRESSURE_EXERTED && !istype(attacking_item, /obj/item/pipewrench))
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], it's too exerted due to internal pressure."))
		add_fingerprint(user)
		return TRUE
	else
		to_chat(user, SPAN_WARNING("You struggle to unwrench \the [src] with your pipe wrench."))
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, istype(attacking_item, /obj/item/pipewrench) ? 80 : 40, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)
		return TRUE
