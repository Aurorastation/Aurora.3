/singleton/recipe/mashedpotato
	appliance = POT | SAUCEPAN | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
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

/singleton/recipe/plaincrepe
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/coating/batter = 5)
	result = /obj/item/reagent_containers/food/snacks/plaincrepe
	reagent_mix = RECIPE_REAGENT_REPLACE
