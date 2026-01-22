//base type for controllers of two-door systems
/obj/machinery/embedded_controller/radio/airlock
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	// Setup parameters only
	radio_filter = RADIO_AIRLOCK
	var/tag_exterior_door
	var/tag_interior_door
	var/tag_airpump
	var/tag_chamber_sensor
	var/tag_exterior_sensor
	var/tag_interior_sensor
	var/tag_airlock_mech_sensor
	var/tag_shuttle_mech_sensor
	var/tag_secure = FALSE
	var/tag_air_alarm
	var/cycle_to_external_air = FALSE
	var/has_interior_sensor
	var/has_exterior_sensor

/obj/machinery/embedded_controller/radio/airlock/Initialize(mapload, given_id_tag, given_frequency, given_tag_exterior_door, given_tag_interior_door, given_tag_airpump, given_tag_chamber_sensor)
	. = ..()
	if(given_id_tag)
		id_tag = given_id_tag
	if(given_frequency)
		set_frequency(given_frequency)
	if(given_tag_exterior_door)
		tag_exterior_door = given_tag_exterior_door
	if(given_tag_interior_door)
		tag_interior_door = given_tag_interior_door
	if(given_tag_airpump)
		tag_airpump = given_tag_airpump
	if(given_tag_chamber_sensor)
		tag_chamber_sensor = given_tag_chamber_sensor
	program = new /datum/computer/file/embedded_program/airlock(src)

/obj/machinery/embedded_controller/radio/airlock/Destroy()
	. = ..()
	GC_TEMPORARY_HARDDEL

/obj/machinery/embedded_controller/radio/airlock/attackby(obj/item/attacking_item, mob/user)
	//Swiping ID on the access button
	if (attacking_item.GetID())
		attack_hand(user)
		return TRUE
	return ..()

/obj/machinery/embedded_controller/radio/airlock/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return FALSE
	return ..()

//Advanced airlock controller for when you want a more versatile airlock controller - useful for turning simple access control rooms into airlocks
/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller
	name = "Advanced Airlock Controller"

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockConsoleAdvanced", ui_x=470, ui_y=290)
		ui.open()

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/ui_data(mob/user)
	var/list/data = list()

	data["chamber_pressure"] = round(program.memory["chamber_sensor_pressure"])
	data["has_exterior_sensor"] = has_exterior_sensor
	data["external_pressure"] = round(program.memory["external_sensor_pressure"])
	data["has_interior_sensor"] = has_interior_sensor
	data["internal_pressure"] = round(program.memory["internal_sensor_pressure"])
	data["processing"] = program.memory["processing"]
	data["purge"] = program.memory["purge"]
	data["secure"] = program.memory["secure"]

	return data

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/ui_act(action, params)
	. = ..()
	if(.)
		return

	program.receive_user_command(action)

//Airlock controller for airlock control - most airlocks on the station use this
/obj/machinery/embedded_controller/radio/airlock/airlock_controller
	name = "Airlock Controller"
	tag_secure = TRUE

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockConsoleStandard", ui_x=470, ui_y=290)
		ui.open()

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/ui_data(mob/user)
	var/list/data = list()

	data["chamber_pressure"] = round(program.memory["chamber_sensor_pressure"])
	data["processing"] = program.memory["processing"]

	return data

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/ui_act(action, params)
	. = ..()
	if(.)
		return

	program.receive_user_command(action)


//Access controller for door control - used in virology and the like
/obj/machinery/embedded_controller/radio/airlock/access_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_control_standby"

	name = "Access Controller"
	tag_secure = TRUE


/obj/machinery/embedded_controller/radio/airlock/access_controller/update_icon()
	if(on && program)
		if(program.memory["processing"])
			icon_state = "access_control_process"
		else
			icon_state = "access_control_standby"
	else
		icon_state = "access_control_off"

/obj/machinery/embedded_controller/radio/airlock/access_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockConsoleAccess", ui_x=470, ui_y=290)
		ui.open()

/obj/machinery/embedded_controller/radio/airlock/access_controller/ui_data(mob/user)
	var/list/data = list()

	data["exterior_status"] = round(program.memory["exterior_status"])
	data["interior_status"] = round(program.memory["interior_status"])
	data["processing"] = program.memory["processing"]

	return data

/obj/machinery/embedded_controller/radio/airlock/access_controller/ui_act(action, params)
	. = ..()
	if(.)
		return

	program.receive_user_command(action)
