/obj/machinery/atmospherics/unary/vent_scrubber
	name = "air scrubber"
	desc = "Has a valve and pump attached to it."
	desc_info = "This filters the atmosphere of harmful gas.  Filtered gas goes to the pipes connected to it, typically a scrubber pipe. \
	It can be controlled from an Air Alarm.  It can be configured to drain all air rapidly with a 'panic syphon' from an air alarm."
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"

	use_power = 0
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes

	level = 1

	var/area/initial_loc
	var/id_tag = null
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/hibernate = 0 //Do we even process?
	var/scrubbing = 1 //0 = siphoning, 1 = scrubbing
	var/list/scrubbing_gas = list(GAS_CO2)

	var/panic = 0 //is this scrubber panicked?

	var/area_uid
	var/radio_filter_out
	var/radio_filter_in

	var/welded = 0

	var/broadcast_status_next_process = FALSE

/obj/machinery/atmospherics/unary/vent_scrubber/on
	use_power = 1
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/unary/vent_scrubber/Initialize()
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_FILTER

	initial_loc = get_area(loc)
	area_uid = initial_loc.uid
	if (!id_tag)
		assign_uid()
		id_tag = num2text(uid)

	radio_filter_in = frequency==initial(frequency)?(RADIO_FROM_AIRALARM):null
	radio_filter_out = frequency==initial(frequency)?(RADIO_TO_AIRALARM):null
	if (frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/unary/vent_scrubber/atmos_init()
	..()
	broadcast_status()

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	unregister_radio(src, frequency)
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag

	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon(var/safety = 0)
	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	if (welded)
		icon_state = "weld"
		return

	if (!powered() || !use_power)
		icon_state = "off"
	else if (scrubbing)
		icon_state = "on"
	else
		icon_state = "in"

/obj/machinery/atmospherics/unary/vent_scrubber/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	signal.data = list(
		"area" = area_uid,
		"tag" = id_tag,
		"device" = "AScr",
		"timestamp" = world.time,
		"power" = use_power,
		"scrubbing" = scrubbing,
		"panic" = panic,
		"filter_o2" = (GAS_OXYGEN in scrubbing_gas),
		"filter_n2" = (GAS_NITROGEN in scrubbing_gas),
		"filter_co2" = (GAS_CO2 in scrubbing_gas),
		"filter_phoron" = (GAS_PHORON in scrubbing_gas),
		"filter_n2o" = (GAS_N2O in scrubbing_gas),
		"sigtype" = "status"
	)

	var/area/A = get_area(src)
	if(!A.air_scrub_names[id_tag])
		var/new_name = "[A.name] Air Scrubber #[A.air_scrub_names.len+1]"
		A.air_scrub_names[id_tag] = new_name
		src.name = new_name
	A.air_scrub_info[id_tag] = signal.data
	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/machinery_process()
	..()

	if (hibernate > world.time)
		return 1

	if (!node)
		use_power = 0

	if (broadcast_status_next_process)
		broadcast_status()
		broadcast_status_next_process = FALSE

	if(!use_power || (stat & (NOPOWER|BROKEN)))
		return 0
	if(welded)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	if(scrubbing)
		//limit flow rate from turfs
		var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here

		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)
	else //Just siphon all air
		//limit flow rate from turfs
		var/transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here

		power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	if(scrubbing && power_draw <= 0)	//99% of all scrubbers
		//Fucking hibernate because you ain't doing shit.
		hibernate = world.time + (rand(100,200))

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

	if(network)
		network.update = 1

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()
	update_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || (signal.data["sigtype"]!="command"))
		return 0

	if(signal.data["power"] != null)
		use_power = text2num(signal.data["power"])
	if(signal.data["power_toggle"] != null)
		use_power = !use_power

	if(signal.data["panic_siphon"]) //must be before if("scrubbing") thing
		panic = text2num(signal.data["panic_siphon"])
		if(panic)
			use_power = 1
			scrubbing = 0
		else
			scrubbing = 1
	if(signal.data["toggle_panic_siphon"] != null)
		panic = !panic
		if(panic)
			use_power = 1
			scrubbing = 0
		else
			scrubbing = 1

	if(signal.data["scrubbing"] != null)
		scrubbing = text2num(signal.data["scrubbing"])
		if(scrubbing)
			panic = 0
	if(signal.data["toggle_scrubbing"])
		scrubbing = !scrubbing
		if(scrubbing)
			panic = 0

	var/list/toggle = list()

	if(!isnull(signal.data["o2_scrub"]) && text2num(signal.data["o2_scrub"]) != (GAS_OXYGEN in scrubbing_gas))
		toggle += GAS_OXYGEN
	else if(signal.data["toggle_o2_scrub"])
		toggle += GAS_OXYGEN

	if(!isnull(signal.data["n2_scrub"]) && text2num(signal.data["n2_scrub"]) != (GAS_NITROGEN in scrubbing_gas))
		toggle += GAS_NITROGEN
	else if(signal.data["toggle_n2_scrub"])
		toggle += GAS_NITROGEN

	if(!isnull(signal.data["co2_scrub"]) && text2num(signal.data["co2_scrub"]) != (GAS_CO2 in scrubbing_gas))
		toggle += GAS_CO2
	else if(signal.data["toggle_co2_scrub"])
		toggle += GAS_CO2

	if(!isnull(signal.data["tox_scrub"]) && text2num(signal.data["tox_scrub"]) != (GAS_PHORON in scrubbing_gas))
		toggle += GAS_PHORON
	else if(signal.data["toggle_tox_scrub"])
		toggle += GAS_PHORON

	if(!isnull(signal.data["n2o_scrub"]) && text2num(signal.data["n2o_scrub"]) != (GAS_N2O in scrubbing_gas))
		toggle += GAS_N2O
	else if(signal.data["toggle_n2o_scrub"])
		toggle += GAS_N2O

	scrubbing_gas ^= toggle

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		broadcast_status_next_process = TRUE
		return //do not update_icon

	broadcast_status_next_process = TRUE
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (W.iswrench())
		if (!(stat & NOPOWER) && use_power)
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], turn it off first."))
			return 1
		var/turf/T = src.loc
		if (node && node.level==1 && isturf(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the plating first."))
			return 1
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
			add_fingerprint(user)
			return 1
		playsound(src.loc, W.usesound, 50, 1)
		to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
		if (do_after(user, 40/W.toolspeed, act_target = src))
			user.visible_message( \
				SPAN_NOTICE("\The [user] unfastens \the [src]."), \
				SPAN_NOTICE("You have unfastened \the [src]."), \
				"You hear a ratchet.")
			new /obj/item/pipe(loc, make_from=src)
			qdel(src)
		return 1

	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if (!WT.welding)
			to_chat(user, SPAN_DANGER("\The [WT] must be turned on!"))
		else if (WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("Now welding \the [src]."))
			playsound(src, 'sound/items/welder.ogg', 50, 1)
			if(do_after(user, 20/W.toolspeed, act_target = src))
				if(!src || !WT.isOn())
					return
				welded = !welded
				update_icon()
				playsound(src, 'sound/items/welder_pry.ogg', 50, 1)
				user.visible_message(SPAN_NOTICE("\The [user] [welded ? "welds \the [src] shut" : "unwelds \the [src]"]."), \
									 SPAN_NOTICE("You [welded ? "weld \the [src] shut" : "unweld \the [src]"]."), \
									 "You hear welding.")
			else
				to_chat(user, SPAN_NOTICE("You fail to complete the welding."))
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return 1

	if(istype(W, /obj/item/melee/arm_blade))
		if(!welded)
			to_chat(user, SPAN_WARNING("\The [W] can only be used to tear open welded scrubbers!"))
			return
		user.visible_message(SPAN_WARNING("\The [user] starts using \the [W] to hack open \the [src]!"), SPAN_NOTICE("You start hacking open \the [src] with \the [W]..."))
		user.do_attack_animation(src, W)
		playsound(loc, 'sound/weapons/smash.ogg', 60, TRUE)
		var/cut_amount = 3
		for(var/i = 0; i <= cut_amount; i++)
			if(!W || !do_after(user, 30, src))
				return
			user.do_attack_animation(src, W)
			user.visible_message(SPAN_WARNING("\The [user] smashes \the [W] into \the [src]!"), SPAN_NOTICE("You smash \the [W] into \the [src]."))
			playsound(loc, 'sound/weapons/smash.ogg', 60, TRUE)
			if(i == cut_amount)
				welded = FALSE
				spark(get_turf(src), 3, alldirs)
				playsound(loc, 'sound/items/welder_pry.ogg', 50, TRUE)
				update_icon()
		return

	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W")
	else
		to_chat(user, "You are too far away to read the gauge.")
	if(welded)
		to_chat(user, "It seems welded shut.")


