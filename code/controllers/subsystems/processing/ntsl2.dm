var/datum/controller/subsystem/processing/ntsl2/SSntsl2

#define NTSL_TIME_TRACK list("new_program", "execute", "remove", "tcom/process", "tcom/get")

/*
NTSL2 deamon management subsystem, responsible for handling events from deamon and it's connection state.
*/
/datum/controller/subsystem/processing/ntsl2
	name = "NTSL2"
	flags = 0
	init_order = SS_INIT_MISC
	wait = 10
	var/connected = FALSE
	var/list/programs = list()
	var/current_task_id = 1

/datum/controller/subsystem/processing/ntsl2/New()
	NEW_SS_GLOBAL(SSntsl2)

/datum/controller/subsystem/processing/ntsl2/Initialize(timeofday)
	attempt_connect()
	..()

/*
 * Builds request object meant to do certain action. Returns FALSE (0) when there was an issue.
 */
/datum/controller/subsystem/processing/ntsl2/proc/build_request(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET, var/body = null)
	if(config.ntsl_hostname && config.ntsl_port) // Requires config to be set.
		var/url = "http://[config.ntsl_hostname]:[config.ntsl_port]/[command]"
		var/request_body = ""
		if(arguments)
			url += "?" + list2params(arguments)
		switch(method)
			if(RUSTG_HTTP_METHOD_POST)
				if(body)
					request_body = json_encode(body)

		return http_create_request(method, url, request_body, list("Content-Type" = "application/json"))
	return FALSE

/*
 * Handles errors from response and returns final response data.
 */
/datum/controller/subsystem/processing/ntsl2/proc/handle_response(var/datum/http_response/response, var/command)
	if (response.errored)
		log_debug("NTSL2++: Proc error while performing command '[command]': [response.error]")
		log_debug("NTSL2++: Due to proc error, NTSL2++ has been DISABLED.")
		disconnect()
		return FALSE
	else if (response.status_code != 200)
		log_debug("NTSL2++: HTTP error while performing command '[command]': [response.status_code]")
		return FALSE
	else
		return response.body

/*
 * Synchronous command to NTSL2 daemon. Uses sleep.
 */
/datum/controller/subsystem/processing/ntsl2/proc/send(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET, var/body = null, var/internal = FALSE)
	if(!internal)
		UNTIL(init_state == SS_INITSTATE_DONE)
		if(!connected)
			return FALSE
	var/datum/http_request/request = build_request(command, arguments, method, body)
	if(istype(request))
		request.begin_async()
#ifdef NTSL_TIME_TRACK
		var/task_id = world.time
		if(command in NTSL_TIME_TRACK)
			rustg_time_reset("ntsl2++[task_id]")
#endif
		UNTIL(request.is_complete())
#ifdef NTSL_TIME_TRACK
		if(command in NTSL_TIME_TRACK)
			var/taskDuration = rustg_time_milliseconds("ntsl2++[task_id]")
			log_debug("NTSL2++: Command '[command]' took [taskDuration] ms")
#endif
		return handle_response(request.into_response(), command)

/datum/controller/subsystem/processing/ntsl2/proc/attempt_connect()
	var/res = send("clear", internal = TRUE)
	if(!res)
		log_debug("NTSL2++ Daemon could not be connected to. Functionality will not be enabled.")
		return FALSE
	else
		connected = TRUE
		log_debug("NTSL2++ Daemon connected successfully.")
		return TRUE

/datum/controller/subsystem/processing/ntsl2/proc/disconnect()
	connected = FALSE
	send("clear", internal = TRUE)
	for(var/p in programs)
		var/datum/ntsl2_program/Prog = p
		Prog.id = 0
		Prog.kill()

// INTERNAL. DO NOT USE
/datum/controller/subsystem/processing/ntsl2/proc/handle_termination(var/program)
	programs -= program

