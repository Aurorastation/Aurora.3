/decl/recipe/popcorn
	appliance = SAUCEPAN
	fruit = list("corn" = 1)
	result = /obj/item/reagent_containers/food/snacks/popcorn

// Jellies
/decl/recipe/amanitajelly
	appliance = SAUCEPAN
	reagents = list(/decl/reagent/water = 5, /decl/reagent/alcohol/vodka = 5, /decl/reagent/toxin/amatoxin = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly
	make_food(var/obj/container as obj)

		. = ..(container)
		for (var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
			being_cooked.reagents.del_reagent(/decl/reagent/toxin/amatoxin)

// Ports from the microwave... yeah

/decl/recipe/mint
	appliance = SAUCEPAN
	reagents = list(/decl/reagent/sugar = 5, /decl/reagent/frostoil = 5)
	result = /obj/item/reagent_containers/food/snacks/mint

/decl/recipe/porkbowl
	appliance = SAUCEPAN
	reagents = list(/decl/reagent/water = 5, /decl/reagent/nutriment/rice = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

/decl/recipe/crab_legs
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/water = 10, /decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/crabmeat,
		/obj/item/reagent_containers/food/snacks/spreads
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/crab_legs
