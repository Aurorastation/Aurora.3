/datum/recipe/fries
	appliance = FRYER
	items = list(
	)


/datum/recipe/jpoppers
	appliance = FRYER
	fruit = list("chili" = 1)
	coating = /datum/reagent/nutriment/coating/batter

/datum/recipe/risottoballs
	appliance = FRYER
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	coating = /datum/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product


//Meaty Recipes
//====================
/datum/recipe/cubancarp
	appliance = FRYER
	fruit = list("chili" = 1)
	items = list(
	)

/datum/recipe/batteredsausage
	appliance = FRYER
	items = list(
	)
	coating = /datum/reagent/nutriment/coating/batter


/datum/recipe/katsu
	appliance = FRYER
	items = list(
	)
	coating = /datum/reagent/nutriment/coating/beerbatter


/datum/recipe/pizzacrunch_1
	appliance = FRYER
	items = list(
	)
	coating = /datum/reagent/nutriment/coating/batter

//Alternate pizza crunch recipe for combination pizzas made in oven
/datum/recipe/pizzacrunch_2
	appliance = FRYER
	items = list(
	)
	coating = /datum/reagent/nutriment/coating/batter

/datum/recipe/friedmushroom
	appliance = FRYER
	fruit = list("plumphelmet" = 1)
	coating = /datum/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product


//Sweet Recipes.
//==================
/datum/recipe/jellydonut
	appliance = FRYER
	reagents = list("berryjuice" = 10, "sugar" = 10)
	items = list(
	)
	result_quantity = 2

/datum/recipe/jellydonut/slime
	appliance = FRYER
	reagents = list("slimejelly" = 10, "sugar" = 10)
	items = list(
	)

/datum/recipe/jellydonut/cherry
	appliance = FRYER
	reagents = list("cherryjelly" = 10, "sugar" = 10)
	items = list(
	)

/datum/recipe/donut
	appliance = FRYER
	reagents = list("sugar" = 10)
	items = list(
	)
	result_quantity = 2

/datum/recipe/chaosdonut
	appliance = FRYER
	reagents = list("frostoil" = 10, "capsaicin" = 10, "sugar" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //This creates its own reagents
	items = list(
	)
	result_quantity = 2





/datum/recipe/funnelcake
	appliance = FRYER
	reagents = list("sugar" = 5, "batter" = 10)

/datum/recipe/pisanggoreng
	appliance = FRYER
	fruit = list("banana" = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	coating = /datum/reagent/nutriment/coating/batter