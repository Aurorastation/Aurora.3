/*
 *  Unit Tests for recipes used in cooking.
 */

/*
 * As long strings are used in the '/decl/recipe's, this test is absolutely necessary
 */
/datum/unit_test/cooking_recipes_fruits
	name = "COOKING: Check recipe fruit tags"

/datum/unit_test/cooking_recipes_fruits/start_test()
	var/list/tags_available = list()
	var/list/tags_in_use = list()
	var/list/tags_required = list()

	var/list/not_found = list()

	var/n_found = 0
	var/n_affected = 0

	var/ktag
	for(var/seed_name in SSplants.seeds)
		var/datum/seed/S = SSplants.seeds[seed_name]
		ktag = S.kitchen_tag
		if(!(ktag in tags_available))
			tags_available[ktag] = list()
			tags_in_use[ktag] = FALSE
		tags_available[ktag] += S.type

	var/list/decl/recipe/recipes = decls_repository.get_decls_of_subtype(/decl/recipe)
	for(var/decl/recipe/R in recipes)
		if(R.fruit && length(R.fruit))
			for(var/tag in R.fruit)
				if(!(tag in tags_required))
					tags_required[tag] = list()
				tags_required[tag] += R

	for(var/tag in tags_required)
		if(!(tag in tags_available))
			not_found += tag
			n_affected += length(tags_required[tag])
		else
			tags_in_use[tag] = TRUE

	for(var/tag in tags_in_use)
		if(!tags_in_use[tag]) // is unused
			var/lstr = english_list(tags_available[tag])
			log_unit_test(
				"[ascii_yellow]--------------- Unused '[tag]', defined by [lstr].[ascii_reset]"
			)
		else
			n_found += 1

	var/n_available = length(tags_available)
	var/n_unused = n_available - n_found
	if(length(not_found))
		for (var/tag in not_found)
			var/lstr = english_list(tags_required[tag])
			log_unit_test(
				"[ascii_red]--------------- Undefined '[tag]', required by [lstr]![ascii_reset]"
			)

		var/msg = "[n_affected] of [length(recipes)] could not find [length(not_found)] tags!"
		if(n_unused)
			msg += " With [n_unused] unsued tags found."
		else
			msg += " With no unused tags."
		fail(msg)
	else
		var/msg = "All [length(recipes)] recipes could find all [n_found] needed tags!"
		if(n_unused)
			msg += " With [n_unused] unsued tags found."
		else
			msg += " With no unused tags."
		pass(msg)

	return 1
