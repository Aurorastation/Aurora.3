
// see code/datums/recipe.dm

/singleton/recipe/humankabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/human/kabob

/singleton/recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/singleton/recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/singleton/recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob

/singleton/recipe/hengsharolls
	fruit = list("cabbage" = 1, "corn" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/mashedpotato,
		/obj/item/reagent_containers/food/snacks/tofu
		)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/hengsharolls

// Salads

/singleton/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/reagent_containers/food/snacks/salad/tossedsalad

/singleton/recipe/aesirsalad
	fruit = list("goldapple" = 1, "ambrosiadeus" = 1)
	result = /obj/item/reagent_containers/food/snacks/salad/aesirsalad
/singleton/recipe/validsalad
	fruit = list("potato" = 1, "ambrosia" = 3)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/salad/validsalad

/singleton/recipe/validsalad/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/salad/validsalad/being_cooked in .)
		being_cooked.reagents.del_reagent(/singleton/reagent/toxin)

/singleton/recipe/tabboulehsalad
	fruit = list("mint" = 3, "tomato" = 1, "wheat" = 1, "lemon" = 1)
	result = /obj/item/reagent_containers/food/snacks/salad/tabboulehsalad
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/tunasalad
	fruit = list("mint" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
		)
	reagents = list(/singleton/reagent/nutriment/mayonnaise = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/salad/tunasalad

/singleton/recipe/tunapastasalad
	fruit = list("mint" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/boiledspaghetti,
		/obj/item/reagent_containers/food/snacks/fish
		)
	reagents = list(/singleton/reagent/nutriment/mayonnaise = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/salad/tunapasta


