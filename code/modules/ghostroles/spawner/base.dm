/datum/ghostspawner
	var/short_name = null
	var/name = null
	var/desc = null
	var/show_on_job_select = TRUE
	var/welcome_message = null
	var/list/tags = list() //Tags associated with that spawner

	//Vars regarding the spawnpoints and conditions of the spawner
	var/list/spawnpoints = null //List of the applicable spawnpoints (by name)
	var/landmark_name = null //Alternatively you can specify a landmark name
	var/max_count = 0 //How often can this spawner be used
	var/count = 0 //How ofen has this spawner been used
	var/req_perms = null //What permission flags are required to use this spawner
	var/req_perms_edit = R_ADMIN
	var/req_head_whitelist = FALSE //If a head of staff whitelist is required
	var/req_species_whitelist = null //Name/Datum of the species whitelist that is required, or null
	var/enabled = TRUE //If the spawnpoint is enabled
	var/enable_chance = null //If set to a value other than null, has the set chance to become enabled
	var/enable_dmessage = TRUE //The message to send to deadchat if the ghostspawner is enabled or TRUE for a default message
	var/respawn_flag = null //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	var/jobban_job = null //If this is set, then it will check if the user is jobbanned from a specific job. Otherwise it will check for the name of the spawner

	//Vars regarding the mob to use
	var/mob/spawn_mob = null //The mob that should be spawned
	var/list/variables = list() //Variables of that mob
	var/mob_name = FALSE //The name of that mob; If null prompts for it
	var/mob_name_pick_message = "Pick a name."
	var/mob_name_prefix = null //The prefix that should be applied to the mob (i.e. CCIAA, Tpr., Cmdr.)
	var/mob_name_suffix = null //The suffix that should be applied to the mob name
	var/away_site = FALSE

/datum/ghostspawner/New()
	. = ..()
	if(!jobban_job)
		jobban_job = name
	if(!isnull(enable_chance))
		enabled = prob(enable_chance)

//Return a error message if the user CANT see the ghost spawner. Otherwise FALSE
/datum/ghostspawner/proc/cant_see(mob/user) //If the user can see the spawner in the menu
	if(req_perms) //Only those with the correct flags can see restricted roles
		if(check_rights(req_perms, show_msg=FALSE, user=user))
			return FALSE //Return early and dont perform whitelist checks if staff flags are met
		else
			return "Missing Permissions"

	if(req_head_whitelist && !check_whitelist(user))
		return "Missing Head of Staff Whitelist"

	if(jobban_job && jobban_isbanned(user,jobban_job))
		return "Job Banned"

	if(!enabled && !can_edit(user)) //If its not enabled and the user cant edit it, dont show it
		return "Currently Disabled"

	if(req_species_whitelist)
		if(!is_alien_whitelisted(user, req_species_whitelist))
			return "Missing Species Whitelist"

	return FALSE

//Return a error message if the user CANT spawn. Otherwise FALSE
/datum/ghostspawner/proc/cant_spawn(mob/user) //If the user can spawn using the spawner
	if(!ROUND_IS_STARTED)
		return "The round is not started yet."
	var/cant_see = cant_see(user)
	if(cant_see) //If we cant see it, we cant spawn it
		return cant_see
	if(!(istype(user, /mob/abstract/observer) || isnewplayer(user)))
		return "You are not a ghost."
	if(!enabled) //If the spawner id disabled, we cant spawn in
		return "This spawner is not enabled."
	if(respawn_flag && !user.MayRespawn(0,respawn_flag))
		return "You can not respawn at this time."
	if(!config.enter_allowed)
		return "There is an administrative lock on entering the game."
	if(SSticker.mode?.explosion_in_progress)
		return "The station is currently exploding."
	if(max_count && count > max_count)
		return "No more slots are available."
	//Check if a spawnpoint is available
	var/T = select_spawnpoint(FALSE)
	if(!T)
		return "No spawnpoint available."
	return FALSE

//Proc executed before someone is spawned in
/datum/ghostspawner/proc/pre_spawn(mob/user)
	count++ //Increment the spawned in mob count
	if(max_count && count >= max_count)
		enabled = FALSE
	return TRUE

//This proc selects the spawnpoint to use.
/datum/ghostspawner/proc/select_spawnpoint(var/use=TRUE)
	if(!isnull(spawnpoints))
		for(var/spawnpoint in spawnpoints) //Loop through the applicable spawnpoints
			var/turf/T = SSghostroles.get_spawnpoint(spawnpoint, use) //Gets the first matching spawnpoint or null if none are available
			if(T) //If we have a spawnpoint, return it
				return T
	if(!isnull(landmark_name))
		var/obj/effect/landmark/L
		for(var/obj/effect/landmark/landmark in landmarks_list)
			if(landmark.name == landmark_name)
				L = landmark
				return get_turf(L)

	log_debug("Ghostspawner: Spawner [short_name] has neither spawnpoints nor landmarks or a matching spawnpoint/landmark could not be found")

	return null //If we dont have anything return null

//The proc to actually spawn in the user
/datum/ghostspawner/proc/spawn_mob(mob/user)
	//OVERWRITE THIS IN THE CHILD IMPLEMENTATIONS to return the spawned in mob !!!
	return null

//Proc executed after someone is spawned in
/datum/ghostspawner/proc/post_spawn(mob/user)
	if(max_count && count >= max_count)
		disable()
	if(welcome_message)
		to_chat(user, span("notice", welcome_message))
	return TRUE

//Proc to check if a specific user can edit this spawner (open/close/...)
/datum/ghostspawner/proc/can_edit(mob/user)
	if(check_rights(req_perms_edit, show_msg=FALSE, user=user))
		return TRUE
	return FALSE

/datum/ghostspawner/proc/is_enabled()
	if(max_count)
		return enabled && count < max_count
	return enabled

//Proc to enable the ghostspawner
/datum/ghostspawner/proc/enable()
	enabled = TRUE
	if(enable_dmessage)
		for(var/mob/abstract/observer/O in player_list)
			if(O.client && !cant_see(O))
				if(enable_dmessage == TRUE)
					to_chat(O, "<span class='deadsay'><b>A ghostspawner for a \"[src.name]\" has been enabled.</b></span>")
				else
					to_chat(O, "<span class='deadsay'><b>[enable_dmessage]</b></span>")
	for(var/i in spawnpoints)
		SSghostroles.update_spawnpoint_status_by_identifier(i)
	return TRUE

//Proc to disable the ghostspawner
/datum/ghostspawner/proc/disable()
	enabled = FALSE
	for(var/i in SSghostroles.spawnpoints)
		SSghostroles.update_spawnpoint_status_by_identifier(i)
	return TRUE

/datum/ghostspawner/simplemob/spawn_mob(mob/user)
	//Select a spawnpoint (if available)
	var/turf/T = select_spawnpoint()
	var/mob/living/simple_animal/S
	if (T)
		S = new spawn_mob(T)
	else
		to_chat(user, "<span class='warning'>Unable to find any spawn point. </span>")

	if(S)
		announce_ghost_joinleave(user, 0, "They are now a [name].")
		S.ckey = user.ckey

	return S
