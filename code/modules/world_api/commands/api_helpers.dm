//
// API for the API
//
/datum/topic_command/api_get_version
	name = "api_get_version"
	description = "Gets the version of the API"
	no_auth = TRUE
	no_throttle = TRUE

/datum/topic_command/api_get_version/run_command(queryparams)
	var/list/version = list()
	var/versionstring = null
	//The Version Number follows SemVer http://semver.org/
	version["major"] = 2 //Major Version Number --> Increment when implementing breaking changes
	version["minor"] = 5 //Minor Version Number --> Increment when adding features
	version["patch"] = 0 //Patchlevel --> Increment when fixing bugs

	versionstring = "[version["major"]].[version["minor"]].[version["patch"]]"

	statuscode = 200
	response = versionstring
	data = version
	return TRUE


//Get all the commands a specific token / ip combo is authorized to use
/datum/topic_command/api_get_authed_commands
	name = "api_get_authed_commands"
	description = "Returns the commands that can be accessed by the requesting ip and token"

/datum/topic_command/api_get_authed_commands/run_command(queryparams)
	var/list/commands = list()
	//Check if DB Connection is established
	if (!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB Connection Unavailable"
		return TRUE

	var/DBQuery/commandsquery = dbcon.NewQuery({"SELECT api_f.command
	FROM ss13_api_token_command as api_t_f, ss13_api_tokens as api_t, ss13_api_commands as api_f
	WHERE api_t.id = api_t_f.token_id AND api_f.id = api_t_f.command_id
	AND (
		(token = :token: AND ip = :ip:)
		OR
		(token = :token: AND ip IS NULL)
		OR
		(token IS NULL AND ip = :ip:)
	)
	ORDER BY command DESC"})


	commandsquery.Execute(list("token" = queryparams["auth"], "ip" = queryparams["addr"]))
	while (commandsquery.NextRow())
		commands[commandsquery.item[1]] = commandsquery.item[1]
		if(commandsquery.item[1] == "_ANY")
			statuscode = 200
			response = "Authorized commands retrieved - ALL"
			data = topic_commands_names
			return TRUE


	statuscode = 200
	response = "Authorized commands retrieved"
	data = commands
	return TRUE

//Get details for a specific api command
/datum/topic_command/api_explain_command
	name = "api_explain_command"
	description = "Explains a specific API command"
	no_throttle = TRUE
	params = list(
		"command" = list("name"="command","desc"="The name of the API command that should be explained","req"=1,"type"="str")
		)

/datum/topic_command/api_explain_command/run_command(queryparams)
	var/datum/topic_command/apicommand = topic_commands[queryparams["command"]]
	var/list/commanddata = list()

	if (isnull(apicommand))
		statuscode = 501
		response = "Not Implemented - The requested command does not exist"
		return TRUE

	//Then query for auth
	if (!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB Connection Unavailable"
		return TRUE

	var/DBQuery/permquery = dbcon.NewQuery({"SELECT api_f.command
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
	//Get the tokens and the associated commands
	//Check if the token, the ip and the command matches OR
	// the token + command matches and the ip is NULL (commands that can be used by any ip, but require a token)
	// the token + ip matches and the command is NULL (Allow a specific ip with a specific token to use all commands)
	// the token + ip is NULL and the command matches (Allow a specific command to be used without auth)

	permquery.Execute(list("token" = queryparams["auth"], "ip" = queryparams["addr"], "command" = queryparams["command"]))

	if (!permquery.RowCount())
		statuscode = 401
		response = "Unauthorized - To access this command"
		return TRUE

	commanddata["name"] = apicommand.name
	commanddata["description"] = apicommand.description
	commanddata["params"] = apicommand.params

	statuscode = 200
	response = "Command data retrieved"
	data = commanddata
	return TRUE


/datum/topic_command/update_command_database
	name = "update_command_database"
	description = "Updates the available topic commands in the database"

/datum/topic_command/update_command_database/run_command(queryparams)
	api_update_command_database()

	statuscode = 200
	response = "Database Updated"
	return TRUE

//Ping Test
/datum/topic_command/ping
	name = "ping"
	description = "API test command"
	no_auth = TRUE

/datum/topic_command/ping/run_command(queryparams)
	statuscode = 200
	response = "Pong"
	data = "Pong"
	return TRUE
