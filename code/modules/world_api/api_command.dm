//API Boilerplate
/datum/topic_command
	var/name = null //Name for the command
	var/no_auth = FALSE //If the user does NOT need to be authed to use the command
	var/no_throttle = FALSE //If this command should NOT be limited by the throtteling
	var/description = null //Description for the command
	var/list/params = list() //Required Parameters for the command
	//Explanation of the parameter options:
	//Required - name -> Name of the parameter - should be the same as the index in the list
	//Required - desc -> Description of the parameter
	//Required - req -> Is this a required parameter: 1 -> Yes, 0 -> No
	//Required - type -> What type is this:
	//						str->String,
	//						int->Integer,
	//						lst->List/array,
	//						senderkey->unique identifier of the person sending the request
	//						slct -> Select one of multiple specified options
	//Required* - options -> The possible options that can be selected (slct)
	var/statuscode = null
	var/response = null
	var/data = null

/datum/topic_command/proc/run_command(queryparams)
	// Always returns 1 --> Details status in statuscode, response and data
	return TRUE

/datum/topic_command/proc/check_params_missing(queryparams)
	//Check if some of the required params are missing
	// 0 -> if all params are supplied
	// >=1 -> if a param is missing
	var/list/missing_params = list()
	var/errorcount = 0

	for(var/key in params)
		var/list/param = params[key]
		if(queryparams[key] == null)
			if(param["req"] == 0)
				log_debug("API: The following parameter is OPTIONAL and missing: [param["name"]] - [param["desc"]]")
			else
				log_debug("API: The following parameter is REQUIRED but missing: [param["name"]] - [param["desc"]]")
				errorcount ++
				missing_params += param["name"]
	if(errorcount)
		log_debug("API: Request aborted. Required parameters missing")
		statuscode = 400
		response = "Required params missing"
		data = missing_params
		return errorcount
	return 0

/datum/topic_command/proc/check_auth(addr, auth_key, bypass_throttle_check = FALSE)
	if (!bypass_throttle_check && _is_throttled(addr))
		return 2

	if (no_auth)
		log_debug("API: Auth bypassed - Command [name] set to no_auth")
		return 0

	if (_is_authorized_via_token(addr, auth_key))
		return 0
	else
		return 1

/datum/topic_command/proc/_is_throttled(addr)
	if (no_throttle)
		log_debug("API: Throttling bypassed - Command [name] set to no_throttle")
		return FALSE

	if (config.api_rate_limit_whitelist[addr] == null)
		log_debug("API: Throttling bypassed - IP [addr] is whitelisted.")
		return FALSE

	var/last_time = world_api_rate_limit[addr]
	world_api_rate_limit[addr] = REALTIMEOFDAY

	if (last_time != null && abs(last_time - REALTIMEOFDAY) < config.api_rate_limit)
		return TRUE

	return FALSE

/datum/topic_command/proc/_is_authorized_via_token(addr, auth_key)
	if (!establish_db_connection(dbcon))
		return FALSE

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

	authquery.Execute(list("token" = auth_key, "ip" = addr, "command" = name))
	log_debug("API: Auth Check - Query Executed - Returned Rows: [authquery.RowCount()]")

	if (authquery.RowCount())
		return TRUE

	return FALSE
