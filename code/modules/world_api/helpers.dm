//Init the API at startup
/hook/startup/proc/setup_api()
	for (var/path in typesof(/datum/topic_command) - /datum/topic_command)
		var/datum/topic_command/A = new path()
		if(A != null)
			topic_commands[A.name] = A
			topic_commands_names.Add(A.name)
		listclearnulls(topic_commands)
		listclearnulls(topic_commands_names)

	if (config.api_rate_limit_whitelist.len)
		// To make the api_rate_limit_whitelist[addr] grabs actually work.
		for (var/addr in config.api_rate_limit_whitelist)
			config.api_rate_limit_whitelist[addr] = 1

	return 1

/world/proc/api_do_auth_check(var/addr, var/auth, var/datum/topic_command/command)
	//Check if command is on nothrottle list
	if(command.no_throttle == 1)
		log_debug("API: Throttling bypassed - Command [command.name] set to no_throttle")
	else
		if(world_api_rate_limit[addr] != null && config.api_rate_limit_whitelist[addr] == null) //Check if the ip is in the rate limiting list and not in the whitelist
			if(abs(world_api_rate_limit[addr] - world.time) < config.api_rate_limit) //Check the last request time of the ip
				world_api_rate_limit[addr] = world.time // Set the time of the last request
				return 2 //Throttled
		world_api_rate_limit[addr] = world.time // Set the time of the last request


	//Check if the command is on the auth whitelist
	if(command.no_auth == 1)
		log_debug("API: Auth bypassed - Command [command.name] set to no_auth")
		return 0 // Authed (bypassed)

	var/DBQuery/authquery = dbcon.NewQuery({"SELECT api_f.command
	FROM ss13_api_token_command as api_t_f, ss13_api_tokens as api_t, ss13_api_commands as api_f
	WHERE api_t.id = api_t_f.token_id AND api_f.id = api_t_f.command_id
	AND	api_t.deleted_at IS NULL
	AND (
	(token = :token: AND ip = :ip: AND command = :command:)
	OR
	(token = :token: AND ip IS NULL AND command = :command:)
	OR
	(token = :token: AND ip = :ip: AND command = \"_ANY\")
	OR
	(token = :token: AND ip IS NULL AND command = \"_ANY\")
	OR
	(token IS NULL AND ip IS NULL AND command = :command:)
	)"})
	//Check if the token is not deleted
	//Check if one of the following is true:
	// Full Match - Token IP and Command Matches
	// Any IP - Token and Command Matches, IP is set to NULL (not required)
	// Any Command - Token and IP Matches, Command is set to _ANY
	// Any Command, Any IP - Token Matches, IP is set to NULL (not required), Command is set to _ANY
	// Public - Token is set to NULL, IP is set to NULL and command matches

	authquery.Execute(list("token" = auth, "ip" = addr, "command" = command.name))
	log_debug("API: Auth Check - Query Executed - Returned Rows: [authquery.RowCount()]")

	if (authquery.RowCount())
		return 0 // Authed
	return 1 // Bad Key


/proc/api_update_command_database()
	log_debug("API: DB Command Update Called")
	//Check if DB Connection is established
	if (!establish_db_connection(dbcon))
		return 0 //Error

	var/DBQuery/commandinsertquery = dbcon.NewQuery({"INSERT INTO ss13_api_commands (command,description)
	VALUES (:command_name:,:command_description:)
	ON DUPLICATE KEY UPDATE description = :command_description:;"})

	for(var/com in topic_commands)
		var/datum/topic_command/command = topic_commands[com]
		commandinsertquery.Execute(list("command_name" = command.name, "command_description" = command.description))
	log_debug("API: DB Command Update Executed")
	return 1 //OK
