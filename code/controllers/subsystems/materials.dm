SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/materials
	var/list/materials_by_name

	var/list/autolathe_categories

/datum/controller/subsystem/materials/Initialize()
	create_material_lists()

	return SS_INIT_SUCCESS

/**
 * Initialize the lists of materials, if they are not initialized already
 */
/datum/controller/subsystem/materials/proc/create_material_lists()
	if(LAZYLEN(materials))
		return

	materials = list()
	materials_by_name = list()

	for(var/M in subtypesof(/material))
		var/material/material = new M
		if(material.name)
			materials += material
			materials_by_name[lowertext(material.name)] = material

/**
 * Returns a `/material` based on its name, or null if the material does not exists
 *
 * * material_name - A string, lowercase, representing the name of the material
 */
/datum/controller/subsystem/materials/proc/get_material_by_name(var/material_name)
	if(!materials_by_name)
		create_material_lists()
	. = materials_by_name[material_name]
	if(!.)
		stack_trace("SSmaterials received a request for a material that was not found: [material_name].")

/**
 * Returns a `/material` based on its display name
 *
 * * material_name - A string, lowercase, representing the display name of the material
 */
/datum/controller/subsystem/materials/proc/material_display_name(var/material_name)
	var/material/material = get_material_by_name(material_name)
	if(material)
		return material.display_name
