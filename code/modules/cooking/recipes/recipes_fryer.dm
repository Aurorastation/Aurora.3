/singleton/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries

/singleton/recipe/cheesyfries
	appliance = SKILLET | MIX | MICROWAVE // You can reheat it or mix it cold, like some sort of monster.
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries

/singleton/recipe/chilicheesefries
	appliance = SKILLET | SAUCEPAN | MIX | MICROWAVE // you can reheat it if you'd like
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/hotchili
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chilicheesefries

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

/singleton/recipe/friedmushroom
	appliance = FRYER
	fruit = list("plumphelmet" = 1)
	coating = /singleton/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedmushroom

/singleton/recipe/katsu
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	result = /obj/item/reagent_containers/food/snacks/chickenkatsu
	coating = /singleton/reagent/nutriment/coating/beerbatter

/singleton/recipe/onionrings
	appliance = FRYER
	fruit = list("onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/onionrings

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

/singleton/recipe/fries_olympia_cheesy
	appliance = FRYER
	reagents = list(/singleton/reagent/spacespice = 3)
	fruit = list("potato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //So we don't end up with a ton of potato juice
	result = /obj/item/reagent_containers/food/snacks/fries_olympia_with_cheese

/singleton/recipe/fries_olympia_no_cheese
	appliance = FRYER
	reagents = list(/singleton/reagent/spacespice = 3)
	fruit = list("potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //So we don't end up with a ton of potato juice
	result = /obj/item/reagent_containers/food/snacks/fries_olympia

//Fishy Recipes
//==================
/singleton/recipe/fishandchips
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/singleton/recipe/fishandchips
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/singleton/recipe/cubancarp
	appliance = FRYER
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

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

/singleton/recipe/pisanggoreng
	appliance = FRYER
	fruit = list("banana" = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pisanggoreng
	coating = /singleton/reagent/nutriment/coating/batter

/singleton/recipe/funnelcake
	appliance = FRYER
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/nutriment/coating/batter = 10)
	result = /obj/item/reagent_containers/food/snacks/funnelcake

/singleton/recipe/corn_dog
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	coating = /singleton/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/corn_dog

/singleton/recipe/north60squid
	appliance = FRYER
	items = list(/obj/item/reagent_containers/food/snacks/squidmeat = 1,
		/obj/item/reagent_containers/food/snacks/fish/raw_shrimp = 1
	)
	reagents = list(/singleton/reagent/drink/lemonjuice = 5 , /singleton/reagent/drink/applejuice = 5, /singleton/reagent/nutriment/garlicsauce = 10)
	coating = /singleton/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/north60squid

/singleton/recipe/falafelballs
	appliance = FRYER
	fruit = list("chickpeas" = 2)
	result = /obj/item/reagent_containers/food/snacks/falafelballs

/singleton/recipe/pop_shrimp
	appliance = FRYER
	reagents = list(/singleton/reagent/spacespice = 2)
	coating = /singleton/reagent/nutriment/coating/batter
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/raw_shrimp,
		/obj/item/reagent_containers/food/snacks/fish/raw_shrimp
	)
	result = /obj/item/reagent_containers/food/snacks/bowl/pop_shrimp_bowl
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
