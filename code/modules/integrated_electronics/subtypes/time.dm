/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Now you can build your own clock!"
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
	power_draw_per_use = 20

/obj/item/integrated_circuit/time/delay/do_work()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/integrated_circuit, activate_pin), 2), delay)

/obj/item/integrated_circuit/time/delay/five_sec
	name = "five-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of five seconds."
	icon_state = "delay-50"
	delay = 5 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/one_sec
	name = "one-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of one second."
	icon_state = "delay-10"
	delay = 1 SECOND
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/half_sec
	name = "half-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of half a second."
	icon_state = "delay-5"
	delay = 5
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/tenth_sec
	name = "tenth-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of 1/10th of a second."
	icon_state = "delay-1"
	delay = 1
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/custom
	name = "custom delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit's delay can be customized, between 1/10th of a second to one hour.  The delay is updated upon receiving a pulse."
	icon_state = "delay"
	inputs = list("delay time" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/custom/on_data_written()
	delay = between(1, get_pin_data(IC_INPUT, 1), 1 HOUR)
	..()

/obj/item/integrated_circuit/time/ticker
	name = "ten second ticker"
	desc = "This circuit sends an automatic pulse every ten seconds."
	icon_state = "tick-m"
	complexity = 8
	var/seconds_to_pulse = 10 SECONDS
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
	else if(is_running)
		is_running = FALSE
		STOP_PROCESSING(SSelectronics, src)
		ticks_completed = 0

/obj/item/integrated_circuit/time/ticker/process()
	var/process_ticks = SSelectronics.wait
	ticks_completed += process_ticks
	if(ticks_completed >= SecondsToTicks(seconds_to_pulse))
		if(SecondsToTicks(seconds_to_pulse) >= process_ticks)
			ticks_completed -= SecondsToTicks(seconds_to_pulse)
		else
			ticks_completed = 0
		activate_pin(1)

/obj/item/integrated_circuit/time/ticker/fast
	name = "two second ticker"
	desc = "This advanced circuit sends an automatic pulse every two seconds."
	icon_state = "tick-f"
	complexity = 12
	seconds_to_pulse = 2
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80

/obj/item/integrated_circuit/time/ticker/slow
	name = "thirty second ticker"
	desc = "This simple circuit sends an automatic pulse every thirty seconds."
	icon_state = "tick-s"
	complexity = 4
	seconds_to_pulse = 30
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/time/ticker/very_slow
	name = "five minute ticker"
	desc = "This simple circuit sends an automatic pulse every five minutes (three hundred seconds)."
	icon_state = "tick-s"
	complexity = 4
	seconds_to_pulse = 300
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

/obj/item/integrated_circuit/time/ticker/custom
	name = "custom ticker"
	desc = "This advanced circuit sends an automatic pulse with a configurable interval between 2 and 600 seconds. Default: 60 seconds."
	icon_state = "tick-f"
	complexity = 15
	seconds_to_pulse = 60
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 80
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN, "ticker time" = IC_PINTYPE_NUMBER)

/obj/item/integrated_circuit/time/ticker/custom/on_data_written()
	seconds_to_pulse = between(2, get_pin_data(IC_INPUT, 2), 600)
	..()

/obj/item/integrated_circuit/time/clock
	name = "integrated clock"
	desc = "Tells you what the local time is, specific to your station, planet, or facility."
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
