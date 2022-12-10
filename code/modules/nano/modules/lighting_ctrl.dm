/datum/nano_module/lighting_ctrl
	name = "Lighting Control"
	var/context = "pub"
	var/lstate = "full"
	var/lusr = null 	// for admin logs

/datum/nano_module/lighting_ctrl/New()
	..()
	lstate = SSnightlight.is_active() ? "dark" : "full"

/datum/nano_module/lighting_ctrl/proc/update_lighting()

	// whether to only select areas explicitly marked for nightlighting
	var/wl_only = context == "all" ? 0 : 1

	SSnightlight.suspend()

	if (lstate == "dark")
		log_and_message_admins("enabled night-mode [wl_only ? "in public areas" : "globally"].", lusr)
		SSnightlight.activate(wl_only)
	else if (lstate == "full")
		log_and_message_admins("disabled night-mode [wl_only ? "in public areas" : "globally"].", lusr)
		SSnightlight.deactivate(wl_only)

/datum/nano_module/lighting_ctrl/Topic(href, href_list)
	if(..())
		return 1
	if (href_list["context"])
		context = href_list["context"]
	if (href_list["mode"])
		lstate = href_list["mode"]
	if (href_list["set"])
		update_lighting()

/datum/nano_module/lighting_ctrl/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	lusr = WEAKREF(user)
	var/list/data = host.initial_data()

	data["context"] = context
	data["status"] = lstate

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "lighting_ctrl.tmpl", "Lighting Control", 800, 500, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
