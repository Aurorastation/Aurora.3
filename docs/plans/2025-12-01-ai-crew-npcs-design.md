# AI Crew NPCs Design Document

## Overview

AI crew NPCs that fill unfilled job slots at round start, acting as indistinguishable crewmembers alongside players. NPCs use a hybrid AI approach: behavior trees for routine actions, local LLM (Ollama/llama.cpp) for conversations and complex judgment calls.

## Key Decisions

- **Spawning**: Round-start only; NPCs fill unfilled slots, leave/reassign if player joins that role
- **Job Coverage**: All jobs including command roles
- **Intelligence**: Full player-like simulation with judgment calls, conversations, crisis handling
- **LLM**: Local model required (Ollama/llama.cpp), server-configured
- **Identification**: Indistinguishable from players
- **Antag Integration**: Full - can be antags, targets, and converted
- **Capability**: Progressive - start with core systems, expand over time

## Architecture

Four-layer system:

```
┌─────────────────────────────────────┐
│     Coordination Subsystem          │  Manages spawning, job assignment, NPC cooperation
├─────────────────────────────────────┤
│     Intelligence Layer (LLM)        │  Conversations, complex decisions
├─────────────────────────────────────┤
│     Job Behavior Modules            │  Role-specific routines and skills
├─────────────────────────────────────┤
│     Base NPC Mob                    │  Core survival, movement, basic interactions
└─────────────────────────────────────┘
```

## Layer 1: Base NPC Mob

**Path**: `/mob/living/carbon/human/npc`

Extends human mob with fundamental NPC behaviors:

- **Survival instincts** - Seek food when hungry, flee immediate threats, find safety when injured
- **Navigation** - Pathfinding using existing SS13 systems, door/airlock usage, avoiding hazards (fire, space, electrified grilles)
- **Basic interactions** - Pick up/drop items, use simple machines, open containers, wear clothing/equipment
- **Perception** - Awareness of nearby mobs, objects, and environmental dangers via view/hearing range
- **State machine** - Idle, working, fleeing, socializing, unconscious - with transitions based on stimuli

The base layer knows nothing about jobs. A base NPC with no job module would wander, eat, sleep, and avoid death.

## Layer 2: Job Behavior Modules

**Path**: `/datum/npc_job_module/`

Job modules attach to base NPCs, defining role-specific behaviors:

```
/datum/npc_job_module
    ├── /engineering      (power, repairs, atmos basics)
    ├── /medical          (triage, treatment, chemistry)
    ├── /security         (patrol, arrests, threats)
    ├── /command          (coordination, decisions, alerts)
    ├── /service          (bartender, chef, botanist, janitor)
    ├── /cargo            (orders, mining, delivery)
    ├── /science          (research, xenobio, robotics)
    └── /civilian         (assistant, chaplain, lawyer)
```

### Module Structure

Each module contains:

- **Task queue** - Prioritized list of actions (fix APC, heal patient, patrol area)
- **Skill definitions** - What complex systems this role can use (surgery, atmospherics, chemistry recipes)
- **Work areas** - Where this NPC belongs (medbay, engineering, bridge)
- **Routine behaviors** - Idle-time actions (chef cooks, janitor cleans, lawyer loiters)
- **Response triggers** - Role-specific reactions (doctor responds to medical alerts, engineer to power alarms)

### Progressive Capability

Each module has a `capability_level` variable:

- **Level 1** - Basic tasks only (engineer: check APCs, simple repairs)
- **Level 2** - Intermediate (engineer: solars, basic piping)
- **Level 3** - Advanced (engineer: full atmos, engine setup, complex repairs)

Servers configure max level. New job modules start at Level 1; levels unlock as behaviors are coded and tested.

## Layer 3: Intelligence Layer (LLM)

**Path**: `/datum/npc_intelligence/`

Bridges NPCs to local LLM for conversations and complex judgment calls.

### LLM Controller

**Path**: `/datum/llm_controller/`

- Connects to local Ollama/llama.cpp endpoint from server config
- Manages request queue with rate limiting and prioritization
- Handles timeouts gracefully - falls back to simple responses if LLM slow/down
- Batches nearby conversations when possible to reduce latency

### When LLM Is Invoked

Selective invocation (not every action):

- **Conversations** - Player speaks to NPC or NPC needs to communicate
- **Complex decisions** - Ambiguous situations behavior trees can't handle
- **Antag planning** - NPC antagonists query for objective strategies
- **Crisis judgment** - Unusual situations outside normal job routines

### Context Building

Each LLM request includes:

- NPC identity (name, job, personality traits)
- Current situation (location, nearby people, recent events)
- Job-relevant knowledge (department status, current tasks)
- Antag objectives if applicable
- Recent conversation history (last 5-10 exchanges)

### Personality System

NPCs get generated personality traits at spawn (nervous, cheerful, formal, lazy, etc.) that influence LLM prompts, making each NPC feel distinct.

