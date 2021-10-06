//Planty recipes
//====================
/decl/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries


/decl/recipe/jpoppers
	appliance = FRYER
	fruit = list("chili" = 1)
	coating = /decl/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/jalapeno_poppers

/decl/recipe/risottoballs
	appliance = FRYER
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/risotto)
	coating = /decl/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/risottoballs

/decl/recipe/onionrings
	appliance = FRYER
	fruit = list("onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/onionrings

/decl/recipe/friedmushroom
	appliance = FRYER
	fruit = list("plumphelmet" = 1)
	coating = /decl/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedmushroom

//Meaty Recipes
//====================
/decl/recipe/cubancarp
	appliance = FRYER
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

/decl/recipe/batteredsausage
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/sausage/battered
	coating = /decl/reagent/nutriment/coating/batter


/decl/recipe/katsu
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	result = /obj/item/reagent_containers/food/snacks/chickenkatsu
	coating = /decl/reagent/nutriment/coating/beerbatter


/decl/recipe/pizzacrunch_1
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /decl/reagent/nutriment/coating/batter

//Alternate pizza crunch recipe for combination pizzas made in oven
/decl/recipe/pizzacrunch_2
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/variable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /decl/reagent/nutriment/coating/batter

//Fishy Recipes
//==================
/decl/recipe/fishandchips
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/decl/recipe/fishfingers
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	coating = /decl/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/fishfingers

//Sweet Recipes.
//==================
/decl/recipe/jellydonut
	appliance = FRYER
	reagents = list(/decl/reagent/drink/berryjuice = 10, /decl/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/donut/jelly
	result_quantity = 2

/decl/recipe/jellydonut/slime
	reagents = list(/decl/reagent/slimejelly = 10, /decl/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/donut/slimejelly

/decl/recipe/jellydonut/cherry
	reagents = list(/decl/reagent/nutriment/cherryjelly = 10, /decl/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/donut/cherryjelly

/decl/recipe/donut
	appliance = FRYER
	reagents = list(/decl/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/donut/normal
	result_quantity = 2

/decl/recipe/funnelcake
	appliance = FRYER
	reagents = list(/decl/reagent/sugar = 5, /decl/reagent/nutriment/coating/batter = 10)
	result = /obj/item/reagent_containers/food/snacks/funnelcake

/decl/recipe/pisanggoreng
	appliance = FRYER
	fruit = list("banana" = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pisanggoreng
	coating = /decl/reagent/nutriment/coating/batter

/decl/recipe/corn_dog
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	fruit = list("corn" = 1)
	coating = /decl/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/corn_dog

/decl/recipe/sweet_and_sour
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagents = list(/decl/reagent/nutriment/soysauce = 5, /decl/reagent/nutriment/coating/batter = 10)
	result = /obj/item/reagent_containers/food/snacks/sweet_and_sour

/decl/recipe/wingfangchu
	appliance = FRYER
	reagents = list(/decl/reagent/nutriment/soysauce = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu

/decl/recipe/roefritters
	appliance = FRYER
	reagents = list(/decl/reagent/nutriment/coating/batter = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/roe
	)
	result = /obj/item/reagent_containers/food/snacks/roefritters