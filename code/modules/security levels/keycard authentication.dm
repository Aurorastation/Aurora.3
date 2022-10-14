/obj/machinery/keycard_auth
	name = "keycard authentication device"
	desc = "This device is used to trigger station functions, which require more than one ID card to authenticate."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/active = 0 //This gets set to 1 on all devices except the one where the initial request was made.
	var/event = ""
	var/screen = 1
	var/confirmed = 0 //This variable is set by the device that confirms the request.
	var/confirm_delay = 20 //(2 seconds)
	var/busy = 0 //Busy when waiting for authentication or an event request has been sent from this device.
	var/obj/machinery/keycard_auth/event_source
	var/mob/event_triggered_by
	var/mob/event_confirmed_by
	var/listening = FALSE
	var/recorded_message = ""
	//1 = select event
	//2 = authenticate
	anchored = 1.0
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/keycard_auth/Initialize(mapload, d, populate_components, is_internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/keycard_auth/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/keycard_auth/attack_ai(mob/user)
	to_chat(user, SPAN_NOTICE("The station AI is not to interact with these devices."))
	return

/obj/machinery/keycard_auth/attackby(obj/item/W, mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	if(istype(W,/obj/item/card/id))
		var/obj/item/card/id/ID = W
		if(access_keycard_auth in ID.access)
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
		dat += "<li><A href='?src=\ref[src];triggerevent=Red alert'>Red alert</A></li>"
		if(!config.ert_admin_call_only)
			dat += "<li><A href='?src=\ref[src];triggerevent=Distress Beacon'>Broadcast Distress Beacon</A></li>"
		dat += "<li><A href='?src=\ref[src];triggerevent=Leviathan'><font color='red'>Unlock Leviathan Safeties</font></A></li>"

		dat += "</ul>"
	if(screen == 2)
		dat += "Please swipe your card to authorize the following event: <b>[event]</b>"
		dat += "<p><A href='?src=\ref[src];reset=1'>Back</A>"

	send_theme_resources(user)
	user << browse(enable_ui_theme(user, dat), "window=keycard_auth;size=500x350")
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
	if(event == "Distress Beacon" && listening && M == event_triggered_by)
		recorded_message = text

/obj/machinery/keycard_auth/proc/broadcast_request(var/mob/user)
	var/distress_message
	if(event == "Distress Beacon" && user)
		distress_message = input(user, "Enter a distress message that other vessels will receive.", "Distress Beacon")
		if(distress_message)
			listening = TRUE
			user.say(distress_message)
			listening = FALSE
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
		log_game("[key_name(event_triggered_by)] triggered and [key_name(event_confirmed_by)] confirmed event [event]",ckey=key_name(event_triggered_by),ckey_target=key_name(event_confirmed_by))
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
				to_chat(usr, "<span class='warning'>The distress beacon is disabled!</span>")
				return
			if(linked)
				if(linked.has_called_distress_beacon)
					to_chat(usr, SPAN_WARNING("The distress beacon has already been fired!"))
					return
				SSdistress.trigger_overmap_distress_beacon(linked, distress_message, user)
			else
				SSdistress.trigger_armed_response_team()
			feedback_inc("alert_keycard_auth_ert",1)
		if("Leviathan")
			if(linked && linked.levi_safeguard)
				if(!linked.levi_safeguard.opened)
					linked.levi_safeguard.open()
					command_announcement.Announce("Commencing connection of Leviathan warp field arrays. All personnel are reminded to seek out a fixed object they can \
												   hold on to in preparation for the firing sequence.", "Leviathan Artillery Control", 'sound/effects/ship_weapons/leviathan_safetyoff.ogg')

/obj/machinery/keycard_auth/proc/is_ert_blocked()
	if(config.ert_admin_call_only)
		return 1
	if(SSticker.mode.ert_disabled)
		SSticker.mode.announce_ert_disabled()
		return 1
	else
		return 0

var/global/maint_all_access = 0

/proc/make_maint_all_access()
	maint_all_access = 1
	security_announcement.Announce("The maintenance access requirement has been revoked on all airlocks.","Attention!")

/proc/revoke_maint_all_access()
	maint_all_access = 0
	security_announcement.Announce("The maintenance access requirement has been readded on all maintenance airlocks.","Attention!")

/obj/machinery/door/airlock/allowed(mob/M)
	var/obj/item/I = M.GetIdCard()
	if(!I)
		return ..(M)
	var/list/A = I.GetAccess()
	var/maint_sec_access = ((security_level > SEC_LEVEL_GREEN) && has_access(access_security, accesses = A))
	var/exceptional_circumstances = maint_all_access || maint_sec_access
	if(exceptional_circumstances && src.check_access_list(list(access_maint_tunnels)))
		return 1
	return ..(M)
