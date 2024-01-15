
SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_NO_FIRE
	init_order = SS_INIT_CODEX

	/// List of cooking recipes, their result and ingredients.
	var/list/cooking_codex_data = list()

	///
	// var/list/chemistry_codex_data = list()
	// var/list/chemistry_codex_ignored_reaction_path = list(/datum/chemical_reaction/slime)
	// var/list/chemistry_codex_ignored_result_path = list(/singleton/reagent/drink, /singleton/reagent/alcohol)

/datum/controller/subsystem/codex/Initialize()
	generate_cooking_codex()
	generate_chemistry_codex()

	LOG_DEBUG("SScodex: [cooking_codex_data.len] cooking recipes; [0] chemistry recipes.")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/codex/proc/generate_cooking_codex()
	var/list/available_recipes = GET_SINGLETON_SUBTYPE_MAP(/singleton/recipe)
	for (var/recipe_path in available_recipes)
		var/singleton/recipe/recipe = GET_SINGLETON(recipe_path)
		var/list/recipe_data = list()

		// result
		var/obj/item/recipe_result = recipe.result
		recipe_data["result"] = initial(recipe_result.name)

		// result image
		var/icon/result_icon = icon(
			icon=initial(recipe_result.icon),
			icon_state=initial(recipe_result.icon_state),
			frame=1,
			)
		recipe_data["result_image"] = icon2base64(result_icon)

		// ingredients
		recipe_data["ingredients"] = list()

		// ingredients, items
		if(recipe.items)
			for(var/ingredient_path in recipe.items)
				var/obj/item/ingredient = ingredient_path
				recipe_data["ingredients"] += initial(ingredient.name)

		// ingredients, fruits
		if(recipe.fruit)
			for(var/fruit_name in recipe.fruit)
				var/count = recipe.fruit[fruit_name]
				recipe_data["ingredients"] += "[count]x [fruit_name]"

		// ingredients, reagents
		if(recipe.reagents)
			for(var/reagent_path in recipe.reagents)
				var/count = recipe.reagents[reagent_path]
				var/singleton/reagent/reagent = GET_SINGLETON(reagent_path)
				recipe_data["ingredients"] += "[count]x [reagent.name]"

		// coating
		if(recipe.coating)
			var/singleton/reagent/reagent = GET_SINGLETON(recipe.coating)
			recipe_data["ingredients"] += "[reagent.name] coating"

		// kitchen appliance
		if(recipe.appliance)
			recipe_data["appliances"] = recipe.get_appliance_names()

		// fin
		recipe_data["ingredients"] = english_list(recipe_data["ingredients"])
		cooking_codex_data += list(recipe_data)

/datum/controller/subsystem/codex/proc/generate_chemistry_codex()
	;
