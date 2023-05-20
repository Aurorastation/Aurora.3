// Salads
//=========================
/singleton/recipe/chips
	appliance = SKILLET | FRYER
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/singleton/recipe/nachos
	appliance = SKILLET // melt the cheese!
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

/singleton/recipe/cheesyfries
	appliance = SKILLET | MIX // You can reheat it or mix it cold, like some sort of monster.
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries

/singleton/recipe/salsa
	fruit = list("chili" = 1, "tomato" = 1, "lime" = 1)
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/blackpepper = 1,/singleton/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/singleton/recipe/guac
	fruit = list("chili" = 1, "lime" = 1)
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/blackpepper = 1,/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/singleton/recipe/cheesesauce
	appliance = SKILLET | SAUCEPAN // melt the cheese
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/blackpepper = 1,/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/singleton/recipe/redcurry
	appliance = SKILLET
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/singleton/recipe/greencurry
	appliance = SKILLET
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/singleton/recipe/yellowcurry
	appliance = SKILLET
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry

/singleton/recipe/friedrice
	appliance = SKILLET | SAUCEPAN
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/rice = 10, /singleton/reagent/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/singleton/recipe/risotto
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/alcohol/wine = 5, /singleton/reagent/nutriment/rice = 10, /singleton/reagent/spacespice = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/reagent_containers/food/snacks/risotto

/singleton/recipe/boiledrice
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/rice = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/singleton/recipe/mossbowl
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/protein/egg = 3)
	fruit = list("moss" = 2)
	result = /obj/item/reagent_containers/food/snacks/mossbowl

/singleton/recipe/ricepudding
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/rice = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/singleton/recipe/bibimbap
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list(/singleton/reagent/nutriment/rice = 5, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

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

/singleton/recipe/stewedsoymeat
	appliance = SAUCEPAN
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

// Toasts
//=========================
/singleton/recipe/tofurkey
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/singleton/recipe/stuffing
	appliance = OVEN
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing

/singleton/recipe/tortilla
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/flour = 5,/singleton/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

//Calzones
//=========================
/singleton/recipe/burrito
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	reagents = list(/singleton/reagent/spacespice = 1)
	result = /obj/item/reagent_containers/food/snacks/burrito

/singleton/recipe/burrito_vegan
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_vegan

/singleton/recipe/burrito_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_spicy

/singleton/recipe/burrito_cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese

/singleton/recipe/burrito_cheese_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese_spicy

/singleton/recipe/burrito_hell
	fruit = list("chili" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito_spicy
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/singleton/recipe/burrito_mystery
	items = list(
		/obj/item/reagent_containers/food/snacks/burrito,
		/obj/item/reagent_containers/food/snacks/soup/mystery
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_mystery

/singleton/recipe/meatbun
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun

/singleton/recipe/custardbun
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/water = 5, /singleton/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/singleton/recipe/chickenmomo
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo

/singleton/recipe/veggiemomo
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/water = 5)
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
/singleton/recipe/enchiladas_new
	appliance = OVEN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

// Tacos
//=========================

/singleton/recipe/taco
	appliance = SKILLET | MIX
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

// Peanuts
/singleton/recipe/peanuts_bowl
	appliance = OVEN
	fruit = list("peanut" = 10)
	result = /obj/item/reagent_containers/food/snacks/chipplate/peanuts_bowl
	reagent_mix = RECIPE_REAGENT_REPLACE // So the output isn't 40u total

/singleton/recipe/peanuts_bowl_dry
	appliance = OVEN
	fruit = list("dried peanut" = 10)
	result = /obj/item/reagent_containers/food/snacks/chipplate/peanuts_bowl
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/chana_masala
	appliance = POT | SAUCEPAN
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 10)
	fruit = list("chickpeas" = 2, "tomato" = 1, "chili" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chana_masala

/singleton/recipe/hummus
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/garlicsauce = 10, /singleton/reagent/spacespice = 2)
	fruit = list("chickpeas" = 2)
	result = /obj/item/reagent_containers/food/snacks/hummus

/singleton/recipe/bagel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/bagel

/singleton/recipe/fairy_bread
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/sprinkles = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/fairy_bread
