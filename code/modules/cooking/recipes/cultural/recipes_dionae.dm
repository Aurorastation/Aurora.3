/datum/recipe/dionae_soup
	APPLIANCE = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 10)
	fruit = list("cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/dionanymph
	)
	result = /obj/item/reagent_containers/food/snacks/soup/diona
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/dionae_stew
	APPLIANCE = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 10)
	fruit = list("potato" = 1, "carrot" = 1, "mushroom" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/dionanymph
	)
	result = /obj/item/reagent_containers/food/snacks/stew/diona
	reagent_mix = RECIPE_REAGENT_REPLACE
