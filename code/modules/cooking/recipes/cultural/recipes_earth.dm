// Salads
//=========================
/datum/recipe/chips
	appliance = SKILLET | FRYER
	reagents = list(/datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/datum/recipe/nachos
	appliance = SKILLET // melt the cheese!
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

/datum/recipe/cheesyfries
	appliance = SKILLET | MIX // You can reheat it or mix it cold, like some sort of monster.
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries

/datum/recipe/salsa
	fruit = list("chili" = 1, "tomato" = 1, "lime" = 1)
	reagents = list(/datum/reagent/spacespice = 1, /datum/reagent/blackpepper = 1,/datum/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/guac
	fruit = list("chili" = 1, "lime" = 1)
	reagents = list(/datum/reagent/spacespice = 1, /datum/reagent/blackpepper = 1,/datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/cheesesauce
	appliance = SKILLET | SAUCEPAN // melt the cheese
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list(/datum/reagent/spacespice = 1, /datum/reagent/blackpepper = 1,/datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/redcurry
	appliance = SKILLET
	reagents = list(/datum/reagent/drink/milk/cream = 5, /datum/reagent/spacespice = 2, /datum/reagent/nutriment/rice = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/datum/recipe/greencurry
	appliance = SKILLET
	reagents = list(/datum/reagent/drink/milk/cream = 5, /datum/reagent/spacespice = 2, /datum/reagent/nutriment/rice = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/datum/recipe/yellowcurry
	appliance = SKILLET
	reagents = list(/datum/reagent/drink/milk/cream = 5, /datum/reagent/spacespice = 2, /datum/reagent/nutriment/rice = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry

/datum/recipe/friedrice
	appliance = SKILLET | SAUCEPAN
	reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/rice = 10, /datum/reagent/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/datum/recipe/risotto
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/alcohol/ethanol/wine = 5, /datum/reagent/nutriment/rice = 10, /datum/reagent/spacespice = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/reagent_containers/food/snacks/risotto

/datum/recipe/boiledrice
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/rice = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/recipe/ricepudding
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/rice = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/recipe/bibimbap
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list(/datum/reagent/nutriment/rice = 5, /datum/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

/datum/recipe/boiledspagetti
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspagetti

/datum/recipe/pastatomato
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 2)
	reagents = list(/datum/reagent/water = 5)
	items = list(/obj/item/reagent_containers/food/snacks/spagetti)
	result = /obj/item/reagent_containers/food/snacks/pastatomato

/datum/recipe/meatballspagetti
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatballspagetti

/datum/recipe/spesslaw
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/spesslaw

/datum/recipe/lomein
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/lomein

/datum/recipe/stewedsoymeat
	appliance = SAUCEPAN
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

// Toasts
//=========================
/datum/recipe/tofurkey
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/recipe/stuffing
	appliance = OVEN
	reagents = list(/datum/reagent/water = 5, /datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing

/datum/recipe/tortilla
	appliance = SKILLET
	reagents = list(/datum/reagent/nutriment/flour = 5,/datum/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

//Calzones
//=========================
/datum/recipe/burrito
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	reagents = list(/datum/reagent/spacespice = 1)
	result = /obj/item/reagent_containers/food/snacks/burrito

/datum/recipe/burrito_vegan
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_vegan

/datum/recipe/burrito_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_spicy

/datum/recipe/burrito_cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese

/datum/recipe/burrito_cheese_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese_spicy

/datum/recipe/burrito_hell
	fruit = list("chili" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito_spicy
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/datum/recipe/burrito_mystery
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/soup/mystery
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_mystery

/datum/recipe/meatbun
	reagents = list(/datum/reagent/spacespice = 1, /datum/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun

/datum/recipe/custardbun
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/spacespice = 1, /datum/reagent/water = 5, /datum/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/datum/recipe/chickenmomo
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/spacespice = 2, /datum/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo

/datum/recipe/veggiemomo
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/spacespice = 2, /datum/reagent/water = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/veggiemomo

// Sushi
//=========================
/datum/recipe/enchiladas_new
	appliance = OVEN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

// Tacos
//=========================

/datum/recipe/taco
	appliance = SKILLET | MIX
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco
