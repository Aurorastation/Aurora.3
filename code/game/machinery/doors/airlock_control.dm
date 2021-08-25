#define AIRLOCK_CONTROL_RANGE 22

// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
/obj/machinery/door/airlock
	var/id_tag
	var/frequency
	var/tmp/shockedby
	var/tmp/datum/radio_frequency/radio_connection
	var/tmp/cur_command = null	//the command the door is currently attempting to complete
	var/tmp/waiting_for_roundstart

/obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if (!arePowerSystemsOn()) return //no power

	if(!signal || signal.encryption) return

	if(id_tag != signal.data["tag"] || !signal.data["command"]) return

	cur_command = signal.data["command"]
	execute_current_command()

/obj/machinery/door/airlock/proc/execute_current_command()
	set waitfor = FALSE
	if(operating)
		if (emagged == 1)
			// Come back and try again later.
			queue_command()
		return //emagged or busy doing something else

	if (!cur_command)
		return

	do_command(cur_command)
	if (command_completed(cur_command))
		cur_command = null
	else
		queue_command()

/obj/machinery/door/airlock/proc/queue_command()
	if (waiting_for_roundstart)
		return

	if (ROUND_IS_STARTED)
		addtimer(CALLBACK(src, .proc/execute_current_command), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		SSticker.OnRoundstart(CALLBACK(src, .proc/handle_queue_command))
		waiting_for_roundstart = TRUE

/obj/machinery/door/airlock/proc/handle_queue_command()
	waiting_for_roundstart = null
	execute_current_command()

/obj/machinery/door/airlock/proc/do_command(var/command)
	switch(command)
		if("open")
			open()

		if("close")
			close()

		if("unlock")
			unlock()

		if("lock")
			lock()

		if("secure_open")
			unlock()

			sleep(2)
			open()

			lock()

		if("secure_close")
			unlock()
			close()

			sleep(2)
			lock()

	send_status()

/obj/machinery/door/airlock/proc/command_completed(var/command)
	switch(command)
		if("open")
			return (!density)

		if("close")
			return density

		if("unlock")
			return !locked

		if("lock")
			return locked

		if("secure_open")
			return (locked && !density)

		if("secure_close")
			return (locked && density)

	return 1	//Unknown command. Just assume it's completed.

/obj/machinery/door/airlock/proc/send_status(var/bumped = 0)
	if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["door_status"] = density?("closed"):("open")
		signal.data["lock_status"] = locked?("locked"):("unlocked")

		if (bumped)
			signal.data["bumped_with_access"] = 1

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)


/obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send) send_status()


/obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send) send_status()

/obj/machinery/door/airlock/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = SSradio.add_object(src, frequency, RADIO_AIRLOCK)

/obj/machinery/door/airlock/Initialize(mapload, d = 0, populate_components = TRUE, var/obj/structure/door_assembly/DA)
	. = ..()
	if(frequency)
		set_frequency(frequency)

	//wireless connection
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

	update_icon()

	if(SSradio)
		set_frequency(frequency)

	if(DA)
		bound_height = DA.bound_height
		bound_width = DA.bound_width

/obj/machinery/door/airlock/Destroy()
	if(frequency && SSradio)
		SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor
	name = "airlock sensor"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	layer = OBJ_LAYER

	anchored = 1
	power_channel = ENVIRON

	var/id_tag
	var/master_tag
	var/frequency = 1379
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1
	var/alert = 0
	var/previousPressure

/obj/machinery/airlock_sensor/update_icon()
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/attack_hand(mob/user)
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data["tag"] = master_tag
	signal.data["command"] = command

	radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	flick("airlock_sensor_cycle", src)

/obj/machinery/airlock_sensor/machinery_process()
	if(on)
		var/datum/gas_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - previousPressure) > 0.001 || previousPressure == null)
			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time
			signal.data["pressure"] = num2text(pressure)

			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)

			previousPressure = pressure

			alert = (pressure < ONE_ATMOSPHERE*0.8)

			update_icon()

/obj/machinery/airlock_sensor/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_AIRLOCK)

/obj/machinery/airlock_sensor/Initialize()
	. = ..()
	set_frequency(frequency)
	if(SSradio)
		set_frequency(frequency)

/obj/machinery/airlock_sensor/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/airlock_sensor/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/airlock_exterior
	command = "cycle_exterior"

/obj/machinery/access_button
	name = "access button"
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"
	layer = OBJ_LAYER

	anchored = 1
	power_channel = ENVIRON

	var/master_tag
	var/frequency = 1449
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1


/obj/machinery/access_button/update_icon()
	if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"

/obj/machinery/access_button/attackby(obj/item/I as obj, mob/user as mob)
	//Swiping ID on the access button
	if (I.GetID())
		attack_hand(user)
		return
	..()

/obj/machinery/access_button/attack_hand(mob/user)
	add_fingerprint(usr)
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied</span>")

	else if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["tag"] = master_tag
		signal.data["command"] = command

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	flick("access_button_cycle", src)


/obj/machinery/access_button/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_AIRLOCK)

/obj/machinery/access_button/Initialize()
	. = ..()

	if(SSradio)
		set_frequency(frequency)

/obj/machinery/access_button/Destroy()
	if(SSradio)
		SSradio.remove_object(src, frequency)
	return ..()

/obj/machinery/access_button/airlock_interior
	frequency = 1379
	command = "cycle_interior"

/obj/machinery/access_button/airlock_exterior
	frequency = 1379
	command = "cycle_exterior"

/obj/machinery/door/airlock/proc/command(var/new_command)
	cur_command = new_command

	//if there's no power, receive the signal but just don't do anything. This allows airlocks to continue to work normally once power is restored
	if(arePowerSystemsOn())
		INVOKE_ASYNC(src, .proc/execute_current_command)
