/obj/machinery/appliance/kettle
	name = "Kettle"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "kettle"
	layer = 2.9
	density = 1
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 500
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 15
	var/appliancetype = KETTLE



/obj/machinery/kettle/Initialize(mapload)
	. = ..()
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	if (mapload)
		addtimer(CALLBACK(src, .proc/setup_recipes), 0)
	else
		setup_recipes()

/obj/machinery/kettle/proc/setup_recipes()
	if (!LAZYLEN(acceptable_items))
		acceptable_items = list()
		acceptable_reagents = list()
		for (var/datum/recipe/recipe in RECIPE_LIST(appliancetype))
			for (var/item in recipe.items)
				acceptable_items[item] = TRUE

			for (var/reagent in recipe.reagents)
				acceptable_reagents[reagent] = TRUE