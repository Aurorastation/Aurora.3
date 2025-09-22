
SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_CODEX

	/// List of cooking recipes and associated data.
	var/list/cooking_codex_data = list()

	/// List of chemistry/reagent reactions and associated data.
	var/list/chemistry_codex_data = list()
	var/list/chemistry_codex_ignored_reaction_path = list(/datum/chemical_reaction/slime)
	var/list/chemistry_codex_ignored_result_path = list(/singleton/reagent/drink, /singleton/reagent/alcohol)

	/// List of fusion reactions and associated data.
	var/list/fusion_codex_data = list()

/datum/controller/subsystem/codex/Initialize()
	//We don't build the codex in fastboot, it's slow and kind of pointless for tests
	if(GLOB.config.fastboot)
		log_subsystem_codex("SScodex: Fastboot detected, skipping codex generation.")

	else
		generate_cooking_codex()
		generate_chemistry_codex()
		generate_fusion_codex()
		log_subsystem_codex("SScodex: [length(cooking_codex_data)] cooking recipes; [length(chemistry_codex_data)] chemistry recipes; [length(fusion_codex_data)] fusion recipes;")

	return SS_INIT_SUCCESS

/datum/controller/subsystem/codex/proc/generate_cooking_codex()
	var/list/available_recipes = GET_SINGLETON_SUBTYPE_MAP(/singleton/recipe)
	for (var/reaction_path in available_recipes)
		var/singleton/recipe/recipe = GET_SINGLETON(reaction_path)
		var/list/cookingRecipeData = list()

		// result
		var/obj/item/recipe_result = recipe.result
		cookingRecipeData["result"] = initial(recipe_result.name)

		// result image
		var/icon/result_icon = icon(
			icon=initial(recipe_result.icon),
			icon_state=initial(recipe_result.icon_state),
			frame=1,
			)
		cookingRecipeData["result_image"] = icon2base64(result_icon)

		// ingredients
		cookingRecipeData["ingredients"] = list()

		// ingredients, items
		if(recipe.items)
			for(var/ingredient_path in recipe.items)
				var/obj/item/ingredient = ingredient_path
				cookingRecipeData["ingredients"] += initial(ingredient.name)

		// ingredients, fruits
		if(recipe.fruit)
			for(var/fruit_name in recipe.fruit)
				var/count = recipe.fruit[fruit_name]
				cookingRecipeData["ingredients"] += "[count]x [fruit_name]"

		// ingredients, reagents
		if(recipe.reagents)
			for(var/reagent_path in recipe.reagents)
				var/count = recipe.reagents[reagent_path]
				var/singleton/reagent/reagent = GET_SINGLETON(reagent_path)
				cookingRecipeData["ingredients"] += "[count]u [reagent.name]"

		// coating
		if(recipe.coating)
			var/singleton/reagent/reagent = GET_SINGLETON(recipe.coating)
			cookingRecipeData["ingredients"] += "[reagent.name] coating"

		// kitchen appliance
		if(recipe.appliance)
			cookingRecipeData["appliances"] = recipe.get_appliance_names()

		// fin
		cookingRecipeData["ingredients"] = english_list(cookingRecipeData["ingredients"])
		cooking_codex_data += list(cookingRecipeData)

/datum/controller/subsystem/codex/proc/generate_chemistry_codex()
	chemistry_codex_data = list()
	for(var/chem_path in SSchemistry.chemical_reactions_clean)
		if(chemistry_codex_ignored_reaction_path && is_path_in_list(chem_path, chemistry_codex_ignored_reaction_path))
			continue
		var/datum/chemical_reaction/CR = new chem_path
		if(!CR.result)
			continue
		if(chemistry_codex_ignored_result_path && is_path_in_list(CR.result, chemistry_codex_ignored_result_path))
			continue
		var/singleton/reagent/R = GET_SINGLETON(CR.result)
		var/chemistryReactionData = list(id = CR.id)
		chemistryReactionData["result"] = list(
			name = R.name,
			description = R.description,
			amount = CR.result_amount
		)

		chemistryReactionData["reagents"] = list()
		for(var/reagent in CR.required_reagents)
			var/singleton/reagent/required_reagent = reagent
			chemistryReactionData["reagents"] += list(list(
				name = initial(required_reagent.name),
				amount = CR.required_reagents[reagent]
			))

		chemistryReactionData["catalysts"] = list()
		for(var/reagent_path in CR.catalysts)
			var/singleton/reagent/required_reagent = reagent_path
			chemistryReactionData["catalysts"] += list(list(
				name = initial(required_reagent.name),
				amount = CR.catalysts[reagent_path]
			))

		chemistryReactionData["inhibitors"] = list()
		for(var/reagent_path in CR.inhibitors)
			var/singleton/reagent/required_reagent = reagent_path
			var/inhibitor_amount = CR.inhibitors[reagent_path] ? CR.inhibitors[reagent_path] : "Any"
			chemistryReactionData["inhibitors"] += list(list(
				name = initial(required_reagent.name),
				amount = inhibitor_amount
			))

		chemistryReactionData["temp_min"] = CR.required_temperature_min

		chemistryReactionData["temp_max"] = CR.required_temperature_max

		chemistry_codex_data += list(chemistryReactionData)

/// Generate a list of all fusion reaction fusion_reactions, then populate the codex from that list.
/datum/controller/subsystem/codex/proc/generate_fusion_codex()
	fusion_codex_data = list()
	var/list/available_fusion_reactions = GET_SINGLETON_SUBTYPE_MAP(/singleton/fusion_reaction)
	LOG_DEBUG("<b>length of available_fusion_reactions = [length(available_fusion_reactions)]</b>")
	for (var/reaction_path in available_fusion_reactions)
		var/singleton/fusion_reaction/fusion_reaction = GET_SINGLETON(reaction_path)
		LOG_DEBUG("<b>[reaction_path]</b>")
		var/list/fusionReactionData = list()

		// Reactants (p,s)
		fusionReactionData["reactants"] = list()
		fusionReactionData["reactants"] += fusion_reaction.p_react
		fusionReactionData["reactants"] += fusion_reaction.s_react

		// Minimum temperature threshold
		fusionReactionData["minimum_temp"] += fusion_reaction.minimum_energy_level

		fusionReactionData["energy_consumption"] += fusion_reaction.energy_consumption
		fusionReactionData["energy_production"] += fusion_reaction.energy_production

		fusionReactionData["radiation"] += fusion_reaction.radiation
		fusionReactionData["instability"] += fusion_reaction.instability

		fusionReactionData["products"] = list()
		for(var/product in fusion_reaction.products)
			fusionReactionData["products"] += list(list(
				name = fusion_reaction.products[1],
				amount = fusion_reaction.products[2]
			))

		fusion_codex_data += list(fusionReactionData)
