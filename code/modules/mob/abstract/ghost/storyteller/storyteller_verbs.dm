// Okay, these verbs are a lot of ugly copypaste. The issue is that we don't really have any other choice.
// The alternative (and the first thing I tried) was to make the Storyteller into basically admin perms, but that introduces way too many issues.

/mob/abstract/ghost/storyteller/verb/storyteller_panel()
	set name = "Storyteller Panel"
	set category = "Storyteller"

	open_storyteller_panel()

/mob/abstract/ghost/storyteller/proc/open_storyteller_panel()
	var/dat = {"
		<center><B>Storyteller Panel</B></center><hr>\n
		"}
	dat += {"
		<BR>
		<A href='byond://?src=[REF(src)];create_object=1'>Create Object</A><br>
		<A href='byond://?src=[REF(src)];create_turf=1'>Create Turf</A><br>
		<A href='byond://?src=[REF(src)]];create_mob=1'>Create Mob</A><br>
		"}

	usr << browse(HTML_SKELETON(dat), "window=storytellerpanel;size=210x280")

/mob/abstract/ghost/storyteller/Topic(href, href_list)
	. = ..()
	if(href_list["create_object"])
		if(usr != src)
			return
		return create_object(usr)

	else if(href_list["create_turf"])
		if(usr != src)
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(usr != src)
			return
		return create_mob(usr)

	else if(href_list["object_list"])
		if(!GLOB.config.allow_admin_spawning)
			to_chat(usr, "Spawning of items is not allowed.")
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()
		var/removed_paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				removed_paths += dirty_path
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				removed_paths += dirty_path
				continue
			else if(ispath(path, /obj/effect/bhole))
				if(!check_rights(R_FUN, 0))
					removed_paths += dirty_path
					continue
			paths += path

		if(!paths ||( length(paths) > 5))
			return

		var/atom/target
		var/list/offset = text2list(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])
		switch(href_list["offset_type"])
			if ("absolute")
				target = locate(0 + X, 0 + Y, 0 + Z)
			if ("relative")
				target = locate(loc.x + X, loc.y + Y, loc.z + Z)

		if(target)
			for (var/path in paths)
				for (var/_ in 1 to number)
					if(ispath(path, /turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N)
							if(obj_name)
								N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.set_dir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(ismob(O))
									var/mob/M = O
									M.set_name(obj_name)

		log_and_message_admins("created [number] [english_list(paths)]")

/mob/abstract/ghost/storyteller/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")

	user << browse(replacetext(create_object_html, "/* ref src */", "[REF(src)]"), "window=create_object;size=700x700")

/mob/abstract/ghost/storyteller/proc/create_turf(var/mob/user)
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")

	user << browse(replacetext(create_turf_html, "/* ref src */", "[REF(src)]"), "window=create_turf;size=700x700")

/mob/abstract/ghost/storyteller/proc/create_mob(var/mob/user)
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")

	user << browse(replacetext(create_mob_html, "/* ref src */", "[REF(src)]"), "window=create_mob;size=700x700")

/mob/abstract/ghost/storyteller/verb/open_narrate_panel()
	set name = "Narrate Panel"
	set category = "Storyteller"

	var/datum/tgui_module/narrate_panel/NP = new /datum/tgui_module/narrate_panel(usr)
	NP.ui_interact(usr)

/mob/abstract/ghost/storyteller/verb/local_screen_text()
	set name = "Local Screen Text"
	set category = "Storyteller"

	var/list/mob/message_mobs = list()
	var/choice = html_decode(sanitize(tgui_alert(src, "Local Screen Text will send a screen text message to mobs. Do you want the mobs messaged to be only ones that you can see, or ignore blocked vision and message everyone within seven tiles of you?", "Narrate Selection", list("View", "Range", "Cancel"))))
	if(choice != "Cancel")
		if(choice == "View")
			message_mobs = mobs_in_view(world.view, src)
		else
			for(var/mob/M in range(world.view, src))
				message_mobs += M
	else
		return

	var/msg = tgui_input_text(src, "Insert the screen message you want to send.", "Local Screen Text")
	if(!msg)
		return

	var/big_text = tgui_alert(src, "Do you want big or normal text?", "Local Screen Text", list("Big", "Normal"))
	var/text_type = /atom/movable/screen/text/screen_text
	if(big_text == "Big")
		text_type = /atom/movable/screen/text/screen_text/command_order

	for(var/mob/M in message_mobs)
		if(M.client)
			M.play_screen_text(msg, text_type, COLOR_PURPLE)
	log_admin("LocalScreenText: [key_name(usr)] : [msg]")
	message_admins(SPAN_NOTICE("Local Screen Text: [key_name_admin(usr)] : [msg]"), 1)

/mob/abstract/ghost/storyteller/verb/global_screen_text()
	set name = "Global Screen Text"
	set category = "Storyteller"

	var/msg = html_decode(sanitize(tgui_input_text(src, "Insert the screen message you want to send.", "Global Screen Text")))
	if(!msg)
		return

	var/big_text = tgui_alert(src, "Do you want big or normal text?", "Global Screen Text", list("Big", "Normal"))
	var/text_type = /atom/movable/screen/text/screen_text
	if(big_text == "Big")
		text_type = /atom/movable/screen/text/screen_text/command_order

	for(var/mob/M in GLOB.mob_list)
		if(M.client)
			M.play_screen_text(msg, text_type, COLOR_PURPLE)

	log_admin("GlobalScreenText: [key_name(usr)] : [msg]")
	message_admins(SPAN_NOTICE("Global Screen Text: [key_name_admin(usr)] : [msg]"), 1)

/mob/abstract/ghost/storyteller/verb/storyteller_direct_narrate(var/mob/M)
	set name = "Direct Narrate"
	set category = "Storyteller"

	if(!M)
		var/list/client_mobs = list()
		for(var/mob/client_mob in get_mob_with_client_list())
			client_mobs[client_mob.name] = client_mob
		var/mob_name = tgui_input_list(src, "Who are you narrating to?", "Direct Narrate", client_mobs)
		if(mob_name)
			M = client_mobs[mob_name]

	if(!M)
		return

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Direct Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))

	if(!msg)
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	message_admins(SPAN_NOTICE(SPAN_BOLD("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")), 1)

