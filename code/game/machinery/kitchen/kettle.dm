/obj/machinery/hotpad
	name = "Stove"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "hotpad"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 500
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 
	var/static/list/acceptable_items 
	var/static/list/acceptable_reagents 
	var/static/max_n_of_items = 15
	var/appliancetype = KETTLE



/obj/machinery/hotpad/Initialize(mapload)
	. = ..()
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	if (mapload)
		addtimer(CALLBACK(src, .proc/setup_recipes), 0)
	else
		setup_recipes()

/obj/machinery/hotpad/proc/setup_recipes()
	if (!LAZYLEN(acceptable_items))
		acceptable_items = list()
		acceptable_reagents = list()
		for (var/datum/recipe/recipe in RECIPE_LIST(appliancetype))
			for (var/item in recipe.items)
				acceptable_items[item] = TRUE

			for (var/reagent in recipe.reagents)
				acceptable_reagents[reagent] = TRUE


/obj/machinery/hotpad/proc/cook()
	if(stat & (NOPOWER))
		return
	start()
	if (reagents.total_volume==0 && !(locate(/obj) in contents)) //dry run
		if (!wzhzhzh(16))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(RECIPE_LIST(appliancetype),src)
	var/obj/cooked
	if (!recipe)
		dirty += 1
		if (prob(max(10,dirty*5)))
			if (!wzhzhzh(16))
				abort()
				return
			muck_start()
			wzhzhzh(16)
			muck_finish()
			cooked = fail()
			cooked.loc = src.loc
			return
		else if (has_extra_item())
			if (!wzhzhzh(16))
				abort()
				return
			broke()
			cooked = fail()
			cooked.loc = src.loc
			return
		else
			if (!wzhzhzh(40))
				abort()
				return
			stop()
			cooked = fail()
			cooked.loc = src.loc
			return
	else
		var/halftime = round((recipe.time*4)/10/2)
		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			cooked = fail()
			cooked.loc = src.loc
			return