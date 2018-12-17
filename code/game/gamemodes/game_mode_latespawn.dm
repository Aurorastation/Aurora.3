/datum/game_mode/var/next_spawn = 0
/datum/game_mode/var/min_autotraitor_delay = 4200  // Approx 7 minutes.
/datum/game_mode/var/max_autotraitor_delay = 12000 // Approx 20 minutes.
/datum/game_mode/var/process_count = 0 //Times process was called


///process()
///Called by the gameticker
/datum/game_mode/process()
	if(world.time >= next_spawn && !emergency_shuttle.departed)
		if(round_autoantag)
			process_autoantag()
		if(process_count == 0)
			process_emergency_spawn()

	// Process loop for objectives like the brig one.
	if (process_objectives.len)
		for (var/datum/objective/A in process_objectives)
			A.process()

	process_count++

//This can be overriden in case a game mode needs to do stuff when a player latejoins
/datum/game_mode/proc/handle_latejoin(var/mob/living/carbon/human/character)
	return 0

/datum/game_mode/proc/process_autoantag()
	message_admins("[uppertext(name)]: Attempting autospawn.")

	var/list/usable_templates = list()
	for(var/datum/antagonist/A in antag_templates)
		if(A.can_late_spawn())
			message_admins("[uppertext(name)]: [A.id] selected for spawn attempt.")
			usable_templates |= A

	if(!usable_templates.len)
		message_admins("[uppertext(name)]: Failed to find configured mode spawn templates, please re-enable auto-antagonists after one is added.")
		round_autoantag = 0
		return

	while(usable_templates.len)
		var/datum/antagonist/spawn_antag = pick(usable_templates)
		usable_templates -= spawn_antag

		if(spawn_antag.attempt_auto_spawn())
			message_admins("[uppertext(name)]: Auto-added a new [spawn_antag.role_text].")
			message_admins("There are now [spawn_antag.get_active_antag_count()]/[spawn_antag.cur_max] active [spawn_antag.role_text_plural].")
			next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)
			return

	message_admins("[uppertext(name)]: Failed to proc a viable spawn template.")
	next_spawn = world.time + min_autotraitor_delay //recheck again in the miniumum time

/datum/game_mode/proc/process_emergency_spawn()
	message_admins("[uppertext(name)]: Checking to see if we need to add more antagonists...")
	var/list/usable_templates = list()
	for(var/datum/antagonist/A in antag_templates)
		if(A.can_late_spawn() && A.can_emergency_spawn())
			message_admins("[uppertext(name)]: [A.id] selected for spawn attempt.")
			usable_templates |= A

	if(!usable_templates.len)
		message_admins("[uppertext(name)]: Could not find any antagonist types that can be processed for emergency spawning.")
		return

	for(var/datum/antagonist/spawn_antag in usable_templates)
		var/desired_spawns = spawn_antag.initial_spawn_target - spawn_antag.current_antagonists
		if(desired_spawns <= 0)
			message_admins("[uppertext(name)]: No additional [spawn_antag.role_text_plural] are needed.")
			continue

		var/spawned_antags = 0
		for(var/i=1,i <= desired_spawns,i++)
			if(!spawn_antag.attempt_auto_spawn())
				break
			else
				spawned_antags++
		if(spawned_antags)
			message_admins("[uppertext(name)]: Emergency added [spawned_antags] new [spawn_antag.role_text_plural] as there weren't enough [spawn_antag.role_text_plural] in the round.")
		else
			message_admins("[uppertext(name)]: Could not find or spawn any additional [spawn_antag.role_text_plural] for the round.")

		message_admins("There are [spawned_antags ? "now" : "currently"] [spawn_antag.get_active_antag_count()]/[spawn_antag.initial_spawn_target] desired [spawn_antag.role_text_plural] in the round.")