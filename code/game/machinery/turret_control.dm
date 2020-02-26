////////////////////////
//Turret Control Panel//
////////////////////////
/area
	// Turrets use this list to see if individual power/lethal settings are allowed
	var/list/turret_controls = list()
	var/list/turrets


/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = 1
	density = 0
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/egun = 1 //if the control panel can switch lethal and stun modes
	var/area/control_area //can be area name, path or nothing.

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 	//Silicons cannot use this
	req_access = list(access_ai_upload)


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
		for(var/area/A in all_areas)
			if(A.name && A.name==control_area)
				control_area = A
				break

	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null

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
		to_chat(user, "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>")
		return 1

	if(locked && !issilicon(user))
		to_chat(user, "<span class='notice'>Access denied.</span>")
		return 1

	return 0

/obj/machinery/turretid/CanUseTopic(mob/user)
	if(isLocked(user))
		return STATUS_CLOSE

	return ..()

/obj/machinery/turretid/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/device/pda))
		if(src.allowed(usr))
			if(emagged)
				to_chat(user, "<span class='notice'>The turret control is unresponsive.</span>")
			else
				locked = !locked
				to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>")
		return
	return ..()

/obj/machinery/turretid/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='danger'>You short out the turret controls' access analysis module.</span>")
		emagged = 1
		locked = 0
		ailock = 0
		return 1

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data
	if(!data)
		data = list()
	VUEUI_SET_IFNOTSET(data["turrets"], list(), ., data)
	VUEUI_SET_CHECK(data["locked"], locked, ., data)
	VUEUI_SET_CHECK(data["enabled"], enabled, ., data)
	VUEUI_SET_CHECK(data["is_lethal"], 1, ., data)
	VUEUI_SET_CHECK(data["lethal"], lethal, ., data)
	VUEUI_SET_CHECK(data["can_switch"], egun, ., data)

	var/usedSettings = list(
		"check_synth" = "Neutralize All Non-Synthetics",
		"check_weapons" = "Check Weapon Authorization",
		"check_records" = "Check Security Records",
		"check_arrest" ="Check Arrest Status",
		"check_access" = "Check Access Authorization",
		"check_anomalies" = "Check misc. Lifeforms"
	)
	VUEUI_SET_IFNOTSET(data["settings"], list(), ., data)
	for(var/v in usedSettings)
		var/name = usedSettings[v]
		VUEUI_SET_IFNOTSET(data["settings"][v], list(), ., data)
		data["settings"][v]["category"] = name
		VUEUI_SET_CHECK(data["settings"][v]["value"], vars[v], ., data)

	if(istype(control_area))
		if(control_area.turrets.len != LAZYLEN(data["turrets"]))
			data["turrets"] = list()
		for (var/obj/machinery/porta_turret/aTurret in control_area.turrets)
			var/ref = "\ref[aTurret]"
			VUEUI_SET_IFNOTSET(data["turrets"][ref], list("ref" = ref), ., data)
			VUEUI_SET_IFNOTSET(data["turrets"][ref]["name"], sanitize(aTurret.name + " [LAZYLEN(data["turrets"])]"), ., data)
			var/rtn = aTurret.vueui_data_change(data["turrets"][ref]["settings"], user, ui)
			if(rtn)
				data["turrets"][ref]["settings"] = rtn
				. = data


/obj/machinery/turretid/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "turrets-control", 375, 725, "Turret Controls")
	ui.open()

/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["turret_ref"] == "this")
		if(href_list["command"] && !isnull(href_list["value"]))
			var/value = text2num(href_list["value"])
			if(href_list["command"] == "enable")
				enabled = value
			else if(href_list["command"] == "lethal")
				lethal = value
			else if(href_list["command"] == "check_synth")
				check_synth = value
			else if(href_list["command"] == "check_weapons")
				check_weapons = value
			else if(href_list["command"] == "check_records")
				check_records = value
			else if(href_list["command"] == "check_arrest")
				check_arrest = value
			else if(href_list["command"] == "check_access")
				check_access = value
			else if(href_list["command"] == "check_anomalies")
				check_anomalies = value
			updateTurrets()
			update_icon()
			SSvueui.check_uis_for_change(src)
	else if(href_list["turret_ref"])
		var/obj/machinery/porta_turret/aTurret = locate(href_list["turret_ref"]) in (control_area.turrets)
		if(!aTurret)
			return
		. = aTurret.Topic(href, href_list)
		SSvueui.check_uis_for_change(src)
		update_icon()

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

/obj/machinery/turretid/proc/getState()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
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
	update_icon()

/obj/machinery/turretid/power_change()
	..()
	updateTurrets()
	update_icon()

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
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = pick(0, 1)

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

	..()
