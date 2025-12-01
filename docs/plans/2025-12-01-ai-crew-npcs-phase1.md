# AI Crew NPCs - Phase 1 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create the foundation for AI-controlled crew NPCs that fill unfilled job slots at round start, starting with a basic NPC mob, coordination subsystem, LLM integration, and an Assistant job module.

**Architecture:** Four-layer system - Base NPC mob extends `/mob/living/carbon/human` with AI behaviors, job modules provide role-specific routines, LLM integration handles conversations, and a coordination subsystem manages spawning/tracking. Phase 1 implements minimal versions of each layer.

**Tech Stack:** BYOND/DM language, local Ollama LLM via HTTP, existing SS13 mob and subsystem patterns.

---

## Prerequisites

- Working BYOND development environment
- Ollama installed locally with a model (e.g., `ollama run llama3`)
- Worktree at `.worktrees/ai-crew-npcs` on branch `feature/ai-crew-npcs`

---

## Task 1: Create NPC Crew Config Files

**Files:**
- Create: `config/npc_crew.txt`
- Create: `config/llm.txt`

**Step 1: Create NPC crew config**

Create `config/npc_crew.txt`:

```
## NPC Crew Configuration

## Enable/disable the AI crew system
## NPC_CREW_ENABLED

## Maximum NPCs to spawn (0 = fill all empty slots)
## NPC_CREW_MAX_COUNT 15

## Jobs NPCs cannot fill (space-separated)
## NPC_CREW_BLOCKED_JOBS captain head_of_personnel

## Allow NPCs as antagonists
## NPC_CREW_ANTAG_ENABLED
```

**Step 2: Create LLM config**

Create `config/llm.txt`:

```
## Local LLM Configuration for NPC Crew

## Ollama API endpoint
## LLM_ENDPOINT http://127.0.0.1:11434/api/generate

## Model name to use
## LLM_MODEL llama3

## Request timeout in deciseconds (100 = 10 seconds)
## LLM_TIMEOUT 100

## Enable fallback to scripted dialogue if LLM unavailable
## LLM_FALLBACK_ENABLED
```

**Step 3: Commit**

```bash
git add config/npc_crew.txt config/llm.txt
git commit -m "feat(npc-crew): add configuration files for NPC crew and LLM"
```

---

## Task 2: Create Config Loading Code

**Files:**
- Create: `code/controllers/configuration/entries/npc_crew.dm`
- Modify: `code/controllers/configuration/configuration.dm` (add include)

**Step 1: Create config entry datums**

Create `code/controllers/configuration/entries/npc_crew.dm`:

```dm
// NPC Crew configuration entries

/datum/config_entry/flag/npc_crew_enabled

/datum/config_entry/number/npc_crew_max_count
	default = 15
	min_val = 0
	max_val = 50

/datum/config_entry/str_list/npc_crew_blocked_jobs

/datum/config_entry/flag/npc_crew_antag_enabled

// LLM configuration entries

/datum/config_entry/string/llm_endpoint
	default = "http://127.0.0.1:11434/api/generate"

/datum/config_entry/string/llm_model
	default = "llama3"

/datum/config_entry/number/llm_timeout
	default = 100
	min_val = 10
	max_val = 600

/datum/config_entry/flag/llm_fallback_enabled
```

**Step 2: Add include to configuration.dm**

Find the configuration includes section in `code/controllers/configuration/configuration.dm` and add:

```dm
#include "entries/npc_crew.dm"
```

**Step 3: Verify config loads**

Compile the project to check for syntax errors:
```bash
DreamMaker aurorastation.dme
```

**Step 4: Commit**

```bash
git add code/controllers/configuration/entries/npc_crew.dm
git add code/controllers/configuration/configuration.dm
git commit -m "feat(npc-crew): add config entry datums for NPC crew and LLM settings"
```

---

## Task 3: Create Base NPC Datum

**Files:**
- Create: `code/modules/npc_crew/_npc_crew.dm`
- Create: `code/modules/npc_crew/npc_datum.dm`

**Step 1: Create module folder and base include file**

Create `code/modules/npc_crew/_npc_crew.dm`:

```dm
// NPC Crew System
// AI-controlled crew members that fill unfilled job slots

// This file must be included first in the module
```

**Step 2: Create NPC tracking datum**

Create `code/modules/npc_crew/npc_datum.dm`:

