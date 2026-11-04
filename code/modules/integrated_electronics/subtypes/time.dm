/*
 * subtypes/time.dm
 * Timing circuits: delays, clocks, pulses, cooldown-style behavior, and scheduled activation.
 */

/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Outputs the current local time when pulsed."
	complexity = 2
	inputs = list()
	outputs = list()
	category_text = "Time"

/obj/item/integrated_circuit/time/delay
	name = "two-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of two seconds."
	icon_state = "delay-20"
	var/delay = 2 SECONDS
	activators = list("incoming"= IC_PINTYPE_PULSE_IN,"outgoing" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 30

/obj/item/integrated_circuit/time/delay/do_work()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/integrated_circuit, activate_pin), 2), delay)

/obj/item/integrated_circuit/time/delay/five_sec
	name = "five-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of five seconds."
	icon_state = "delay-50"
	delay = 5 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/time/delay/one_sec
	name = "one-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of one second."
	icon_state = "delay-10"
	delay = 1 SECOND
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/time/delay/half_sec
	name = "half-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of half a second."
	icon_state = "delay-5"
	complexity = 4
	delay = 5
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 60

/obj/item/integrated_circuit/time/delay/tenth_sec
	name = "tenth-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of 1/10th of a second."
	icon_state = "delay-1"
	complexity = 6
	delay = 1
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 100

/obj/item/integrated_circuit/time/delay/custom
	name = "custom delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit's delay can be customized, between 1/10th of a second to one hour.  The delay is updated upon receiving a pulse."
	icon_state = "delay"
	complexity = 6
	inputs = list("delay time" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100

/obj/item/integrated_circuit/time/delay/custom/on_data_written()
	delay = between(1, get_pin_data(IC_INPUT, 1), 1 HOUR)
	..()

/obj/item/integrated_circuit/time/ticker
	name = "ten second ticker"
	desc = "Sends an automatic pulse every ten seconds."
	icon_state = "tick-m"
	complexity = 8
	var/seconds_to_pulse = 10
	var/ticks_completed = 0
	var/is_running = FALSE
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN)
	activators = list("outgoing pulse" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40

/obj/item/integrated_circuit/time/ticker/Destroy()
	STOP_PROCESSING(SSelectronics, src)
	. = ..()

/obj/item/integrated_circuit/time/ticker/on_data_written()
	var/do_tick = get_pin_data(IC_INPUT, 1)
	if(do_tick && !is_running)
		is_running = TRUE
		START_PROCESSING(SSelectronics, src)
	else if(!do_tick && is_running)
		is_running = FALSE
		STOP_PROCESSING(SSelectronics, src)
		ticks_completed = 0

/obj/item/integrated_circuit/time/ticker/process()
	var/process_ticks = SSelectronics.wait
	var/pulse_ticks = SecondsToTicks(seconds_to_pulse)
	ticks_completed += process_ticks
	if(ticks_completed >= pulse_ticks)
		if(pulse_ticks >= process_ticks)
			ticks_completed -= pulse_ticks
		else
			ticks_completed = 0
		if(!check_power())
			power_fail()
			return
		activate_pin(1)

/obj/item/integrated_circuit/time/ticker/power_fail()
	is_running = FALSE
	STOP_PROCESSING(SSelectronics, src)
	ticks_completed = 0

/obj/item/integrated_circuit/time/ticker/rapid
	name = "one second ticker"
	desc = "Sends a high-speed automatic pulse every second."
	icon_state = "tick-f"
	complexity = 18
	seconds_to_pulse = 1
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 240

/obj/item/integrated_circuit/time/ticker/fast
	name = "two second ticker"
	desc = "Sends an automatic pulse every two seconds."
	icon_state = "tick-f"
	complexity = 12
	seconds_to_pulse = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 120

/obj/item/integrated_circuit/time/ticker/slow
	name = "thirty second ticker"
	desc = "Sends an automatic pulse every thirty seconds."
	icon_state = "tick-s"
	complexity = 4
	seconds_to_pulse = 30
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/time/ticker/very_slow
	name = "five minute ticker"
	desc = "Sends an automatic pulse every five minutes."
	icon_state = "tick-s"
	complexity = 4
	seconds_to_pulse = 300
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/time/ticker/custom
	name = "custom ticker"
	desc = "Sends automatic pulses at a configurable interval between 2 and 600 seconds. Default: 60 seconds."
	icon_state = "tick-f"
	complexity = 15
	seconds_to_pulse = 60
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 120
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN, "ticker time" = IC_PINTYPE_NUMBER)

