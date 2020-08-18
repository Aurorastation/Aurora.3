//Baked sweets:
//---------------

/datum/recipe/cookie
	appliance = OVEN
	reagents = list(/datum/reagent/drink/milk = 10, /datum/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/fortunecookie
	appliance = OVEN
	reagents = list(/datum/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie

/datum/recipe/fortunecookie/make_food(var/obj/container as obj)

	var/obj/item/paper/paper

	//Fuck fortune cookies. This is a quick hack
	//Duplicate the item searching code with a special case for paper
	for (var/i in items)
		var/obj/item/I = locate(i) in container
		if (!paper  && istype(I, /obj/item/paper))
			paper = I
			continue

		if (I)
			qdel(I)

	//Then store and null out the items list so it wont delete any paper
	var/list/L = items.Copy()
	items = null
	. = ..(container)

	//Restore items list, so that making fortune cookies once doesnt break the oven
	items = L


	for (var/obj/item/reagent_containers/food/snacks/fortunecookie/being_cooked in .)
		paper.forceMove(being_cooked)
		being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
		return

/datum/recipe/fortunecookie/check_items(var/obj/container as obj)
	. = ..()
	if (.)
		var/obj/item/paper/paper = locate() in container
		if (!paper || !istype(paper))
			return FALSE
		if (!paper.info)
			return FALSE
	return .

/datum/recipe/brownies
	appliance = OVEN
	reagents = list(/datum/reagent/browniemix = 10, /datum/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies

/datum/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list(/datum/reagent/browniemix = 10, /datum/reagent/nutriment/protein/egg = 3)
	fruit = list("ambrosia" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies

// Cakes.
//============
/datum/recipe/cake
	appliance = OVEN
	reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/flour = 15, /datum/reagent/sugar = 15, /datum/reagent/nutriment/protein/egg = 9)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/plain
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/carrot

/datum/recipe/cake/cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/cheese

/datum/recipe/cake/orange
	fruit = list("orange" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/orange

/datum/recipe/cake/lime
	appliance = OVEN
	fruit = list("lime" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lime

/datum/recipe/cake/lemon
	appliance = OVEN
	fruit = list("lemon" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lemon

/datum/recipe/cake/chocolate
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/chocolate

/datum/recipe/cake/birthday
	appliance = OVEN
	items = list(/obj/item/flame/candle)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/birthday

/datum/recipe/cake/apple
	appliance = OVEN
	fruit = list("apple" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/apple

/datum/recipe/cake/brain
	appliance = OVEN
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/brain

/datum/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(/datum/reagent/nutriment/honey = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun

/datum/recipe/truffle
	appliance = OVEN
	reagents = list(/datum/reagent/nutriment/coco = 2, /datum/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

//Predesigned pies
//=======================

/datum/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie

/datum/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/datum/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/datum/recipe/pie
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/datum/reagent/sugar = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/pie

/datum/recipe/pie/apple
	fruit = list("apple" = 1)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/recipe/pie/cherry
	fruit = list("cherries" = 1)
	reagents = list(/datum/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/cherrypie

/datum/recipe/pie/amanita
	fruit = null
	reagents = list(/datum/reagent/toxin/amatoxin = 5)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/recipe/pie/plump
	fruit = list("plumphelmet" = 1)
	reagents = null
	result = /obj/item/reagent_containers/food/snacks/plump_pie

/datum/recipe/pie/pumpkin
	fruit = null
	reagents = list(/datum/reagent/sugar = 5, /datum/reagent/nutriment/pumpkinpulp = 5, /datum/reagent/spacespice/pumpkinspice = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list(/datum/reagent/sugar = 5, /datum/reagent/drink/milk = 5, /datum/reagent/nutriment/flour = 10, /datum/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/appletart
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/keylimepie
	appliance = OVEN
	fruit = list("lime" = 2)
	reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/sugar = 5, /datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Confections
/datum/recipe/chocolateegg
	appliance = SAUCEPAN | POT // melt the chocolate
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg
