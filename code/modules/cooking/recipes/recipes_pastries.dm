//Baked sweets:
//---------------

/decl/recipe/cookie
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk = 10, /decl/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/fortunecookie
	appliance = OVEN
	reagents = list(/decl/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie

/decl/recipe/fortunecookie/make_food(var/obj/container as obj)

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

/decl/recipe/fortunecookie/check_items(var/obj/container as obj)
	. = ..()
	if (. != COOK_CHECK_FAIL)
		var/obj/item/paper/paper = locate() in container
		if (!paper || !istype(paper))
			return COOK_CHECK_FAIL
	return .

/decl/recipe/brownies
	appliance = OVEN
	reagents = list(/decl/reagent/browniemix = 10, /decl/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies

/decl/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list(/decl/reagent/browniemix = 10, /decl/reagent/nutriment/protein/egg = 3)
	fruit = list("ambrosia" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies

// Cakes.
//============
/decl/recipe/cake
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/nutriment/flour = 15, /decl/reagent/sugar = 15, /decl/reagent/nutriment/protein/egg = 9)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/plain
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/carrot

/decl/recipe/cake/cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/cheese

/decl/recipe/cake/orange
	fruit = list("orange" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/orange

/decl/recipe/cake/lime
	appliance = OVEN
	fruit = list("lime" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lime

/decl/recipe/cake/lemon
	appliance = OVEN
	fruit = list("lemon" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lemon

/decl/recipe/cake/chocolate
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/chocolate

/decl/recipe/cake/birthday
	appliance = OVEN
	items = list(/obj/item/flame/candle)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/birthday

/decl/recipe/cake/apple
	appliance = OVEN
	fruit = list("apple" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/apple

/decl/recipe/cake/brain
	appliance = OVEN
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/brain

/decl/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(/decl/reagent/nutriment/honey = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun

/decl/recipe/truffle
	appliance = OVEN
	reagents = list(/decl/reagent/nutriment/coco = 2, /decl/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

//Predesigned pies
//=======================

/decl/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie

/decl/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/decl/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/decl/recipe/pie
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/decl/reagent/sugar = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/pie

/decl/recipe/pie/apple
	fruit = list("apple" = 1)
	result = /obj/item/reagent_containers/food/snacks/applepie

/decl/recipe/pie/cherry
	fruit = list("cherries" = 1)
	reagents = list(/decl/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/cherrypie

/decl/recipe/pie/amanita
	fruit = null
	reagents = list(/decl/reagent/toxin/amatoxin = 5)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/decl/recipe/pie/plump
	fruit = list("plumphelmet" = 1)
	reagents = null
	result = /obj/item/reagent_containers/food/snacks/plump_pie

/decl/recipe/pie/pumpkin
	fruit = null
	reagents = list(/decl/reagent/sugar = 5, /decl/reagent/nutriment/pumpkinpulp = 5, /decl/reagent/spacespice/pumpkinspice = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list(/decl/reagent/sugar = 5, /decl/reagent/drink/milk = 5, /decl/reagent/nutriment/flour = 10, /decl/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/appletart
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/keylimepie
	appliance = OVEN
	fruit = list("lime" = 2)
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/sugar = 5, /decl/reagent/nutriment/protein/egg = 3, /decl/reagent/nutriment/flour = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Confections
/decl/recipe/chocolateegg
	appliance = SAUCEPAN | POT // melt the chocolate
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg
