/singleton/recipe/popcorn
	appliance = SAUCEPAN
	fruit = list("corn" = 1)
	result = /obj/item/reagent_containers/food/snacks/popcorn

// Jellies
/singleton/recipe/amanitajelly
	appliance = SAUCEPAN
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/alcohol/vodka = 5, /singleton/reagent/toxin/amatoxin = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly

/singleton/recipe/amanitajelly/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
		being_cooked.reagents.del_reagent(/singleton/reagent/toxin/amatoxin)

// Ports from the microwave... yeah

/singleton/recipe/mint
	appliance = SAUCEPAN
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/frostoil = 5)
	result = /obj/item/reagent_containers/food/snacks/mint
