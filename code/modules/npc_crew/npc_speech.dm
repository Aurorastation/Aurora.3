// NPC speech handler
// Handles NPC responses to hearing speech from other mobs

/// Called when the NPC hears speech from another mob
/datum/npc_crew_member/proc/handle_heard_speech(mob/speaker, message)
	// Check if body is conscious
	if(!body || body.stat != CONSCIOUS)
		return

	// Don't respond to ourselves
	if(speaker == body)
		return

	// Check distance (within 7 tiles)
	if(get_dist(body, speaker) > 7)
		return

	// Build context and system prompt
	var/context = build_speech_context(speaker, message)
	var/system_prompt = build_system_prompt()

	// Delay response slightly to feel more natural
	spawn(rand(10, 30))
		// Double-check body is still valid and conscious
		if(!body || body.stat != CONSCIOUS)
			return

		// Request LLM response via get_llm_controller()
		var/datum/llm_controller/llm = get_llm_controller()
		var/response

		if(llm)
			response = llm.request(context, system_prompt)

		// Use fallback if LLM unavailable or returned nothing
		if(!response || response == "")
			response = llm.get_fallback_response()

		// Make NPC say the response
		if(response && body)
			body.say(response)

/// Builds the context string for the LLM
/datum/npc_crew_member/proc/build_speech_context(mob/speaker, message)
	var/speaker_name = "Someone"
	if(speaker)
		speaker_name = speaker.name

	return "[speaker_name] says: \"[message]\""

/// Builds the system prompt for the LLM
/datum/npc_crew_member/proc/build_system_prompt()
	var/job_title = "crew member"
	if(assigned_job)
		job_title = assigned_job.title

	var/personality = get_personality_description()

	var/prompt = "You are [body.real_name], a [job_title] on a space station. "
	prompt += "Your personality is [personality]. "
	prompt += "Respond to what you hear in character, keeping responses brief (1-2 sentences). "
	prompt += "Do not use quotation marks in your response. "
	prompt += "Stay in character and respond naturally as this crew member would."

	return prompt
