/decl/recipe/friedegg_easy
	appliance = SKILLET
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg/overeasy

/decl/recipe/friedegg
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg/overeasy
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/decl/recipe/poachedegg
	appliance = SKILLET | SAUCEPAN
	reagents = list(/decl/reagent/spacespice = 1, /decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1, /decl/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/decl/recipe/honeytoast
	appliance = SKILLET
	reagents = list(/decl/reagent/nutriment/honey = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast

/decl/recipe/bacon_and_eggs
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/decl/recipe/ntmuffin
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nt_muffin

/decl/recipe/boiledegg
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/water = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg

/decl/recipe/omelette
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list(/decl/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/decl/recipe/muffin
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/sugar = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/muffin

/decl/recipe/berrymuffin
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/sugar = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list("berries" = 1)
	result = /obj/item/reagent_containers/food/snacks/berrymuffin

/decl/recipe/quiche
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/nutriment/protein/egg = 9, /decl/reagent/nutriment/flour = 10)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/decl/recipe/pancakes
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
		)
	result = /obj/item/reagent_containers/food/snacks/pancakes
	result_quantity = 2

/decl/recipe/pancakes/berry
	fruit = list("berries" = 2)
	result = /obj/item/reagent_containers/food/snacks/pancakes/berry

/decl/recipe/waffles
	appliance = SKILLET
	reagents = list(/decl/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/waffles
