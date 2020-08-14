/datum/recipe/chilied_eggs
	appliance = SAUCEPAN | POT
	items = list(
		/obj/item/reagent_containers/food/snacks/hotchili,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/chilied_eggs

/datum/recipe/red_sun_special
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/cheesewedge

	)
	result = /obj/item/reagent_containers/food/snacks/red_sun_special

/datum/recipe/hatchling_suprise
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/poachedegg,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon

	)
	result = /obj/item/reagent_containers/food/snacks/hatchling_suprise

/datum/recipe/riztizkzi_sea
	appliance = SAUCEPAN | POT
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagents = list(/datum/reagent/blood = 15)
	result = /obj/item/reagent_containers/food/snacks/riztizkzi_sea

/datum/recipe/father_breakfast
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/omelette,
		/obj/item/reagent_containers/food/snacks/meatsteak
	)
	result = /obj/item/reagent_containers/food/snacks/father_breakfast

/datum/recipe/stuffed_meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/reagent_containers/food/snacks/stuffed_meatball

/datum/recipe/grilled_carp
	appliance = SKILLET // 'grilled' is even in the name
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish
	)
	reagents = list(/datum/reagent/spacespice = 1)
	fruit = list("cabbage" = 1, "lime" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/grilled_carp

/datum/recipe/bacon_stick
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_stick

/datum/recipe/egg_pancake
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/omelette
	)
	result = /obj/item/reagent_containers/food/snacks/egg_pancake

/datum/recipe/sushi_roll
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/boiledrice
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi_roll
