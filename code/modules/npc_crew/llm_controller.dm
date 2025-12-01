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
/// Returns the LLM's response text, or null on error
/datum/llm_controller/proc/request(prompt)
	if(!prompt || !length(prompt))
		return null

	// Check if we should even try (if we've already determined it's unavailable)
	if(available == FALSE && fallback_enabled)
		return get_fallback_response()

	// Build request body
	var/list/request_body = list(
		"model" = model,
		"prompt" = prompt,
		"stream" = FALSE
	)

	var/body_json = json_encode(request_body)

	// Build headers
	var/list/headers = list(
		"Content-Type" = "application/json"
	)

	// Create HTTP request using the codebase's HTTP system
	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_POST, endpoint, body_json, headers)

	// Execute as blocking request (we need the response immediately for dialogue)
	// Note: This is generally not recommended but necessary for synchronous dialogue
	try
		var/raw_response = rustg_http_request_blocking(RUSTG_HTTP_METHOD_POST, endpoint, body_json, json_encode(headers), null)

		// Parse response
		var/list/response_data = json_decode(raw_response)

		if(!response_data)
			log_debug("LLM request failed: unable to parse response")
			available = FALSE
			if(fallback_enabled)
				return get_fallback_response()
			return null

		// Check for errors
		if(response_data["error"])
			log_debug("LLM request failed: [response_data["error"]]")
			available = FALSE
			if(fallback_enabled)
				return get_fallback_response()
			return null

		// Extract response text
		var/response_text = response_data["response"]
		if(!response_text || !length(response_text))
			log_debug("LLM request failed: empty response")
			available = FALSE
			if(fallback_enabled)
				return get_fallback_response()
			return null

		// Success - mark as available
		available = TRUE
		return response_text

	catch(var/exception)
		log_debug("LLM request exception: [exception]")
		available = FALSE
		if(fallback_enabled)
			return get_fallback_response()
		return null

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
