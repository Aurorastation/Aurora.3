/singleton/recipe/mashedpotato
	fruit = list("potato" = 1)
	result = /obj/item/reagent_containers/food/snacks/mashedpotato

/singleton/recipe/sauerkraut
	appliance = MIX
	fruit = list("cabbage" = 1)
	reagents = list(/singleton/reagent/enzyme = 5)
	result = /obj/item/reagent_containers/food/snacks/sauerkraut
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/whitechocolate
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/vanilla = 2, /singleton/reagent/drink/milk = 2, /singleton/reagent/sugar = 2)
	result = /obj/item/reagent_containers/food/snacks/whitechocolate
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/whitechocolate/soy
	reagents = list(/singleton/reagent/nutriment/vanilla = 2, /singleton/reagent/drink/milk/soymilk = 2, /singleton/reagent/sugar = 2)