/mob/abstract/ghost/storyteller/verb/toggle_build_mode()
	set name = "Toggle Build Mode"
	set category = "Storyteller"

	if(usr != src)
		return

	var/datum/click_handler/handler = GetClickHandler()
	if(handler.type == /datum/click_handler/build_mode)
		usr.RemoveClickHandler(/datum/click_handler/build_mode)
	else
		usr.PushClickHandler(/datum/click_handler/build_mode)

/mob/abstract/ghost/storyteller/verb/command_report()
	set name = "Create Command Report"
	set category = "Storyteller"

	var/reporttitle = sanitizeSafe(tgui_input_text(usr, "Pick a title for the report.", "Title"))
	if(!reporttitle)
		reporttitle = "NanoTrasen Update"
	var/reportbody = sanitize(tgui_input_text(usr, "Please enter anything you want. Anything. Serious.", "Body", multiline = TRUE), extra = FALSE)
	if(!reportbody)
		return

	var/announce = tgui_alert(usr, "Should this be announced to the general population?", "Announcement", list("Yes","No"))
	switch(announce)
		if("Yes")
			command_announcement.Announce("[reportbody]", reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
		if("No")
			to_world(SPAN_WARNING("New [SSatlas.current_map.company_name] Update available at all communication consoles."))
			sound_to_playing_players('sound/AI/commandreport.ogg')

	log_admin("Storyteller [key_name(src)] has created a command report: [reportbody]")
	message_admins("Storyteller [key_name_admin(src)] has created a command report", 1)

	//New message handling
	post_comm_message(reporttitle, reportbody)

/mob/abstract/ghost/storyteller/verb/send_odyssey_message()
	set name = "Unrestrict Away Site Landing"
	set category = "Storyteller"

	if(!SSodyssey.site_landing_restricted)
		to_chat(src, SPAN_WARNING("Site landing is already unrestricted!"))
		return

	var/reporttitle = sanitizeSafe(tgui_input_text(usr, "Pick a title for the message the Horizon will get.", "Title"))
	if(!reporttitle)
		reporttitle = "SCC Sensors Report"
	var/reportbody = sanitize(tgui_input_text(usr, "Enter the message the Horizon will get. It should at least describe what they're doing here in a general sense, along with the reason why they can land now.", "Body", multiline = TRUE), extra = FALSE)
	if(!reportbody)
		return

	var/announce = tgui_alert(usr, "Should this be announced to the general population?", "Announcement", list("Yes","No"))
	switch(announce)
		if("Yes")
			command_announcement.Announce("[reportbody]", reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1)
		if("No")
			command_announcement.Announce("New [SSatlas.current_map.company_name] update available at all communication consoles.", "[SSatlas.current_map.company_name] Report", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1)

	SSodyssey.scenario.unrestrict_away_site_landing()
	log_admin("Storyteller [key_name(src)] has lifted the away site landing restrictions: [reportbody]")

	//New message handling
	post_comm_message(reporttitle, reportbody)

/mob/abstract/ghost/storyteller/verb/change_mob_name(var/mob/victim)
	set name = "Change Mob Name"

	var/new_name = tgui_input_text(src, "Enter a new name.", "Change Mob Name", max_length = MAX_NAME_LEN)
	if(!new_name)
		return

	log_admin("[key_name(src)] has renamed [victim] to [new_name].")
	victim.set_name(new_name)

/mob/abstract/ghost/storyteller/verb/change_obj_name(var/obj/thing)
	set name = "Change Object Name"

	var/new_name = tgui_input_text(src, "Enter a new name.", "Change Object Name", max_length = MAX_NAME_LEN)
	if(!new_name)
		return

	log_admin("[key_name(src)] has renamed [thing] to [new_name].")
	thing.name = new_name

/mob/abstract/ghost/storyteller/verb/change_obj_desc(var/obj/thing)
	set name = "Change Object Description"

	var/new_desc = tgui_input_text(src, "Enter a new description.", "Change Object Description", max_length = MAX_MESSAGE_LEN)
	if(!new_desc)
		return

	log_admin("[key_name(src)] has changed [thing]'s description to [new_desc].")
	thing.desc = new_desc

/mob/abstract/ghost/storyteller/verb/set_outfit(var/mob/living/carbon/human/H)
	set name = "Set Outfit"
	set category = "Storyteller"

	do_dressing(H)

/mob/abstract/ghost/storyteller/proc/show_traitor_panel(var/mob/M)
	set name = "Edit Antagonist"
	set category = "Storyteller"

	if(!istype(M))
		to_chat(usr, SPAN_WARNING("This can only be used on mobs!"))
		return

	if(!M.mind)
		to_chat(usr, SPAN_WARNING("This mob has no mind!"))
		return

	M.mind.edit_memory()

/mob/abstract/ghost/storyteller/verb/create_explosion()
	set name = "Create Explosion"
	set category = "Storyteller"

	var/turf/epicenter = get_turf(src)
	var/choice = tgui_input_list(usr, "What size explosion would you like to produce?", "Drop Bomb", list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb"))
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = tgui_input_number(usr, "Set the devastation range (in tiles).", "Devastation")
			var/heavy_impact_range = tgui_input_number(usr, "Set the heavy impact range (in tiles).", "Heavy")
			var/light_impact_range = tgui_input_number(usr, "Set the light impact range (in tiles).", "Light")
			var/flash_range = tgui_input_number(usr, "Set the flash range (in tiles).", "Flash")
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins(SPAN_NOTICE("[ckey] creating an explosion at [epicenter.loc]."))

/mob/abstract/ghost/storyteller/verb/delete_atom(atom/O as obj|mob|turf in range(world.view))
	set name = "Delete"
	set category = "Storyteller"

	var/action = alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No", "Hard Delete")

	if (action == "No" || !action)
		return

	if (istype(O, /mob/abstract/ghost/observer))
		return

	log_admin("[key_name(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
	message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])", 1)

	if (isturf(O))	// Can't qdel a turf.
		var/turf/T = O
		T.ChangeTurf(/turf/space)
		return

	if (action == "Yes")
		qdel(O, TRUE)
	else
		// This is naughty, but sometimes necessary.
		O.Destroy(TRUE)	// Because direct del without this breaks things.
		del(O)

/mob/abstract/ghost/storyteller/verb/rejuvenate(mob/living/M as mob in range(world.view))
	set name = "Rejuvenate"
	set category = "Storyteller"

	if(!istype(M))
		return

	M.revive()
	message_admins(SPAN_DANGER("Storyteller [key_name_admin(usr)] healed / revived [key_name_admin(M)]!"), 1)
