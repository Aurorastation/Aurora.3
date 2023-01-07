/datum/ghostspawner
	var/short_name = null
	var/name = null
	var/desc = null

	var/observers_only = FALSE
	var/show_on_job_select = TRUE // Determines if the ghost spawner role is considered unique or not.

	var/welcome_message = null
	var/list/tags = list() //Tags associated with that spawner

	//Vars regarding the spawnpoints and conditions of the spawner
	var/list/spawn_atoms = list() // List of atoms you can spawn at - Use loc_type: GS_LOC_ATOM
	var/atom_add_message = null // Message to display to the ghosts if a spawn atom has been added. The "spawn instructions" are appended automatically

	var/list/spawnpoints = null //List of the applicable spawnpoints (by name) - Use loc_type: GS_LOC_POS
	var/landmark_name = null //Alternatively you can specify a landmark name - Use loc_type: GS_LOC_POS

	var/loc_type = GS_LOC_POS

	var/max_count = 0 //How often can this spawner be used
	var/count = 0 //How ofen has this spawner been used
	var/req_perms = null //What permission flags are required to use this spawner
	var/req_perms_edit = R_ADMIN
	var/enabled = TRUE //If the spawnpoint is enabled
	var/enable_chance = null //If set to a value other than null, has the set chance to become enabled
	var/enable_dmessage = TRUE //The message to send to deadchat if the ghostspawner is enabled or TRUE for a default message
	var/respawn_flag = null //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)

	//If jobban_job is set, then it will check if the user is jobbanned from a specific job. Otherwise it will check for the name of the spawner.
	//it will also check if there is a whitelist required and if the player has the relevant whitelist for the specified job (or the name of the spawner)
	var/jobban_job = null

	//Vars regarding the mob to use
	var/mob/spawn_mob = null //The mob that should be spawned
	var/list/variables = list() //Variables of that mob
	var/mob_name = FALSE //The name of that mob; If null prompts for it
	var/mob_name_pick_message = "Pick a name."
	var/mob_name_prefix = null //The prefix that should be applied to the mob (i.e. CCIAA, Tpr., Cmdr.)
	var/mob_name_suffix = null //The suffix that should be applied to the mob name
	var/away_site = FALSE

	// Variables that restrict spawning until certain conditions are met //
	/// Need at least X number of horizon crew before you can spawn in as this at all
	var/hor_crew_needed_to_spawn = 0
	/// Multiplies the current slots + 1 by this variable to determine the amount of players required to spawn as this
	var/hor_crew_needed_per_slot = 0

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

	if(!enabled && !can_edit(user)) //If its not enabled and the user cant edit it, dont show it
		return "Currently Disabled"

	if(loc_type == GS_LOC_ATOM && !length(spawn_atoms))
		return "No spawn atoms available"

	var/ban_reason = jobban_isbanned(user,jobban_job)
	if(jobban_job && ban_reason)
		return "[ban_reason]"

	if(observers_only && !isobserver(user))
		return "Observers Only"

	return FALSE

//Return a error message if the user CANT spawn. Otherwise FALSE
/datum/ghostspawner/proc/cant_spawn(mob/user, var/deep_check = FALSE) //If the user can spawn using the spawner
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
	if(loc_type == GS_LOC_POS)
		var/T = select_spawnlocation(FALSE)
		if(!T)
			return "No spawnpoint available."
	else
		if(!length(spawn_atoms))
			return "No mobs are available to spawn."
	if(deep_check)
		if(hor_crew_needed_to_spawn || hor_crew_needed_per_slot)
			var/horizon_crew = 0
			for(var/mob/living/crew in living_mob_list)
				var/datum/job/job = SSjobs.GetJob(crew.job)
				if(job && job.faction == "Station")
					horizon_crew++
			if(hor_crew_needed_to_spawn > horizon_crew)
				return "Sorry, there needs to be at least [hor_crew_needed_to_spawn] crewmembers on the Horizon before you can spawn as this. (Currently: [horizon_crew])"
			var/crew_needed = (count + 1) * hor_crew_needed_per_slot
			if(crew_needed > horizon_crew)
				return "Sorry, there needs to be at least [crew_needed] crewmembers on the Horizon before you can spawn as this. (Currently: [horizon_crew])"
	return FALSE

