/mob/abstract/storyteller/verb/storyteller_panel()
	set name = "Storyteller Panel"
	set category = "Storyteller"

	open_storyteller_panel()

/mob/abstract/storyteller/proc/open_storyteller_panel()
	var/dat = {"
		<center><B>Storyteller Panel</B></center><hr>\n
		"}
	dat += {"
		<BR>
		<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
		"}

	usr << browse(dat, "window=storytellerpanel;size=210x280")

/mob/abstract/storyteller/verb/storyteller_local_narrate()
	set name = "Eye Narrate"
	set category = "Storyteller"

	var/list/mob/message_mobs = list()
	var/choice = tgui_alert(usr, "Narrate to mobs in view, or in range?", "Narrate Selection", list("In view", "In range", "Cancel"))
	if(choice != "Cancel")
		if(choice == "In view")
			message_mobs = mobs_in_view(world.view, eyeobj)
		else
			for(var/mob/M in range(world.view, eyeobj))
				message_mobs += M
	else
		return

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Local Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))
	if(!msg)
		return

	for(var/M in message_mobs)
		to_chat(M, msg)

	log_admin("LocalNarrate: [key_name(usr)] : [msg]", admin_key = key_name(usr))
	message_admins("<span class='notice'>\bold LocalNarrate: [key_name_admin(usr)] : [msg]<BR></span>", 1)

/mob/abstract/storyteller/verb/storyteller_global_narrate()
	set name = "Global Narrate"
	set category = "Storyteller"

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Global Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))

	if (!msg)
		return
	to_world("[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]",admin_key=key_name(usr))
	message_admins("<span class='notice'>\bold GlobalNarrate: [key_name_admin(usr)] : [msg]<BR></span>", 1)

/mob/abstract/storyteller/verb/storyteller_direct_narrate(var/mob/M)
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
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]",admin_key=key_name(usr),ckey=key_name(M))
	message_admins("<span class='notice'>\bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]<BR></span>", 1)
	feedback_add_details("admin_verb","DIRN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/mob/abstract/storyteller/verb/spawn_atom(var/object as text)
	set name = "Spawn"
	set category = "Storyteller"

	/// a little bit of extra sanitization never hurts
	if(usr != src)
		return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")

/mob/abstract/storyteller/verb/toggle_build_mode()
	set name = "Toggle Build Mode"
	set category = "Storyteller"

	if(usr != src)
		return

	var/datum/click_handler/handler = GetClickHandler()
	if(handler.type == /datum/click_handler/build_mode)
		usr.PopClickHandler()
	else
		usr.PushClickHandler(/datum/click_handler/build_mode)

/mob/abstract/storyteller/proc/cmd_admin_create_centcom_report()
	set name = "Create Command Report"
	set category = "Storyteller"

	if(usr != src)
		return

	var/reporttitle
	var/reportbody
	var/reporter = null
	var/reporttype = tgui_alert(usr, "Choose whether to use a template or custom report.", "Create Command Report", list("Custom", "Template"))
	if(!reporttype)
		return
	switch(reporttype)
		if("Template")
			if (!establish_db_connection(GLOB.dbcon))
				to_chat(src, SPAN_NOTICE("Unable to connect to the database."))
				return
			var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT title, message FROM ss13_ccia_general_notice_list WHERE deleted_at IS NULL")
			query.Execute()

			var/list/template_names = list()
			var/list/templates = list()

			while (query.NextRow())
				template_names += query.item[1]
				templates[query.item[1]] = query.item[2]

			// Catch empty list
			if (!templates.len)
				to_chat(src, SPAN_NOTICE("There are no templates in the database."))
				return

			reporttitle = tgui_input_list(usr, "Please select a command report template.", "Create Command Report", template_names)
			if(!reporttitle)
				return
			reportbody = templates[reporttitle]

		if("Custom")
			reporttitle = sanitizeSafe(tgui_input_text(usr, "Pick a title for the report.", "Title"))
			if(!reporttitle)
				reporttitle = "NanoTrasen Update"
			reportbody = sanitize(tgui_input_text(usr, "Please enter anything you want. Anything. Serious.", "Body", multiline = TRUE), extra = FALSE)
			if(!reportbody)
				return

	if (reporttype == "Template")
		reporter = sanitizeSafe(tgui_input_text(usr, "Please enter your CCIA name. (blank for CCIAAMS)", "Name"))
		if (reporter)
			reportbody += "\n\n- [reporter], Central Command Internal Affairs Agent, [commstation_name()]"
		else
			reportbody += "\n\n- CCIAAMS, [commstation_name()]"

	var/announce = tgui_alert(usr, "Should this be announced to the general population?", "Announcement", list("Yes","No"))
	switch(announce)
		if("Yes")
			command_announcement.Announce("[reportbody]", reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
		if("No")
			to_world(SPAN_WARNING("New [SSatlas.current_map.company_name] Update available at all communication consoles."))
			sound_to(world, ('sound/AI/commandreport.ogg'))

	log_admin("[key_name(src)] has created a command report: [reportbody]",admin_key=key_name(usr))
	message_admins("[key_name_admin(src)] has created a command report", 1)
	//New message handling
	post_comm_message(reporttitle, reportbody)
