SUBSYSTEM_DEF(fabrication)
	name = "Fabrication"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MISC

	/**
	 * List of lists(Strings => Paths - Subtypes of `/singsingleton/fabricator_recipe`). Global list of fabricator recipes. Set during `Initialize()`.
	 *
	 * Example formatting:
	 * ```dm
	 * 	list(
	 * 		"general" = list(
	 * 			/singleton/fabricator_recipe/A,
	 * 			/singleton/fabricator_recipe/B
	 * 		),
	 * 		"microlathe" = list(
	 * 			/singleton/fabricator_recipe/C,
	 * 			/singleton/fabricator_recipe/D
	 * 		)
	 * 	)
	 * ```
	 */
	var/list/recipes =    list()

	/**
	 * List of lists (Strings => Strings). Global list of recipe categories. These are pulled from the recipes provided in `recipes`. Set during `Initialize()`.
	 *
	 * Example formatting:
	 * ```dm
	 * 	list(
	 * 		"general" = list(
	 * 			"Arms and Ammunition",
	 * 			"Devices and Components"
	 * 		),
	 * 		"microlathe" = list(
	 * 			"Cutlery",
	 * 			"Drinking Glasses"
	 * 		)
	 * 	)
	 * ```
	 */
	var/list/categories = list()

/datum/controller/subsystem/fabrication/Initialize()
	for(var/singleton/fabricator_recipe/recipe as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/fabricator_recipe))
		if(is_abstract(recipe))
			continue
		if(!recipe.name)
			continue
		for(var/type in recipe.fabricator_types)
			if(!recipes[type])
				recipes[type] = list()
			recipes[type] += recipe
			if (!categories[type])
				categories[type] = list()
			categories[type] |= recipe.category
		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
		qdel(I)
	return SS_INIT_SUCCESS

/**
 * Retrieves a list of categories for the given root type.
 *
 * **Parameters**:
 * - `type` - The root type to fetch from the `categories` list.
 *
 * Returns list of strings. The categories associated with the given root type.
 */
/datum/controller/subsystem/fabrication/proc/get_categories(type)
	return categories[type]

/**
 * Retrieves a list of recipes for the given root type.
 *
 * **Parameters**:
 * - `type` - The root type to fetch from the `recipes` list.
 *
 * Returns list of paths (`/singleton/fabricator_recipe`). The recipes associated with the given root type.
 */
/datum/controller/subsystem/fabrication/proc/get_recipes(type)
	return recipes[type]
