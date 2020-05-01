/datum/nano_module/exosuit_control
	name = "Exosuit Monitoring and Control"
	var/stored_data
	var/screen = 0

// If PC is not null header template is loaded. Use PC.get_header_data() to get relevant nanoui data from it. All data entries begin with "PC_...."
// In future it may be expanded to other modular computer devices.
/datum/nano_module/exosuit_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	data["screen"] = screen
	switch (screen)
		if (0)
			var/list/beacons = list()
			for(var/obj/item/mecha_parts/mecha_tracking/TR in exo_beacons)
				beacons.len++
				beacons[beacons.len] = TR.get_mecha_info_nano()

			data["beacons"] = beacons
		if (1)
			data["log"] = stored_data

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "exosuit_control.tmpl", "Exosuit Control and Monitoring", 800, 500, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/exosuit_control/Topic(href, href_list)
	if(..())
		return
	var/datum/topic_input/old_filter = new /datum/topic_input(href,href_list)
	if(href_list["send_message"])
		var/obj/item/mecha_parts/mecha_tracking/MT = old_filter.getObj("send_message")
		var/message = sanitize(input(usr,"Input message","Transmit message") as text)
		var/obj/mecha/M = MT.in_mecha()
		if(message && M)
			M.occupant_message(message)
		return
	if(href_list["shock"])
		var/obj/item/mecha_parts/mecha_tracking/MT = old_filter.getObj("shock")

		var/response = alert(usr,"Are you certain you wish to terminate this exosuit? Executing this procedure will render it inoperable, and should only be used in extreme circumstances. Improper use will result in your being held liable for damage to Nanotrasen property","Confirm shutdown","Destroy","Cancel")
		if (response == "Destroy")
			MT.shock(usr)
	if(href_list["get_log"])
		var/obj/item/mecha_parts/mecha_tracking/MT = old_filter.getObj("get_log")
		stored_data = MT.get_mecha_log()
		screen = 1
	if(href_list["return"])
		screen = 0
	return
