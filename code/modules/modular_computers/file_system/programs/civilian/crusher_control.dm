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
	var/message = "" // Message to return to the user
	var/list/pistons = list() //List of pistons linked to the program
	var/list/airlocks = list() //List of airlocks linked to the program
	var/list/status_airlocks = list() //Status of the airlocks
	var/list/status_pistons = list() //Status of the pistons

/datum/nano_module/program/crushercontrol/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()
	data["message"] = message
	data["airlock_count"] = airlocks.len
	data["piston_count"] = pistons.len
	data["status_airlocks"] = status_airlocks
	data["status_pistons"] = status_pistons
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crushercontrol.tmpl", name, 500, 350, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/crushercontrol/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["initialize"])
		pistons = list()
		for(var/obj/machinery/crusher_piston/base/pstn in orange(10,src.host))
			log_debug("Checking Piston")
			if( pstn.disabled || pstn.panel_open)
				continue
			pistons += pstn
			log_debug("Pistons found and added")

		airlocks = list()
		for(var/obj/machinery/door/airlock/arlk in orange(10,src.host))
			log_debug("Checking Airlock")
			if( arlk.id_tag != "crusher")
				continue
			airlocks += arlk
			log_debug("Airlock found and added")
		
		crush_stop()
		airlock_open()

	if(href_list["hatch_open"])
		message = "Opening the Hatch"
		log_debug("Opening the hatch")
		airlock_open()

	if(href_list["hatch_close"])
		message = "Closing the Hatch"
		log_debug("Closing the hatch")
		airlock_close()

	if(href_list["crush"])
		message = "Crushing Shit"
		log_debug("Crushing")
		airlock_close()
		crush_start()


/datum/nano_module/program/crushercontrol/proc/airlock_open()
	for(var/obj/machinery/door/airlock/arlk in airlocks)
		arlk.unlock()
		arlk.open()
		arlk.lock()

/datum/nano_module/program/crushercontrol/proc/airlock_close()
	for(var/obj/machinery/door/airlock/arlk in airlocks)
		arlk.unlock()
		arlk.close()
		arlk.lock()

/datum/nano_module/program/crushercontrol/proc/crush_start()
	for(var/obj/machinery/crusher_piston/base/pstn in pistons)
		pstn.crush_start()

/datum/nano_module/program/crushercontrol/proc/crush_stop()
	for(var/obj/machinery/crusher_piston/base/pstn in pistons)
