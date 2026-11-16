/*
General Explination:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to manipulate it. It has four variables and seven procs:

Variables:
- possible_tech is a list of all the /datum/tech that can potentially be researched by the player. The RefreshResearch() proc
(explained later) only goes through those when refreshing what you know. Generally, possible_tech contains ALL of the existing tech
but it is possible to add tech to the game that DON'T start in it (example: Xeno tech). Generally speaking, you don't want to mess
with these since they should be the default version of the datums. They're actually stored in a list rather then using typesof to
refer to them since it makes it a bit easier to search through them for specific information.
- know_tech is the companion list to possible_tech. It's the tech you can actually research and improve. Until it's added to this
list, it can't be improved. All the tech in this list are visible to the player.
- known_designs is functionally identical to known_tech except it's for /datum/design

Procs:
- TechHasReqs: Used by other procs (specifically RefreshResearch) to see whether all of a tech's requirements are currently in
known_tech and at a high enough level.
- DesignHasReqs: Same as TechHasReqs but for /datum/design and known_design.
- AddTech2Known: Adds a /datum/tech to known_tech. It checks to see whether it already has that tech (if so, it just replaces it). If
it doesn't have it, it adds it. Note: It does NOT check possible_tech at all. So if you want to add something strange to it (like
a player made tech?) you can.
- AddDesign2Known: Same as AddTech2Known except for /datum/design and known_designs.
- RefreshResearch: This is the workhorse of the R&D system. It updates the /datum/research holder and adds any unlocked tech paths
and designs you have reached the requirements for. It only checks through possible_tech and designs, however, so it won't
accidentally add "secret" tech to it.
- UpdateTech is used as part of the actual researching process. It takes an ID and finds techs with that same ID in known_tech. When
it finds it, it checks to see whether it can improve it at all. If the known_tech's level is less then or equal to
the inputted level, it increases the known tech's level to the inputted level -1 or know tech's level +1 (whichever is higher).

The tech datums are the actual "tech trees" that you improve through researching. Each one has five variables:
- Name:		Pretty obvious. This is often viewable to the players.
- Desc:		Pretty obvious. Also player viewable.
- ID:		This is the unique ID of the tech that is used by the various procs to find and/or maniuplate it.
- Level:	This is the current level of the tech. All techs start at 1 and have a max of 15. Devices and some techs require a certain
level in specific techs before you can produce them.
- Req_tech:	This is a list of the techs required to unlock this tech path. If left blank, it'll automatically be loaded into the
research holder datum.

*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/

// Global design lists
GLOBAL_LIST_INIT(designs, null)
GLOBAL_LIST_EMPTY(designs_protolathe_categories)
GLOBAL_LIST_EMPTY(designs_imprinter_categories)

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_tech = list()			//List of locally known tech. Datum/tech go here.
	var/list/known_designs = list()			//List of available designs.
	var/list/uploaded_designs = list()		//List of designs manually uploaded from disks.
	var/research_points = 0				//Available research data points to spend on tech nodes
	var/list/unlocked_nodes = list()		//List of unlocked /datum/tech_node IDs
	var/list/invested_points = list()		//node_id -> current invested points (decays on outermost nodes across rounds)
	var/sync_persistence = TRUE
	var/list/active_bounties = list()		//List of active /datum/research_bounty datums
	var/list/completed_bounty_types = list()	//Bounty datum types already completed this round
	var/bounty_counter = 0
	var/bounty_rerolls = 3				//Remaining contract rerolls; +1 granted per completed bounty

	var/standard_start_level				// The level non-antag techs are set at
	var/antag_start_level					// ditto but antag
	var/load_tech = TRUE					// Whether we should gather the techs
	var/load_designs = TRUE					// ditto but designs

/datum/research/New()		//Insert techs into possible_tech here. Known_tech automatically updated.
	if(load_tech)
		for(var/tech_path in subtypesof(/datum/tech))
			var/datum/tech/T = new tech_path(src)
			known_tech[T.id] = T
			if(!T.antag_tech)
				if(standard_start_level)
					T.level = standard_start_level
			else
				if(antag_start_level)
					T.level = antag_start_level
	if(load_designs && isnull(GLOB.designs))
		InitializeDesigns()
	InitializeTechNodes()
	InitializeBounties()
	RefreshResearch()

/datum/research/techonly
	load_designs = FALSE

/datum/research/hightech
	standard_start_level = 3
	research_points = 0

/datum/research/proc/InitializeTechNodes()
	for(var/node_id in GLOB.tech_nodes)
		var/datum/tech_node/node = GLOB.tech_nodes[node_id]
		if(node.starts_unlocked)
			unlocked_nodes |= node.id
	var/singleton/persistent_type/generic/research_tech_nodes/RP = GET_SINGLETON(/singleton/persistent_type/generic/research_tech_nodes)
	if(sync_persistence && RP && length(RP.node_investments))
		for(var/node_id in RP.node_investments)
			var/datum/tech_node/N = GLOB.tech_nodes[node_id]
			var/pts = RP.node_investments[node_id]
			if(N && !N.antag_tech && pts > 0)
				unlocked_nodes |= node_id
				invested_points[node_id] = min(N.cost, pts)

/datum/research/proc/can_unlock_node(node_id)
	if(!GLOB.tech_nodes[node_id])
		return FALSE
	if(node_id in unlocked_nodes)
		return FALSE
	var/datum/tech_node/node = GLOB.tech_nodes[node_id]
	for(var/prereq in node.prereq_ids)
		if(!(prereq in unlocked_nodes))
			return FALSE
	return TRUE

/datum/research/proc/unlock_node(node_id, charge_points = TRUE)
	var/datum/tech_node/node = GLOB.tech_nodes[node_id]
	if(!node)
		return FALSE
	if(charge_points)
		if(!can_unlock_node(node_id))
			return FALSE
		if(research_points < node.cost)
			return FALSE
		research_points -= node.cost

	unlocked_nodes |= node_id
	if(node.cost > 0)
		invested_points[node_id] = node.cost
	if(sync_persistence && !node.antag_tech)
		var/singleton/persistent_type/generic/research_tech_nodes/RP = GET_SINGLETON(/singleton/persistent_type/generic/research_tech_nodes)
		RP?.record_investment(node_id, node.cost)
	RefreshResearch()
	return TRUE

/datum/research/proc/is_outermost_node(node_id)
	if(!(node_id in unlocked_nodes))
		return FALSE
	var/datum/tech_node/N = GLOB.tech_nodes[node_id]
	if(!N || N.starts_unlocked || N.cost <= 0)
		return FALSE
	for(var/other_id in unlocked_nodes)
		if(other_id == node_id)
			continue
		var/datum/tech_node/other = GLOB.tech_nodes[other_id]
		if(other && (node_id in other.prereq_ids))
			return FALSE
	return TRUE

/datum/research/proc/maintain_node(node_id)
	if(!(node_id in unlocked_nodes))
		return 0
	var/datum/tech_node/N = GLOB.tech_nodes[node_id]
	if(!N || N.starts_unlocked || N.cost <= 0 || research_points <= 0)
		return 0
	var/current = invested_points[node_id] || 0
	var/needed = N.cost - current
	if(needed <= 0)
		return 0
	var/to_spend = min(research_points, needed)
	research_points -= to_spend
	invested_points[node_id] = current + to_spend
	if(sync_persistence && !N.antag_tech)
		var/singleton/persistent_type/generic/research_tech_nodes/RP = GET_SINGLETON(/singleton/persistent_type/generic/research_tech_nodes)
		RP?.record_investment(node_id, invested_points[node_id])
	return to_spend

/datum/research/proc/add_research_points(amount)
	if(amount > 0)
		research_points += amount

/datum/research/proc/InitializeBounties()
	active_bounties.Cut()
	for(var/i in 1 to 3)
		var/datum/research_bounty/F = create_bounty("firearms")
		if(F)
			active_bounties += F
		var/datum/research_bounty/XB = create_bounty("xenobotany")
		if(XB)
			active_bounties += XB
		var/datum/research_bounty/X = create_bounty("xenobiology")
		if(X)
			active_bounties += X
		var/datum/research_bounty/C = create_bounty("circuits")
		if(C)
			active_bounties += C
		var/datum/research_bounty/S = create_bounty("survey")
		if(S)
			active_bounties += S
		var/datum/research_bounty/A = create_bounty("xenoarch")
		if(A)
			active_bounties += A

/datum/research/proc/create_bounty(category, exclude_type = null)
	var/base_type = /datum/research_bounty/firearm
	if(category == "xenobotany")
		base_type = /datum/research_bounty/xenobotany
	else if(category == "xenobiology")
		base_type = /datum/research_bounty/xenobiology
	else if(category == "circuits")
		base_type = /datum/research_bounty/circuit
	else if(category == "survey")
		base_type = /datum/research_bounty/survey
	else if(category == "xenoarch")
		base_type = /datum/research_bounty/xenoarch
	var/list/all_types = subtypesof(base_type)
	if(!length(all_types))
		return null
	var/list/existing_types = list()
	for(var/datum/research_bounty/existing in active_bounties)
		existing_types |= existing.type
	if(exclude_type)
		existing_types |= exclude_type
	var/list/candidates = all_types - existing_types - completed_bounty_types
	if(!length(candidates))
		return null
	var/chosen_type = pick(candidates)
	var/datum/research_bounty/B = new chosen_type
	bounty_counter++
	B.id = "bounty_[bounty_counter]"
	return B

/datum/research/proc/reroll_bounty(bounty_id)
	if(bounty_rerolls <= 0)
		return FALSE
	for(var/i in 1 to length(active_bounties))
		var/datum/research_bounty/B = active_bounties[i]
		if(B.id == bounty_id)
			var/cat = B.category
			var/datum/research_bounty/replacement = create_bounty(cat, B.type)
			if(!replacement)
				return FALSE
			qdel(B)
			active_bounties[i] = replacement
			bounty_rerolls--
			return TRUE
	return FALSE

/datum/research/proc/get_matching_bounty(obj/item/I)
	if(!I)
		return null
	var/datum/research_bounty/best = null
	for(var/datum/research_bounty/B in active_bounties)
		if(B.matches_item(I))
			if(!best || B.reward_points > best.reward_points)
				best = B
	return best

/datum/research/proc/complete_bounty(datum/research_bounty/target_bounty)
	if(!target_bounty)
		return 0
	var/reward = target_bounty.reward_points
	var/cat = target_bounty.category
	completed_bounty_types |= target_bounty.type
	for(var/i in 1 to length(active_bounties))
		if(active_bounties[i] == target_bounty)
			qdel(target_bounty)
			var/datum/research_bounty/replacement = create_bounty(cat)
			if(replacement)
				active_bounties[i] = replacement
			else
				active_bounties.Cut(i, i + 1)
			bounty_rerolls++
			break
	return reward

/datum/research/proc/InitializeDesigns()
	GLOB.designs = list()
	for(var/T in subtypesof(/datum/design))
		var/datum/design/D = new T
		if(D.materials)
			SSmaterials.normalize_material_amounts(D.materials)
		GLOB.designs[D.type] = D
		if(D.build_type & PROTOLATHE)
			GLOB.designs_protolathe_categories |= D.p_category
		if(D.build_type & IMPRINTER)
			GLOB.designs_imprinter_categories |= D.p_category

//Checks to see if design has all the required pre-reqs.
//Input: datum/design; Output: 0/1 (false/true)
/datum/research/proc/DesignHasReqs(var/datum/design/D)
	if(!D.req_tech.len)
		return TRUE

	for(var/req in D.req_tech)
		var/datum/tech/T = known_tech[req]
		if(isnull(T))
			return FALSE
		if(T.level < D.req_tech[req])
			return FALSE

	return TRUE

//Adds a tech to known_tech list. Checks to make sure there aren't duplicates and updates existing tech's levels if needed.
//Input: datum/tech; Output: Null
/datum/research/proc/AddTech2Known(var/datum/tech/T)
	if(isnull(T))
		return
	var/datum/tech/known = known_tech[T.id]
	var/will_update_progress = FALSE
	if(T.level > known.level)
		known.level = T.level
		known.next_level_threshold = T.next_level_threshold
		known.next_level_progress = 0
		will_update_progress = TRUE
	else if (T.level == known.level && T.next_level_progress > known.next_level_progress)
		will_update_progress = TRUE

	if(will_update_progress)
		known.next_level_progress = T.next_level_progress

/datum/research/proc/AddDesign2Known(var/datum/design/D)
	if(!D)
		return
	uploaded_designs[D.type] = D
	known_designs[D.type] = D

//Refreshes known_tech and known_designs list
//Input/Output: n/a
/datum/research/proc/RefreshResearch()
	known_designs.Cut() // this is to refresh the ordering of the designs, the alternative is an expensive insertion or sorting proc
	if(load_designs)
		for(var/node_id in unlocked_nodes)
			var/datum/tech_node/node = GLOB.tech_nodes[node_id]
			if(!node)
				continue
			for(var/design_path in node.unlocked_designs)
				var/datum/design/D = GLOB.designs[design_path]
				if(D)
					known_designs[D.type] = D
		for(var/design_path in uploaded_designs)
			var/datum/design/D = uploaded_designs[design_path]
			if(D)
				known_designs[D.type] = D
	for(var/id in known_tech)
		var/datum/tech/T = known_tech[id]
		T.level = between(0, T.level, MAX_TECH_LEVEL)
		T.next_level_threshold = get_level_value(T.level)

/datum/research/proc/get_level_value(var/level)
	return 5 ** level

//Refreshes the levels of a given tech.
//Input: Tech's ID and Level; Output: null
/datum/research/proc/UpdateTech(var/ID, var/update_level)
	var/datum/tech/KT = known_tech[ID]
	var/progress = get_level_value(update_level)
	while(progress > 0)
		if(KT.level >= MAX_TECH_LEVEL)
			break
		if(KT.next_level_progress + progress >= KT.next_level_threshold)
			var/progress_left = KT.next_level_threshold - KT.next_level_progress
			KT.next_level_progress += progress_left
			KT.level++
			KT.level = clamp(KT.level, 0, MAX_TECH_LEVEL)
			KT.next_level_threshold = get_level_value(KT.level)
			progress -= progress_left
			continue
		KT.next_level_progress += progress
		break

// A simple helper proc to find the name of a tech with a given ID.
/proc/CallTechName(var/ID)
	for(var/T in subtypesof(/datum/tech))
		var/datum/tech/check_tech = T
		if(initial(check_tech.id) == ID)
			return initial(check_tech.name)

/***************************************************************
**						Technology Datums					  **
**	Includes all the various technoliges and what they make.  **
***************************************************************/

