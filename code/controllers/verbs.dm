/client/proc/debug_antagonist_template(antag_type in GLOB.all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = GLOB.all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller()
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	var/list/available_controllers = list()
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if (MC_RUNNING() && SS.flags & SS_NO_DISPLAY)
			continue
		available_controllers[SS.name] = SS
	available_controllers["Evacuation Controller"] = evacuation_controller
	var/css = input("What controller would you like to debug?", "Controllers") as null|anything in available_controllers
	if(!css)
		return
	debug_variables(available_controllers[css])

	message_admins("Admin [key_name_admin(usr)] is debugging the [css] controller.")
