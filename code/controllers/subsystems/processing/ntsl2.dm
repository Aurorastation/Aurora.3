/*
NTSL2 deamon management subsystem, responsible for handling events from deamon and it's connection state.
*/
PROCESSING_SUBSYSTEM_DEF(ntsl2)
	name = "NTSL2"
	flags = 0
	init_order = SS_INIT_MISC
	// priority = SS_PRIORITY_PROCESSING
	var/connected = FALSE
	var/list/programs = list()
	var/list/tasks = list()
	var/current_task_id = 1

/datum/controller/subsystem/processing/ntsl2/Initialize(timeofday)
	attempt_connect()

	return SS_INIT_SUCCESS

/*
 * Builds request object meant to do certain action. Returns FALSE (0) when there was an issue.
 */
/datum/controller/subsystem/processing/ntsl2/proc/build_request(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET)
	if(GLOB.config.ntsl_hostname && GLOB.config.ntsl_port) // Requires config to be set.
		var/url = "http://[GLOB.config.ntsl_hostname]:[GLOB.config.ntsl_port]/[command]"
		var/body = ""
		switch(method)
			if(RUSTG_HTTP_METHOD_GET)
				if(arguments)
					url += "?" + list2params(arguments)
			if(RUSTG_HTTP_METHOD_POST)
				if(arguments)
					body = json_encode(arguments)

		return http_create_request(method, url, body)
	return FALSE

/*
 * Handles errors from response and returns final response data.
 */
/datum/controller/subsystem/processing/ntsl2/proc/handle_response(var/datum/http_response/response, var/command)
	if (response.errored)
		LOG_DEBUG("NTSL2++: Proc error while performing command '[command]': [response.error]")
		return FALSE
	else if (response.status_code != 200)
		LOG_DEBUG("NTSL2++: HTTP error while performing command '[command]': [response.status_code]")
		return FALSE
	else
		return response.body

/*
 * Synchronous command to NTSL2 daemon. DO NOT USE for like almost anything.
 */
/datum/controller/subsystem/processing/ntsl2/proc/sync_send(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET)
	var/datum/http_request/request = build_request(command, arguments, method)
	if(istype(request))
		request.begin_async()
		UNTIL(request.is_complete())
		return handle_response(request.into_response(), command)


/*
 * ASynchronous command to NTSL2 daemon. Returns id of task, meant to track progress of this task.
 */
/datum/controller/subsystem/processing/ntsl2/proc/send_task(var/command, var/list/arguments, var/method = RUSTG_HTTP_METHOD_GET, var/program = null, var/callback = null)
	if(!connected)
		return FALSE
	var/datum/http_request/request = build_request(command, arguments, method)
	if(istype(request))
		request.begin_async()
		var/task = list(request = request, program = program, command = command, callback = callback)
		var/task_id = "[current_task_id++]"
		tasks[task_id] = task
		return task_id
	return FALSE


/datum/controller/subsystem/processing/ntsl2/proc/handle_task_completion(var/response, var/list/task)
	var/command = task["command"]
	var/datum/ntsl2_program/program = task["program"]
	switch(command)
		if("new_program")
			if(!response)
				crash_with("NTSL2++: Program initialization failed, but program was handed out.")
			program.id = response
			for(var/c in program.ready_tasks)
				var/datum/callback/callback = c
				if(istype(callback))
					callback.InvokeAsync()
			return
		if("execute")
			LOG_DEBUG("NTSL2++ Daemon could not be connected to. Functionality will not be enabled.")
			// Not sure what to do with successful / unsuccessful execution
			return
		if("computer/get_buffer")
			if(response)
				var/datum/ntsl2_program/computer/P = program
				if(istype(P))
					P.buffer = response
					if(istype(P.buffer_update_callback))
						P.buffer_update_callback.InvokeAsync()
			return
	var/datum/callback/cb = task["callback"]
	if(istype(cb))
		cb.InvokeAsync(response)



/datum/controller/subsystem/processing/ntsl2/proc/is_complete(var/task_id)
	if(!task_id)
		return TRUE
	if(tasks[task_id])
		return FALSE
	return TRUE


/datum/controller/subsystem/processing/ntsl2/proc/attempt_connect()
	if(GLOB.config.ntsl_disabled)
		LOG_DEBUG("NTSL2++ Daemon disabled via config")
		return FALSE
	var/res = sync_send("clear")
	if(!res)
		LOG_DEBUG("NTSL2++ Daemon could not be connected to. Functionality will not be enabled.")
		return FALSE
	else
		connected = TRUE
		LOG_DEBUG("NTSL2++ Daemon connected successfully.")
		return TRUE

/datum/controller/subsystem/processing/ntsl2/proc/disconnect()
	connected = FALSE
	sync_send("clear")
	// TODO: Kill programs
	for(var/p in programs)
		var/datum/ntsl2_program/Prog = p
		Prog.kill()

// INTERNAL. DO NOT USE
/datum/controller/subsystem/processing/ntsl2/proc/handle_termination(var/program)
	programs -= program


/datum/controller/subsystem/processing/ntsl2/fire(resumed)
	for(var/task_id in tasks)
		var/task = tasks[task_id]
		var/datum/http_request/req = task["request"]
		if(req.is_complete())
			var/datum/http_response/res = req.into_response()
			var/result = handle_response(res, task["command"])
			handle_task_completion(result, task)
			tasks -= task_id

	. = ..()
