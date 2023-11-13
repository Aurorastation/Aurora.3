
/singleton/recipe/boiledspaghetti
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspaghetti

/singleton/recipe/pastatomato
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 2)
	reagents = list(/singleton/reagent/water = 5)
	items = list(/obj/item/reagent_containers/food/snacks/spaghetti)
	result = /obj/item/reagent_containers/food/snacks/pastatomato

/singleton/recipe/meatballspaghetti
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatballspaghetti

/singleton/recipe/spesslaw
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/spesslaw

/singleton/recipe/lomein
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/lomein