## Layer 4: Coordination Subsystem

**Path**: `/datum/controller/subsystem/npc_crew`

Orchestrates all AI crew at round level.

### Round-Start Spawning

1. After job assignment completes, check for unfilled slots
2. For each empty slot, spawn NPC at appropriate spawn point
3. Assign job module, generate name/appearance/personality
4. Register NPC in tracking list

### Job Handoff (Player Joins Mid-Round)

When player joins a role an NPC holds:

- NPC receives "reassignment" event
- If other unfilled jobs exist, NPC transfers (changes ID, gets new job module)
- If no jobs available, NPC becomes assistant or leaves (cryo, "transfer shuttle")

### NPC-to-NPC Cooperation

- **Broadcast channels** - NPCs listen to department radio, respond to calls
- **Task sharing** - Overwhelmed NPCs offload tasks to nearby same-department NPCs
- **Command chain** - Command NPCs issue orders as high-priority tasks
- **Group behaviors** - Emergency response (multiple NPCs respond to crisis areas)

### Tracking & Cleanup

- Maintains list of active NPCs and their states
- Handles NPC death (removes from tracking, no respawn)
- Provides admin verbs for monitoring/control

## Antagonist Integration

### Antag Selection

NPCs participate in normal antag rolling:

- Weighted same as players (or configurable weight)
- Can roll any antag type: traitor, changeling, vampire, cult, rev, etc.
- Objectives generated normally

### NPC Antag Behavior

**Path**: `/datum/npc_antag_module/`

Overrides/extends job behavior for antag NPCs:

- **Objective parsing** - LLM interprets objectives into actionable sub-goals
- **Opportunity detection** - Recognizes good moments to act (target alone, no cameras)
- **Resource gathering** - Acquires tools for objectives
- **Cover maintenance** - Continues job duties to avoid suspicion

### Conversion Mechanics

Full support for conversion antags:

- **Cult** - Can be converted, draws runes, chants, converts others
- **Revolution** - Can be flashed, follows head rev orders, recruits
- **Thralls/Vampires** - Can be enthralled, serves master

Converted NPCs get modified behavior priorities favoring new allegiance.

### As Targets

- NPCs can be assassination/steal targets
- Resist appropriately (flee, fight, call security) based on personality
- Command NPCs have appropriate paranoia levels

## Configuration

### NPC Crew Config (`config/npc_crew.txt`)

```
## NPC Crew Configuration

# Enable/disable the system
NPC_CREW_ENABLED = TRUE

# Max NPCs to spawn (0 = fill all empty slots)
NPC_CREW_MAX_COUNT = 15

# Jobs NPCs can fill (comma-separated, or ALL)
NPC_CREW_ALLOWED_JOBS = ALL

# Jobs NPCs cannot fill (overrides above)
NPC_CREW_BLOCKED_JOBS = captain,head of personnel

# Capability level cap (1-3)
NPC_CREW_CAPABILITY_LEVEL = 2

# Allow NPCs as antagonists
NPC_CREW_ANTAG_ENABLED = TRUE

# Antag weight multiplier (1.0 = same as players)
NPC_CREW_ANTAG_WEIGHT = 0.8
```

### LLM Config (`config/llm.txt`)

```
# Local LLM endpoint (Ollama default)
LLM_ENDPOINT = http://127.0.0.1:11434/api/generate

# Model name
LLM_MODEL = llama3

# Request timeout (seconds)
LLM_TIMEOUT = 10

# Max concurrent requests
LLM_MAX_CONCURRENT = 5

# Fallback to scripted dialogue if LLM unavailable
LLM_FALLBACK_ENABLED = TRUE
```

### Admin Verbs

- `Check NPC Status` - Lists all NPCs, jobs, current tasks, states
- `Force NPC Action` - Make NPC perform specific behavior
- `Remove NPC` - Despawn NPC cleanly
- `Adjust NPC Count` - Add/remove NPCs mid-round

## Implementation Phases

### Phase 1: Foundation

- Base NPC mob with survival behaviors and navigation
- Coordination subsystem with spawning/tracking
- Basic LLM connection with simple conversation
- One job module at Level 1 (Assistant)

### Phase 2: Core Jobs

- Engineering module (power monitoring, basic repairs)
- Medical module (triage, basic treatment)
- Security module (patrol, respond to alerts)
- Service modules (bartender, chef, janitor)

### Phase 3: Complex Jobs

- Command modules (Captain, HoS, CMO, CE, RD, HoP)
- Science modules (basic research, xenobio)
- Full cargo integration (orders, mining support)

### Phase 4: Full Integration

- Antag modules (traitor, changeling, cult, etc.)
- Advanced capability levels (Level 2-3 for all jobs)
- NPC-to-NPC coordination refinement
- Conversion mechanics

### Phase 5: Polish

- Personality variety and quirks
- Edge case handling
- Performance optimization
- Admin tools expansion
