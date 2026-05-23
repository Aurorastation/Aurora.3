/*
 * subtypes/time.dm
 * Timing circuits: delays, clocks, pulses, cooldown-style behavior, and scheduled activation.
 */

/// time circuit: Outputs the current local time when pulsed..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Outputs the current local time when pulsed."
	complexity = 2
	inputs = list()
	outputs = list()
	category_text = "Time"

/// two-sec delay circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/delay
	name = "two-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of two seconds."
	icon_state = "delay-20"
	// Stores `delay` state used by this integrated electronics object.
	var/delay = 2 SECONDS
	activators = list("incoming"= IC_PINTYPE_PULSE_IN,"outgoing" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/time/delay/do_work()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/integrated_circuit, activate_pin), 2), delay)

/// five-sec delay circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/delay/five_sec
	name = "five-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of five seconds."
	icon_state = "delay-50"
	delay = 5 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// one-sec delay circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/delay/one_sec
	name = "one-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of one second."
	icon_state = "delay-10"
	delay = 1 SECOND
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// half-sec delay circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/delay/half_sec
	name = "half-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of half a second."
	icon_state = "delay-5"
	delay = 5
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// tenth-sec delay circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/delay/tenth_sec
	name = "tenth-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of 1/10th of a second."
	icon_state = "delay-1"
	delay = 1
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// custom delay circuit: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/delay/custom
	name = "custom delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit's delay can be customized, between 1/10th of a second to one hour.  The delay is updated upon receiving a pulse."
	icon_state = "delay"
	inputs = list("delay time" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_RESEARCH

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/time/delay/custom/on_data_written()
	delay = between(1, get_pin_data(IC_INPUT, 1), 1 HOUR)
	..()

/// ten second ticker: Sends an automatic pulse every ten seconds.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/ticker
	name = "ten second ticker"
	desc = "Sends an automatic pulse every ten seconds."
	icon_state = "tick-m"
	complexity = 8
	// Stores `seconds_to_pulse` state used by this integrated electronics object.
	var/seconds_to_pulse = 10 SECONDS
	// Stores `ticks_completed` state used by this integrated electronics object.
	var/ticks_completed = 0
	// Stores `is_running` state used by this integrated electronics object.
	var/is_running = FALSE
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN)
	activators = list("outgoing pulse" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/// Releases owned objects and clears references before parent deletion runs.
/obj/item/integrated_circuit/time/ticker/Destroy()
	STOP_PROCESSING(SSelectronics, src)
	. = ..()

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/time/ticker/on_data_written()
	// Stores `do_tick` state used by this integrated electronics object.
	var/do_tick = get_pin_data(IC_INPUT, 1)
	if(do_tick && !is_running)
		is_running = TRUE
		START_PROCESSING(SSelectronics, src)
	else if(is_running)
		is_running = FALSE
		STOP_PROCESSING(SSelectronics, src)
		ticks_completed = 0

/// Runs periodic behavior while this object is registered for processing.
/obj/item/integrated_circuit/time/ticker/process()
	// Stores `process_ticks` state used by this integrated electronics object.
	var/process_ticks = SSelectronics.wait
	ticks_completed += process_ticks
	if(ticks_completed >= SecondsToTicks(seconds_to_pulse))
		if(SecondsToTicks(seconds_to_pulse) >= process_ticks)
			ticks_completed -= SecondsToTicks(seconds_to_pulse)
		else
			ticks_completed = 0
		activate_pin(1)

/// two second ticker: Sends an automatic pulse every two seconds.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/ticker/fast
	name = "two second ticker"
	desc = "Sends an automatic pulse every two seconds."
	icon_state = "tick-f"
	complexity = 12
	seconds_to_pulse = 2
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/// thirty second ticker: Sends an automatic pulse every thirty seconds.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/ticker/slow
	name = "thirty second ticker"
	desc = "Sends an automatic pulse every thirty seconds."
	icon_state = "tick-s"
	complexity = 4
	seconds_to_pulse = 30
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/// five minute ticker: Sends an automatic pulse every five minutes.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/ticker/very_slow
	name = "five minute ticker"
	desc = "Sends an automatic pulse every five minutes."
	icon_state = "tick-s"
	complexity = 4
	seconds_to_pulse = 300
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/// custom ticker: Sends automatic pulses at a configurable interval between 2 and 600 seconds. Default: 60 seconds.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/ticker/custom
	name = "custom ticker"
	desc = "Sends automatic pulses at a configurable interval between 2 and 600 seconds. Default: 60 seconds."
	icon_state = "tick-f"
	complexity = 15
	seconds_to_pulse = 60
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN, "ticker time" = IC_PINTYPE_NUMBER)

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/time/ticker/custom/on_data_written()
	seconds_to_pulse = between(2, get_pin_data(IC_INPUT, 2), 600)
	..()

