// Lightweight versions of Polaris' AI diagnostics.

/datum/ai_holder/proc/ai_log_output(message = "missing message", verbosity = AI_LOG_INFO)
	if(debug_ai == AI_LOG_OFF || verbosity > debug_ai)
		return
	var/holder_description = holder ? "[holder] ([holder.x],[holder.y],[holder.z])" : "deleted holder"
	log_debug("AI: [holder_description] @[world.time]: [message]")

/datum/ai_holder/proc/stance_color()
	if(!holder)
		return
	switch(stance)
		if(AI_STANCE_SLEEP)
			holder.color = "#ffffff"
		if(AI_STANCE_IDLE)
			holder.color = "#00ff00"
		if(AI_STANCE_ALERT)
			holder.color = "#ffff00"
		if(AI_STANCE_APPROACH)
			holder.color = "#ff9933"
		if(AI_STANCE_FIGHT)
			holder.color = "#ff0000"
		if(AI_STANCE_BLINDFIGHT)
			holder.color = "#ff6666"
		if(AI_STANCE_MOVE)
			holder.color = "#0000ff"
		if(AI_STANCE_REPOSITION)
			holder.color = "#ff00ff"
		if(AI_STANCE_FOLLOW)
			holder.color = "#00ffff"
		if(AI_STANCE_FLEE)
			holder.color = "#666666"
		if(AI_STANCE_DISABLED)
			holder.color = "#222222"
		else
			holder.color = null

/datum/ai_holder/proc/debug()
	debug_ai = AI_LOG_INFO
	stance_coloring = TRUE
	path_display = TRUE
	last_turf_display = TRUE
	stance_color()
	if(target_last_seen_turf)
		target_last_seen_turf.AddOverlays(last_turf_overlay)
	for(var/turf/path_turf in path)
		path_turf.AddOverlays(path_overlay)

/datum/ai_holder/proc/disable_debug()
	if(target_last_seen_turf)
		target_last_seen_turf.CutOverlays(last_turf_overlay)
	for(var/turf/path_turf in path)
		path_turf.CutOverlays(path_overlay)
	debug_ai = AI_LOG_OFF
	stance_coloring = FALSE
	path_display = FALSE
	last_turf_display = FALSE
	if(holder)
		holder.color = null

/datum/ai_holder/hostile/debug
	wander = FALSE
	conserve_ammo = FALSE
	intelligence_level = AI_INTELLIGENCE_SMART
	debug_ai = AI_LOG_INFO
	stance_coloring = TRUE
	path_display = TRUE
	last_turf_display = TRUE

/datum/ai_holder/simple_animal/hostile/debug
	wander = FALSE
	conserve_ammo = FALSE
	intelligence_level = AI_INTELLIGENCE_SMART
	debug_ai = AI_LOG_INFO
	stance_coloring = TRUE
	path_display = TRUE
	last_turf_display = TRUE
