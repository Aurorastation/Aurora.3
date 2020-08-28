//Skrell foods
/decl/recipe/lortl
	appliance = OVEN
	fruit = list("q'lort slice" = 1)
	reagents = list(/datum/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/lortl
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/lortl_dry
	appliance = MIX
	fruit = list("dried q'lort slice" = 1)
	reagents = list(/datum/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/lortl

/decl/recipe/xuqqil
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/crabmeat
	)
	result = /obj/item/reagent_containers/food/snacks/xuqqil

/decl/recipe/zantiri
	appliance = SAUCEPAN | POT
	fruit = list("guami" = 2, "eki" = 1)
	reagents = list(/datum/reagent/water = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/zantiri

/decl/recipe/qilvo
	appliance = SAUCEPAN | POT
	fruit = list("seaweed" = 2)
	reagents = list(/datum/reagent/water = 10, /datum/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/squidmeat
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/qilvo
