/// Base job module that defines role-specific behaviors for NPCs
/datum/npc_job_module
	/// The NPC this module is attached to
	var/datum/npc_crew_member/owner
	/// Job title this module handles
	var/job_title = "Assistant"
	/// Current task being performed
	var/current_task = null
	/// Work areas (list of area types this job frequents)
	var/list/work_areas = list()
	/// Capability level (1-3)
	var/capability_level = 1

/datum/npc_job_module/New(datum/npc_crew_member/npc)
	. = ..()
	owner = npc

/datum/npc_job_module/Destroy()
	owner = null
	. = ..()

/// Called each processing tick
/datum/npc_job_module/proc/process()
	return

/// Get a list of tasks this module can perform
/datum/npc_job_module/proc/get_available_tasks()
	return list()

/// Called when the NPC should start working
/datum/npc_job_module/proc/start_work()
	return

/// Called when entering idle state
/datum/npc_job_module/proc/on_idle()
	return
