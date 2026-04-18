/client/verb/ooc_verb()
	set name = ".OOC"
	set hidden = TRUE
	winset(src, null, "command=[src.tgui_say_create_open_command(OOC_CHANNEL)]")

/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC.Chat"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	if(!(prefs.toggles & CHAT_OOC))
		to_chat(src, SPAN_WARNING("You have OOC muted."))
		return

	msg = sanitize(msg)

	if(!msg)
		return

	if(!holder)
		if(!GLOB.config.ooc_allowed)
			to_chat(src, SPAN_DANGER("OOC is globally muted."))
			return
		if(!GLOB.config.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, SPAN_DANGER("OOC for dead mobs has been turned off."))
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/ooc_style = "everyone"
	if(holder && !holder.fakekey)
		ooc_style = "elevated"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & (R_DEBUG|R_DEV))
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	msg = process_chat_markup(msg, list("*"))

	for(var/client/target in GLOB.clients)
		if(target.prefs?.toggles & CHAT_OOC)
			var/display_name = src.key
			if(holder)
				if(holder.fakekey)
					if(target.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			if(holder && !holder.fakekey && (holder.rights & R_ADMIN) && GLOB.config.allow_admin_ooccolor && (src.prefs.ooccolor != initial(src.prefs.ooccolor))) // keeping this for the badmins
				to_chat(target, "<font color='[src.prefs.ooccolor]'><span class='ooc'>" + create_text_tag("OOC", target) + " <EM>[display_name]:</EM> <span class='message linkify'>[msg]</span></span></font>")
			else
				to_chat(target, "<span class='ooc'><span class='[ooc_style]'>" + create_text_tag("OOC", target) + " <EM>[display_name]:</EM> <span class='message linkify'>[msg]</span></span></span>")

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC.Chat"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_DANGER("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = sanitize(msg)
	msg = process_chat_markup(msg, list("*"))
	if(!msg)
		return

	if(!(prefs.toggles & CHAT_LOOC))
		to_chat(src, SPAN_DANGER("You have LOOC muted."))
		return
	if(mob.stat == DEAD && !(prefs.toggles & CHAT_GHOSTLOOC))
		to_chat(src, SPAN_DANGER("You have observer LOOC muted."))
		return

	if(!holder)
		if(!GLOB.config.looc_allowed)
			to_chat(src, SPAN_DANGER("LOOC is globally muted."))
			return
		if(!GLOB.config.dead_looc_allowed && (mob.stat == DEAD))
			to_chat(usr, SPAN_DANGER("LOOC for dead mobs has been turned off."))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/mob/source = src.mob
	var/list/messageturfs = list() //List of turfs we broadcast to.
	var/list/messagemobs = list() //List of living mobs nearby who can hear it

	for(var/turf in range(world.view, get_turf(source)))
		messageturfs += turf
	if(isAI(source))
		var/mob/living/silicon/ai/AI = source
		for(var/turf in range(world.view, get_turf(AI.eyeobj)))
			messageturfs += turf

	for(var/mob/M in GLOB.player_list)
		if(!M.client || istype(M, /mob/abstract/new_player))
			continue
		if(isAI(M))
			var/mob/living/silicon/ai/AI = M
			if(get_turf(AI.eyeobj) in messageturfs)
				messagemobs += M
				continue
		if(get_turf(M) in messageturfs)
			messagemobs += M

	var/display_name = source.key
	if(holder && holder.fakekey)
		display_name = holder.fakekey
	if(source.stat != DEAD)
		display_name = source.name

	msg = process_chat_markup(msg, list("*"))

	var/prefix
	var/admin_stuff
	for(var/client/target in GLOB.clients)
		if(target.prefs.toggles & CHAT_LOOC)
			if(mob.stat == DEAD && !(target.prefs.toggles & CHAT_GHOSTLOOC))
				continue
			admin_stuff = ""
			var/display_remote = 0
			if (target.holder && ((R_MOD|R_ADMIN) & target.holder.rights))
				display_remote = 1
			if(display_remote)
				prefix = "(R)"
				admin_stuff += "/([source.key])"
				if(target != source.client)
					admin_stuff += "(<A href='byond://?src=[REF(target.holder)];adminplayerobservejump=[REF(mob)]'>JMP</A>)"
			if(target.mob in messagemobs)
				prefix = ""
			if((target.mob in messagemobs) || display_remote)
				to_chat(target, "<span class='ooc'><span class='looc'>" + create_text_tag("LOOC", target) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message linkify'>[msg]</span></span></span>")

/client/verb/stop_all_sounds()
	set name = "Stop all sounds"
	set desc = "Stop all sounds that are currently playing."
	set category = "OOC"

	if(!mob)
		return

	mob << sound(null)

/client/verb/rolldice()
	set name = "Roll the Dice!"
	set desc = "Rolls the Dice of your choice!"
	set category = "OOC"

	var/list/choice = list(2, 4, 6, 8, 10, 12, 20, 50, 100)
	var/input = input("Select the Dice you want!", "Dice", null, null) in choice

	to_chat(usr, SPAN_NOTICE("You roll [rand(1,input)] out of [input]!"))

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC.Debug"
	set desc = "Fit the width of the map window to match the viewport"

	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/list/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))

	// Client closed the window? Some other error? This is unexpected behaviour, let's
	// CRASH with some info.
	if(!sizes["mapwindow.size"])
		CRASH("sizes does not contain mapwindow.size key. This means a winget failed to return what we wanted. --- sizes var: [sizes] --- sizes length: [length(sizes)]")

	var/list/map_size = splittext(sizes["mapwindow.size"], "x")

	// Gets the type of zoom we're currently using from our view datum
	// If it's 0 we do our pixel calculations based off the size of the mapwindow
	// If it's not, we already know how big we want our window to be, since zoom is the exact pixel ratio of the map
	var/zoom_value = /*src.view_size?.zoom ||*/ 0

	var/desired_width = 0
	if(zoom_value)
		desired_width = round(view_size[1] * zoom_value * ICON_SIZE_X)
	else

		// Looks like we expect mapwindow.size to be "ixj" where i and j are numbers.
		// If we don't get our expected 2 outputs, let's give some useful error info.
		if(length(map_size) != 2)
			CRASH("map_size of incorrect length --- map_size var: [map_size] --- map_size length: [length(map_size)]")
		var/height = text2num(map_size[2])
		desired_width = round(height * aspect_ratio)

	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Avoid auto-resizing the statpanel and chat into nothing.
	desired_width = min(desired_width, split_width - 300)

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")

/// Attempt to automatically fit the viewport, assuming the user wants it
/client/proc/attempt_auto_fit_viewport()
	/*if (!prefs.read_preference(/datum/preference/toggle/auto_fit_viewport))
		return*/ //We do not have this in aurora yet
	if(fully_created)
		INVOKE_ASYNC(src, VERB_REF(fit_viewport))
	else //Delayed to avoid wingets from Login calls.
		addtimer(CALLBACK(src, VERB_REF(fit_viewport), 1 SECONDS))

/client/verb/refresh_tgui()
	set name = "Refresh TGUI"
	set category = "OOC.Debug"

	for(var/window_id in tgui_windows)
		var/datum/tgui_window/window = tgui_windows[window_id]
		window.reinitialize()

/client/verb/fix_stat_panel()
	set name = "Fix-Stat-Panel"
	set hidden = TRUE

	init_verbs()
