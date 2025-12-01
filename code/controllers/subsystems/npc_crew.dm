// NPC Crew Subsystem
// Manages spawning and processing of AI crew members

SUBSYSTEM_DEF(npc_crew)
	name = "NPC Crew"
	priority = FIRE_PRIORITY_NPC_ACTIONS
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = INIT_ORDER_DEFAULT

	/// List of all registered NPC crew members
	var/list/datum/npc_crew_member/npcs = list()
	/// Whether the NPC spawning system is enabled
	var/enabled = TRUE
	/// Maximum number of NPCs that can be active at once
	var/max_npcs = 10
	/// List of job titles that NPCs cannot fill
	var/list/blocked_jobs = list()
	/// Current processing run list
	var/list/currentrun = list()

/datum/controller/subsystem/npc_crew/Initialize()
	// Load config settings if they exist
	if(GLOB.config)
		// Future config loading will go here
		// For now, using default values
		enabled = TRUE
		max_npcs = 10
		blocked_jobs = list()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/npc_crew/fire(resumed = FALSE)
	if(!enabled)
		return

	if(!resumed)
		currentrun = npcs.Copy()

	var/list/current_run = currentrun

	while(length(current_run))
		var/datum/npc_crew_member/npc = current_run[length(current_run)]
		current_run.len--

		if(QDELETED(npc))
			npcs -= npc
			continue

		// Process the NPC's AI
		npc.process_ai()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/npc_crew/stat_entry(msg)
	msg = "NPCs:[length(npcs)]/[max_npcs]"
	return ..()

/// Registers an NPC with the subsystem for processing
/datum/controller/subsystem/npc_crew/proc/register_npc(datum/npc_crew_member/npc)
	if(!npc || QDELETED(npc))
		return FALSE

	if(npc in npcs)
		return FALSE

	npcs += npc
	return TRUE

/// Unregisters an NPC from the subsystem
/datum/controller/subsystem/npc_crew/proc/unregister_npc(datum/npc_crew_member/npc)
	if(!npc)
		return FALSE

	npcs -= npc
	return TRUE

/// Returns the current number of active NPCs
/datum/controller/subsystem/npc_crew/proc/get_npc_count()
	return length(npcs)

/// Checks if a job is blocked from NPC assignment
/datum/controller/subsystem/npc_crew/proc/is_job_blocked(job_title)
	if(!job_title)
		return TRUE

	return (job_title in blocked_jobs)

/// Spawns NPCs for unfilled job slots
/// Returns the number of NPCs spawned
/datum/controller/subsystem/npc_crew/proc/spawn_npcs_for_unfilled_slots()
	if(!enabled)
		return 0

	if(get_npc_count() >= max_npcs)
		return 0

	var/spawned = 0

	// Iterate through all available jobs
	for(var/datum/job/job in SSjobs.occupations)
		if(!job)
			continue

		// Skip if we've hit the NPC limit
		if(get_npc_count() >= max_npcs)
			break

		// Skip blocked jobs
		if(is_job_blocked(job.title))
			continue

		// Check if the job has unfilled positions
		var/total_positions = job.get_total_positions()
		if(total_positions == -1) // Unlimited positions
			continue

		var/unfilled = total_positions - job.current_positions
		if(unfilled <= 0)
			continue

		// Try to spawn an NPC for this job
		if(spawn_npc_for_job(job))
			spawned++
			job.current_positions++

	return spawned

/// Spawns a single NPC for a specific job
/// Returns TRUE on success, FALSE on failure
/datum/controller/subsystem/npc_crew/proc/spawn_npc_for_job(datum/job/job)
	if(!job)
		return FALSE

	if(!enabled)
		return FALSE

	if(get_npc_count() >= max_npcs)
		return FALSE

	if(is_job_blocked(job.title))
		return FALSE

	// Find a spawn location
	var/turf/spawn_location
	if(length(GLOB.latejoin))
		spawn_location = pick(GLOB.latejoin)
	else
		log_debug("SSnpc_crew: No latejoin spawns available")
		return FALSE

	// Create the human mob
	var/mob/living/carbon/human/H = new(spawn_location)
	if(!H)
		log_debug("SSnpc_crew: Failed to create human mob for [job.title]")
		return FALSE

	// Generate a random name
	// Using a simple NPC naming scheme - will be improved in later phases
	H.real_name = "NPC-[rand(1000, 9999)]"
	H.name = H.real_name

	// Create a mind for the NPC
	if(!H.mind)
		H.mind = new /datum/mind(null)
		H.mind.active = TRUE
		H.mind.current = H

	// Assign the job
	H.mind.assigned_role = job.title
	H.job = job.title

	// Equip the NPC with their job's gear
	// Using latejoin = TRUE since NPCs spawn after roundstart
	SSjobs.EquipRank(H, job.title, TRUE)

	// Create the NPC datum to handle AI behavior
	var/datum/npc_crew_member/npc_datum = new(H, job)
	if(!npc_datum)
		log_debug("SSnpc_crew: Failed to create NPC datum for [job.title]")
		qdel(H)
		return FALSE

	log_debug("SSnpc_crew: Successfully spawned NPC [H.real_name] as [job.title]")
	return TRUE
