/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * /singleton/recipe by rastaf0            13 apr 2011 *
 * * * * * * * * * * * * * * * * * * * * * * * * * *
 * This is powerful and flexible recipe system.
 * It exists not only for food.
 * supports both reagents and objects as prerequisites.
 * In order to use this system you have to define a deriative from /singleton/recipe
 * * reagents are reagents. Acid, milc, booze, etc.
 * * items are objects. Fruits, tools, circuit boards.
 * * result is type to create as new object
 * * time is optional parameter, you shall use in in your machine,
	 default /singleton/recipe/ procs does not rely on this parameter.
 *
 *  Functions you need:
 *  /singleton/recipe/proc/make(var/obj/container as obj)
 *    Creates result inside container,
 *    deletes prerequisite reagents,
 *    transfers reagents from prerequisite objects,
 *    deletes all prerequisite objects (even not needed for recipe at the moment).
 *
 *  /proc/select_recipe(obj/obj as obj, exact = 1, appliance)
 *    Wonderful function that select suitable recipe for you.
 *    obj is a machine (or magik hat) with prerequisites,
 *    exact = 0 forces algorithm to ignore superfluous stuff.
 *
 *
 *  Functions you do not need to call directly but could:
 *  /singleton/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
 *  /singleton/recipe/proc/check_items(var/obj/container as obj)
 *
 * */



/singleton/recipe
	var/display_name
	var/list/reagents // example: = list(/decl/reagent/drink/berryjuice = 5) // do not list same reagent twice
	var/list/recipe_taste_override // example: = list("uncooked dough" = "crispy dough")
	var/list/items    // example: = list(/obj/item/crowbar, /obj/item/welder) // place /foo/bar before /foo
	var/list/fruit    // example: = list("fruit" = 3)
	var/coating = null//Required coating on all items in the recipe. The default value of null explitly requires no coating
	//A value of -1 is permissive and cares not for any coatings
	//Any typepath indicates a specific coating that should be present
	//Coatings are used for batter, breadcrumbs, beer-batter, colonel's secret coating, etc

	var/result        // example: = /obj/item/reagent_containers/food/snacks/donut/normal
	var/result_quantity = 1 //number of instances of result that are created.
	var/time = 100    // 1/10 part of second

	#define RECIPE_REAGENT_REPLACE		0 //Reagents in the ingredients are discarded.
	//Only the reagents present in the result at compiletime are used
	#define RECIPE_REAGENT_MAX	1 //The result will contain the maximum of each reagent present between the two pools. Compiletime result, and sum of ingredients
	#define RECIPE_REAGENT_MIN 2 //As above, but the minimum, ignoring zero values.
	#define RECIPE_REAGENT_SUM 3 //The entire quantity of the ingredients are added to the result

	var/reagent_mix = RECIPE_REAGENT_MAX	//How to handle reagent differences between the ingredients and the results

	var/finished_temperature = T0C + 40 //The temperature of the reagents of the final product.Only affects nutrient type.

	var/appliance = MIX//Which appliances this recipe can be made in.
	//List of defines is in _defines/misc.dm. But for reference they are:
	/*
		MIX
		FRYER
		OVEN
		SKILLET
		SAUCEPAN
		POT
	*/
	//This is a bitfield, more than one type can be used

/singleton/recipe/proc/get_appliance_names()
	var/list/appliance_names
	if(appliance & GRILL) // this comes first in the proc because it's the most important - geeves
		LAZYADD(appliance_names, "a grill")
	if(appliance & MIX)
		LAZYADD(appliance_names, "a mixing bowl or plate")
	if(appliance & FRYER)
		LAZYADD(appliance_names, "a fryer")
	if(appliance & OVEN)
		LAZYADD(appliance_names, "an oven")
	if(appliance & SKILLET)
		LAZYADD(appliance_names, "a skillet")
	if(appliance & SAUCEPAN)
		LAZYADD(appliance_names, "a saucepan")
	if(appliance & POT)
		LAZYADD(appliance_names, "a pot")
	return english_list(appliance_names, and_text = " or ")

/singleton/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
	if (isemptylist(reagents))
		return avail_reagents?.total_volume ? COOK_CHECK_EXTRA : COOK_CHECK_EXACT

	if (!avail_reagents)
		return COOK_CHECK_EXTRA

	. = TRUE
	for (var/r_r in reagents)
		var/aval_r_amnt = REAGENT_VOLUME(avail_reagents, r_r)
		if (aval_r_amnt - reagents[r_r] >= 0)
			if (aval_r_amnt>reagents[r_r])
				. = COOK_CHECK_EXTRA
		else
			return COOK_CHECK_FAIL

	if ((reagents?length(reagents):0) < length(avail_reagents.reagent_volumes))
		return COOK_CHECK_EXTRA
	return .

