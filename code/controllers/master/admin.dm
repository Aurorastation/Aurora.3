// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	var/target

/obj/effect/statclick/New(loc, text, target)
	..()
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click(location, control, params)
	if(!usr.client.holder || !target)
		return

	var/permit_mark = TRUE
		
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
			permit_mark = FALSE
		else
			class = "unknown"
			permit_mark = FALSE

	var/list/paramlist = params2list(params)
	if (paramlist["shift"] && permit_mark && target)
		if (target in usr.client.holder.watched_processes)
			usr << span("notice", "[target] removed from watchlist.")
			LAZYREMOVE(usr.client.holder.watched_processes, target)
		else
			usr << span("notice", "[target] added to watchlist.")
			LAZYADD(usr.client.holder.watched_processes, target)
	else
		usr.client.debug_variables(target)
		message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")

// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!check_rights(R_DEBUG|R_SERVER)) 
		return

	switch(controller)
		if("Master")
			new/datum/controller/master()
			feedback_add_details("admin_verb","RMC")
		if("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
