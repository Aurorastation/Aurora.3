// Reloads the current cargo configuration
/datum/topic_command/cargo_reload
	name = "cargo_reload"
	description = "Reloads the current cargo configuration."
	params = list(
		"force" = list("name"="force","desc"="Force the reload even if orders have already been placed","type"="int","req"=0)
	)

/datum/topic_command/cargo_reload/run_command(queryparams)
	var/force = text2num(queryparams["force"])
	if(!SScargo.get_order_count())
		SScargo.load_from_sql()
		message_admins("Cargo has been reloaded via the API.")
		statuscode = 200
		response = "Cargo Reloaded from SQL."
	else
		if(force)
			SScargo.load_from_sql()
			message_admins("Cargo has been force-reloaded via the API. All current orders have been purged.")
			statuscode = 200
			response = "Cargo Force-Reloaded from SQL."
		else
			statuscode = 500
			response = "Orders have been placed. Use force parameter to overwrite."
	return TRUE

// Update discord_bot's channels.
/datum/topic_command/update_bot_channels
	name = "update_bot_channels"
	description = "Tells the ingame instance of the Discord bot to update its cached channels list."

/datum/topic_command/update_bot_channels/run_command()
	data = null

	if (!discord_bot)
		statuscode = 404
		response = "Ingame Discord bot not initialized."
		return 1

	switch (discord_bot.update_channels())
		if (1)
			statuscode = 404
			response = "Ingame Discord bot is not active."
		if (2)
			statuscode = 500
			response = "Ingame Discord bot encountered error attempting to access database."
		else
			statuscode = 200
			response = "Ingame Discord bot's channels were successfully updated."

	return TRUE

//Restart Round
/datum/topic_command/restart_round
	name = "restart_round"
	description = "Restarts the round"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="A display friendly name for the sender.","req"=1,"type"="str")
	)

/datum/topic_command/restart_round/run_command(queryparams)
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)

	to_world("<font size=4 color='#ff2222'>Server restarting by remote command.</font>")
	log_and_message_admins("World restart initiated remotely by [senderkey].")
	feedback_set_details("end_error","remote restart")

	spawn(50)
		log_game("Rebooting due to remote command. Initiator: [senderkey]")
		world.Reboot("Rebooting due to remote command.")

	statuscode = 200
	response = "Restart Command accepted"
	data = null
	return TRUE

/datum/topic_command/tgs_reboot
	name = "restart_tgs"
	description = "Orders an immediate reboot via TGS, including the shutting down of DreamDaemon."
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that authorized the restart","req"=1,"type"="str")
	)

/datum/topic_command/tgs_reboot/run_command(queryparams)
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)

	if (!world.TgsAvailable())
		statuscode = 503
		response = "TGS not available."
		data = null
		return TRUE

	to_world("<font size=4 color='#ff2222'>Server restarting by remote command.</font>")
	log_and_message_admins("World restart initiated remotely by [senderkey].")
	feedback_set_details("end_error","remote restart")

	world.Reboot("Rebooting due to remote command.", hard_reset = TRUE)

	statuscode = 200
	response = "Restart Command accepted"
	data = null
	return TRUE

//Sends a text to everyone on the server
/datum/topic_command/broadcast_text
	name = "broadcast_text"
	description = "Sends a text to everyone on the server."
	params = list(
		"senderkey" = list("name"="senderkey","desc"="A display friendly name for the sender.","req"=1,"type"="str"),
		"text" = list("name"="text","desc"="The text that should be sent","req"=1,"type"="str")
	)

/datum/topic_command/broadcast_text/run_command(queryparams)
	var/sender = sanitize(queryparams["senderkey"])
	var/text = sanitize(queryparams["text"])

	to_world("<span class=notice><b>[sender] Announces via Remote:</b><p style='text-indent: 50px'>[text]</p></span>")
	log_admin("Remote announce: [sender] : [queryparams["text"]]")

	statuscode = 200
	response = "Text sent"
	return TRUE

//Reloads all admins via remote command. Updates from the forumuser API if enabled.
/datum/topic_command/admins_reload
	name = "admins_reload"
	description = "Reloads all admins and pulls new data from the forumuser API if it's enabled."

/datum/topic_command/broadcast_text/run_command(queryparams)
	log_and_message_admins("AdminRanks: remote reload of the admins list initiated.")

	if (config.use_forumuser_api)
		if (!update_admins_from_api(reload_once_done=FALSE))
			statuscode = 500
			response = "Updating admins from the forumuser API failed. Aborted."
			return FALSE
		else
			statuscode = 201
			response = "Admins updated from the forumuser API and reloaded."
	else
		statuscode = 200
		response = "Admins reloaded."

	load_admins()
	return TRUE
