
/singleton/recipe/redcurry
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/singleton/recipe/greencurry
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/singleton/recipe/yellowcurry
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry

/singleton/recipe/chana_masala
	appliance = POT | SAUCEPAN
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/rice = 10)
	fruit = list("chickpeas" = 2, "tomato" = 1, "chili" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chana_masala

/singleton/recipe/friedrice
	appliance = SKILLET | SAUCEPAN | MICROWAVE
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/rice = 10, /singleton/reagent/nutriment/soysauce = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/singleton/recipe/risotto
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/alcohol/wine = 5, /singleton/reagent/nutriment/rice = 10, /singleton/reagent/spacespice = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/reagent_containers/food/snacks/risotto

/singleton/recipe/boiledrice
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/rice = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/singleton/recipe/ricepudding
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/rice = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/singleton/recipe/bibimbap
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list(/singleton/reagent/nutriment/rice = 5, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

/singleton/recipe/stewedsoymeat
	appliance = SAUCEPAN | MICROWAVE
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

/singleton/recipe/tofurkey
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/singleton/recipe/roast_chicken
	appliance = OVEN
	fruit = list("potato" = 2)
	reagents = list(/singleton/reagent/blackpepper = 1, /singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/sliceable/roast_chicken

/singleton/recipe/meatbun
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun

/singleton/recipe/custardbun
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/water = 5, /singleton/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/singleton/recipe/chickenmomo
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo

/singleton/recipe/veggiemomo
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/water = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/veggiemomo

/singleton/recipe/porkbowl
	appliance = SAUCEPAN | MICROWAVE
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/rice = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

/singleton/recipe/crab_legs
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/crabmeat,
		/obj/item/reagent_containers/food/snacks/spreads
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/crab_legs

/singleton/recipe/hash_browns
	appliance = GRILL | SKILLET
	reagents = list(/singleton/reagent/blackpepper = 1, /singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/hash_browns

/singleton/recipe/alfajores
	appliance = OVEN
	reagents = list(/singleton/reagent/sugar = 15, /singleton/reagent/nutriment/flour = 10, /singleton/reagent/drink/milk = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bowl/alfajores

/singleton/recipe/biscuits_and_gravy
	appliance = SAUCEPAN
	reagents = list(/singleton/reagent/condiment/gravy = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/biscuits_and_gravy
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/mozzarella_sticks
	appliance = FRYER
	reagents = list(/singleton/reagent/nutriment/flour = 5, /singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bowl/mozzarella_sticks

/singleton/recipe/mozzarella_sticks_alt
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	coating = /singleton/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bowl/mozzarella_sticks

/singleton/recipe/jambalaya
	appliance = SKILLET
	fruit = list("tomato" = 1)
	reagents = list(/singleton/reagent/spacespice = 3, /singleton/reagent/nutriment/rice = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/fish/raw_shrimp,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/jambalaya
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

// Konyang

/singleton/recipe/mossbowl
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/flour = 10)
	fruit = list("moss" = 2)
	result = /obj/item/reagent_containers/food/snacks/mossbowl

/singleton/recipe/moss_dumplings
	appliance = OVEN
	fruit = list("moss" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/moss_dumplings
	result_quantity = 2

/singleton/recipe/maeuntang
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "moss" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/fish)
	result = /obj/item/reagent_containers/food/snacks/soup/maeuntang

/singleton/recipe/miyeokguk
	appliance = SAUCEPAN | POT
	fruit = list("moss" = 1, "seaweed" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/soup/miyeokguk

/singleton/recipe/sweet_chili_chicken
	appliance = SAUCEPAN | POT
	fruit = list("lime" = 1)
	reagents = list(/singleton/reagent/nutriment/soysauce = 5,  /singleton/reagent/nutriment/sweet_chili= 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/boiledrice,
	)
	result = /obj/item/reagent_containers/food/snacks/sweet_chili_chicken
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/eggrolls_vegetable
	appliance = FRYER
	fruit = list("cabbage" = 1, "carrot" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 5,  /singleton/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/bowl/eggrolls_vegetable
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/eggrolls_vegetable_vegan
	appliance = FRYER
	fruit = list("cabbage" = 1, "carrot" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 5,  /singleton/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/bowl/eggrolls_vegetable
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/eggrolls_meat
	appliance = FRYER
	fruit = list("cabbage" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 5,  /singleton/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
	)
	result = /obj/item/reagent_containers/food/snacks/bowl/eggrolls_meat
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/eggrolls_meat_alt
	appliance = FRYER
	fruit = list("cabbage" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 5, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
	)
	result = /obj/item/reagent_containers/food/snacks/bowl/eggrolls_meat
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

// Mictlani

/singleton/recipe/pozole
	appliance = SAUCEPAN | POT
	fruit = list("dyn leaf" = 1, "cabbage" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/soup/pozole
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/elotes
	appliance = OVEN | GRILL
	reagents = list(/singleton/reagent/nutriment/mayonnaise = 5, /singleton/reagent/spacespice = 2)
	fruit = list("corn" = 2, "lime" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/elotes

// Dominia

/singleton/recipe/moroz_flatbread
	appliance = OVEN
	fruit = list ("tomato" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/moroz_flatbread

/singleton/recipe/brudet
	appliance = SAUCEPAN | POT
	fruit = list ("tomato" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/fish)
	result = /obj/item/reagent_containers/food/snacks/soup/brudet

/singleton/recipe/imperial_pot
	appliance = POT
	fruit = list("potato" = 2, "lemon" = 2, "garlic" = 1, "onion" = 1)
	reagents = list(/singleton/reagent/water = 15, /singleton/reagent/nutriment/rice = 30)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish/mollusc,
		/obj/item/reagent_containers/food/snacks/fish/mollusc
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/imperial_pot

/singleton/recipe/jadrica
	appliance = OVEN
	fruit = list("carrot" = 2, "garlic" = 1)
	reagents = list(/singleton/reagent/enzyme = 5, /singleton/reagent/alcohol/wine = 5, /singleton/reagent/spacespice = 1, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/jadrica
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/imperial_scallops
	appliance = SAUCEPAN | POT
	fruit = list("lemon" = 1, "garlic" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/sodiumchloride = 2, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/mollusc,
		/obj/item/reagent_containers/food/snacks/fish/mollusc,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/imperial_scallops
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace

// New Hai Phong

/singleton/recipe/chetroinuoc
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/nutriment/vanilla = 5, /singleton/reagent/nutriment/rice = 10)
	fruit = list("soybeans" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chetroinuoc

// Europan Food

/singleton/recipe/deepdive
	fruit = list ("seaweed" = 1)
	reagents = list(/singleton/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/deepdive

// Biesel

/singleton/recipe/bluemoon
	appliance = SAUCEPAN
	fruit = list ("blue raspberry" = 1)
	reagents = list(/singleton/reagent/drink/milk/cream = 5)
	items = list(/obj/item/reagent_containers/food/snacks/whitechocolate)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bluemoon

//Eridani

/singleton/recipe/puffpuffs
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/flour = 10, /singleton/reagent/water = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bowl/puffpuffs

/singleton/recipe/fufu
	appliance = SAUCEPAN | POT
	fruit = list("banana" = 2)
	reagents = list(/singleton/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/bowl/fufus
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/dodo_ikire
	appliance = SKILLET | SAUCEPAN
	fruit = list("banana" = 2, "chili" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/dodo_ikire
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/crimson_lime
	appliance = SAUCEPAN
	fruit = list("lime" = 1, "chili" = 1)
	reagents = list(/singleton/reagent/nutriment/coco = 5, /singleton/reagent/drink/milk = 5)
	result = /obj/item/reagent_containers/food/snacks/crimson_lime
	reagent_mix = RECIPE_REAGENT_REPLACE

//Silversun

/singleton/recipe/clams_casino
	appliance = SKILLET
	fruit = list ("bellpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/mollusc,
		/obj/item/reagent_containers/food/snacks/fish/mollusc,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/clams_casino
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace

/singleton/recipe/lady_lulaine
	appliance = MIX
	fruit = list ("blueberries" = 1 , "berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/muffin,
		/obj/item/reagent_containers/food/snacks/muffin
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 6, /singleton/reagent/drink/ice = 5, /singleton/reagent/drink/milk/cream = 5, /singleton/reagent/sugar = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/lady_lulaine
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace

/singleton/recipe/pazillo
	appliance = OVEN
	fruit = list ("tomato" = 1 , "chickpeas" = 1, "onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/pazillo
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace so it's not full of juice

//Luna
/singleton/recipe/traumwurst
	appliance = SKILLET | SAUCEPAN
	reagents = list(/singleton/reagent/drink/milk/cream = 5)
	fruit = list("eggplant" = 1, "plumphelmet" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/sausage
		)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify and replace
	result = /obj/item/reagent_containers/food/snacks/traumwurst

// Xanu Prime

/singleton/recipe/steakxanu
	appliance = SKILLET
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/spacespice = 2, /singleton/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/steakxanu
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/xanu_curry
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/spacespice = 4, /singleton/reagent/drink/milk = 5, /singleton/reagent/nutriment/rice = 10)
	fruit = list("garlic" = 1 , "chickpeas" = 1, "onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/xanu_curry
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/bunkerbuster
	appliance = MIX
	reagents = list(/singleton/reagent/spacespice = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg/overeasy,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/flatbread
	)
	result = /obj/item/reagent_containers/food/snacks/bunkerbuster
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/crozets
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/spacespice = 2)
	fruit = list("tomato" = 1, "chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spaghetti,
		/obj/item/reagent_containers/food/snacks/spreads/lard,
		/obj/item/reagent_containers/food/snacks/fish/fishfillet
	)
	result = /obj/item/reagent_containers/food/snacks/crozets
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/seafoodplatter
	appliance = MIX
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/spacespice = 2, /singleton/reagent/alcohol/beer = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/fishfillet,
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/crabmeat

	)
	result = /obj/item/reagent_containers/food/snacks/seafoodplatter
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/xanuvindaloo
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 1, "chili" = 1)
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/spacespice = 2, /singleton/reagent/drink/milk/cream = 5, /singleton/reagent/nutriment/vanilla = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	result = /obj/item/reagent_containers/food/snacks/xanuvindaloo
	reagent_mix = RECIPE_REAGENT_REPLACE

// Himeo

/singleton/recipe/minerpie
	appliance = SKILLET
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/spacespice = 2, /singleton/reagent/drink/milk/cream = 5)
	fruit = list("onion" = 1, "plumphelmet" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/minerpie
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/hakhmaparm
	appliance = SKILLET
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/hakhma,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bun,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/hakhmaparm

/singleton/recipe/steelworkersandwich
	appliance = SKILLET
	fruit = list("cabbage" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/fries
	)
	result = /obj/item/reagent_containers/food/snacks/steelworkersandwich
	reagent_mix = RECIPE_REAGENT_REPLACE

//Gadpathur
/singleton/recipe/paneer_gadpathur
	appliance = SAUCEPAN | POT
	result = /obj/item/reagent_containers/food/snacks/paneer_gadpathur
	fruit = list ("tomato" = 1, "chili" = 1)
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/nutriment/rice = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/paneer_gadpathur

//Galatea

/singleton/recipe/baked_golden_apple
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/no_raisin
	)
	result = /obj/item/reagent_containers/food/snacks/baked_golden_apple
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/fire_loaf
	appliance = OVEN
	fruit = list ("onion" = 1, "chili" = 3)
	reagents = list(/singleton/reagent/kelotane = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/fire_loaf
