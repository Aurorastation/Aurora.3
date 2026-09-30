/datum/admin_secret_item/fun_secret/break_all_lights
	name = "Break All Lights"

/datum/admin_secret_item/fun_secret/break_all_lights/execute(var/mob/user)
	. = ..()
	if(.)
		lightsout(0,0)

/datum/admin_secret_item/fun_secret/break_all_lights_on_z_level
	name = "Break All Lights on Current Z-Level"

/datum/admin_secret_item/fun_secret/break_all_lights_on_z_level/execute(var/mob/user)
	. = ..()
	if(.)
		var/turf/admin_turf = get_turf(user)
		if(admin_turf)
			lightsout(0, 0, 25, admin_turf.z)
