//Init the API at startup
/hook/startup/proc/setup_api()
	for (var/path in typesof(/datum/topic_command) - /datum/topic_command)
		var/datum/topic_command/A = new path()
		if(A != null)
			GLOB.topic_commands[A.name] = A
			GLOB.topic_commands_names.Add(A.name)
		listclearnulls(GLOB.topic_commands)
		listclearnulls(GLOB.topic_commands_names)

	if (GLOB.config.api_rate_limit_whitelist.len)
		// To make the api_rate_limit_whitelist[addr] grabs actually work.
		for (var/addr in GLOB.config.api_rate_limit_whitelist)
			GLOB.config.api_rate_limit_whitelist[addr] = 1

	return 1