```dm
/// Datum that tracks an NPC crew member and their state
/datum/npc_crew_member
	/// The human mob this NPC controls
	var/mob/living/carbon/human/body
	/// The job datum assigned to this NPC
	var/datum/job/assigned_job
	/// Current behavioral state: "idle", "working", "fleeing", "socializing"
	var/state = "idle"
	/// Personality traits list (e.g., "cheerful", "nervous", "formal")
	var/list/personality_traits = list()
	/// Whether this NPC has been initialized
	var/initialized = FALSE

/datum/npc_crew_member/New(mob/living/carbon/human/H, datum/job/J)
	. = ..()
	body = H
	assigned_job = J
	generate_personality()

/datum/npc_crew_member/Destroy()
	body = null
	assigned_job = null
	. = ..()

/// Generate random personality traits for this NPC
/datum/npc_crew_member/proc/generate_personality()
	var/list/possible_traits = list(
		"cheerful",
		"nervous",
		"formal",
		"casual",
		"lazy",
		"diligent",
		"talkative",
		"quiet",
		"friendly",
		"aloof"
	)
	// Pick 2-3 random traits
	var/num_traits = rand(2, 3)
	for(var/i in 1 to num_traits)
		if(!length(possible_traits))
			break
		var/trait = pick(possible_traits)
		personality_traits += trait
		possible_traits -= trait

/// Initialize this NPC's AI behaviors
/datum/npc_crew_member/proc/initialize_ai()
	if(initialized)
		return
	initialized = TRUE
	// Register with the NPC subsystem for processing
	if(SSnpc_crew)
		SSnpc_crew.register_npc(src)

/// Called each processing tick by the subsystem
/datum/npc_crew_member/proc/process_ai()
	if(!body || body.stat == DEAD)
		return FALSE
	// Base processing - to be expanded
	return TRUE

/// Get a string describing this NPC's personality for LLM context
/datum/npc_crew_member/proc/get_personality_description()
	if(!length(personality_traits))
		return "average personality"
	return english_list(personality_traits)
```

**Step 3: Commit**

```bash
git add code/modules/npc_crew/
git commit -m "feat(npc-crew): add base NPC crew member datum with personality system"
```

---

## Task 4: Create NPC Crew Subsystem

**Files:**
- Create: `code/controllers/subsystems/npc_crew.dm`

**Step 1: Create the subsystem**

Create `code/controllers/subsystems/npc_crew.dm`:

```dm
SUBSYSTEM_DEF(npc_crew)
	name = "NPC Crew"
	flags = SS_BACKGROUND
	wait = 10 // Process every 1 second
	priority = FIRE_PRIORITY_NPC

	/// List of all active NPC crew members
	var/list/datum/npc_crew_member/npcs = list()
	/// Whether the system is enabled
	var/enabled = FALSE
	/// Maximum NPCs allowed
	var/max_npcs = 15
	/// Jobs NPCs cannot fill
	var/list/blocked_jobs = list()

/datum/controller/subsystem/npc_crew/Initialize()
	// Load configuration
	enabled = config.npc_crew_enabled
	if(!enabled)
		flags |= SS_NO_FIRE
		return ..()

	max_npcs = config.npc_crew_max_count
	if(config.npc_crew_blocked_jobs)
		blocked_jobs = config.npc_crew_blocked_jobs.Copy()

	return ..()

/datum/controller/subsystem/npc_crew/fire(resumed = FALSE)
	if(!enabled)
		return

	// Process each NPC
	for(var/datum/npc_crew_member/npc in npcs)
		if(!npc.process_ai())
			// NPC is dead or invalid, remove them
			unregister_npc(npc)

/// Register an NPC for processing
/datum/controller/subsystem/npc_crew/proc/register_npc(datum/npc_crew_member/npc)
	if(npc in npcs)
		return
	npcs += npc

/// Unregister an NPC from processing
/datum/controller/subsystem/npc_crew/proc/unregister_npc(datum/npc_crew_member/npc)
	npcs -= npc

/// Get count of active NPCs
/datum/controller/subsystem/npc_crew/proc/get_npc_count()
	return length(npcs)

/// Check if a job is blocked from NPC filling
/datum/controller/subsystem/npc_crew/proc/is_job_blocked(datum/job/J)
	if(!J)
		return TRUE
	var/job_id = ckey(J.title)
	return (job_id in blocked_jobs)

/// Spawn NPCs for unfilled job slots - called after job assignment
/datum/controller/subsystem/npc_crew/proc/spawn_npcs_for_unfilled_slots()
	if(!enabled)
		return

	var/spawned = 0
	for(var/datum/job/J in SSjobs.occupations)
		if(is_job_blocked(J))
			continue
		// Check for unfilled slots
		var/unfilled = J.total_positions - J.current_positions
		if(unfilled <= 0)
			continue
		// Spawn NPCs for unfilled slots
		for(var/i in 1 to unfilled)
			if(max_npcs > 0 && get_npc_count() >= max_npcs)
				return spawned
			if(spawn_npc_for_job(J))
				spawned++

	log_game("NPC Crew: Spawned [spawned] NPCs for unfilled job slots")
	return spawned

/// Spawn a single NPC for a specific job
/datum/controller/subsystem/npc_crew/proc/spawn_npc_for_job(datum/job/J)
	// Find spawn location
	var/turf/spawn_loc = J.get_roundstart_spawn_point()
	if(!spawn_loc)
		// Fallback to a latejoin spawn
		var/obj/effect/landmark/start/sloc = locate(/obj/effect/landmark/start/assistant)
		if(sloc)
			spawn_loc = get_turf(sloc)
	if(!spawn_loc)
		return FALSE

	// Create the human mob
	var/mob/living/carbon/human/H = new(spawn_loc)

	// Generate random appearance
	H.gender = pick(MALE, FEMALE)
	H.real_name = random_name(H.gender, species = SPECIES_HUMAN)
	H.name = H.real_name

	// Create mind and assign job
	H.mind_initialize()
	H.mind.assigned_role = J.title

	// Equip the job
	SSjobs.EquipRank(H, J.title, FALSE)
	J.current_positions++

	// Create NPC datum and initialize AI
	var/datum/npc_crew_member/npc = new(H, J)
	npc.initialize_ai()

	// Mark mob as NPC-controlled (for internal tracking)
	H.npc_crew_datum = npc

	return TRUE
```

