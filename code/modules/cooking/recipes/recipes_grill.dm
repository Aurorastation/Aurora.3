/singleton/recipe/grilled_meat
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	result = /obj/item/reagent_containers/food/snacks/meatsteak/grilled

/singleton/recipe/grilled_meat_spicy
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/spacespice = 1)
	result = /obj/item/reagent_containers/food/snacks/meatsteak/grilled/spicy

/singleton/recipe/grilled_xenomeat
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xenomeat/grilled

/singleton/recipe/grilled_xenomeat/make_food(obj/container) // make sure we burn all the polyacid away
	. = ..()
	var/list/results = .
	for(var/thing in results)
		var/obj/item/XMG = thing
		XMG.reagents.del_reagent(/singleton/reagent/acid/polyacid)