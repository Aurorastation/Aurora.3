////////////////////////
//Turret Control Panel//
////////////////////////
/area
	// Turrets use this list to see if individual power/lethal settings are allowed
	var/list/turret_controls = list()
	var/list/turrets = list()


/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machinery/turret_control.dmi'
	icon_state = "control_standby"
	anchored = 1
	density = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/egun = 1 //if the control panel can switch lethal and stun modes
	var/area/control_area //can be area name, path or nothing.

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_wildlife = 1	//checks if it can shoot at simple animals or anything that passes issmall
	var/check_synth = 0		//if active, will shoot at anything not an AI or cyborg
	var/target_borgs = FALSE//if active, will shoot at borgs
	var/ailock = 0 	//Silicons cannot use this
	req_access = list(ACCESS_AI_UPLOAD)


/obj/machinery/turretid/stun
	enabled = 1
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = 1
	lethal = 1
	icon_state = "control_kill"

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	return ..()

/obj/machinery/turretid/Initialize(mapload)
	. = ..()
	if(!control_area)
		control_area = get_area(src)
	else if(istext(control_area))
		for(var/area/A in GLOB.all_areas)
			if(A.name && A.name==control_area)
				control_area = A
				break

	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null
	updateTurrets()
	if (!mapload)
		power_change() //Checks power and initial settings
		turretModes()
	else
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/turretid/LateInitialize()
	power_change()
	turretModes()

/obj/machinery/turretid/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_WARNING("There seems to be a firewall preventing you from accessing this device."))
		return TRUE

	if(!issilicon(user))
		if(locked && !allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return TRUE

	return FALSE

/obj/machinery/turretid/CanUseTopic(mob/user)
	if(isLocked(user))
		return STATUS_CLOSE

	return ..()

/obj/machinery/turretid/attackby(obj/item/attacking_item, mob/user)
	if(stat & BROKEN)
		return

	if(attacking_item.GetID())
		if(src.allowed(usr))
			if(emagged)
				to_chat(user, "<span class='notice'>The turret control is unresponsive.</span>")
			else
				locked = !locked
				to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>")
		return TRUE
	return ..()

/obj/machinery/turretid/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='danger'>You short out the turret controls' access analysis module.</span>")
		emagged = 1
		locked = 0
		ailock = 0
		return 1

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/ui_data(mob/user)
	var/list/data = list()
	data["turrets"] = list()
	data["locked"] = isAI(user) ? FALSE : locked
	data["enabled"] = enabled
	data["is_lethal"] = TRUE
	data["lethal"] = lethal
	data["can_switch"] = egun

	var/usedSettings = list(
		"check_synth" = "Neutralize All Non-Synthetics",
		"target_borgs" = "Neutralize All Cyborg-likes",
		"check_wildlife" = "Neutralize All Wildlife",
		"check_weapons" = "Check Weapon Authorization",
		"check_records" = "Check Security Records",
		"check_arrest" = "Check Arrest Status",
		"check_access" = "Check Access Authorization"
	)
	data["settings"] = list()
	for(var/v in usedSettings)
		var/name = usedSettings[v]
		data["settings"] += list(list("category" = name, "value" = vars[v], "variable_name" = v))

	if(istype(control_area))
		if(control_area.turrets.len != LAZYLEN(data["turrets"]))
			data["turrets"] = list()
		for(var/obj/machinery/porta_turret/aTurret in control_area.turrets)
			var/ref = "\ref[aTurret]"
			data["turrets"] += list(list("name" = sanitize(aTurret.name + " [LAZYLEN(data["turrets"])]"), "ref" = ref, "settings" = aTurret.get_settings(), "enabled" = aTurret.enabled, "lethal" = aTurret.lethal))
	return data

/obj/machinery/turretid/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TurretControl", "Defense Systems Control Panel", 375, 725)
		ui.open()

/obj/machinery/turretid/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("command")
			if(params["turret_ref"] == "this")
				if(!isnull(params["value"]))
					var/value = text2num(params["value"])
					switch(params["command"])
						if("enable")
							enabled = value
						if("lethal")
							lethal = value
						if("check_synth")
							check_synth = value
						if("target_borgs")
							target_borgs = value
						if("check_weapons")
							check_weapons = value
						if("check_records")
							check_records = value
						if("check_arrest")
							check_arrest = value
						if("check_access")
							check_access = value
						if("check_wildlife")
							check_wildlife = value
					updateTurrets()
					. = TRUE
			else
				var/obj/machinery/porta_turret/aTurret = locate(params["turret_ref"]) in (control_area.turrets)
				if(!aTurret)
					return
				. = aTurret.ui_act(action, params, ui, state)

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = getState()
	if(istype(control_area))
		for (var/obj/machinery/porta_turret/aTurret in control_area.turrets)
			if (aTurret.lethal == lethal || aTurret.egun)
				TC.enabled = enabled
				aTurret.setState(TC)
			else
				TC.enabled = 0
				aTurret.setState(TC)

	queue_icon_update()

/obj/machinery/turretid/proc/getState()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.target_borgs = target_borgs
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_wildlife = check_wildlife
	TC.ailock = ailock

	return TC

/obj/machinery/turretid/proc/turretModes()
	if (!istype(control_area))
		return
	var/one_mode = 0 // Is there general one mode only turret
	var/both_mode = 0 // Is there both mode turrets
	for (var/obj/machinery/porta_turret/aTurret in control_area.turrets)
		// If turret only has lethal mode - lock switching modes
		if(!aTurret.egun)
			one_mode = 1
			egun = 0
		else
			both_mode = 1
	// If there is a turret with lethal mode only, and turret with both modes. Disable turrets with lethality that is not same as current control setting.
	if(both_mode && one_mode)
		egun = 1
	else if (LAZYLEN(control_area.turrets)) // If we just have turrets with one mode, ensure that panel's lethal variable is same as Turrets.
		var/obj/machinery/porta_turret/aTurret = control_area.turrets[1]
		lethal = aTurret.lethal
		updateTurrets()

/obj/machinery/turretid/power_change()
	..()
	updateTurrets()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
		set_light(0)
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
			set_light(1.5, 1,"#990000")
		else
			icon_state = "control_stun"
			set_light(1.5, 1,"#FF9900")
	else
		icon_state = "control_standby"
		set_light(1.5, 1,"#003300")

/obj/machinery/turretid/emp_act(severity)
	. = ..()

	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_wildlife = pick(0, 1)

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

