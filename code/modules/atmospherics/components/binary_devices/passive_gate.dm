#define REGULATE_NONE	0
#define REGULATE_INPUT	1	//shuts off when input side is below the target pressure
#define REGULATE_OUTPUT	2	//shuts off when output side is above the target pressure

/obj/machinery/atmospherics/binary/passive_gate
	name = "pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. Does not require power."
	desc_info = "This is a one-way regulator, allowing gas to flow only at a specific pressure and flow rate.  If the light is green, it is flowing."
	icon = 'icons/atmos/passive_gate.dmi'
	icon_state = "map"
	level = 1

	use_power = POWER_USE_OFF
	interact_offline = 1
	var/unlocked = 0	//If 0, then the valve is locked closed, otherwise it is open(-able, it's a one-way valve so it closes if gas would flow backwards).
	var/target_pressure = ONE_ATMOSPHERE
	var/max_pressure_setting = ATMOS_PUMP_MAX_PRESSURE	//kPa
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	var/regulate_mode = REGULATE_OUTPUT

	var/flowing = 0	//for icons - becomes zero if the valve closes itself due to regulation mode

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

	var/broadcast_status_next_process = FALSE

/obj/machinery/atmospherics/binary/passive_gate/on
	unlocked = 1
/obj/machinery/atmospherics/binary/passive_gate/on/input
	regulate_mode = REGULATE_INPUT

/obj/machinery/atmospherics/binary/passive_gate/on/output/max/Initialize()
	. = ..()
	target_pressure = max_pressure_setting

/obj/machinery/atmospherics/binary/passive_gate/on/input/max/Initialize()
	. = ..()
	target_pressure = max_pressure_setting

/obj/machinery/atmospherics/binary/passive_gate/scrubbers
	name = "scrubbers pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. This is one is for scrubber pipes."
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"

	unlocked = TRUE
	target_pressure = 200

/obj/machinery/atmospherics/binary/passive_gate/supply
	name = "supply pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. This is one is for supply pipes."
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"

	unlocked = TRUE
	target_pressure = 200

/obj/machinery/atmospherics/binary/passive_gate/fuel
	name = "fuel pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. This is one is for fuel pipes."
	icon_state = "map-fuel"
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"

	unlocked = TRUE
	target_pressure = 200

/obj/machinery/atmospherics/binary/passive_gate/aux
	name = "auxiliary pressure regulator"
	desc = "A one-way air valve that can be used to regulate input or output pressure, and flow rate. This is one is for auxiliary pipes."
	icon_state = "map-aux"
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"

	unlocked = TRUE
	target_pressure = 200

/obj/machinery/atmospherics/binary/passive_gate/Initialize()
	. = ..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5

/obj/machinery/atmospherics/binary/passive_gate/update_icon()
	icon_state = (unlocked && flowing)? "on" + icon_connect_type : "off" + icon_connect_type

/obj/machinery/atmospherics/binary/passive_gate/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node1, turn(dir, 180), icon_connect_type)
		add_underlay(T, node2, dir, icon_connect_type)

/obj/machinery/atmospherics/binary/passive_gate/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/passive_gate/process()
	..()

	if (broadcast_status_next_process)
		broadcast_status()
		broadcast_status_next_process = FALSE

	last_flow_rate = 0

	if(!unlocked)
		return 0

	var/output_starting_pressure = air2.return_pressure()
	var/input_starting_pressure = air1.return_pressure()

	var/pressure_delta
	switch (regulate_mode)
		if (REGULATE_INPUT)
			pressure_delta = input_starting_pressure - target_pressure
		if (REGULATE_OUTPUT)
			pressure_delta = target_pressure - output_starting_pressure

	//-1 if pump_gas() did not move any gas, >= 0 otherwise
	var/returnval = -1
	if((regulate_mode == REGULATE_NONE || pressure_delta > 0.01) && (air1.temperature > 0 || air2.temperature > 0))	//since it's basically a valve, it makes sense to check both temperatures
		flowing = 1

		//flow rate limit
		var/transfer_moles = (set_flow_rate/air1.volume)*air1.total_moles

		//Figure out how much gas to transfer to meet the target pressure.
		switch (regulate_mode)
			if (REGULATE_INPUT)
				transfer_moles = min(transfer_moles, air1.total_moles*(pressure_delta/input_starting_pressure))
			if (REGULATE_OUTPUT)
				transfer_moles = min(transfer_moles, calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0))

		//pump_gas() will return a negative number if no flow occurred
		returnval = pump_gas_passive(src, air1, air2, transfer_moles)

	if (returnval >= 0)
		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	if (last_flow_rate)
		flowing = 1

	update_icon()