**Step 2: Commit**

```bash
git add code/controllers/subsystems/npc_crew.dm
git commit -m "feat(npc-crew): add NPC crew subsystem for spawning and processing"
```

---

## Task 5: Add NPC Variable to Human Mob

**Files:**
- Modify: `code/modules/mob/living/carbon/human/human.dm`

**Step 1: Add NPC tracking variable**

Find the variable declarations section at the top of `/mob/living/carbon/human` in `code/modules/mob/living/carbon/human/human.dm` and add:

```dm
	/// If this human is controlled by the NPC crew system, this holds their datum
	var/datum/npc_crew_member/npc_crew_datum
```

**Step 2: Add helper proc**

Add this proc to the human mob (can be at end of file or in a logical location):

```dm
/// Returns TRUE if this human is an NPC crew member
/mob/living/carbon/human/proc/is_npc_crew()
	return !isnull(npc_crew_datum)
```

**Step 3: Commit**

```bash
git add code/modules/mob/living/carbon/human/human.dm
git commit -m "feat(npc-crew): add NPC crew datum variable to human mob"
```

---

## Task 6: Hook NPC Spawning into Round Start

**Files:**
- Modify: `code/controllers/subsystems/ticker.dm`

**Step 1: Find the round start job assignment**

In `code/controllers/subsystems/ticker.dm`, find where `SSjobs.DivideOccupations()` is called during round start. After job assignment completes, add the NPC spawning call:

```dm
// After SSjobs.DivideOccupations() completes:
SSnpc_crew.spawn_npcs_for_unfilled_slots()
```

The exact location will depend on the ticker structure. Look for code that happens after players are assigned jobs but before the round fully begins.

**Step 2: Commit**

```bash
git add code/controllers/subsystems/ticker.dm
git commit -m "feat(npc-crew): hook NPC spawning into round start after job assignment"
```

---

## Task 7: Create LLM Controller Datum

**Files:**
- Create: `code/modules/npc_crew/llm_controller.dm`

**Step 1: Create the LLM controller**

Create `code/modules/npc_crew/llm_controller.dm`:

