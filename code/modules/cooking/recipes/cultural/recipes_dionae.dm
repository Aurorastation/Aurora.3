/decl/recipe/dionae_soup
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/water = 10)
	fruit = list("cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/dionanymph
	)
	result = /obj/item/reagent_containers/food/snacks/soup/diona
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/dionae_stew
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/water = 10)
	fruit = list("potato" = 1, "carrot" = 1, "mushroom" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/dionanymph
	)
	result = /obj/item/reagent_containers/food/snacks/stew/diona
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/diona_roast
	appliance = OVEN
	fruit = list("apple" = 1)
	reagents = list(/decl/reagent/spacespice = 2)
	items = list(/obj/item/reagent_containers/food/snacks/meat/dionanymph)
	result = /obj/item/reagent_containers/food/snacks/sliceable/dionaroast