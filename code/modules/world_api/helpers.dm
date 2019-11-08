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