```dm
/// Controller for communicating with the local LLM
/datum/llm_controller
	/// API endpoint URL
	var/endpoint = "http://127.0.0.1:11434/api/generate"
	/// Model name
	var/model = "llama3"
	/// Timeout in deciseconds
	var/timeout = 100
	/// Whether fallback is enabled
	var/fallback_enabled = TRUE
	/// Whether the LLM is available (set after first connection attempt)
	var/available = null

/datum/llm_controller/New()
	. = ..()
	// Load config
	endpoint = config.llm_endpoint || endpoint
	model = config.llm_model || model
	timeout = config.llm_timeout || timeout
	fallback_enabled = config.llm_fallback_enabled

/// Request a response from the LLM
/// Returns the response text, or null if failed/unavailable
/datum/llm_controller/proc/request(prompt, context = "", system_prompt = "")
	if(available == FALSE && fallback_enabled)
		return null

	var/list/request_body = list(
		"model" = model,
		"prompt" = prompt,
		"stream" = FALSE
	)

	if(system_prompt)
		request_body["system"] = system_prompt

	var/datum/http_request/req = new()
	req.prepare(RUSTG_HTTP_METHOD_POST, endpoint, json_encode(request_body), list("Content-Type" = "application/json"))
	req.begin_async()

	// Wait for response with timeout
	var/start_time = world.time
	while(!req.is_complete())
		if(world.time - start_time > timeout)
			log_debug("LLM request timed out after [timeout] ds")
			if(available == null)
				available = FALSE
			return null
		sleep(1)

	var/datum/http_response/res = req.into_response()
	if(res.errored || res.status_code != 200)
		log_debug("LLM request failed: [res.error]")
		if(available == null)
			available = FALSE
		return null

	if(available == null)
		available = TRUE

	// Parse response
	var/list/response_data = json_decode(res.body)
	if(!response_data || !response_data["response"])
		return null

	return response_data["response"]

/// Generate a fallback response when LLM is unavailable
/datum/llm_controller/proc/get_fallback_response(context = "")
	var/list/generic_responses = list(
		"Hmm, let me think about that.",
		"I'm not sure what to say.",
		"Interesting...",
		"I'll have to get back to you on that.",
		"*nods thoughtfully*"
	)
	return pick(generic_responses)

/// Global LLM controller instance
var/global/datum/llm_controller/llm_controller

/proc/get_llm_controller()
	if(!llm_controller)
		llm_controller = new()
	return llm_controller
```

**Step 2: Commit**

```bash
git add code/modules/npc_crew/llm_controller.dm
git commit -m "feat(npc-crew): add LLM controller for Ollama integration"
```

---

## Task 8: Add NPC Speech Handler

**Files:**
- Create: `code/modules/npc_crew/npc_speech.dm`

**Step 1: Create speech handling for NPCs**

Create `code/modules/npc_crew/npc_speech.dm`:

```dm
/// Handle when someone speaks to or near an NPC
/datum/npc_crew_member/proc/handle_heard_speech(mob/speaker, message)
	if(!body || body.stat != CONSCIOUS)
		return
	if(speaker == body)
		return // Don't respond to ourselves

	// Check if we're being addressed (simple check - speaker is close and facing us)
	if(get_dist(speaker, body) > 7)
		return

	// Build context for LLM
	var/context = build_speech_context(speaker, message)
	var/system_prompt = build_system_prompt()

	// Request LLM response
	var/datum/llm_controller/llm = get_llm_controller()
	var/response = llm.request(context, "", system_prompt)

	if(!response && llm.fallback_enabled)
		response = llm.get_fallback_response(context)

	if(response)
		// Delay response slightly for realism
		spawn(rand(10, 30))
			if(body && body.stat == CONSCIOUS)
				body.say(response)

/// Build the context string for an LLM request
/datum/npc_crew_member/proc/build_speech_context(mob/speaker, message)
	var/speaker_name = speaker.name || "Someone"
	return "[speaker_name] says: \"[message]\""

/// Build the system prompt describing who this NPC is
/datum/npc_crew_member/proc/build_system_prompt()
	var/job_title = assigned_job ? assigned_job.title : "Crew Member"
	var/personality = get_personality_description()

	return {"You are [body.real_name], a [job_title] on a space station.
Your personality: [personality].
Respond naturally and briefly (1-2 sentences max).
Stay in character. You are having a casual conversation with a coworker.
Do not use quotation marks in your response."}
```

**Step 2: Commit**

```bash
git add code/modules/npc_crew/npc_speech.dm
git commit -m "feat(npc-crew): add NPC speech handler with LLM integration"
```

---

## Task 9: Hook Speech into Hearing System

**Files:**
- Modify: `code/modules/mob/living/carbon/human/human.dm` (or wherever `Hear()` is defined)

**Step 1: Find the Hear proc**

Locate where `/mob/living/carbon/human/Hear()` or the equivalent hearing proc is defined. Add NPC speech handling:

