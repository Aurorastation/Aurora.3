// NPC crew member tracking datum
// Handles AI behavior, personality, and state management for NPC crew

// List of possible personality traits
GLOBAL_LIST_INIT(npc_personality_traits, list(
	"diligent",
	"cautious",
	"efficient",
	"friendly",
	"reserved",
	"methodical",
	"adaptable",
	"thorough",
	"practical",
	"observant"
))

/datum/npc_crew_member
	/// Reference to the mob body
	var/mob/living/carbon/human/body
	/// The job datum assigned to this NPC
	var/datum/job/assigned_job
	/// The job behavior module for this NPC
	var/datum/npc_job_module/job_module
	/// Current state (idle, working, etc)
	var/state = "idle"
	/// List of personality trait strings
	var/list/personality_traits = list()
	/// Whether the NPC has been initialized
	var/initialized = FALSE

/datum/npc_crew_member/New(mob/living/carbon/human/target_mob, datum/job/job)
	if(!target_mob || !job)
		stack_trace("NPC crew member created with invalid mob or job")
		qdel(src)
		return

	body = target_mob
	assigned_job = job

	generate_personality()
	initialize_ai()

/datum/npc_crew_member/Destroy()
	// Unregister from subsystem
	if(initialized)
		SSnpc_crew.unregister_npc(src)

	// Clean up job module
	if(job_module)
		qdel(job_module)
		job_module = null

	// Clean up references
	body = null
	assigned_job = null
	personality_traits = null

	return ..()

/// Generates a random personality for this NPC by selecting 2-3 traits
/datum/npc_crew_member/proc/generate_personality()
	personality_traits = list()

	var/trait_count = rand(2, 3)
	var/list/available_traits = GLOB.npc_personality_traits.Copy()

	for(var/i = 1 to trait_count)
		if(!length(available_traits))
			break
		var/trait = pick(available_traits)
		personality_traits += trait
		available_traits -= trait

/// Initializes the AI and registers with the NPC crew subsystem
/datum/npc_crew_member/proc/initialize_ai()
	if(initialized)
		return FALSE
	initialized = TRUE

	// Create job module based on assigned job
	if(assigned_job)
		job_module = create_job_module(assigned_job)

	// Register with the NPC subsystem for processing
	if(SSnpc_crew)
		SSnpc_crew.register_npc(src)

	return TRUE

/// Create the appropriate job module for a given job
/datum/npc_crew_member/proc/create_job_module(datum/job/J)
	// For Phase 1, all jobs use assistant module
	// This will be expanded in later phases
	var/datum/npc_job_module/module = new /datum/npc_job_module/assistant(src)
	return module

/// Called by the subsystem to process AI behavior
/datum/npc_crew_member/proc/process_ai()
	if(!body || QDELETED(body))
		return FALSE

	if(body.stat == DEAD)
		return FALSE

	// Process job module
	if(job_module)
		job_module.process()

	return TRUE

/// Returns a human-readable description of the NPC's personality
/datum/npc_crew_member/proc/get_personality_description()
	if(!length(personality_traits))
		return "unremarkable"

	return english_list(personality_traits)