/singleton/recipe/proc/check_fruit(var/obj/container)
	if (isemptylist(fruit))
		var/obj/item/reagent_containers/food/snacks/grown/G = locate() in container
		return G ? COOK_CHECK_EXTRA : COOK_CHECK_EXACT
	. = COOK_CHECK_EXTRA
	var/list/checklist = fruit.Copy()
	for(var/obj/item/reagent_containers/food/snacks/S in container)
		var/use_tag
		if(istype(S, /obj/item/reagent_containers/food/snacks/grown))
			var/obj/item/reagent_containers/food/snacks/grown/G = S
			if(!G.seed || !G.seed.kitchen_tag)
				continue
			use_tag = G.dry ? "dried [G.seed.kitchen_tag]" : G.seed.kitchen_tag
		else if(istype(S, /obj/item/reagent_containers/food/snacks/fruit_slice))
			var/obj/item/reagent_containers/food/snacks/fruit_slice/FS = S
			if(!FS.seed || !FS.seed.kitchen_tag)
				continue
			use_tag = "[FS.seed.kitchen_tag] slice"
		use_tag = "[S.dry ? "dried " : ""][use_tag]"
		if(isnull(checklist[use_tag]))
			continue
		if (check_coating(S))
			checklist[use_tag]--
	for(var/ktag in checklist)
		if(!isnull(checklist[ktag]))
			if(checklist[ktag] < 0)
				. = COOK_CHECK_EXTRA
			else if(checklist[ktag] > 0)
				. = COOK_CHECK_FAIL
				break
	return .

/singleton/recipe/proc/check_items(var/obj/container as obj)
	if (isemptylist(items))
		return container?.contents.len ? COOK_CHECK_EXTRA : COOK_CHECK_EXACT
	. = COOK_CHECK_EXACT
	var/list/checklist = items.Copy()
	for(var/obj/O in container)
		if(istype(O,/obj/item/reagent_containers/food/snacks/grown))
			continue // Fruit is handled in check_fruit().
		var/found = 0
		for(var/i = 1; i < length(checklist)+1; i++)
			var/item_type = checklist[i]
			if (istype(O,item_type))
				if(check_coating(O))
					checklist.Cut(i, i+1)
					found = 1
					break

		if (!found)
			. = COOK_CHECK_EXTRA
		if (isemptylist(checklist) && . != COOK_CHECK_EXTRA)
			return COOK_CHECK_EXTRA//No need to iterate through everything if we know theres at least oen extraneous ingredient
	if (length(checklist))
		. = COOK_CHECK_FAIL

	return .

//This is called on individual items within the container.
/singleton/recipe/proc/check_coating(var/obj/item/reagent_containers/food/snacks/S)
	if(!istype(S))
		return TRUE//Only snacks can be battered

	if (coating == -1)
		return TRUE //-1 value doesnt care

	return !coating || (S.coating == coating)

//general version
/singleton/recipe/proc/make(var/obj/container as obj)
	var/obj/result_obj = new result(container)
	for (var/obj/O in (container.contents-result_obj))
		O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
		qdel(O)
	container.reagents.clear_reagents()

	return result_obj

// food-related
//This proc is called under the assumption that the container has already been checked and found to contain the necessary ingredients
/singleton/recipe/proc/make_food(var/obj/container as obj)
	if(!result)
		return


