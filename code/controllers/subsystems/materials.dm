SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = INIT_ORDER_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/materials_by_name

/datum/controller/subsystem/materials/Initialize()
	create_material_names_list()

	return SS_INIT_SUCCESS

/**
 * Initialize the lists of materials, if they are not initialized already
 */
/datum/controller/subsystem/materials/proc/create_material_names_list()
	if(LAZYLEN(materials_by_name))
		return

	materials_by_name = list()

	for(var/M in subtypesof(/singleton/material))
		var/singleton/material/material = new M
		if(material.name)
			materials_by_name[lowertext(material.name)] = material

/**
 * Returns a `/material` based on its name, or null if the material does not exists
 *
 * * material_name - A string, lowercase, representing the name of the material
 */
/datum/controller/subsystem/materials/proc/get_material_by_name(var/material_name)
	if(!materials_by_name)
		create_material_names_list()
	. = materials_by_name[material_name]
	if(!.)
		stack_trace("SSmaterials received a request for a material that was not found: [material_name].")

/**
 * Returns a `/material` based on its display name
 *
 * * material_name - A string, lowercase, representing the display name of the material
 */
/datum/controller/subsystem/materials/proc/material_display_name(var/material_name)
	var/singleton/material/material = get_material_by_name(material_name)
	if(material)
		return material
