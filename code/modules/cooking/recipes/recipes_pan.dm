/decl/recipe/popcorn
	appliance = SAUCEPAN
	fruit = list("corn" = 1)
	result = /obj/item/reagent_containers/food/snacks/popcorn

// Jellies
/decl/recipe/amanitajelly
	appliance = SAUCEPAN
	reagents = list(/datum/reagent/water = 5, /datum/reagent/alcohol/ethanol/vodka = 5, /datum/reagent/toxin/amatoxin = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly
	make_food(var/obj/container as obj)

		. = ..(container)
		for (var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
			being_cooked.reagents.del_reagent(/datum/reagent/toxin/amatoxin)

// Ports from the microwave... yeah

/decl/recipe/mint
	appliance = SAUCEPAN
	reagents = list(/datum/reagent/sugar = 5, /datum/reagent/frostoil = 5)
	result = /obj/item/reagent_containers/food/snacks/mint

/decl/recipe/porkbowl
	appliance = SAUCEPAN
	reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/rice = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

/decl/recipe/crab_legs
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 10, /datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/crabmeat,
		/obj/item/reagent_containers/food/snacks/spreads
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/crab_legs
