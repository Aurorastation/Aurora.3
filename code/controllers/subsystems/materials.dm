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
 * * log_missing - Whether to stack trace if the material was not found
 */
/datum/controller/subsystem/materials/proc/get_material_by_name(var/material_name, var/log_missing = TRUE)
	if(!istext(material_name))
		return
	if(!materials_by_name)
		create_material_names_list()

	material_name = lowertext(material_name)
	if(material_name == "metal")
		material_name = "steel" // old DEFAULT_WALL_MATERIAL_NAME

	. = materials_by_name[material_name]
	if(!. && log_missing)
		stack_trace("SSmaterials received a request for a material that was not found: [material_name].")

/**
 * Returns a `/material` based on either its singleton path or name.
 *
 * * material_id - A `/singleton/material` path, a material datum, a material name, or href text containing a material path
 * * log_missing - Whether to stack trace if the material was not found
 */
/datum/controller/subsystem/materials/proc/get_material_by_id(var/material_id, var/log_missing = TRUE)
	if(ispath(material_id, /singleton/material))
		return GET_SINGLETON(material_id)
	if(istype(material_id, /singleton/material))
		var/singleton/material/material = material_id
		return material
	if(istext(material_id))
		var/material_path = text2path(material_id)
		if(ispath(material_path, /singleton/material))
			return GET_SINGLETON(material_path)
		return get_material_by_name(material_id, log_missing)
	if(log_missing)
		stack_trace("SSmaterials received a request for an invalid material id: [material_id].")

/**
 * Returns the canonical `/singleton/material` path for any supported material id.
 */
/datum/controller/subsystem/materials/proc/material_to_path(var/material_id, var/log_missing = TRUE)
	var/singleton/material/material = get_material_by_id(material_id, log_missing)
	if(material)
		return material.type

/**
 * Normalizes a material amount list in-place to singleton material path keys.
 */
/datum/controller/subsystem/materials/proc/normalize_material_amounts(var/list/materials)
	if(!islist(materials))
		return

	var/list/normalized = list()
	for(var/material_id in materials)
		var/material_path = material_to_path(material_id, FALSE)
		if(!material_path)
			material_path = material_id
		normalized[material_path] = (normalized[material_path] || 0) + materials[material_id]

	materials.Cut()
	for(var/material_id in normalized)
		materials[material_id] = normalized[material_id]

/**
 * Returns the amount of a material in a list, accepting either old names or singleton paths.
 */
/datum/controller/subsystem/materials/proc/get_material_amount(var/list/materials, var/material_id)
	if(!islist(materials))
		return 0

	var/material_path = material_to_path(material_id, FALSE)
	if(!material_path)
		return materials[material_id] || 0

	var/amount = materials[material_path] || 0
	var/singleton/material/material = get_material_by_id(material_path, FALSE)
	if(material?.name)
		amount += materials[material.name] || 0
	return amount

/**
 * Adds a material amount to a list under its canonical singleton path key.
 */
/datum/controller/subsystem/materials/proc/add_material_amount(var/list/materials, var/material_id, var/amount)
	if(!islist(materials) || !amount)
		return

	var/material_path = material_to_path(material_id, FALSE)
	if(!material_path)
		material_path = material_id
	materials[material_path] = (materials[material_path] || 0) + amount

/**
 * Removes a material amount from a list under its canonical singleton path key.
 */
/datum/controller/subsystem/materials/proc/remove_material_amount(var/list/materials, var/material_id, var/amount)
	if(!islist(materials) || !amount)
		return

	var/material_path = material_to_path(material_id, FALSE)
	if(!material_path)
		material_path = material_id
	materials[material_path] = max(0, (materials[material_path] || 0) - amount)

/**
 * Returns the stack type associated with a material id.
 */
/datum/controller/subsystem/materials/proc/material_stack_type(var/material_id)
	var/singleton/material/material = get_material_by_id(material_id, FALSE)
	return material?.stack_type

/**
 * Returns a material display name.
 *
 * * material_name - Any material id accepted by `get_material_by_id`.
 */
/datum/controller/subsystem/materials/proc/material_display_name(var/material_name)
	var/singleton/material/material = get_material_by_id(material_name, FALSE)
	if(material)
		return capitalize(material.display_name)
	return "[material_name]"