//Radio remote control

/obj/machinery/atmospherics/binary/passive_gate/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/passive_gate/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = unlocked,
		"target_output" = target_pressure,
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = set_flow_rate,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/passive_gate/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/passive_gate/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id) || (signal.data["sigtype"]!="command"))
		return 0

	if("power" in signal.data)
		unlocked = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		unlocked = !unlocked

	if("set_target_pressure" in signal.data)
		target_pressure = between(
			0,
			text2num(signal.data["set_target_pressure"]),
			max_pressure_setting
		)

	if("set_regulate_mode" in signal.data)
		regulate_mode = text2num(signal.data["set_regulate_mode"])

	if("set_flow_rate" in signal.data)
		regulate_mode = text2num(signal.data["set_flow_rate"])

	if("status" in signal.data)
		broadcast_status_next_process = TRUE
		return //do not update_icon

	broadcast_status_next_process = TRUE
	update_icon()
	return

/obj/machinery/atmospherics/binary/passive_gate/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/passive_gate/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosPressureRegulator", capitalize_first_letters(name))
		ui.open()

/obj/machinery/atmospherics/binary/passive_gate/ui_data()
	var/data = list()
	data["on"] = unlocked
	data["pressure"] = round(target_pressure)
	data["max_pressure"] = max_pressure_setting
	data["rate"] = round(set_flow_rate)
	data["max_rate"] = air1.volume
	data["flow_rate"] = round(last_flow_rate)
	data["regulate_mode"] = regulate_mode
	return data

/obj/machinery/atmospherics/binary/passive_gate/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_valve")
			unlocked = !unlocked
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
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = air1.volume
				. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				set_flow_rate = clamp(rate, 0, air1.volume)
		if("regulate_off")
			regulate_mode = REGULATE_NONE
			. = TRUE
		if("regulate_input")
			regulate_mode = REGULATE_INPUT
			. = TRUE
		if("regulate_output")
			regulate_mode = REGULATE_OUTPUT
			. = TRUE
	update_icon()


/obj/machinery/atmospherics/binary/passive_gate/Topic(href,href_list)
	if(..()) return 1

	if(href_list["toggle_valve"])
		unlocked = !unlocked

	if(href_list["regulate_mode"])
		switch(href_list["regulate_mode"])
			if ("off") regulate_mode = REGULATE_NONE
			if ("input") regulate_mode = REGULATE_INPUT
			if ("output") regulate_mode = REGULATE_OUTPUT

	switch(href_list["set_press"])
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure = max_pressure_setting
		if ("set")
			var/new_pressure = input(usr,"Enter new output pressure (0-[max_pressure_setting]kPa)","Pressure Control",src.target_pressure) as num
			src.target_pressure = between(0, new_pressure, max_pressure_setting)

	switch(href_list["set_flow_rate"])
		if ("min")
			set_flow_rate = 0
		if ("max")
			set_flow_rate = air1.volume
		if ("set")
			var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[air1.volume]kPa)","Flow Rate Control",src.set_flow_rate) as num
			src.set_flow_rate = between(0, new_flow_rate, air1.volume)

	usr.set_machine(src)	//Is this even needed with NanoUI?
	src.update_icon()
	src.add_fingerprint(usr)
	return

/obj/machinery/atmospherics/binary/passive_gate/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!W.iswrench())
		return ..()
	if (unlocked)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], turn it off first.</span>")
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if (!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > PRESSURE_EXERTED)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], it too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return TRUE
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if(W.use_tool(src, user, istype(W, /obj/item/pipewrench) ? 80 : 40, volume = 50))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)
		return TRUE

#undef REGULATE_NONE
#undef REGULATE_INPUT
#undef REGULATE_OUTPUT
