/datum/autowiki/food_recipes
	page = "Template:Autowiki/Content/FoodRecipeData"


/datum/autowiki/food_recipes/generate()
	var/output = ""

	var/list/available_recipes = GET_SINGLETON_SUBTYPE_MAP(/singleton/recipe)
	for(var/recipe_path in available_recipes)
		var/singleton/recipe/recipe = GET_SINGLETON(recipe_path)
		var/list/recipe_data = list()

		// result
		var/obj/item/recipe_result = new recipe.result()
		recipe_data["name"] = initial(recipe_result.name)

		var/filename = SANITIZE_FILENAME(escape_value(format_text(initial(recipe_result.name))))
		var/flat_icon = getFlatIcon(recipe_result, no_anim = TRUE)
		if(flat_icon)
			upload_icon(flat_icon, filename)
		recipe_data["icon"] = filename

		var/obj/item/reagent_containers/cooking_container/board/bowl/food_container = new()

		// ingredients
		recipe_data["ingredients"] = list()

		// ingredients, items
		if(recipe.items)
			var/list/ingredients = list()
			for(var/ingredient_path in recipe.items)
				var/obj/item/ingredient = new ingredient_path(food_container)
				ingredients = simple_counting_list(ingredients, initial(ingredient.name))
			for(var/ingredient in ingredients)
				var/count = ingredients[ingredient]
				recipe_data["ingredients"] += "[count]x [lowertext(ingredient)]"

		// ingredients, fruits
		if(recipe.fruit)
			for(var/fruit_name in recipe.fruit)
				var/needs_slice = findtext(fruit_name, " slice")
				var/needs_dried = findtext(fruit_name, "dried ")
				var/parsed_fruit_name = fruit_name
				if(needs_slice)
					parsed_fruit_name = replacetext(parsed_fruit_name, " slice", "")
				if(needs_dried)
					parsed_fruit_name = replacetext(parsed_fruit_name, "dried ", "")
				var/datum/seed/seed_datum = SSplants.seeds_by_kitchen_tag[parsed_fruit_name]
				var/obj/item/reagent_containers/food/snacks/grown/product = seed_datum.spawn_seed(food_container)
				if(needs_slice)
					var/reagents_to_transfer = product.reagents.total_volume / 4
					var/obj/item/reagent_containers/food/snacks/fruit_slice/product_slice = new(food_container, product.seed)
					product.reagents.trans_to_obj(product_slice, reagents_to_transfer)
					qdel(product)
					product = product_slice
				if(needs_dried)
					product.dry = TRUE

				var/count = recipe.fruit[fruit_name]
				recipe_data["ingredients"] += "[count]x [lowertext(fruit_name)]"

		// ingredients, reagents
		if(recipe.reagents)
			for(var/reagent_path in recipe.reagents)
				var/count = recipe.reagents[reagent_path]
				var/singleton/reagent/reagent = GET_SINGLETON(reagent_path)
				food_container.reagents.add_reagent(reagent_path, count)

				recipe_data["ingredients"] += "[count]u [lowertext(reagent.name)]"

		// coating
		if(recipe.coating)
			for(var/obj/item/reagent_containers/food/snacks/thing in food_container)
				thing.coating = recipe.coating

			var/singleton/reagent/reagent = GET_SINGLETON(recipe.coating)
			recipe_data["ingredients"] += "[reagent.name] coating"

		// kitchen appliance
		if(recipe.appliance)
			recipe_data["appliances"] = recipe.get_appliance_names()

		// fin
		recipe_data["ingredients"] = english_list(recipe_data["ingredients"], and_text = ", ")

		var/list/cooking_results = recipe.make_food(food_container)
		var/obj/cooking_obj = cooking_results[1]

		var/list/result_reagents = list()
		for(var/_reagent in cooking_obj.reagents.reagent_volumes)
			var/singleton/reagent/reagent = GET_SINGLETON(_reagent)
			result_reagents += "[REAGENT_VOLUME(cooking_obj.reagents, _reagent)]u [lowertext(reagent.name)]"
		if(length(result_reagents))
			recipe_data["result_reagents"] = english_list(result_reagents, and_text = ", ")

		output += include_template("Autowiki/FoodRecipe", recipe_data)

		qdel(recipe_result)

		for(var/atom/thing in food_container)
			qdel(thing)
		qdel(food_container)

	return output

/datum/autowiki/food_recipes/proc/wiki_sanitize_assoc(list/sanitizing_list)
	var/list/sanitized = list()

	for(var/key in sanitizing_list)
		var/value = sanitizing_list[key]

		sanitized[escape_value(key)] = escape_value(value)

	return sanitized
