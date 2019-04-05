/client/proc/disconnect_ntsl()
	set name = "NTSL Disconnect"
	set category = "Debug"
	if(!check_rights(R_DEBUG))	return

	if(ntsl2.connected)
		log_admin("[key_name(src)] disabled NTSL",admin_key=key_name(src))
		message_admins("[key_name_admin(src)] disabled NTSL", 1)

		ntsl2.disconnect()

		feedback_add_details("admin_verb","DNT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		to_chat(usr, "<span class='warning'>NTSL2+ Daemon is already disconnected.</span>")

/client/proc/connect_ntsl()
	set name = "NTSL Connect"
	set category = "Debug"
	if(!check_rights(R_DEBUG))	return

	if(!ntsl2.connected)
		log_admin("[key_name(src)] enabled NTSL",admin_key=key_name(src))
		message_admins("[key_name_admin(src)] enabled NTSL", 1)

		ntsl2.attempt_connect()

		feedback_add_details("admin_verb","CNT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		to_chat(usr, "<span class='warning'>NTSL2+ Daemon is already connected.</span>")