/datum/tech //Datum of individual technologies.
	var/name = "name"					//Name of the technology.
	var/desc = "description"			//General description of what it does and what it makes.
	var/id = "id"						//An easily referenced ID. Must be alphanumeric, lower-case, and no symbols.
	var/antag_tech
	var/level = 1						//A simple number scale of the research level. Level 0 = Secret tech.
	var/next_level_progress = 0			// The research progress until the next level is reached, makes things more gradual
	var/next_level_threshold = 10		// The next threshold that must be reached before it ticks to the next level

/datum/tech/materials
	name = "Materials Research"
	desc = "Development of new and improved materials."
	id = TECH_MATERIAL

/datum/tech/engineering
	name = "Engineering Research"
	desc = "Development of new and improved engineering parts."
	id = TECH_ENGINEERING

/datum/tech/phorontech
	name = "Phoron Research"
	desc = "Research into the mysterious substance colloqually known as 'phoron'."
	id = TECH_PHORON

/datum/tech/powerstorage
	name = "Power Manipulation Technology"
	desc = "The various technologies behind the storage and generation of electicity."
	id = TECH_POWER

/datum/tech/bluespace
	name = "'Blue-space' Research"
	desc = "Research into the sub-reality known as 'blue-space'"
	id = TECH_BLUESPACE

/datum/tech/biotech
	name = "Biological Technology"
	desc = "Research into the deeper mysteries of life and organic substances."
	id = TECH_BIO

/datum/tech/combat
	name = "Combat Systems Research"
	desc = "The development of offensive and defensive systems."
	id = TECH_COMBAT

/datum/tech/magnets
	name = "Electromagnetic Spectrum Research"
	desc = "Research into the electromagnetic spectrum. No clue how they actually work, though."
	id = TECH_MAGNET

/datum/tech/programming
	name = "Data Theory Research"
	desc = "The development of new computer and artificial intelligence and data storage systems."
	id = TECH_DATA

/datum/tech/syndicate
	name = "Esoteric Technologies Research"
	desc = "The study of bleeding-edge, experimental and often restricted technologies."
	id = TECH_ILLEGAL
	antag_tech = TRUE
	level = 0

/datum/tech/arcane
	name = "Arcane Research"
	desc = "Research into the occult and arcane field for use in practical science"
	id = TECH_ARCANE
	antag_tech = TRUE
	level = 0

/obj/item/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/datum/tech/stored

/obj/item/disk/tech_disk/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(stored)
			. += "It is storing the following tech:"
			. += " - [stored.name]: Level - [stored.level] | Progress - [stored.next_level_progress]/[stored.next_level_threshold]"
		else
			. += "It doesn't have any tech stored."

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/datum/design/blueprint

/obj/item/disk/design_disk/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		if(blueprint)
			. += "It is storing the following design:"
			. += " - [blueprint.name]"
		else
			. += "It doesn't have any blueprint stored."

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
