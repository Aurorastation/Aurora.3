/datum/computer_file/program/crushercontrol
	filename = "crushercontrol"
	filedesc = "Crusher Control"
	extended_desc = "Application to Control the Crusher"
	size = 8
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	required_access_download = access_hop
	required_access_run = access_janitor
	usage_flags = PROGRAM_TELESCREEN
	nanomodule_path = /datum/nano_module/program/crushercontrol

/datum/nano_module/program/crushercontrol
	name = "Crusher Control"
	var/message = "" // Message to return to the user
	var/extending = FALSE //If atleast one of the pistons is extending
	var/list/pistons = list() //List of pistons linked to the program
	var/list/airlocks = list() //List of airlocks linked to the program
	var/list/status_airlocks = list() //Status of the airlocks
	var/list/status_pistons = list() //Status of the pistons

/datum/nano_module/program/crushercontrol/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	status_pistons = list()
	extending = FALSE

	//Cycle through the pistons and get their status
	var/i = 1
	for(var/obj/machinery/crusher_base/pstn in pistons)
		var/num_progress = pstn.get_num_progress()
		var/is_blocked = pstn.is_blocked()
		var/action = pstn.get_action()
		if(action == "extend")
			extending = TRUE
		status_pistons.Add(list(list(
			"progress"=num_progress,
			"blocked"=is_blocked,
			"action"=action,
			"piston"=i
			)))
		i++

	data["message"] = message
	data["airlock_count"] = airlocks.len
	data["piston_count"] = pistons.len
	data["status_airlocks"] = status_airlocks
	data["status_pistons"] = status_pistons
	data["extending"] = extending
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crushercontrol.tmpl", name, 500, 350, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/datum/nano_module/program/crushercontrol/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["initialize"])
		pistons = list()
		for(var/obj/machinery/crusher_base/pstn in orange(10, src.host))
			pistons += pstn

		airlocks = list()
		for(var/obj/machinery/door/airlock/arlk in orange(10, src.host))
			if(arlk.id_tag != "crusher")
				continue
			airlocks += arlk
		
		airlock_open()

	if(href_list["hatch_open"])
		message = "Opening the Hatch"
		airlock_open()

	if(href_list["hatch_close"])
		message = "Closing the Hatch"
		airlock_close()

	if(href_list["crush"])
		message = "Crushing"
		airlock_close()
		crush_start()
		
	if(href_list["abort"])
		message = "Aborting"
		crush_stop()
	
	if(href_list["close"])
		message = null


/datum/nano_module/program/crushercontrol/proc/airlock_open()
	for(var/thing in airlocks)
		var/obj/machinery/door/airlock/arlk = thing
		if(!arlk.cur_command)
			// Not using do_command so that the command queuer works.
			arlk.cur_command = "secure_open"
			arlk.execute_current_command()

/datum/nano_module/program/crushercontrol/proc/airlock_close()
	for(var/thing in airlocks)
		var/obj/machinery/door/airlock/arlk = thing
		if(!arlk.cur_command)
			arlk.cur_command = "secure_close"
			arlk.execute_current_command()

/datum/nano_module/program/crushercontrol/proc/crush_start()
	for(var/obj/machinery/crusher_base/pstn in pistons)
		pstn.crush_start()

/datum/nano_module/program/crushercontrol/proc/crush_stop()
	for(var/obj/machinery/crusher_base/pstn in pistons)
		pstn.crush_abort()