//Proc executed before someone is spawned in
/datum/ghostspawner/proc/pre_spawn(mob/user)
	count++ //Increment the spawned in mob count
	if(max_count && count >= max_count)
		enabled = FALSE
	return TRUE

//This proc selects the spawnpoint to use. - Only used when mode is GS_LOC_POS
/datum/ghostspawner/proc/select_spawnlocation(var/use=TRUE)
	if(loc_type != GS_LOC_POS)
		log_debug("Ghostspawner: select_spawnlocation is not valid for spawner [short_name] as it is not position based")
		return null
	if(!isnull(spawnpoints))
		for(var/spawnpoint in spawnpoints) //Loop through the applicable spawnpoints
			var/turf/T = SSghostroles.get_spawnpoint(spawnpoint, use) //Gets the first matching spawnpoint or null if none are available
			if(T) //If we have a spawnpoint, return it
				return T
	if(!isnull(landmark_name))
		var/list/possible_landmarks = list()
		for(var/obj/effect/landmark/landmark in landmarks_list)
			if(landmark.name == landmark_name)
				possible_landmarks += landmark
		if(length(possible_landmarks))
			var/obj/effect/landmark/L = pick(possible_landmarks)
			return get_turf(L)

	log_debug("Ghostspawner: Spawner [short_name] has neither spawnpoints nor landmarks or a matching spawnpoint/landmark could not be found")

	return null //If we dont have anything return null

//Selects a spawnatom from the list of available atoms and removes it if use is set to true (default)
/datum/ghostspawner/proc/select_spawnatom(var/use=TRUE)
	if(loc_type != GS_LOC_ATOM)
		log_debug("Ghostspawner: select_spawnatom is not valid for spawner [short_name] as it is not atom based")
		return null
	var/atom/A = pick(spawn_atoms)
	if(use)
		spawn_atoms -= A
	return A

//The proc to actually spawn in the user
/datum/ghostspawner/proc/spawn_mob(mob/user)
	//OVERWRITE THIS IN THE CHILD IMPLEMENTATIONS to return the spawned in mob !!!

	//This is a basic proc for atom based spawners.
	//  Location based spawners usually need a bit more logic
	//  Atom based spanwers select a atom using the select_spawnatom() proc and then assigned a player to it
	//  by calling assign_player() with the current mob of the player that should be assigned as a argument.
	if(loc_type != GS_LOC_ATOM)
		return null

	var/atom/A = select_spawnatom()

	if(A)
		return A.assign_player(user)
	to_chat(user, SPAN_DANGER("There are no spawn atoms available to spawn at!"))
	return FALSE

//Proc executed after someone is spawned in
/datum/ghostspawner/proc/post_spawn(mob/user)
	if(max_count && count >= max_count)
		disable()
	if(welcome_message)
		to_chat(user, SPAN_NOTICE(welcome_message))
	universe.OnPlayerLatejoin(user)
	return TRUE

//Proc to check if a specific user can edit this spawner (open/close/...)
/datum/ghostspawner/proc/can_edit(mob/user)
	if(check_rights(req_perms_edit, show_msg=FALSE, user=user))
		return TRUE
	return FALSE

/datum/ghostspawner/proc/is_enabled()
	if(loc_type == GS_LOC_ATOM)
		return enabled && !!length(spawn_atoms)
	if(max_count)
		return enabled && count < max_count
	return enabled

//Proc to enable the ghostspawner
/datum/ghostspawner/proc/enable()
	if((max_count - count) <= 0)
		to_chat(usr, "The ghostspawner can not be enabled - No slots available")
		return
	if(usr)
		log_and_message_admins("has enabled the ghostspawner [src.name]")
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
	if(loc_type == GS_LOC_POS)
		for(var/i in SSghostroles.spawnpoints)
			SSghostroles.update_spawnpoint_status_by_identifier(i)
	return TRUE
