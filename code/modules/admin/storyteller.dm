GLOBAL_LIST_INIT(storyteller_verbs, list(
	/datum/admins/proc/storyteller_panel
	))

/mob/living/storyteller/proc/storyteller_panel()
	set name = "Storyteller Panel"
	set category = "Storyteller"

	if(client?.holder)
		client.holder.storyteller_panel()
		feedback_add_details("admin_verb","STP")

/datum/admins/proc/storyteller_panel()
	if(!check_rights(R_STORYTELLER))
		return

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

/mob/living/storyteller/proc/storyteller_local_narrate()
	set name = "Eye Narrate"
	set category = "Storyteller"

	if(!check_rights(R_STORYTELLER))
		return

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
	feedback_add_details("admin_verb", "STLN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/mob/living/storyteller/proc/storyteller_global_narrate()
	set name = "Global Narrate"
	set category = "Storyteller"

	if(!check_rights(R_STORYTELLER))
		return

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Global Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))

	if (!msg)
		return
	to_world("[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]",admin_key=key_name(usr))
	message_admins("<span class='notice'>\bold GlobalNarrate: [key_name_admin(usr)] : [msg]<BR></span>", 1)
	feedback_add_details("admin_verb","STGN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/mob/living/storyteller/proc/storyteller_direct_narrate(var/mob/M)
	set name = "Direct Narrate"
	set category = "Storyteller"

	if(!check_rights(R_STORYTELLER))
		return

	if(!M)
		var/list/client_mobs = list()
		for(var/mob/M in get_mob_with_client_list())
			client_mobs[M.name] = M
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
