/singleton/recipe/icecreamsandwich
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/drink/ice = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/icecreamsandwich

/singleton/recipe/banana_split
	fruit = list("banana" = 1)
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/drink/ice = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/banana_split

/singleton/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/sugar = 5)
	result = /obj/item/reagent_containers/food/snacks/candiedapple


/singleton/recipe/izuixu
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/drink/ice = 5, /singleton/reagent/alcohol/butanol/xuizijuice= 5)
	fruit = list("strawberries" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/izuixu

/singleton/recipe/triolade
	appliance = SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/whitechocolate
	)
	reagents = list(/singleton/reagent/nutriment/coco = 5 , /singleton/reagent/drink/milk/cream = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify it
	result = /obj/item/reagent_containers/food/snacks/triolade


/singleton/recipe/floatingisland
	fruit = list("cherries" = 1)
	reagents = list(/singleton/reagent/nutriment/gelatin = 5, /singleton/reagent/drink/ice = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/reagent_containers/food/snacks/floatingisland

/singleton/recipe/pralinebox
	appliance = SAUCEPAN
	fruit = list("cherries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/whitechocolate
	)
	reagents = list(/singleton/reagent/nutriment/coco = 10 , /singleton/reagent/drink/milk/cream = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify it
	result = /obj/item/storage/box/fancy/food/pralinebox

/singleton/recipe/chocolatecrepe
	appliance = SKILLET
	items = list(
	/obj/item/reagent_containers/food/snacks/plaincrepe
	)
	reagents = list(/singleton/reagent/nutriment/choconutspread = 5)
	result = /obj/item/reagent_containers/food/snacks/crepe/chocolate

/singleton/recipe/chocolatecrepe_fancy
	fruit = list("banana" = 1)
	items = list(
	/obj/item/reagent_containers/food/snacks/crepe/chocolate,
	/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/crepe/chocolatefancy
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/whitechocolatecrepe
	appliance = SKILLET
	items = list(
	/obj/item/reagent_containers/food/snacks/plaincrepe,
	/obj/item/reagent_containers/food/snacks/whitechocolate
	)
	result = /obj/item/reagent_containers/food/snacks/crepe/whitechocolate

/singleton/recipe/whitechocolatecrepe_fancy
	fruit = list("strawberries" = 1)
	items = list(
	/obj/item/reagent_containers/food/snacks/crepe/whitechocolate,
	/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/crepe/whitechocolate_fancy
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/breakfastcrepe //yeah savory crepes are not exactly confections but... still kind of the best place for it.
	appliance = SKILLET
	items = list(
	/obj/item/reagent_containers/food/snacks/plaincrepe,
	/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/crepe/breakfast

/singleton/recipe/hamcheesecrepe
	appliance = SKILLET
	items = list(
	/obj/item/reagent_containers/food/snacks/plaincrepe,
	/obj/item/reagent_containers/food/snacks/cheesewedge,
	/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/crepe/hamcheese

/singleton/recipe/custard
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sugar = 5, /singleton/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/custard

/singleton/recipe/nakarka_mousse_berry
	appliance = SAUCEPAN
	fruit = list ("berries" = 1)
	reagents = list(/singleton/reagent/drink/milk/nemiik = 5, /singleton/reagent/drink/milk/cream = 5, /singleton/reagent/sugar = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nakarka_mousse

/singleton/recipe/nakarka_mousse_cherry
	appliance = SAUCEPAN
	reagents = list(/singleton/reagent/drink/milk/nemiik = 5, /singleton/reagent/drink/milk/cream = 5, /singleton/reagent/sugar = 5, /singleton/reagent/nutriment/cherryjelly = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nakarka_mousse/cherry
