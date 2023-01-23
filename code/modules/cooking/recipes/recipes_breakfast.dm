/singleton/recipe/friedegg_easy
	appliance = SKILLET
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg/overeasy

/singleton/recipe/friedegg
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg/overeasy
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/singleton/recipe/poachedegg
	appliance = SKILLET | SAUCEPAN
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/singleton/recipe/honeytoast
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/honey = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast

/singleton/recipe/bacon_and_eggs
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/singleton/recipe/ntmuffin
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nt_muffin

/singleton/recipe/boiledegg
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg

/singleton/recipe/omelette
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/singleton/recipe/muffin
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sugar = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/muffin

/singleton/recipe/berrymuffin
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sugar = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list("berries" = 1)
	result = /obj/item/reagent_containers/food/snacks/berrymuffin

/singleton/recipe/quiche
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/protein/egg = 9, /singleton/reagent/nutriment/flour = 10)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/singleton/recipe/pancakes
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
		)
	result = /obj/item/reagent_containers/food/snacks/pancakes
	result_quantity = 2

/singleton/recipe/pancakes/berry
	fruit = list("berries" = 2)
	result = /obj/item/reagent_containers/food/snacks/pancakes/berry

/singleton/recipe/waffles
	appliance = SKILLET
	reagents = list(/singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/waffles
