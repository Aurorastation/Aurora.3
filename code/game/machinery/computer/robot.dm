/obj/machinery/computer/robotics
	name = "robotics control console"
	desc = "Used to remotely lockdown or detonate linked cyborgs."
	icon = 'icons/obj/modular_computers/modular_console.dmi'

	icon_screen = "robot"
	icon_keyboard = "purple_key"
	icon_keyboard_emis = "purple_key_mask"
	light_color = LIGHT_COLOR_PURPLE

	req_one_access = list(ACCESS_RD, ACCESS_ROBOTICS)
	circuit = /obj/item/circuitboard/robotics

	var/safety = TRUE


/obj/machinery/computer/robotics/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/computer/robotics/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/robotics/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoboticsControl", "Robotic Control Console")
		ui.open()

/obj/machinery/computer/robotics/ui_data(mob/user)
	return list(
		"robots" = get_cyborgs(user),
		"safety" = safety,
		"is_ai" = issilicon(user)
	)

/obj/machinery/computer/robotics/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!src.allowed(user))
		to_chat(user, "Access denied.")
		return

	switch(action)
		// Destroys the cyborg
		if("detonate")
			var/mob/living/silicon/robot/target = get_cyborg_by_name(params["name"])
			if(!target || !istype(target))
				return
			if(isAI(user) && (target.connected_ai != user))
				to_chat(user, "Access denied. This robot is not linked to you.")
				return
			// Cyborgs may blow up themselves via the console
			if(isrobot(user) && user != target)
				to_chat(user, "Access denied.")
				return
			var/choice = tgui_alert(user, "Really detonate [target.name]?", "Robotics Control", list("Yes", "No"))
			if(choice != "Yes")
				return TRUE
			if(!target || !istype(target))
				return TRUE
			// Antagonistic cyborgs? Left here for downstream
			if(target.mind && target.mind.special_role && target.emagged)
				to_chat(target, "Extreme danger.  Termination codes detected.  Scrambling security codes and automatic AI unlink triggered.")
				target.ResetSecurityCodes()
				return TRUE
			if(target.emagged)
				to_chat(user, "Access denied. Safety protocols are disabled.")
				return TRUE
			message_admins("[key_name_admin(user)] detonated [target.name]!")
			log_game("[key_name(user)] detonated [target.name]!")
			to_chat(target, SPAN_DANGER("Self-destruct command received."))
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/silicon/robot, self_destruct)), 1 SECONDS)
			return TRUE

		// Locks or unlocks the cyborg
		if("lockdown")
			var/mob/living/silicon/robot/target = get_cyborg_by_name(params["name"])
			if(!target || !istype(target))
				return
			if(isAI(user) && (target.connected_ai != user))
				to_chat(user, "Access denied. This robot is not linked to you.")
				return
			if(isrobot(user))
				to_chat(user, "Access denied.")
				return
			if(target.emagged)
				return TRUE
			var/choice = tgui_alert(user, "Really [target.lock_charge ? "unlock" : "lockdown"] [target.name]?", "Robotics Control", list("Yes", "No"))
			if(choice != "Yes")
				return TRUE
			if(!target || !istype(target))
				return TRUE
			target.SetLockdown(!target.lock_charge)
			message_admins("[key_name_admin(user)] [target.lock_charge ? "locked down" : "released"] [target.name]!")
			log_game("[key_name(user)] [target.lock_charge ? "locked down" : "released"] [target.name]!")
			to_chat(target, (target.lock_charge ? "You have been locked down!" : "Your lockdown has been lifted!"))
			return TRUE

		// Changes borg's access
		if("access")
			var/mob/living/silicon/robot/target = get_cyborg_by_name(params["name"])
			if(!istype(target))
				return
			if(isAI(user) && (target.connected_ai != user))
				to_chat(user, "Access denied. This robot is not linked to you.")
				return
			if(isrobot(user) || target.emagged)
				to_chat(user, "Access denied.")
				return
			if(!target.module)
				to_chat(user, "\The [src]\s access protocols are immutable.")
				return TRUE
			target.module.all_access = !target.module.all_access
			target.update_access()
			var/log_message = "[key_name_admin(user)] changed [target.name] access to [target.module.all_access ? "all access" : "role specific"]."
			message_admins(log_message)
			log_game(log_message)
			to_chat(target, "Your access was changed to: [target.module.all_access ? "all access" : "role specific"].")
			return TRUE

		// Remotely hacks the cyborg. Only antag AIs can do this and only to linked cyborgs.
		if("hack")
			var/mob/living/silicon/robot/target = get_cyborg_by_name(params["name"])
			if(!target || !istype(target))
				return
			if(!istype(user, /mob/living/silicon/ai) || !(user.mind.special_role && user.mind.original == user))
				to_chat(user, "Access denied.")
				return
			if(target.emagged)
				to_chat(user, "Robot is already hacked.")
				return TRUE
			var/choice = tgui_alert(user, "Really hack [target.name]? This cannot be undone.", "Robotics Control", list("Yes", "No"))
			if(choice != "Yes")
				return TRUE
			if(!target || !istype(target))
				return TRUE
			message_admins("[key_name_admin(user)] emagged [target.name] using robotic console!")
			log_game("[key_name(user)] emagged [target.name] using robotic console!")
			target.emagged = TRUE
			to_chat(target, SPAN_NOTICE("Failsafe protocols overriden. New tools available."))
			return TRUE

		// Arms/disarms the emergency self-destruct system
		if("arm")
			if(istype(user, /mob/living/silicon))
				to_chat(user, "Access denied.")
				return
			safety = !safety
			to_chat(user, "You [safety ? "disarm" : "arm"] the emergency self destruct")
			return TRUE

		// Destroys all accessible cyborgs if safety is disabled
		if("nuke")
			if(istype(user, /mob/living/silicon))
				to_chat(user, "Access denied.")
				return
			if(safety)
				to_chat(user, "Self-destruct aborted - safety active")
				return TRUE
			message_admins("[key_name_admin(user)] detonated all cyborgs!")
			log_game("[key_name(user)] detonated all cyborgs!")
			for(var/mob/living/silicon/robot/cyborg in GLOB.mob_list)
				if(istype(cyborg, /mob/living/silicon/robot/drone))
					continue
				if(cyborg.scrambled_codes)
					continue
				if(cyborg.emagged)
					continue
				to_chat(cyborg, SPAN_DANGER("Self-destruct command received."))
				addtimer(CALLBACK(cyborg, TYPE_PROC_REF(/mob/living/silicon/robot, self_destruct)), 1 SECONDS)
			return TRUE


