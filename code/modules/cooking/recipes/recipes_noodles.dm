

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

/singleton/recipe/matsuul
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/sashimi,
		/obj/item/reagent_containers/food/snacks/sashimi,
		/obj/item/reagent_containers/food/snacks/sashimi
	)
	fruit = list("earthenroot" = 1, "eki" = 1, "mint" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/matsuul

/singleton/recipe/macandcheese
	appliance = SAUCEPAN | POT
	reagents = list (/singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/macandcheese

/singleton/recipe/macandcheese/bacon
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/macandcheese/bacon

/singleton/recipe/ramenbowl
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/nutriment/soysauce = 5)
	fruit = list("seaweed" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ramenbowl

/singleton/recipe/spaghettibolognese
	appliance = SAUCEPAN | POT
	fruit = list("garlic" = 1, "onion" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/protein = 6)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/spaghettibolognese

/singleton/recipe/raviolicheese
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 1)
	reagents = list(/singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ravioli/cheese

/singleton/recipe/raviolimeat
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/protein = 6)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ravioli/meat

/singleton/recipe/ravioliearthenroot
	appliance = SAUCEPAN | POT
	fruit = list("earthenroot" = 1, "pumpkin" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/drink/milk/soymilk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ravioli/earthenroot
