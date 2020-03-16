var/datum/controller/subsystem/materials/SSmaterials

/datum/controller/subsystem/materials
	name = "Materials"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/materials
	var/list/materials_by_name

/datum/controller/subsystem/materials/New()
	NEW_SS_GLOBAL(SSmaterials)

/datum/controller/subsystem/materials/Initialize()
	create_material_lists()
	. = ..()

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

/datum/controller/subsystem/materials/proc/get_material_by_name(var/M)
	if(!materials_by_name)
		create_material_lists()
	. = materials_by_name[M]
	if(!.)
		log_debug("Material not found: [M].")

/datum/controller/subsystem/materials/proc/material_display_name(var/M)
	var/material/material = get_material_by_name(M)
	if(material)
		return material.display_name