```dm
/mob/living/carbon/human/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	. = ..()
	// If this is an NPC, let them process the speech
	if(npc_crew_datum && speaker != src)
		npc_crew_datum.handle_heard_speech(speaker, raw_message)
```

Note: The exact proc signature and location depends on the codebase. Search for "Hear" in human-related files.

**Step 2: Commit**

```bash
git add code/modules/mob/living/carbon/human/human.dm
git commit -m "feat(npc-crew): hook NPC speech processing into human Hear proc"
```

---

## Task 10: Create Assistant Job Module

**Files:**
- Create: `code/modules/npc_crew/job_modules/_job_module.dm`
- Create: `code/modules/npc_crew/job_modules/assistant.dm`

**Step 1: Create base job module datum**

Create `code/modules/npc_crew/job_modules/_job_module.dm`:

```dm
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
```

**Step 2: Create assistant job module**

Create `code/modules/npc_crew/job_modules/assistant.dm`:

```dm
/// Job module for Assistant role - the simplest NPC behavior
/datum/npc_job_module/assistant
	job_title = "Assistant"
	work_areas = list(/area/hallway, /area/crew_quarters)

/datum/npc_job_module/assistant/process()
	if(!owner || !owner.body)
		return

	var/mob/living/carbon/human/H = owner.body
	if(H.stat != CONSCIOUS)
		return

	// Simple behavior: occasionally wander or emote
	if(prob(5))
		do_idle_behavior()

/datum/npc_job_module/assistant/proc/do_idle_behavior()
	if(!owner || !owner.body)
		return

	var/mob/living/carbon/human/H = owner.body

	// Pick a random idle action
	switch(rand(1, 3))
		if(1)
			// Wander a bit
			var/turf/T = get_step(H, pick(NORTH, SOUTH, EAST, WEST))
			if(T && !T.density)
				H.Move(T)
		if(2)
			// Do an emote
			var/list/emotes = list("yawn", "scratch", "look around", "stretch")
			H.custom_emote(1, pick(emotes))
		if(3)
			// Just stand there
			return

/datum/npc_job_module/assistant/get_available_tasks()
	return list("wander", "idle", "socialize")

/datum/npc_job_module/assistant/on_idle()
	// Assistants are always kind of idle
	return
```

**Step 3: Commit**

```bash
git add code/modules/npc_crew/job_modules/
git commit -m "feat(npc-crew): add base job module and assistant implementation"
```

---

## Task 11: Integrate Job Module with NPC Datum

**Files:**
- Modify: `code/modules/npc_crew/npc_datum.dm`

**Step 1: Add job module variable and initialization**

Add to `/datum/npc_crew_member`:

```dm
	/// The job behavior module for this NPC
	var/datum/npc_job_module/job_module
```

Update the `initialize_ai()` proc:

```dm
/datum/npc_crew_member/proc/initialize_ai()
	if(initialized)
		return
	initialized = TRUE

	// Create job module based on assigned job
	if(assigned_job)
		job_module = create_job_module(assigned_job)

	// Register with the NPC subsystem for processing
	if(SSnpc_crew)
		SSnpc_crew.register_npc(src)

/// Create the appropriate job module for a given job
/datum/npc_crew_member/proc/create_job_module(datum/job/J)
	// For Phase 1, all jobs use assistant module
	// This will be expanded in later phases
	var/datum/npc_job_module/module = new /datum/npc_job_module/assistant(src)
	return module
```

Update the `process_ai()` proc:

```dm
/datum/npc_crew_member/proc/process_ai()
	if(!body || body.stat == DEAD)
		return FALSE

	// Process job module
	if(job_module)
		job_module.process()

	return TRUE
```

Update `Destroy()`:

```dm
/datum/npc_crew_member/Destroy()
	if(job_module)
		qdel(job_module)
		job_module = null
	body = null
	assigned_job = null
	. = ..()
```

**Step 2: Commit**

```bash
git add code/modules/npc_crew/npc_datum.dm
git commit -m "feat(npc-crew): integrate job module with NPC datum processing"
```

---

## Task 12: Add Module Includes to DME

**Files:**
- Modify: `aurorastation.dme`

**Step 1: Add includes for all NPC crew files**

Find the includes section in `aurorastation.dme` and add the NPC crew module files in the correct order:

