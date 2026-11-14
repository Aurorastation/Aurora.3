/**
 * Prompts for a 24-hour time in HH:MM format. Returns the time or null if cancelled.
 */
/proc/tgui_input_time(mob/user, message = "Enter a time.", title = "Time Input", default, timeout = 0, ui_state = GLOB.always_state)
	if(!user)
		user = usr
	if(!istype(user))
		if(istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	if(!user.client)
		return

	var/static/regex/time_format = regex(@"^([01][0-9]|2[0-3]):[0-5][0-9]$")
	if(!istext(default) || !time_format.Find(default))
		default = time2text(world.timeofday, "hh:mm")
	if(!user.client.prefs.tgui_inputs)
		while(TRUE)
			var/entry = tgui_input_text(user, message, title, default, max_length = 5, encode = FALSE)
			if(isnull(entry))
				return
			if(time_format.Find(entry))
				return entry
			to_chat(user, SPAN_WARNING("Enter a time in HH:MM (24-hour) format."))

	var/datum/tgui_input_time/time_input = new(user, message, title, default, timeout, ui_state)
	time_input.ui_interact(user)
	time_input.wait()
	if(time_input)
		. = time_input.entry
		qdel(time_input)

/datum/tgui_input_time
	var/closed = FALSE
	var/default
	var/entry
	var/message
	var/start_time
	var/timeout
	var/title
	var/datum/ui_state/state

/datum/tgui_input_time/New(mob/user, message, title, default, timeout, ui_state)
	src.default = default
	src.message = message
	src.title = title
	src.state = ui_state
	if(timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_input_time/Destroy(force)
	SStgui.close_uis(src)
	state = null
	return ..()

/datum/tgui_input_time/proc/wait()
	while(!entry && !closed && !QDELETED(src))
		stoplag(1)

/datum/tgui_input_time/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TimeInputModal")
		ui.open()

/datum/tgui_input_time/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_input_time/ui_state(mob/user)
	return state

/datum/tgui_input_time/ui_static_data(mob/user)
	if(!user.client)
		return list()
	return list(
		"default_time" = default,
		"large_buttons" = user.client.prefs.tgui_buttons_large,
		"swapped_buttons" = user.client.prefs.tgui_inputs_swapped,
		"message" = message,
		"title" = title
	)

/datum/tgui_input_time/ui_data(mob/user)
	var/list/data = list()
	if(timeout)
		data["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))
	return data

/datum/tgui_input_time/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("submit")
			var/static/regex/time_format = regex(@"^([01][0-9]|2[0-3]):[0-5][0-9]$")
			if(!istext(params["entry"]) || !time_format.Find(params["entry"]))
				to_chat(ui.user, SPAN_WARNING("Enter a time in HH:MM (24-hour) format."))
				return TRUE
			entry = params["entry"]
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
