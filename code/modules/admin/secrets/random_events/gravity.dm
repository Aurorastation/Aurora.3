/**********
* Gravity *
**********/
/datum/admin_secret_item/random_event/gravity/New()
	..()
	name = "Toggle [station_name(TRUE)] Artificial Gravity"

/datum/admin_secret_item/random_event/gravity/can_execute(var/mob/user)
	if(!(SSticker.mode))
		return 0

	return ..()

/datum/admin_secret_item/random_event/gravity/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/station_levels = SSmapping.levels_by_trait(ZTRAIT_STATION)
	var/enabled = FALSE
	for(var/grav_z in GLOB.gravity_generators)
		if(grav_z in station_levels)
			for(var/obj/machinery/gravity_generator/main/B as anything in GLOB.gravity_generators[grav_z])
				B.eventshutofftoggle()
				enabled = !B.eventon

	feedback_inc("admin_secrets_fun_used",1)
	feedback_add_details("admin_secrets_fun_used","Grav")
	if(enabled)
		log_admin("[key_name(user)] toggled gravity on.")
		message_admins(SPAN_NOTICE("[key_name_admin(user)] toggled gravity on."), 1)
		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
	else
		log_admin("[key_name(user)] toggled gravity off.")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled gravity off."), 1)
		command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes. Have a nice day.")
