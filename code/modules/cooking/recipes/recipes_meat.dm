/singleton/recipe/cutlet
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet

/singleton/recipe/meatball
	appliance = SKILLET | SAUCEPAN | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatball

/singleton/recipe/bacon
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon

/singleton/recipe/bacon_oven
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/oven
	result_quantity = 6

//Bacon
/singleton/recipe/bacon_pan
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/pan
	result_quantity = 6

/singleton/recipe/meatsteak
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/singleton/recipe/syntisteak
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/singleton/recipe/sausage
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/sausage
	result_quantity = 2

/singleton/recipe/hotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog

/singleton/recipe/classichotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/corgi
	)
	result = /obj/item/reagent_containers/food/snacks/classichotdog

/singleton/recipe/pepperoni
	appliance = SKILLET
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/pepperoni
	result_quantity = 1

/singleton/recipe/nugget
	appliance = FRYER
	reagents = list(/singleton/reagent/nutriment/flour = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nugget
	result_quantity = 4

/singleton/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/pita,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab

/singleton/recipe/meatballs_and_peas
	appliance = SKILLET | SAUCEPAN | MICROWAVE
	fruit = list("peas" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
	)
	result = /obj/item/reagent_containers/food/snacks/meatballs_and_peas
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/schnitzel
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/flour = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/schnitzel
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/cozmo_cubes
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/cosmozoan,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/cozmo_cubes
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/steak_tartare
	fruit = list("onion" = 1)
	appliance = MIX
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/nutriment/protein/egg = 3)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/steak_tartare
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/meatloaf
	appliance = OVEN
	fruit = list("onion" = 1)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/nutriment/ketchup = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatloaf
	reagent_mix = RECIPE_REAGENT_REPLACE
