var/datum/controller/subsystem/ntsl2/SSntsl2

/*
NTSL2 deamon management subsystem, responsible for handling events from deamon and it's connection state.
*/
/datum/controller/subsystem/ntsl2
	name = "NTSL2"
	flags = 0
	init_order = SS_INIT_MISC
	// priority = SS_PRIORITY_PROCESSING
	var/connected = FALSE
	var/list/programs = list()

/datum/controller/subsystem/ntsl2/New()
	NEW_SS_GLOBAL(SSntsl2)

/datum/controller/subsystem/ntsl2/Initialize(timeofday)
	attempt_connect()
	..()

/*
	Sends a command to the Daemon. This is an internal function, and should be avoided when used externally.
*/
/datum/controller/subsystem/ntsl2/proc/i_send(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET)
	if(config.ntsl_hostname && config.ntsl_port) // Requires config to be set.
		var/url = "http://[config.ntsl_hostname]:[config.ntsl_port]/[command]"
		var/body = ""
		switch(method)
			if(RUSTG_HTTP_METHOD_GET)
				if(arguments)
					url += "?" + list2params(arguments)
			if(RUSTG_HTTP_METHOD_POST)
				if(arguments)
					body = json_encode(arguments)
		
		var/datum/http_request/request = http_create_request(method, url, body)
		request.begin_async()
		UNTIL(request.is_complete())
		var/datum/http_response/res = request.into_response()
		if (res.errored)
			log_debug("NTSL2++: Proc error while perfoming command '[command]': [res.error]")
			return FALSE
		else if (res.status_code != 200)
			log_debug("NTSL2++: HTTP error while perfoming command '[command]': [res.status_code]")
			return FALSE
		else
			return res.body
	return FALSE

/datum/controller/subsystem/ntsl2/proc/send(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET)
	if(!connected)
		return FALSE
	return i_send(command, arguments, method)
	
/datum/controller/subsystem/ntsl2/proc/attempt_connect()
	var/res = i_send("clear")
	if(!res)
		log_debug("NTSL2++ Daemon could not be connected to. Functionality will not be enabled.")
		return FALSE
	else
		connected = TRUE
		log_debug("NTSL2++ Daemon connected successfully.")
		return TRUE

/datum/controller/subsystem/ntsl2/proc/disconnect()
	connected = FALSE
	i_send("clear")
	// TODO: Kill programs
	for(var/p in programs)
		var/datum/ntsl2_program/Prog = p
		Prog.kill()

// INTERNAL. DO NOT USE
/datum/controller/subsystem/ntsl2/proc/handle_termination(var/program)
	programs -= program


/datum/controller/subsystem/ntsl2/fire(resumed)
	. = ..()
	