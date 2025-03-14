/obj/machinery/keycard_auth
	name = "keycard authentication device"
	desc = "This device is used to trigger station functions, which require more than one ID card to authenticate."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/active = 0 //This gets set to 1 on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/confirmed = 0 //This variable is set by the device that confirms the request.
	var/confirm_delay = 20 //(2 seconds)
	var/busy = 0 //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	var/recorded_message = ""
	//1 = select event
	//2 = authenticate
	anchored = 1.0
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = AREA_USAGE_ENVIRON

/obj/machinery/keycard_auth/Initialize(mapload, d, populate_components, is_internal)
	..()
	desc = "This device is used to trigger [station_name(TRUE)] functions, which require more than one ID card to authenticate."
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/keycard_auth/LateInitialize()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/keycard_auth/attack_ai(mob/user)
	to_chat(user, SPAN_NOTICE("The station AI is not to interact with these devices."))
	return

/obj/machinery/keycard_auth/attackby(obj/item/attacking_item, mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(istype(attacking_item, /obj/item/card/id))
		var/obj/item/card/id/ID = attacking_item
		if(ACCESS_KEYCARD_AUTH in ID.access)
			if(active == 1)
				//This is not the device that made the initial request. It is the device confirming the request.
				if(event_source)
					event_source.confirmed = 1
					event_source.event_confirmed_by = usr
			else if(screen == 2)
				event_triggered_by = usr
				broadcast_request(user) //This is the device making the initial event request. It needs to broadcast to other devices

/obj/machinery/keycard_auth/power_change()
	..()
	if(stat &NOPOWER)
		icon_state = "auth_off"

/obj/machinery/keycard_auth/attack_hand(mob/user)
	if(user.stat || stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(busy)
		to_chat(user, "This device is busy.")
		return

	user.set_machine(src)

	var/dat = "<h1>Keycard Authentication Device</h1>"

	dat += "This device is used to trigger some high security events. It requires the simultaneous swipe of two high-level ID cards."
	dat += "<br><hr><br>"

	if(screen == 1)
		dat += "Select an event to trigger:<ul>"
		dat += "<li><A href='byond://?src=[REF(src)];triggerevent=Red alert'>Red alert</A></li>"
		if(!GLOB.config.ert_admin_call_only)
			dat += "<li><A href='byond://?src=[REF(src)];triggerevent=Distress Beacon'>Broadcast Distress Beacon</A></li>"
		dat += "<li><A href='byond://?src=[REF(src)];triggerevent=Emergency Evacuation'>Emergency Evacuation</A></li>"

		dat += "</ul>"
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='byond://?src=[REF(src)];reset=1'>Back</A>"


	user << browse(dat, "window=keycard_auth;size=500x350")
	return


/obj/machinery/keycard_auth/Topic(href, href_list)
	..()
	if(busy)
		to_chat(usr, "This device is busy.")
		return
	if(usr.stat || stat & (BROKEN|NOPOWER))
		to_chat(usr, "This device is without power.")
		return
	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
	if(href_list["reset"])
		reset()

	updateUsrDialog()
	add_fingerprint(usr)
	return

/obj/machinery/keycard_auth/proc/reset()
	active = 0
	event = ""
	screen = 1
	confirmed = 0
	event_source = null
	icon_state = "auth_off"
	event_triggered_by = null
	event_confirmed_by = null
	recorded_message = ""

/obj/machinery/keycard_auth/hear_talk(mob/M, text, verb, datum/language/speaking)
	if(event == "Distress Beacon" && M == event_triggered_by)
		recorded_message = text

/obj/machinery/keycard_auth/proc/broadcast_request(var/mob/user)
	var/distress_message
	if(event == "Distress Beacon" && user)
		distress_message = tgui_input_text(user, "Enter a distress message that other vessels will receive.", "Distress Beacon", "", MAX_MESSAGE_LEN)
		if(distress_message)
			become_hearing_sensitive()
			user.say(distress_message)
			lose_hearing_sensitivity()
		else
			to_chat(user, SPAN_WARNING("The beacon refuses to launch without a message!"))
			reset()
			return
	icon_state = "auth_on"
	for(var/obj/machinery/keycard_auth/KA in SSmachinery.machinery)
		if(KA == src)
			continue
		KA.reset()
		spawn()
			KA.receive_request(src)

	sleep(confirm_delay)
	if(confirmed)
		confirmed = 0
		trigger_event(event, recorded_message, user)
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]")
		message_admins("[key_name_admin(event_triggered_by)] triggered and [key_name_admin(event_confirmed_by)] confirmed event [event]", 1)
	reset()

/obj/machinery/keycard_auth/proc/receive_request(var/obj/machinery/keycard_auth/source)
	if(stat & (BROKEN|NOPOWER))
		return
	event_source = source
	busy = 1
	active = 1
	icon_state = "auth_on"

	sleep(confirm_delay)

	event_source = null
	icon_state = "auth_off"
	active = 0
	busy = 0

/obj/machinery/keycard_auth/proc/trigger_event(var/event, var/distress_message, var/mob/user)
	switch(event)
		if("Red alert")
			set_security_level(SEC_LEVEL_RED)
			feedback_inc("alert_keycard_auth_red",1)
		if("Distress Beacon")
			if(is_ert_blocked())
				to_chat(usr, SPAN_WARNING("The distress beacon is disabled!"))
				return
			if(linked)
				if(linked.has_called_distress_beacon)
					to_chat(usr, SPAN_WARNING("The distress beacon has already been fired!"))
					return
				SSdistress.trigger_overmap_distress_beacon(linked, distress_message, user)
			else
				SSdistress.trigger_armed_response_team()
			feedback_inc("alert_keycard_auth_ert",1)
		if("Unlock Leviathan Safeties")
			if(linked && linked.levi_safeguard)
				if(!linked.levi_safeguard.opened)
					linked.levi_safeguard.open()
					command_announcement.Announce("Commencing connection of Leviathan warp field arrays. All personnel are reminded to seek out a fixed object they can \
													hold on to in preparation for the firing sequence.", "Leviathan Artillery Control", 'sound/effects/ship_weapons/leviathan_safetyoff.ogg')
		if("Emergency Evacuation")
			call_shuttle_proc(user, TRANSFER_EMERGENCY)

/obj/machinery/keycard_auth/proc/is_ert_blocked()
	if(GLOB.config.ert_admin_call_only)
		return 1
	if(SSticker.mode.ert_disabled)
		SSticker.mode.announce_ert_disabled()
		return 1
	else
		return 0

GLOBAL_VAR_INIT(maint_all_access, FALSE)

/proc/make_maint_all_access()
	GLOB.maint_all_access = TRUE
	security_announcement.Announce("The maintenance access requirement has been revoked on all airlocks.","Attention!")

/proc/revoke_maint_all_access()
	GLOB.maint_all_access = FALSE
	security_announcement.Announce("The maintenance access requirement has been readded on all maintenance airlocks.","Attention!")

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0

	var/obj/item/I = M.GetIdCard()
	if(!I)
		return ..(M)
	var/list/A = I.GetAccess()
	var/maint_sec_access = ((GLOB.security_level > SEC_LEVEL_GREEN) && has_access(ACCESS_SECURITY, accesses = A))
	var/exceptional_circumstances = GLOB.maint_all_access || maint_sec_access
	if(exceptional_circumstances && src.check_access_list(list(ACCESS_MAINT_TUNNELS)))
		return 1
	if(access_by_level || req_one_access_by_level)
		var/sec_level = get_security_level()
		if(sec_level in (req_one_access_by_level ? req_one_access_by_level : access_by_level))
			var/access_to_use = req_one_access_by_level ? req_one_access_by_level[sec_level] : access_by_level[sec_level]
			if(!access_to_use)
				return TRUE
			if(req_one_access_by_level)
				if(has_access(req_one_access = access_to_use, accesses = A))
					return TRUE
			else
				if(has_access(access_to_use, accesses = A))
					return TRUE
	return ..(M)