//We will subtract all the ingredients from the container, and transfer their reagents into a holder
//We will not touch things which are not required for this recipe. They will be left behind for the caller
//to decide what to do. They may be used again to make another recipe or discarded, or merged into the results,
//thats no longer the concern of this proc
	var/datum/reagents/buffer = new /datum/reagents(1e12)//

	//Find items we need
	if (LAZYLEN(items))
		for (var/i in items)
			var/obj/item/I = locate(i) in container
			if (I && I.reagents)
				I.reagents.trans_to_holder(buffer,I.reagents.total_volume)
				qdel(I)

	//Find fruits
	if (LAZYLEN(fruit))
		var/list/checklist = list()
		checklist = fruit.Copy()

		for(var/obj/item/reagent_containers/food/snacks/grown/G in container)
			if(!G.seed || !G.seed.kitchen_tag || isnull(checklist[G.seed.kitchen_tag]))
				continue

			if (checklist[G.seed.kitchen_tag] > 0)
				//We found a thing we need
				checklist[G.seed.kitchen_tag]--
				if (G && G.reagents)
					G.reagents.trans_to_holder(buffer,G.reagents.total_volume)
				qdel(G)

	//And lastly deduct necessary quantities of reagents
	if (LAZYLEN(reagents))
		for (var/r in reagents)
			//Doesnt matter whether or not there's enough, we assume that check is done before
			container.reagents.trans_type_to(buffer, r, reagents[r])

	// this is the generic list of reagent tastes to change, but the recipe-specific one override this
	var/list/taste_replacers = list(
		"uncooked dough" = "cooked dough"
	)
	for(var/reagent in buffer.reagent_data)
		for(var/taste in buffer.reagent_data[reagent])
			if(taste in recipe_taste_override)
				buffer.reagent_data[reagent][recipe_taste_override[taste]] = buffer.reagent_data[reagent][taste]
				buffer.reagent_data[reagent] -= taste
				continue
			if(taste in taste_replacers)
				buffer.reagent_data[reagent][taste_replacers[taste]] = buffer.reagent_data[reagent][taste]
				buffer.reagent_data[reagent] -= taste
				continue

	/*
	Now we've removed all the ingredients that were used and we have the buffer containing the total of
	all their reagents.
	If we have multiple results, holder will be used as a buffer to hold reagents for the result objects.
	If, as in the most common case, there is only a single result, then it will just be a reference to
	the single-result's reagents
	*/
	var/datum/reagents/holder = new/datum/reagents(10000000000)
	var/list/results = list()
	for (var/_ in 1 to result_quantity)
		var/obj/result_obj = new result(container)
		results.Add(result_obj)

		if (!result_obj.reagents)//This shouldn't happen
			//If the result somehow has no reagents defined, then create a new holder
			result_obj.create_reagents(buffer.total_volume*1.5)

		if (result_quantity == 1)
			qdel(holder)
			holder = result_obj.reagents
		else
			result_obj.reagents.trans_to_holder(holder, result_obj.reagents.total_volume)


	switch(reagent_mix)
		if (RECIPE_REAGENT_REPLACE)
			//We do no transferring
		if (RECIPE_REAGENT_SUM)
			//Sum is easy, just shove the entire buffer into the result
			buffer.trans_to_holder(holder, buffer.total_volume)
		if (RECIPE_REAGENT_MAX)
			//We want the highest of each.
			//Iterate through everything in buffer. If the target has less than the buffer, then top it up
			for (var/_R in buffer.reagent_volumes)
				var/rvol = REAGENT_VOLUME(holder, _R)
				var/bvol = REAGENT_VOLUME(buffer, _R)
				if (rvol < bvol)
					//Transfer the difference
					buffer.trans_type_to(holder, _R, bvol-rvol)

		if (RECIPE_REAGENT_MIN)
			//Min is slightly more complex. We want the result to have the lowest from each side
			//But zero will not count. Where a side has zero its ignored and the side with a nonzero value is used
			for (var/_R in buffer.reagent_volumes)
				var/rvol = REAGENT_VOLUME(holder, _R)
				var/bvol = REAGENT_VOLUME(buffer, _R)
				if (rvol == 0) //If the target has zero of this reagent
					buffer.trans_type_to(holder, _R, bvol)
					//Then transfer all of ours

				else if (rvol > bvol)
					//if the target has more than ours
					//Remove the difference
					holder.remove_reagent(_R, rvol-bvol)


	if (length(results) > 1)
		//If we're here, then holder is a buffer containing the total reagents for all the results.
		//So now we redistribute it among them
		var/total = holder.total_volume
		for (var/i in results)
			var/atom/a = i //optimisation
			holder.trans_to(a, total / length(results))

	return results

//When exact is false, extraneous ingredients are ignored
//When exact is true, extraneous ingredients will fail the recipe
//In both cases, the full complement of required inredients is still needed
/proc/select_recipe(var/obj/obj as obj, var/exact = COOK_CHECK_EXTRA, var/appliance = null)
	if(!appliance)
		CRASH("Null appliance flag passed to select_recipe!")
	var/list/available_recipes = GET_SINGLETON_SUBTYPE_MAP(/singleton/recipe)
	var/list/possible_recipes = list()
	for (var/R in available_recipes)
		var/singleton/recipe/recipe = GET_SINGLETON(R)
		if(!(appliance & recipe.appliance))
			continue
		if((recipe.check_reagents(obj.reagents) < exact) || (recipe.check_items(obj) < exact) || (recipe.check_fruit(obj) < exact))
			continue
		possible_recipes |= recipe
	if (isemptylist(possible_recipes))
		return null
	sortTim(possible_recipes, /proc/cmp_recipe_complexity_dsc) // Select the most complex recipe
	return possible_recipes[1]
