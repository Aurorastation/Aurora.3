/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/var/list/controller_debug_list = list(
	"Configuration",
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
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
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
