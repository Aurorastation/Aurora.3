//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

GLOBAL_LIST_EMPTY(priority_air_alarms)
GLOBAL_LIST_EMPTY(minor_air_alarms)


/obj/machinery/computer/atmos_alert
	name = "atmospheric alert computer"
	desc = "Used to access atmospheric sensors."
	circuit = /obj/item/circuitboard/atmos_alert

	icon_screen = "alert:0"
	icon_keyboard = "cyan_key"
	icon_keyboard_emis = "cyan_key_mask"
	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/atmos_alert/Initialize()
	. = ..()
	GLOB.atmosphere_alarm.register_alarm(src, TYPE_PROC_REF(/atom, update_icon))

/obj/machinery/computer/atmos_alert/Destroy()
	GLOB.atmosphere_alarm.unregister_alarm(src)
	return ..()

/obj/machinery/computer/atmos_alert/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/atmos_alert/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosAlertComputer")
		ui.open()

/obj/machinery/computer/atmos_alert/ui_data(mob/user)
	var/list/data = list()
	var/list/major_alarms = list()
	var/list/minor_alarms = list()

	for(var/datum/alarm/alarm in GLOB.atmosphere_alarm.major_alarms())
		major_alarms += list(list("name" = sanitize(alarm.alarm_name()), "ref" = REF(alarm)))

	for(var/datum/alarm/alarm in GLOB.atmosphere_alarm.minor_alarms())
		minor_alarms += list(list("name" = sanitize(alarm.alarm_name()), "ref" = REF(alarm)))

	data["priority_alarms"] = major_alarms
	data["minor_alarms"] = minor_alarms
	return data

/obj/machinery/computer/atmos_alert/update_icon()
	if(!(stat & (NOPOWER|BROKEN)))
		var/list/alarms = GLOB.atmosphere_alarm.major_alarms()
		if(alarms.len)
			icon_screen = "alert:2"
		else
			alarms = GLOB.atmosphere_alarm.minor_alarms()
			if(alarms.len)
				icon_screen = "alert:1"
			else
				icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/atmos_alert/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "clear_alarm")
		var/datum/alarm/alarm = locate(params["ref"]) in GLOB.atmosphere_alarm.alarms
		if(alarm)
			for(var/datum/alarm_source/alarm_source in alarm.sources)
				var/obj/machinery/alarm/air_alarm = alarm_source.source
				if(istype(air_alarm))
					air_alarm.alarm_reset()
		return TRUE