/obj/item/integrated_circuit/time/ticker/custom/on_data_written()
	seconds_to_pulse = between(2, get_pin_data(IC_INPUT, 2), 600)
	..()

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

/obj/item/integrated_circuit/time/clock/do_work()
	set_pin_data(IC_OUTPUT, 1, time2text(station_time_in_ticks, "hh:mm:ss") )
	set_pin_data(IC_OUTPUT, 2, text2num(time2text(station_time_in_ticks, "hh") ) )
	set_pin_data(IC_OUTPUT, 3, text2num(time2text(station_time_in_ticks, "mm") ) )
	set_pin_data(IC_OUTPUT, 4, text2num(time2text(station_time_in_ticks, "ss") ) )

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/timed/signal_burst_ticker
	name = "signal burst ticker"
	desc = "A ticker that starts when pulsed, ticks a fixed number of times, then stops."
	extended_desc = "Useful when you want a signaler, scanner, button, or other pulse source to temporarily enable a repeating circuit chain. Pulse count is clamped from 1 to 20, and interval is clamped from 1 to 60 seconds."
	icon_state = "clock"
	complexity = 10
	spawn_flags = IC_SPAWN_RESEARCH
	category_text = "Time"
	power_draw_per_use = 160

	inputs = list(
		"pulse count" = IC_PINTYPE_NUMBER,
		"interval seconds" = IC_PINTYPE_NUMBER,
		"enabled" = IC_PINTYPE_BOOLEAN
	)

	inputs_default = list(
		"1" = 4,
		"2" = 2,
		"3" = TRUE
	)

	outputs = list(
		"current pulse" = IC_PINTYPE_NUMBER,
		"running" = IC_PINTYPE_BOOLEAN
	)

	activators = list(
		"start" = IC_PINTYPE_PULSE_IN,
		"stop" = IC_PINTYPE_PULSE_IN,
		"on pulse" = IC_PINTYPE_PULSE_OUT,
		"on finished" = IC_PINTYPE_PULSE_OUT
	)

	var/running = FALSE
	var/current_tick = 0
	var/max_ticks = 4
	var/delay_time = 2 SECONDS
	var/burst_id = 0


/obj/item/integrated_circuit/timed/signal_burst_ticker/do_work(activator_id)
	var/active_pin = activator_id

	if(istype(active_pin, /datum/integrated_io))
		active_pin = activators.Find(active_pin)

	if(!isnum(active_pin))
		active_pin = 1

	if(active_pin == 2)
		stop_burst(FALSE)
		return

	if(running)
		return

	pull_data()

	if(!get_pin_data(IC_INPUT, 3))
		stop_burst(FALSE)
		return

	var/input_ticks = get_pin_data(IC_INPUT, 1)
	var/input_delay = get_pin_data(IC_INPUT, 2)

	if(isnum(input_delay))
		input_delay = between(1, input_delay, 60)
	else
		input_delay = 2

	if(isnum(input_ticks))
		input_ticks = between(1, round(input_ticks), 20)
	else
		input_ticks = 4

	delay_time = input_delay SECONDS
	max_ticks = input_ticks
	current_tick = 0
	running = TRUE
	burst_id++

	set_pin_data(IC_OUTPUT, 1, current_tick)
	set_pin_data(IC_OUTPUT, 2, running)
	push_data()

	// Timer IDs make old callbacks harmless after stop/restart or deletion.
	addtimer(CALLBACK(src, PROC_REF(process_tick), burst_id), delay_time)


/obj/item/integrated_circuit/timed/signal_burst_ticker/proc/process_tick(expected_burst_id)
	if(!running || expected_burst_id != burst_id)
		return

	if(!check_power())
		power_fail()
		return

	current_tick++

	set_pin_data(IC_OUTPUT, 1, current_tick)
	set_pin_data(IC_OUTPUT, 2, running)
	push_data()
	activate_pin(3)

	if(current_tick >= max_ticks)
		stop_burst(TRUE)
		return

	addtimer(CALLBACK(src, PROC_REF(process_tick), expected_burst_id), delay_time)

/obj/item/integrated_circuit/timed/signal_burst_ticker/proc/stop_burst(finished)
	if(!running && !finished)
		set_pin_data(IC_OUTPUT, 2, FALSE)
		push_data()
		return

	running = FALSE
	burst_id++
	set_pin_data(IC_OUTPUT, 2, running)
	push_data()

	if(finished)
		activate_pin(4)


/obj/item/integrated_circuit/timed/signal_burst_ticker/Destroy()
	running = FALSE
	burst_id++
	return ..()

/obj/item/integrated_circuit/timed/signal_burst_ticker/power_fail()
	stop_burst(FALSE)