```dm
#include "code\modules\npc_crew\_npc_crew.dm"
#include "code\modules\npc_crew\npc_datum.dm"
#include "code\modules\npc_crew\llm_controller.dm"
#include "code\modules\npc_crew\npc_speech.dm"
#include "code\modules\npc_crew\job_modules\_job_module.dm"
#include "code\modules\npc_crew\job_modules\assistant.dm"
#include "code\controllers\subsystems\npc_crew.dm"
```

**Step 2: Compile and verify**

```bash
DreamMaker aurorastation.dme
```

Fix any compile errors that arise.

**Step 3: Commit**

```bash
git add aurorastation.dme
git commit -m "feat(npc-crew): add NPC crew module includes to DME"
```

---

## Task 13: Add Admin Verbs

**Files:**
- Create: `code/modules/npc_crew/admin_verbs.dm`

**Step 1: Create admin verbs for NPC management**

Create `code/modules/npc_crew/admin_verbs.dm`:

```dm
/client/proc/check_npc_crew_status()
	set name = "Check NPC Crew Status"
	set category = "Admin.Game"

	if(!check_rights(R_ADMIN))
		return

	if(!SSnpc_crew || !SSnpc_crew.enabled)
		to_chat(src, "<span class='warning'>NPC Crew system is not enabled.</span>")
		return

	var/msg = "<b>NPC Crew Status</b><br>"
	msg += "Active NPCs: [SSnpc_crew.get_npc_count()] / [SSnpc_crew.max_npcs]<br><br>"

	for(var/datum/npc_crew_member/npc in SSnpc_crew.npcs)
		var/job_title = npc.assigned_job ? npc.assigned_job.title : "Unknown"
		var/status = npc.body ? (npc.body.stat == CONSCIOUS ? "Alive" : "Incapacitated") : "No body"
		var/loc = npc.body ? "[get_area(npc.body)]" : "N/A"
		msg += "<b>[npc.body?.real_name || "Unknown"]</b> - [job_title]<br>"
		msg += "  Status: [status], Location: [loc]<br>"
		msg += "  Personality: [npc.get_personality_description()]<br><br>"

	to_chat(src, msg)

/client/proc/force_spawn_npc()
	set name = "Force Spawn NPC"
	set category = "Admin.Game"

	if(!check_rights(R_ADMIN))
		return

	if(!SSnpc_crew)
		to_chat(src, "<span class='warning'>NPC Crew subsystem not initialized.</span>")
		return

	var/list/job_choices = list()
	for(var/datum/job/J in SSjobs.occupations)
		job_choices[J.title] = J

	var/choice = input(src, "Select job for NPC:", "Spawn NPC") as null|anything in job_choices
	if(!choice)
		return

	var/datum/job/selected_job = job_choices[choice]
	if(SSnpc_crew.spawn_npc_for_job(selected_job))
		to_chat(src, "<span class='notice'>Spawned NPC [choice].</span>")
	else
		to_chat(src, "<span class='warning'>Failed to spawn NPC.</span>")
```

**Step 2: Add include to DME**

Add to `aurorastation.dme`:

```dm
#include "code\modules\npc_crew\admin_verbs.dm"
```

**Step 3: Commit**

```bash
git add code/modules/npc_crew/admin_verbs.dm aurorastation.dme
git commit -m "feat(npc-crew): add admin verbs for NPC status and spawning"
```

---

## Task 14: Final Compilation and Testing

**Step 1: Full compile**

```bash
DreamMaker aurorastation.dme
```

Fix all compile errors.

**Step 2: Test checklist**

1. Enable NPC crew in config (uncomment `NPC_CREW_ENABLED` in `config/npc_crew.txt`)
2. Start a local round
3. Verify NPCs spawn for unfilled slots
4. Use admin verb "Check NPC Crew Status" to see active NPCs
5. Speak near an NPC and verify they respond (requires Ollama running)
6. Verify NPCs perform idle behaviors

**Step 3: Commit any fixes**

```bash
git add -A
git commit -m "fix(npc-crew): compilation fixes and adjustments"
```

---

## Summary

Phase 1 creates the foundation:

| Component | Status |
|-----------|--------|
| Config files | Created |
| NPC datum | Created with personality system |
| NPC subsystem | Created with spawn/process logic |
| LLM controller | Created for Ollama integration |
| Speech handling | Created with LLM responses |
| Assistant job module | Created with basic idle behaviors |
| Admin verbs | Created for monitoring/control |

**Next phases will add:**
- Phase 2: Engineering, Medical, Security, Service job modules
- Phase 3: Command and Science job modules
- Phase 4: Antagonist integration
- Phase 5: Polish and advanced behaviors
