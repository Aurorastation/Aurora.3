/singleton/recipe/tortilla
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/flour = 5,/singleton/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

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
	appliance = SKILLET | MIX | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

/singleton/recipe/fish_taco
	appliance = MIX | SKILLET | MICROWAVE
	fruit = list("chili" = 1, "lemon" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/fish_taco

// Chips
//=========================

/singleton/recipe/chips
	appliance = SKILLET | FRYER | MICROWAVE
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/singleton/recipe/nachos
	appliance = SKILLET | MICROWAVE // melt the cheese!
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

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
	appliance = SKILLET | SAUCEPAN | MICROWAVE // melt the cheese
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/blackpepper = 1,/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/singleton/recipe/hummus
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/garlicsauce = 10, /singleton/reagent/spacespice = 2)
	fruit = list("chickpeas" = 2)
	result = /obj/item/reagent_containers/food/snacks/dip/hummus

// Peanuts
//=========================
/singleton/recipe/peanuts_bowl
	appliance = OVEN | MICROWAVE
	fruit = list("peanut" = 10)
	result = /obj/item/reagent_containers/food/snacks/chipplate/peanuts_bowl
	reagent_mix = RECIPE_REAGENT_REPLACE // So the output isn't 40u total

/singleton/recipe/peanuts_bowl_dry
	appliance = OVEN | MICROWAVE
	fruit = list("dried peanut" = 10)
	result = /obj/item/reagent_containers/food/snacks/chipplate/peanuts_bowl
	reagent_mix = RECIPE_REAGENT_REPLACE

// Burritos
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
