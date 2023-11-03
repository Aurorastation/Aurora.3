/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	var/locked = FALSE
	var/require_module = FALSE
	var/installed = FALSE

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R, var/mob/user)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_WARNING("\The [R] is permanently deactivated and cannot take any upgrades."))
		return FALSE
	if(!R.module && require_module)
		to_chat(user, SPAN_WARNING("\The [R] cannot be upgraded with this until it has chosen a module."))
		return FALSE
	return TRUE

/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	require_module = TRUE

/obj/item/borg/upgrade/reset/action(mob/living/silicon/robot/R, mob/user)
	. = ..()
	if(!.)
		return FALSE
	if(istype(R, /mob/living/silicon/robot/combat) || istype(R, /mob/living/silicon/robot/shell))
		to_chat(user, SPAN_WARNING("\The [R] rejects the reset board. Seems the fitted module is permanent."))
		return FALSE

	R.uneq_all()
	R.mod_type = initial(R.mod_type)
	R.hands.icon_state = initial(R.hands.icon_state)

	R.notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, R.module.name)
	R.module.Reset(R)
	qdel(R.module)
	R.module = null
	R.updatename("Default")
	return TRUE

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R, mob/user)
	. = ..()
	if(!.)
		return FALSE
	R.Namepick()
	return TRUE

/obj/item/borg/upgrade/floodlight
	name = "robot floodlight module"
	desc = "Used to boost cyborg's light intensity."
	icon_state = "cyborg_upgrade1"

/obj/item/borg/upgrade/floodlight/action(mob/living/silicon/robot/R, mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(R.intense_light)
		to_chat(user, SPAN_WARNING("\The [R]'s light has already been upgraded."))
		return FALSE
	else
		R.intense_light = TRUE
		R.update_robot_light()
		to_chat(R, SPAN_NOTICE("Lighting systems upgrade detected."))
	return TRUE

/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"

/obj/item/borg/upgrade/restart/action(var/mob/living/silicon/robot/R, mob/user)
	if(R.health < 0)
		to_chat(user, SPAN_WARNING("\The [R] is still too damaged to force a restart."))
		return FALSE

	if(!R.key)
		for(var/mob/abstract/observer/ghost in player_list)
			if(ghost.mind?.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	dead_mob_list -= R
	living_mob_list |= R
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return TRUE

/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_module = TRUE

/obj/item/borg/upgrade/vtec/action(var/mob/living/silicon/robot/R, mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(R.speed < 0)
		to_chat(user, SPAN_WARNING("\The [R]'s VTEC systems have already been upgraded."))
		return FALSE

	R.speed = -1
	return TRUE

/obj/item/borg/upgrade/syndicate
	name = "non-standard equipment module"
	desc = "Unlocks equipment buried deep within all robots, for very bad occasions."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE

/obj/item/borg/upgrade/syndicate/action(var/mob/living/silicon/robot/R, mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(R.emagged)
		to_chat(user, SPAN_WARNING("\The [R] has already had its non-standard equipment unlocked."))
		return FALSE

	R.emagged = TRUE
	R.fake_emagged = TRUE
	return TRUE

/obj/item/borg/upgrade/combat
	name = "combat cyborg module"
	desc = "Unlocks the combat cyborg module"
	icon_state = "cyborg_upgrade3"
	require_module = FALSE

/obj/item/borg/upgrade/combat/action(var/mob/living/silicon/robot/R, mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(R.crisis_override)
		to_chat(user, SPAN_WARNING("\The [R] already has its combat module available."))
		return FALSE

	R.crisis_override = TRUE
	return TRUE