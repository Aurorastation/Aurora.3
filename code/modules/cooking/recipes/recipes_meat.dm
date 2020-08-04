/datum/recipe/cutlet
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet

/datum/recipe/meatball
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatball

/datum/recipe/bacon
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon

/datum/recipe/bacon_oven
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/oven
	result_quantity = 6

//Bacon
/datum/recipe/bacon_pan
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/pan
	result_quantity = 6

/datum/recipe/meatsteak
	appliance = SKILLET
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/recipe/syntisteak
	appliance = SKILLET
	reagents = list(/datum/reagent/sodiumchloride = 1, /datum/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/recipe/sausage
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/sausage
	result_quantity = 2

/datum/recipe/nugget
	appliance = FRYER
	reagents = list(/datum/reagent/nutriment/flour = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nugget

/datum/recipe/fishandchips
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips
