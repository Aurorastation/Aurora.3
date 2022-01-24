/datum/admin_secret_item/fun_secret/light_switches
	name = "Set All Light Switches"
	log = 0
	feedback = 0
	warn_before_use = 0

/datum/admin_secret_item/fun_secret/light_switches/execute(var/mob/user)
	. = ..()
	if(.)
		switch(input("What to set all light switches to?", "Set all light switches", "Cancel") in list("On", "Off", "Initial State", "Cancel"))
			if("On")
				log_and_message_admins("used secret '[name] ON'", user)
				feedback_inc("admin_secrets_used", 1)
				feedback_add_details("admin_secrets_used", "[name] ON")
				set_switches(TRUE)
			if("Off")
				log_and_message_admins("used secret '[name] OFF'", user)
				feedback_inc("admin_secrets_used", 1)
				feedback_add_details("admin_secrets_used", "[name] OFF")
				set_switches(FALSE)
			if("Initial State")
				log_and_message_admins("used secret '[name] INITIAL'", user)
				feedback_inc("admin_secrets_used", 1)
				feedback_add_details("admin_secrets_used", "[name] INITIAL")
				set_switches(null)

/datum/admin_secret_item/fun_secret/light_switches/proc/set_switches(var/new_state)
	for(var/area/A in all_areas)
		if(A.lightswitch != new_state)
			A.set_lightswitch(new_state)
