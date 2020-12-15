/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines // you fucking misspelled guidelines, you cow
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

// #TODO-MERGE: Go over this file and make sure everything's fine. We might have missing vars.

/datum/design						//Datum for object designs, used in construction
	var/name						//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc						//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name					//An item name before it is modified by various name-modifying procs
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/build_type					//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of chemicals.
	var/build_path					//The path of the object that gets created.
	var/time = 10					//How many ticks it requires to build
	var/p_category = "Misc"
	var/category					//Primarily used for Mech Fabricators, but can be used for anything.

/datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)
		var/atom/build_item = build_path
		desc = initial(build_item.desc)

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE