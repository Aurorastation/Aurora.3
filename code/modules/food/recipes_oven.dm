/datum/recipe/ovenchips
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/ovenchips



/datum/recipe/dionaroast
	appliance = OVEN
	fruit = list("apple" = 1)
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/reagent_containers/food/snacks/meat/dionanymph)
	result = /obj/item/reagent_containers/food/snacks/dionaroast
	reagent_mix = RECIPE_REAGENT_REPLACE //No eating polyacid


/datum/recipe/ribplate //Putting this here for not seeing a roast section.
	appliance = OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ribplate




//Predesigned breads
//================================
/datum/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list("sodiumchloride" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bread

/datum/recipe/baguette
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/baguette


/datum/recipe/tofubread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/tofubread


/datum/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread

/datum/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread

/datum/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/syntibread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread

/datum/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bananabread


/datum/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun

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
	reagents = list("sugar" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/pie

/datum/recipe/cherrypie
	appliance = OVEN
	fruit = list("cherries" = 1)
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/cherrypie


/datum/recipe/amanita_pie
	appliance = OVEN
	reagents = list("amatoxin" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/recipe/plump_pie
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/plump_pie


/datum/recipe/pumpkinpie
	appliance = OVEN
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10, "pumpkinpulp"= 5, "pumpkinspice"= 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	reagent_mix = RECIPE_REAGENT_REPLACE //We dont want raw egg in the result

/datum/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 10, "egg" = 3)
	result = /obj/item/reagent_containers/food/snacks/appletart
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/keylimepie
	appliance = OVEN
	fruit = list("lime" = 2)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/quiche
	appliance = OVEN
	reagents = list("milk" = 5, "egg" = 9, "flour" = 10)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/tajaran_bread
	appliance = OVEN
	fruit = list("nifberries" = 1)
	reagents = list("spacespice" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread
	)
	result = /obj/item/reagent_containers/food/snacks/tajaran_bread
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/hardbread
	appliance = OVEN
	reagents = list("spacespice" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/hardbread

//Baked sweets:
//---------------

/datum/recipe/cookie
	appliance = OVEN
	reagents = list("milk" = 10, "sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/fortunecookie
	appliance = OVEN
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie
	make_food(var/obj/container as obj)

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


	check_items(var/obj/container as obj)
		. = ..()
		if (.)
			var/obj/item/paper/paper = locate() in container
			if (!paper || !istype(paper))
				return 0
			if (!paper.info)
				return 0
		return .

/datum/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2


/datum/recipe/cracker
	appliance = OVEN
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker

/datum/recipe/brownies
	appliance = OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies


/datum/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	fruit = list("ambrosia" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies




//Pizzas
//=========================
/datum/recipe/pizzamargherita
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/pineapplepizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

//Spicy
//================
/datum/recipe/enchiladas
	appliance = OVEN
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cutlet)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

/datum/recipe/monkeysdelight
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	result = /obj/item/reagent_containers/food/snacks/monkeysdelight
	reagent_mix = RECIPE_REAGENT_REPLACE





// Cakes.
//============
/datum/recipe/cake
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/plain
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/cake/carrot
	appliance = OVEN
	fruit = list("carrot" = 3)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/carrot

/datum/recipe/cake/cheese
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/cheese

/datum/recipe/cake/orange
	appliance = OVEN
	fruit = list("orange" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "orangejuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/orange

/datum/recipe/cake/lime
	appliance = OVEN
	fruit = list("lime" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "limejuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lime

/datum/recipe/cake/lemon
	appliance = OVEN
	fruit = list("lemon" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "lemonjuice" = 3, "sugar" = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cake/lemon

/datum/recipe/cake/chocolate
	appliance = OVEN
	items = list(/obj/item/reagent_containers/food/snacks/chocolatebar)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "coco" = 4, "sugar" = 5)
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

/datum/recipe/pancakes
	appliance = OVEN
	fruit = list("berries" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
		)
	result = /obj/item/reagent_containers/food/snacks/pancakes
	result_quantity = 2

/datum/recipe/lasagna
	appliance = OVEN
	fruit = list("tomato" = 2, "eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/lasagna
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list("honey" = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun

/datum/recipe/enchiladas_new
	appliance = OVEN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

//Bacon
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

/datum/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/datum/recipe/bacon_flatbread
	appliance = OVEN
	fruit = list("tomato" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_flatbread

/datum/recipe/truffle
	appliance = OVEN
	reagents = list("coco" = 2, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

/datum/recipe/croissant
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "water" = 5, "milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/croissant

/datum/recipe/tajcandy
	appliance = OVEN
	fruit = list("sugartree" = 2)
	reagents = list("fatshouter_milk" = 5, "egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/tajcandy