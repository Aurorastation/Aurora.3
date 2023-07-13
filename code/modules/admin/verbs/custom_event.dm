// verb for admins to set custom event
/client/proc/cmd_admin_change_custom_event()
	set category = "Fun"
	set name = "Change Custom Event"

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/canon_death = alert("Should deaths be canon?", "Canon Deaths", "No", "Yes")
	if(canon_death=="Yes")
		config.canon_death = TRUE
		log_admin("[usr.key] has enabled canon deaths.",admin_key=key_name(usr))
		message_admins("[key_name_admin(usr)] has enabled canon deaths.")

	var/input = sanitize(input(usr, "Enter the description of the custom event. Be descriptive. To cancel the event, make this blank or hit cancel.", "Custom Event", custom_event_msg) as message|null, MAX_BOOK_MESSAGE_LEN, extra = 0)
	if(!input || input == "")
		custom_event_msg = null
		log_admin("[usr.key] has cleared the custom event text.",admin_key=key_name(usr))
		message_admins("[key_name_admin(usr)] has cleared the custom event text.")
		return

	log_admin("[usr.key] has changed the custom event text.",admin_key=key_name(usr))
	message_admins("[key_name_admin(usr)] has changed the custom event text.")

	custom_event_msg = input

	to_world("<h1 class='alert'>Custom Event</h1>")
	to_world("<h2 class='alert'>A custom event is starting. OOC Info:</h2>")
	to_world("<span class='alert'>[custom_event_msg]</span>")
	if(config.canon_death)
		to_world("<span class='alert'>Deaths during this event are canon and permanent.</span>")
	to_world("<br>")

// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"

	if(!custom_event_msg || custom_event_msg == "")
		to_chat(src, "There currently is no known custom event taking place.")
		to_chat(src, "Keep in mind: it is possible that an admin has not properly set this.")
		return

	to_chat(src, "<h1 class='alert'>Custom Event</h1>")
	to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
	to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
	if(config.canon_death)
		to_world("<span class='alert'>Deaths during this event are canon and permanent.</span>")
	to_chat(src, "<br>")

/hook/death/proc/canonize_death(mob/living/carbon/human/H, gibbed)
	if(config.canon_death && config.sql_enabled && config.sql_saves)
		if(H.character_id)
			var/DBQuery/commit_death = dbcon.NewQuery("UPDATE ss13_characters SET deleted_by = 'server', deleted_reason = 'Canon Event Death in [sanitizeSQL(game_id)]', deleted_at = NOW() WHERE id = :char_id:")
			commit_death.Execute(list("char_id" = H.character_id))