/**
 * Returns a list of accessible cyborgs for the TGUI interface.
 *
 * * operator - The mob operating the console; determines AI-specific hackable status visibility
 */
/obj/machinery/computer/robotics/proc/get_cyborgs(mob/operator)
	var/list/robots = list()

	for(var/mob/living/silicon/robot/cyborg in GLOB.mob_list)
		// Ignore drones
		if(istype(cyborg, /mob/living/silicon/robot/drone))
			continue
		// Ignore antagonistic cyborgs
		if(cyborg.scrambled_codes)
			continue

		var/list/robot = list()
		robot["name"] = cyborg.name
		if(cyborg.stat)
			robot["status"] = "Not Responding"
		else if(cyborg.lock_charge) // changed this from !cyborg.canmove to cyborg.lock_charge because of issues with lockdown and chairs
			robot["status"] = "Lockdown"
		else
			robot["status"] = "Operational"

		if(cyborg.cell)
			robot["cell"] = TRUE
			robot["cell_capacity"] = cyborg.cell.maxcharge
			robot["cell_current"] = cyborg.cell.charge
			robot["cell_percentage"] = round(cyborg.cell.percent())
		else
			robot["cell"] = FALSE

		robot["module"] = cyborg.module ? cyborg.module.name : "None"
		robot["master_ai"] = cyborg.connected_ai ? cyborg.connected_ai.name : "None"
		robot["hackable"] = FALSE
		robot["access"] = cyborg.module ? cyborg.module.all_access : FALSE
		// Antag AIs know whether linked cyborgs are hacked or not.
		if(operator && istype(operator, /mob/living/silicon/ai) && (cyborg.connected_ai == operator) && (operator.mind.special_role && operator.mind.original == operator))
			robot["hacked"] = cyborg.emagged ? TRUE : FALSE
			robot["hackable"] = cyborg.emagged ? FALSE : TRUE
		robots.Add(list(robot))
	return robots

/// Finds a cyborg mob by name in the global mob list. Returns null if not found.
/obj/machinery/computer/robotics/proc/get_cyborg_by_name(name)
	if(!name)
		return
	for(var/mob/living/silicon/robot/cyborg in GLOB.mob_list)
		if(cyborg.name == name)
			return cyborg
