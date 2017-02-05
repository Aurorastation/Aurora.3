/datum/computer_file/program/crushercontrol
	filename = "crushercontrol"
	filedesc = "Crusher Control"
	extended_desc = "Application to Control the Crusher"
	size = 8
	requires_ntnet = 0
	available_on_ntnet = 0
	required_access_download = access_hop
	required_access_run = access_janitor
	usage_flags = PROGRAM_TELESCREEN
	nanomodule_path = /datum/nano_module/program/crushercontrol/

/datum/nano_module/program/crushercontrol/
	name = "Crusher Control"
	var/list/linked_pistons = list() //List of linked crusher pistons
	var/status = 1 //1 - Idle, 2 - Crusing, 0 - Error
	var/message = "" // Message to return to the user
	var/hatch_status = 0 // 0 - Open, 1 - Closed
	var/datum/radio_frequency/radio_connection
	var/frequency = 1449

/datum/nano_module/program/crushercontrol/New()
	..()
	set_frequency(frequency)

/datum/nano_module/program/crushercontrol/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)
	log_debug("Radio Connection Established")

/datum/nano_module/program/crushercontrol/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	data["num_linked_pistons"] = linked_pistons.len
	data["status"] = status
	data["message"] = message
	data["crushprogress"] = 30 //Placeholder for now
	data["hatch_status"] = hatch_status



	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crushercontrol.tmpl", name, 500, 350, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/crushercontrol/Topic(href, href_list)
	var/datum/computer_file/program/crushercontrol/prog = program
	if(..())
		return 1

	if(href_list["clear_message"])
		message = ""

	if(href_list["search_pistons"])
		log_debug("Searching for Pistons")
		linked_pistons = list()
		for(var/obj/machinery/crusher_piston/piston in oview(10,src))
			if( piston.disabled || piston.panel_open)
				continue
			linked_pistons += piston
			piston.linked_program = prog
			log_debug("Pistons found and added")

	if(href_list["hatch_open"])
		log_debug("Opening the hatch")
		airlock_open()

	if(href_list["hatch_close"])
		log_debug("Closing the hatch")
		airlock_close()

	if(href_list["crush"])
		log_debug("Crushing")
		airlock_close()
		crush()


/datum/nano_module/program/crushercontrol/proc/airlock_open()
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.data["tag"] = "crusher"
	signal.data["command"] = "secure_open"
	radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

/datum/nano_module/program/crushercontrol/proc/airlock_close()
	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.data["tag"] = "crusher"
	signal.data["command"] = "secure_close"
	radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

/datum/nano_module/program/crushercontrol/proc/crush()
	for(var/obj/machinery/crusher_piston/piston in linked_pistons)
		piston.start_crush()
