/var/datum/controller/subsystem/materials/SSmaterials

/datum/controller/subsystem/materials
	name = "Materials"
	flags = SS_NO_FIRE

	var/list/materials
	var/list/materials_by_name

/datum/controller/subsystem/materials/Initialize()
	create_material_lists()
	. = ..()

/datum/controller/subsystem/materials/proc/create_material_lists()
	if(LAZYLEN(materials))
		return

	materials = list()
	materials_by_name = list()

	for(var/M in subtypesof(/datum/material))
		var/material/material = new M
		if(material.name)
			materials += material
			materials_by_name[lowertext(new_mineral.name)] = material
	. = ..()

/datum/controller/subsystem/materials/proc/get_material_by_name(var/material)
	if(!materials_by_name)
		create_material_lists()
	. = materials_by_name[material]
	if(!.)
		log_error("Material not found: [material].")