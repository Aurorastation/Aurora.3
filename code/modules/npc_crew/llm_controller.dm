// LLM Controller for NPC Crew System
// Manages communication with Ollama API for generating NPC dialogue and responses

/// Singleton instance of the LLM controller
GLOBAL_DATUM(llm_controller, /datum/llm_controller)

/datum/llm_controller
	/// Ollama API endpoint URL
	var/endpoint
	/// Model name to use (e.g. "llama3")
	var/model
	/// Request timeout in deciseconds
	var/timeout
	/// Whether to fall back to scripted responses when LLM unavailable
	var/fallback_enabled
	/// Availability status: null = not checked, TRUE = available, FALSE = unavailable
	var/available = null

/datum/llm_controller/New()
	. = ..()

	// Load configuration from GLOB.config
	if(!GLOB.config)
		stack_trace("LLM controller initialized before config loaded")
		return

	endpoint = GLOB.config.llm_endpoint
	model = GLOB.config.llm_model
	timeout = GLOB.config.llm_timeout
	fallback_enabled = GLOB.config.llm_fallback_enabled

	log_debug("LLM Controller initialized: endpoint=[endpoint], model=[model], timeout=[timeout]ds, fallback=[fallback_enabled]")

/// Makes a request to the Ollama API
/// Arguments:
/// * prompt - The prompt to send to the LLM
/// * system_prompt - Optional system prompt to set context
/// Returns the LLM's response text, or null on error
/datum/llm_controller/proc/request(prompt, system_prompt = "")
	if(available == FALSE && fallback_enabled)
		return null

	// Build request body
	var/list/request_body = list(
		"model" = model,
		"prompt" = prompt,
		"stream" = FALSE
	)
	if(system_prompt)
		request_body["system"] = system_prompt

	var/body_json = json_encode(request_body)
	var/list/headers = list("Content-Type" = "application/json")

	// Create async request
	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_POST, endpoint, body_json, headers)
	req.begin_async()

	// Wait for response with timeout
	var/start_time = world.time
	while(!req.is_complete())
		if(world.time - start_time > timeout)
			log_debug("LLM request timed out after [timeout] ds")
			if(isnull(available))
				available = FALSE
			return null
		sleep(1)

	// Parse response
	var/datum/http_response/res = req.into_response()
	if(res.errored || res.status_code != 200)
		log_debug("LLM request failed: status [res.status_code], error: [res.error]")
		if(isnull(available))
			available = FALSE
		return null

	if(isnull(available))
		available = TRUE

	// Parse JSON response
	var/list/response_data = json_decode(res.body)
	if(!response_data || !response_data["response"])
		log_debug("LLM response missing 'response' field")
		return null

	return response_data["response"]

/// Returns a generic fallback response when LLM is unavailable
/datum/llm_controller/proc/get_fallback_response()
	var/static/list/fallback_responses = list(
		"I'm a bit busy right now.",
		"Sorry, I'm focused on my work.",
		"Not right now, I have things to do.",
		"Can we talk later?",
		"I'm in the middle of something.",
		"Let me get back to my duties.",
		"I need to focus on my tasks."
	)

	return pick(fallback_responses)

/// Global getter proc for the LLM controller singleton
/proc/get_llm_controller()
	if(!GLOB.llm_controller)
		GLOB.llm_controller = new /datum/llm_controller()
	return GLOB.llm_controller
