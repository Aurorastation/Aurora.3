/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/var/list/controller_debug_list = list(
	"Ticker",
	"Jobs",
	"Radio",
	"Supply",
	"Shuttles",
	"Configuration",
	"pAI",
	"Cameras",
	"Gas Data",
	"Observation"
)

/client/proc/debug_controller(controller in controller_debug_list)
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Jobs")
			debug_variables(job_master)
			feedback_add_details("admin_verb","DJobs")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Supply")
			debug_variables(supply_controller)
			feedback_add_details("admin_verb","DSupply")
		if("Shuttles")
			debug_variables(shuttle_controller)
			feedback_add_details("admin_verb","DShuttles")
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("pAI")
			debug_variables(paiController)
			feedback_add_details("admin_verb","DpAI")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Gas Data")
			debug_variables(gas_data)
			feedback_add_details("admin_verb","DGasdata")
		if("Observation")
			debug_variables(all_observable_events)
			feedback_add_details("admin_verb", "DObservation")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
