/datum/computer_file/program/cooking_codex
	filename = "cookcodex"
	filedesc = "Cooking Codex"
	program_icon_state = "supply"
	program_key_icon_state = "teal_key"
	extended_desc = "Useful program to view cooking recipes."
	size = 14
	required_access_download = null
	available_on_ntnet = TRUE
	tgui_id = "CookingCodex"

/datum/computer_file/program/cooking_codex/ui_data(mob/user)
	var/list/data = list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/list/recipes_data = list()
	var/list/available_recipes = GET_SINGLETON_SUBTYPE_MAP(/singleton/recipe)
	for (var/recipe_path in available_recipes)
		var/singleton/recipe/recipe = GET_SINGLETON(recipe_path)
		var/list/recipe_data = list()

		// result
		var/obj/item/recipe_result = recipe.result
		recipe_data["result"] = initial(recipe_result.name)

		// ingredients
		if(recipe.items)
			var/list/ingredients = list()
			for(var/ingredient_path in recipe.items)
				var/obj/item/ingredient = ingredient_path
				ingredients += list(initial(ingredient.name))
			recipe_data["ingredients"] = ingredients

		// fin
		recipes_data += list(recipe_data)

	data["recipes"] = recipes_data

	return data
