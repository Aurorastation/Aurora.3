//Baked sweets:
//---------------

////////////////////////////////////////////MUFFINS////////////////////////////////////////////
/singleton/recipe/muffin
	appliance = OVEN | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk = 20, /singleton/reagent/sugar = 20)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin
	result_quantity = 6

/singleton/recipe/muffin/berry
	fruit = list("berries" = 2)
	result = /obj/item/reagent_containers/food/snacks/muffin/berry

/singleton/recipe/muffin/chocolate
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin/chocolate

/singleton/recipe/muffin/whitechocolate
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/whitechocolate,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin/whitechocolate

/singleton/recipe/muffin/cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin/cheese

/singleton/recipe/muffin/cheese/honkers
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers,
	)

/singleton/recipe/muffin/butter
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/spreads/butter,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin/butter

/singleton/recipe/muffin/raisin
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/no_raisin,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin/raisin

/singleton/recipe/muffin/meat
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin/meat

/singleton/recipe/muffin/meat/meatsnack
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatsnack,
	)

////////////////////////////////////////////PANCAKES////////////////////////////////////////////

/singleton/recipe/pancakes
	appliance = SKILLET
	reagents = list(/singleton/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes

/singleton/recipe/pancakes/berry //alternate way to get berry pancakes if you want to use actual berries and not syrup.
	fruit = list("berries" = 1)
	reagents = list(/singleton/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes/berry

////////////////////////////////////////////WAFFLES////////////////////////////////////////////

/singleton/recipe/waffles
	appliance = SKILLET
	reagents = list(/singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/waffles

/singleton/recipe/soywafers
	appliance = OVEN | MICROWAVE
	fruit = list("soybeans" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soywafers

/singleton/recipe/rofflewaffles
	appliance = OVEN | MICROWAVE
	reagents = list(/singleton/reagent/drugs/psilocybin = 5, /singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

////////////////////////////////////////////OTHER////////////////////////////////////////////

/singleton/recipe/cookie
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 10, /singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/fortunecookie
	appliance = OVEN
	reagents = list(/singleton/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie

/singleton/recipe/fortunecookie/make_food(var/obj/container as obj)

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

/singleton/recipe/fortunecookie/check_items(var/obj/container as obj)
	. = ..()
	if (. != COOK_CHECK_FAIL)
		var/obj/item/paper/paper = locate() in container
		if (!paper || !istype(paper))
			return COOK_CHECK_FAIL
	return .

/singleton/recipe/brownies
	appliance = OVEN
	reagents = list(/singleton/reagent/browniemix = 10, /singleton/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies

/singleton/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list(/singleton/reagent/browniemix = 10, /singleton/reagent/nutriment/protein/egg = 3)
	fruit = list("ambrosia" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies

/singleton/recipe/cakepops
	appliance = OVEN
	reagents = list(/singleton/reagent/browniemix = 5, /singleton/reagent/nutriment/vanilla = 5, /singleton/reagent/nutriment/sprinkles = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/whitechocolate
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/storage/box/fancy/food/cakepopjar

/singleton/recipe/cranberry_orange_rolls
	appliance = OVEN
	fruit = list("cranberries" = 1, "orange"  = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/drink/milk/cream = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace
	result = /obj/item/reagent_containers/food/snacks/sliceable/cranberry_orange_rolls

// Cakes.
//============
/singleton/recipe/cake
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/flour = 15, /singleton/reagent/sugar = 15, /singleton/reagent/nutriment/protein/egg = 9)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/plain
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/carrot

/singleton/recipe/cake/cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/cheese

/singleton/recipe/cake/orange
	fruit = list("orange" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/orange

/singleton/recipe/cake/lime
	appliance = OVEN
	fruit = list("lime" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lime

/singleton/recipe/cake/lemon
	appliance = OVEN
	fruit = list("lemon" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lemon

/singleton/recipe/cake/chocolate
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/chocolate

/singleton/recipe/cake/birthday
	appliance = OVEN
	items = list(/obj/item/flame/candle)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/birthday

/singleton/recipe/cake/apple
	appliance = OVEN
	fruit = list("apple" = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/apple

/singleton/recipe/cake/ntella_cheesecake
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/choconutspread = 15, /singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cookiesnack,
		/obj/item/reagent_containers/food/snacks/cookiesnack,
		/obj/item/reagent_containers/food/snacks/cookiesnack,
		/obj/item/reagent_containers/food/snacks/cookiesnack,
		/obj/item/reagent_containers/food/snacks/cookiesnack,
		/obj/item/reagent_containers/food/snacks/cookiesnack //Oreo cookies aren't a thing in the game yet but if/when they're made, please replace this with them!
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/ntella_cheesecake

/singleton/recipe/cake/starcake
	fruit = list("orange" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 10, /singleton/reagent/sugar = 15, /singleton/reagent/nutriment/coco = 10, /singleton/reagent/drink/milk/cream = 5, /singleton/reagent/nutriment/protein/egg = 6)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/starcake

//Predesigned pies
//=======================
/singleton/recipe/berryclafoutis
	appliance = OVEN
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/singleton/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat
	)
	recipe_taste_override = list("uncooked dough" = "crispy dough")
	result = /obj/item/reagent_containers/food/snacks/meatpie

/singleton/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/singleton/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/singleton/recipe/pie
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/singleton/reagent/sugar = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/pie

/singleton/recipe/pie/apple
	fruit = list("apple" = 1)
	result = /obj/item/reagent_containers/food/snacks/applepie

/singleton/recipe/pie/cherry
	fruit = list("cherries" = 1)
	reagents = list(/singleton/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/cherrypie

/singleton/recipe/pie/cranberry
	fruit = list("cranberries" = 1)
	reagents = list(/singleton/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cranberry_pie
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace

/singleton/recipe/pie/amanita
	fruit = null
	reagents = list(/singleton/reagent/toxin/amatoxin = 5)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/singleton/recipe/pie/plump
	fruit = list("plumphelmet" = 1)
	reagents = null
	result = /obj/item/reagent_containers/food/snacks/plump_pie

/singleton/recipe/pie/pumpkin
	fruit = null
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/nutriment/pumpkinpulp = 5, /singleton/reagent/spacespice/pumpkinspice = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/keylimepie
	appliance = OVEN
	fruit = list("lime" = 2)
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sugar = 5, /singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/nutriment/flour = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/singleton/recipe/quiche
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/protein/egg = 9, /singleton/reagent/nutriment/flour = 10)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/singleton/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/flour = 10, /singleton/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/appletart
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/truffle
	appliance = OVEN
	reagents = list(/singleton/reagent/nutriment/coco = 2, /singleton/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

/singleton/recipe/giffypie
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sugar = 5, /singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/nutriment/flour = 10, /singleton/reagent/nutriment/grapejelly = 10, /singleton/reagent/nutriment/peanutbutter = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/giffypie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Roulades
/singleton/recipe/ylpharoulade
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/whitechocolate
	)
	reagents = list(/singleton/reagent/sugar = 10, /singleton/reagent/drink/ylphaberryjuice = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/ylpharoulade
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/chocolateroulade
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	reagents = list(/singleton/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/chocolateroulade
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/strawberrybars
	appliance = OVEN
	fruit = list("strawberries" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	reagents = list(/singleton/reagent/nutriment/flour = 10, /singleton/reagent/sugar = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sliceable/strawberrybars
