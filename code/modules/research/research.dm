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
var/global/list/designs = null
var/global/list/designs_protolathe_categories = list()
var/global/list/designs_imprinter_categories = list()

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_tech = list()			//List of locally known tech. Datum/tech go here.
	var/list/known_designs = list()			//List of available designs.

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
	if(load_designs && isnull(designs))
		InitializeDesigns()
	RefreshResearch()

/datum/research/techonly
	load_designs = FALSE

/datum/research/hightech
	standard_start_level = 3

/datum/research/proc/InitializeDesigns()
	designs = list()
	for(var/T in subtypesof(/datum/design))
		var/datum/design/D = new T
		designs[D.type] = D
		if(D.build_type & PROTOLATHE)
			designs_protolathe_categories |= D.p_category
		if(D.build_type & IMPRINTER)
			designs_imprinter_categories |= D.p_category

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
	known_designs[D.type] = D

//Refreshes known_tech and known_designs list
//Input/Output: n/a
/datum/research/proc/RefreshResearch()
	known_designs.Cut() // this is to refresh the ordering of the designs, the alternative is an expensive insertion or sorting proc
	if(load_designs)
		for(var/path in designs)
			var/datum/design/PD = designs[path]
			if(DesignHasReqs(PD))
				AddDesign2Known(PD)
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
			progress -= KT.next_level_threshold - KT.next_level_progress
			KT.level++
			KT.level = clamp(KT.level, 0, MAX_TECH_LEVEL)
			KT.next_level_threshold = get_level_value(KT.level)
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
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	var/datum/tech/stored

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/disk/tech_disk/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(stored)
			to_chat(user, FONT_SMALL("It is storing the following tech:"))
			to_chat(user, FONT_SMALL(" - [stored.name]: Level - [stored.level] | Progress - [stored.next_level_progress]/[stored.next_level_threshold]"))
		else
			to_chat(user, FONT_SMALL("It doesn't have any tech stored."))

/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	var/datum/design/blueprint

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/disk/design_disk/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(blueprint)
			to_chat(user, FONT_SMALL("It is storing the following design:"))
			to_chat(user, FONT_SMALL(" - [blueprint.name]"))
		else
			to_chat(user, FONT_SMALL("It doesn't have any blueprint stored."))
