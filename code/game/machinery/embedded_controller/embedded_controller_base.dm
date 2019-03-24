/obj/machinery/embedded_controller
	var/datum/computer/file/embedded_program/program	//the currently executing program

	name = "Embedded Controller"
	anchored = 1

	use_power = 1
	idle_power_usage = 10

	var/on = 1

obj/machinery/embedded_controller/radio/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal || signal.encryption) return

	if(program)
		program.receive_signal(signal, receive_method, receive_param)
			//spawn(5) program.process() //no, program.process sends some signals and machines respond and we here again and we lag -rastaf0

/obj/machinery/embedded_controller/machinery_process()
	if(program)
		program.process()

	update_icon()

/obj/machinery/embedded_controller/attack_ai(mob/user as mob)
	src.ui_interact(user)

/obj/machinery/embedded_controller/attack_hand(mob/user as mob)

	if(!user.IsAdvancedToolUser())
		return 0

	src.ui_interact(user)

/obj/machinery/embedded_controller/ui_interact()
	return

/obj/machinery/embedded_controller/radio
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	power_channel = ENVIRON
	density = 0

	var/id_tag
	//var/radio_power_use = 50 //power used to xmit signals

	var/frequency = 1379
	var/radio_filter = null
	var/datum/radio_frequency/radio_connection
	unacidable = 1

/obj/machinery/embedded_controller/radio/Initialize()
	. = ..()
	set_frequency(frequency)

/obj/machinery/embedded_controller/radio/update_icon()
	if(on && program)
		if(program.memory["processing"])
			icon_state = "airlock_control_process"
		else
			icon_state = "airlock_control_standby"
	else
		icon_state = "airlock_control_off"

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		//use_power(radio_power_use)	//neat idea, but causes way too much lag.
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, radio_filter)

/obj/machinery/embedded_controller/radio/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/weapon/screwdriver))
		to_chat(user, span("notice", "You unscrew \the [src] from the wall."))
		dismantle()
	else if(istype(C,/obj/item/device/debugger))
		var/newtag = input(user, "Enter a new controller ID tag.", "Controller Tag Control") as null|text
		id_tag = newtag
		update_tags()
		return

/obj/machinery/embedded_controller/radio/proc/update_tags()
	return

/obj/machinery/embedded_controller/radio/airlock/update_tags()
	. = ..()
	tag_exterior_door = "[id_tag]_outer"
	tag_interior_door = "[id_tag]_inner"
	tag_airpump = "[id_tag]_pump"
	tag_chamber_sensor = "[id_tag]_sensor"
	tag_exterior_sensor = "[id_tag]_ext_sensor"
	tag_interior_sensor = "[id_tag]_int_sensor"
	tag_airlock_mech_sensor = "[id_tag]_airlock_mech"
	tag_shuttle_mech_sensor = "[id_tag]_shuttle_mech"
	sync_program()

/obj/machinery/embedded_controller/radio/dismantle()
	playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
	var/obj/item/frame/controller/radio/controller = new/obj/item/frame/controller(loc)
	controller.build_machine_type = src.type
	controller.id_tag = src.id_tag
	qdel(src)
	return 1