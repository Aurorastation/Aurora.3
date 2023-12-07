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

/singleton/recipe/pralinebox //Don't put this recipe in the wiki i want it to be hidden here in the code.
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
