//Planty recipes
//====================
/singleton/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries


/singleton/recipe/jpoppers
	appliance = FRYER
	fruit = list("chili" = 1)
	coating = /singleton/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/jalapeno_poppers

/singleton/recipe/risottoballs
	appliance = FRYER
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/risotto)
	coating = /singleton/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/risottoballs

/singleton/recipe/onionrings
	appliance = FRYER
	fruit = list("onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/onionrings

/singleton/recipe/friedmushroom
	appliance = FRYER
	fruit = list("plumphelmet" = 1)
	coating = /singleton/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedmushroom

//Meaty Recipes
//====================
/singleton/recipe/cubancarp
	appliance = FRYER
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

/singleton/recipe/batteredsausage
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/sausage/battered
	coating = /singleton/reagent/nutriment/coating/batter


/singleton/recipe/katsu
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	result = /obj/item/reagent_containers/food/snacks/chickenkatsu
	coating = /singleton/reagent/nutriment/coating/beerbatter


/singleton/recipe/pizzacrunch_1
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /singleton/reagent/nutriment/coating/batter

//Alternate pizza crunch recipe for combination pizzas made in oven
/singleton/recipe/pizzacrunch_2
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/variable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /singleton/reagent/nutriment/coating/batter

//Fishy Recipes
//==================
/singleton/recipe/fishandchips
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/singleton/recipe/fishfingers
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	coating = /singleton/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/fishfingers

//Sweet Recipes.
//==================
/singleton/recipe/jellydonut
	appliance = FRYER
	reagents = list(/singleton/reagent/drink/berryjuice = 10, /singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/donut/jelly
	result_quantity = 2

/singleton/recipe/jellydonut/slime
	reagents = list(/singleton/reagent/slimejelly = 10, /singleton/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/donut/slimejelly

/singleton/recipe/jellydonut/cherry
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 10, /singleton/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/donut/cherryjelly

/singleton/recipe/donut
	appliance = FRYER
	reagents = list(/singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/donut/normal
	result_quantity = 2

/singleton/recipe/funnelcake
	appliance = FRYER
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/nutriment/coating/batter = 10)
	result = /obj/item/reagent_containers/food/snacks/funnelcake

/singleton/recipe/pisanggoreng
	appliance = FRYER
	fruit = list("banana" = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pisanggoreng
	coating = /singleton/reagent/nutriment/coating/batter

/singleton/recipe/corn_dog
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	fruit = list("corn" = 1)
	coating = /singleton/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/corn_dog

/singleton/recipe/sweet_and_sour
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagents = list(/singleton/reagent/nutriment/soysauce = 5, /singleton/reagent/nutriment/coating/batter = 10)
	result = /obj/item/reagent_containers/food/snacks/sweet_and_sour

/singleton/recipe/wingfangchu
	appliance = FRYER
	reagents = list(/singleton/reagent/nutriment/soysauce = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu

/singleton/recipe/roefritters
	appliance = FRYER
	reagents = list(/singleton/reagent/nutriment/coating/batter = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/roe
	)
	result = /obj/item/reagent_containers/food/snacks/roefritters