/// integrated clock: Outputs the local station, planet, or facility time.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/time/clock
	name = "integrated clock"
	desc = "Outputs the local station, planet, or facility time."
	icon_state = "clock"
	inputs = list()
	outputs = list(
		"time" = IC_PINTYPE_STRING,
		"hours" = IC_PINTYPE_NUMBER,
		"minutes" = IC_PINTYPE_NUMBER,
		"seconds" = IC_PINTYPE_NUMBER
	)
	activators = list("get time" = IC_PINTYPE_PULSE_IN, "on time got" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/time/clock/do_work()
	set_pin_data(IC_OUTPUT, 1, time2text(station_time_in_ticks, "hh:mm:ss") )
	set_pin_data(IC_OUTPUT, 2, text2num(time2text(station_time_in_ticks, "hh") ) )
	set_pin_data(IC_OUTPUT, 3, text2num(time2text(station_time_in_ticks, "mm") ) )
	set_pin_data(IC_OUTPUT, 4, text2num(time2text(station_time_in_ticks, "ss") ) )

	push_data()
	activate_pin(2)

/// signal burst ticker: A ticker that starts when pulsed, ticks a fixed number of times, then stops. Useful when you want a signaler, scanner, button, or other pulse source to temporarily enable a repeating circuit chain.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/timed/signal_burst_ticker
	name = "signal burst ticker"
	desc = "A ticker that starts when pulsed, ticks a fixed number of times, then stops."
	extended_desc = "Useful when you want a signaler, scanner, button, or other pulse source to temporarily enable a repeating circuit chain."
	icon_state = "clock"
	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	category_text = "Time"
	power_draw_per_use = 50

	inputs = list(
		"delay seconds" = IC_PINTYPE_NUMBER,
		"tick count" = IC_PINTYPE_NUMBER
	)

	inputs_default = list(
		"1" = 2,
		"2" = 4
	)

	outputs = list(
		"current tick" = IC_PINTYPE_NUMBER,
		"running" = IC_PINTYPE_BOOLEAN
	)

	activators = list(
		"start" = IC_PINTYPE_PULSE_IN,
		"on tick" = IC_PINTYPE_PULSE_OUT,
		"on finished" = IC_PINTYPE_PULSE_OUT
	)

	// Stores `running` state used by this integrated electronics object.
	var/running = FALSE
	// Stores `current_tick` state used by this integrated electronics object.
	var/current_tick = 0
	// Stores `max_ticks` state used by this integrated electronics object.
	var/max_ticks = 4
	// Stores `delay_time` state used by this integrated electronics object.
	var/delay_time = 2 SECONDS


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/timed/signal_burst_ticker/do_work()
	if(running)
		return

	pull_data()

	// Stores `input_delay` state used by this integrated electronics object.
	var/input_delay = get_pin_data(IC_INPUT, 1)
	// Stores `input_ticks` state used by this integrated electronics object.
	var/input_ticks = get_pin_data(IC_INPUT, 2)

	if(isnum(input_delay))
		input_delay = max(0.1, input_delay)
	else
		input_delay = 2

	if(isnum(input_ticks))
		input_ticks = max(1, round(input_ticks))
	else
		input_ticks = 4

	delay_time = input_delay SECONDS
	max_ticks = input_ticks
	current_tick = 0
	running = TRUE

	set_pin_data(IC_OUTPUT, 1, current_tick)
	set_pin_data(IC_OUTPUT, 2, running)
	push_data()

	addtimer(CALLBACK(src, PROC_REF(process_tick)), delay_time)


/// Implements `process_tick` behavior for this integrated electronics type.
/obj/item/integrated_circuit/timed/signal_burst_ticker/proc/process_tick()
	if(!running)
		return

	current_tick++

	set_pin_data(IC_OUTPUT, 1, current_tick)
	set_pin_data(IC_OUTPUT, 2, running)
	push_data()
	activate_pin(2)

	if(current_tick >= max_ticks)
		running = FALSE
		set_pin_data(IC_OUTPUT, 2, running)
		push_data()
		activate_pin(3)
		return

	addtimer(CALLBACK(src, PROC_REF(process_tick)), delay_time)


/// Releases owned objects and clears references before parent deletion runs.
/obj/item/integrated_circuit/timed/signal_burst_ticker/Destroy()
	running = FALSE
	return ..()
