// Tajaran breads
/datum/recipe/tajaran_bread
	appliance = OVEN
	fruit = list("nifberries" = 1)
	reagents = list(/datum/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread
	)
	result = /obj/item/reagent_containers/food/snacks/tajaran_bread
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/hardbread
	appliance = OVEN
	reagents = list(/datum/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/hardbread

// Tajaran peasant food
/datum/recipe/tajaran_stew
	appliance = SAUCEPAN | POT
	fruit = list("nifberries" = 2, "mushroom" = 1, "mtear" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/stew/tajaran

/datum/recipe/earthenroot_soup
	appliance = SAUCEPAN | POT
	fruit = list("earthenroot" = 2)
	reagents = list(/datum/reagent/water = 10, /datum/reagent/spacespice = 1, /datum/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/soup/earthenroot

/*
/datum/recipe/bloodsausage
	fruit = list("nfrihi" = 2
*/

// Tajaran Seafood
/datum/recipe/spicy_clams
	fruit = list("chili" = 1, "cabbage" = 1)
	reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/clam
	)
	result = /obj/item/reagent_containers/food/snacks/spicy_clams

// Tajaran candy
/datum/recipe/tajcandy
	appliance = OVEN
	fruit = list("sugartree" = 2)
	reagents = list(/datum/reagent/drink/milk/adhomai = 5, /datum/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/tajcandy