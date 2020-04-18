/datum/component/multitool
	var/window_x = 370
	var/window_y = 470
	var/station_alert = FALSE

/datum/component/multitool/Initialize(var/alert_mode = FALSE)
	if(alert_mode)
		station_alert = TRUE

/datum/component/multitool/proc/interact(var/obj/item/device/multitool/M, var/mob/user)
	if(CanUseTopic(user) != STATUS_INTERACTIVE)
		return

	var/html = get_interact_window(M, user)
	if(html)
		var/datum/browser/popup = new(usr, "multitool", "Multitool Menu", window_x, window_y)
		popup.set_content(html)
		popup.set_title_image(user.browse_rsc_icon(M.icon, M.icon_state))
		popup.open()
	else
		close_window(usr)

/datum/component/multitool/proc/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	if(station_alert)
		var/obj/item/circuitboard/stationalert/SA = parent
		. += "<b>Alarm Sources</b><br>"
		. += "<table>"
		for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
			. += "<tr>"
			. += "<td>[AH.category]</td>"
			if(AH in SA.alarm_handlers)
				. += "<td><span class='good'>&#9724</span>Active</td><td><a href='?src=\ref[src];remove=\ref[AH]'>Inactivate</a></td>"
			else
				. += "<td><span class='bad'>&#9724</span>Inactive</td><td><a href='?src=\ref[src];add=\ref[AH]'>Activate</a></td>"
			. += "</tr>"
		. += "</table>"

/datum/component/multitool/proc/close_window(var/mob/user)
	user << browse(null, "window=multitool")

/datum/component/multitool/proc/buffer(var/obj/item/device/multitool/multitool)
	. += "<b>Buffer Memory:</b><br>"
	var/buffer_name = multitool.get_buffer_name()
	if(buffer_name)
		. += "[buffer_name] <a href='?src=\ref[src];send=\ref[multitool.buffer_object]'>Send</a> <a href='?src=\ref[src];purge=1'>Purge</a><br>"
	else
		. += "No connection stored in the buffer."

/datum/component/multitool/CanUseTopic(var/mob/user)
	. = ..()
	if(. == STATUS_CLOSE)
		return

	if(!user.get_multitool())
		return STATUS_CLOSE

	var/datum/host = parent.ui_host()
	return user.default_can_use_topic(host)

/datum/component/multitool/Topic(href, href_list)
	if(..())
		close_window(usr)
		return 1

	var/mob/user = usr
	var/obj/item/device/multitool/M = user.get_multitool()
	if(href_list["send"])
		var/atom/buffer = locate(href_list["send"])
		. = send_buffer(M, buffer, user)
	else if(href_list["purge"])
		M.set_buffer(null)
		. = MT_REFRESH
	else
		. = on_topic(href, href_list, user)

	switch(.)
		if(MT_REFRESH)
			interact(M, user)
		if(MT_CLOSE)
			close_window(user)
	return 1

/datum/component/multitool/proc/on_topic(href, href_list, user)
	if(station_alert)
		var/obj/item/circuitboard/stationalert/SA = parent
		if(href_list["add"])
			var/datum/alarm_handler/AH = locate(href_list["add"]) in SSalarm.all_handlers
			if(AH)
				SA.alarm_handlers |= AH
				return MT_REFRESH

		if(href_list["remove"])
			var/datum/alarm_handler/AH = locate(href_list["remove"]) in SSalarm.all_handlers
			if(AH)
				SA.alarm_handlers -= AH
				return MT_REFRESH

		return MT_NOACTION

/datum/component/multitool/proc/send_buffer(var/obj/item/device/multitool/M, var/atom/buffer, var/mob/user)
	if(M.get_buffer() == buffer && buffer)
		receive_buffer(M, buffer, user)
	else if(!buffer)
		to_chat(user, "<span class='warning'>Unable to acquire data from the buffered object. Purging from memory.</span>")
	return MT_REFRESH

/datum/component/multitool/proc/receive_buffer(var/obj/item/device/multitool/M, var/atom/buffer, var/mob/user)
	return
