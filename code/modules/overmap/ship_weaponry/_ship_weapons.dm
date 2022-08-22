/datum/ship_weapon
	var/name = "ship artillery"
	var/desc = "You shouldn't see this."
	var/caliber = SHIP_CALIBER_NONE
	var/firing_effects
	var/list/obj/item/ship_ammunition/loaded = list()
	var/obj/machinery/weapon_control/controller

/datum/ship_weapon/Destroy()
	for(var/obj/O in loaded)
		qdel(O)
	loaded.Cut()
	controller = null
	return ..()

/datum/ship_weapon/proc/firing_checks() //Check if we CAN fire.
	if(length(loaded))
		return TRUE
	else
		return FALSE

/datum/ship_weapon/proc/pre_fire() //We can fire, so what do we do before that? Think like a laser charging up.
	return TRUE

/datum/ship_weapon/proc/on_fire() //We just fired! Cool effects!
	return TRUE