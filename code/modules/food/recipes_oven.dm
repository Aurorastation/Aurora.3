/datum/recipe/ovenchips
	appliance = OVEN
	items = list(
	)



/datum/recipe/dionaroast
	appliance = OVEN
	fruit = list("apple" = 1)
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	reagent_mix = RECIPE_REAGENT_REPLACE //No eating polyacid


/datum/recipe/ribplate //Putting this here for not seeing a roast section.
	appliance = OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE




//Predesigned breads
//================================
/datum/recipe/bread
	appliance = OVEN
	items = list(
	)
	reagents = list("sodiumchloride" = 1)

/datum/recipe/baguette
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
	)


/datum/recipe/tofubread
	appliance = OVEN
	items = list(
	)


/datum/recipe/creamcheesebread
	appliance = OVEN
	items = list(
	)

/datum/recipe/flatbread
	appliance = OVEN
	items = list(
	)

/datum/recipe/meatbread
	appliance = OVEN
	items = list(
	)

/datum/recipe/syntibread
	appliance = OVEN
	items = list(
	)

/datum/recipe/xenomeatbread
	appliance = OVEN
	items = list(
	)

/datum/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
	)


/datum/recipe/bun
	appliance = OVEN
	items = list(
	)

//Predesigned pies
//=======================

/datum/recipe/meatpie
	appliance = OVEN
	items = list(
	)

/datum/recipe/tofupie
	appliance = OVEN
	items = list(
	)

/datum/recipe/xemeatpie
	appliance = OVEN
	items = list(
	)

/datum/recipe/pie
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("sugar" = 5)

/datum/recipe/cherrypie
	appliance = OVEN
	fruit = list("cherries" = 1)
	reagents = list("sugar" = 10)
	items = list(
	)


/datum/recipe/amanita_pie
	appliance = OVEN
	reagents = list("amatoxin" = 5)

/datum/recipe/plump_pie
	appliance = OVEN
	fruit = list("plumphelmet" = 1)


/datum/recipe/pumpkinpie
	appliance = OVEN
	fruit = list("pumpkin" = 1)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //We dont want raw egg in the result

/datum/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 10, "egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/keylimepie
	appliance = OVEN
	fruit = list("lime" = 2)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/quiche
	appliance = OVEN
	reagents = list("milk" = 5, "egg" = 9, "flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Baked sweets:
//---------------

/datum/recipe/cookie
	appliance = OVEN
	reagents = list("milk" = 10, "sugar" = 10)
	items = list(
	)
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/fortunecookie
	appliance = OVEN
	reagents = list("sugar" = 5)
	items = list(
	)
	make_food(var/obj/container as obj)


		//Fuck fortune cookies. This is a quick hack
		//Duplicate the item searching code with a special case for paper
		for (var/i in items)
			var/obj/item/I = locate(i) in container
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


			paper.loc = being_cooked
			being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
			return


	check_items(var/obj/container as obj)
		. = ..()
		if (.)
			if (!paper || !istype(paper))
				return 0
			if (!paper.info)
				return 0
		return .

/datum/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	result_quantity = 2


/datum/recipe/cracker
	appliance = OVEN
	reagents = list("sodiumchloride" = 1)
	items = list(
	)

/datum/recipe/brownies
	appliance = OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe


/datum/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	fruit = list("ambrosia" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe




//Pizzas
//=========================
/datum/recipe/pizzamargherita
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
	)

/datum/recipe/meatpizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
	)

/datum/recipe/syntipizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
	)

/datum/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles

/datum/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
	)






//Spicy
//================
/datum/recipe/enchiladas
	appliance = OVEN
	fruit = list("chili" = 2, "corn" = 1)



/datum/recipe/monkeysdelight
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE





// Cakes.
//============
/datum/recipe/cake
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/cake/carrot
	appliance = OVEN
	fruit = list("carrot" = 3)

/datum/recipe/cake/cheese
	appliance = OVEN
	items = list(
	)

/datum/recipe/cake/orange
	appliance = OVEN
	fruit = list("orange" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "orangejuice" = 3, "sugar" = 5)

/datum/recipe/cake/lime
	appliance = OVEN
	fruit = list("lime" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "limejuice" = 3, "sugar" = 5)

/datum/recipe/cake/lemon
	appliance = OVEN
	fruit = list("lemon" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "lemonjuice" = 3, "sugar" = 5)

/datum/recipe/cake/chocolate
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "coco" = 4, "sugar" = 5)

/datum/recipe/cake/birthday
	appliance = OVEN
	items = list(/obj/item/clothing/head/cakehat)

/datum/recipe/cake/apple
	appliance = OVEN
	fruit = list("apple" = 2)

/datum/recipe/cake/brain
	appliance = OVEN
	items = list(/obj/item/organ/brain)

/datum/recipe/pancakes
	appliance = OVEN
	fruit = list("blueberries" = 2)
	items = list(
	)

/datum/recipe/lasagna
	appliance = OVEN
	fruit = list("tomato" = 2, "eggplant" = 1)
	items = list(
	)

/datum/recipe/honeybun
	appliance = OVEN
	items = list(
	)
	reagents = list("honey" = 5)
