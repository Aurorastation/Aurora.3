/singleton/recipe/chilied_eggs
	appliance = SAUCEPAN | POT | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/hotchili,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/chilied_eggs

/singleton/recipe/red_sun_special
	appliance = SKILLET | SAUCEPAN | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/cheesewedge

	)
	result = /obj/item/reagent_containers/food/snacks/red_sun_special

/singleton/recipe/hatchling_suprise
	appliance = SKILLET | SAUCEPAN | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/poachedegg,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon

	)
	result = /obj/item/reagent_containers/food/snacks/hatchling_suprise

/singleton/recipe/riztizkzi_sea
	appliance = SAUCEPAN | POT | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagents = list(/singleton/reagent/blood = 15)
	result = /obj/item/reagent_containers/food/snacks/riztizkzi_sea

/singleton/recipe/father_breakfast
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/omelette,
		/obj/item/reagent_containers/food/snacks/meatsteak
	)
	result = /obj/item/reagent_containers/food/snacks/father_breakfast

/singleton/recipe/stuffed_meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/reagent_containers/food/snacks/stuffed_meatball

/singleton/recipe/grilled_carp
	appliance = SKILLET | GRILL // 'grilled' is even in the name
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/fish
	)
	reagents = list(/singleton/reagent/spacespice = 1)
	fruit = list("cabbage" = 1, "lime" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/grilled_carp

/singleton/recipe/bacon_stick
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_stick

/singleton/recipe/egg_pancake
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/omelette
	)
	result = /obj/item/reagent_containers/food/snacks/egg_pancake

/singleton/recipe/sushi_roll
	items = list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/reagent_containers/food/snacks/boiledrice
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi_roll

/singleton/recipe/batwings
	appliance = SKILLET | SAUCEPAN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/bat,
		/obj/item/reagent_containers/food/snacks/meat/bat,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/batwings

/singleton/recipe/jellystew
	appliance = POT
	fruit = list("chili" = 2)
	reagents = list(/singleton/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/cosmozoan,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/jellystew

/singleton/recipe/stuffedfish
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/fishfillet,
		/obj/item/reagent_containers/food/snacks/fish/roe,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/stuffedfish

/singleton/recipe/stuffedcarp
	appliance = SKILLET | SAUCEPAN
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/carpmeat,
		/obj/item/reagent_containers/food/snacks/fish/roe,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/stuffedcarp

/singleton/recipe/razirnoodles
	appliance = SKILLET | SAUCEPAN
	fruit = list("lime" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/moghes,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/razirnoodles

/singleton/recipe/sintapudding
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/blood = 15, /singleton/reagent/sugar = 10, /singleton/reagent/nutriment/coco = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/sintapudding

/singleton/recipe/stokskewer
	appliance = SKILLET
	fruit = list("gukhe" = 1)
	reagents = list(/singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/moghes,
	)
	result = /obj/item/reagent_containers/food/snacks/stokkebab

/singleton/recipe/gukhefish
	appliance = SKILLET | SAUCEPAN
	fruit = list("gukhe" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/gukhefish

/singleton/recipe/aghrasshcake
	appliance = OVEN
	fruit = list("aghrassh nut" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 3, /singleton/reagent/blackpepper = 3, /singleton/reagent/nutriment/coco = 3, /singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/meat/moghes
	)
	result = /obj/item/reagent_containers/food/snacks/aghrasshcake

/singleton/recipe/eyebowl
	appliance = SAUCEPAN | POT
	fruit = list("aghrassh nut" = 1, "tomato" = 1)
	reagents = list(/singleton/reagent/blackpepper = 2, /singleton/reagent/nutriment/protein/egg = 6)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/moghes
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/eyebowl
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/caramelized_steak_bites
	appliance = SKILLET | SAUCEPAN
	reagents = list(/singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/spreads/butter
	)
	result = /obj/item/reagent_containers/food/snacks/caramelized_steak_bites
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/guwan_gruel
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet, //Intentionally any meat and not moghesian. Guwans can't be picky.
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/guwan_gruel
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/egg_pie
	appliance = OVEN
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/nutriment/protein/egg = 6)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/reagent_containers/food/snacks/egg_pie
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/orszi
	appliance = OVEN | GRILL
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/orszi

/singleton/recipe/sth_fish
	appliance = SKILLET | SAUCEPAN
	fruit = list("S'th berry" = 1, "seaweed" = 1)
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish
	)
	result = /obj/item/reagent_containers/food/snacks/sth_fish
	reagent_mix = RECIPE_REAGENT_REPLACE
