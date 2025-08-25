// Breads
//================================
/singleton/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun

/singleton/recipe/bunbun
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/bunbun

/singleton/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bread

/singleton/recipe/tofubread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/tofubread


/singleton/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread


/singleton/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/singleton/recipe/syntibread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/singleton/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread

/singleton/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/singleton/reagent/drink/milk = 5, /singleton/reagent/sugar = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

/singleton/recipe/baguette
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/baguette

/singleton/recipe/croissant
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/water = 5, /singleton/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/croissant

/singleton/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(/singleton/reagent/nutriment/honey = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun

/singleton/recipe/flatbread
	appliance = OVEN | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread

/singleton/recipe/poppypretzel
	appliance = OVEN
	reagent_mix = RECIPE_REAGENT_REPLACE
	fruit = list("poppy" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/singleton/recipe/bagel
	appliance = OVEN
	reagent_mix = RECIPE_REAGENT_REPLACE
	fruit = list("poppy" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/bagel

/singleton/recipe/cracker
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker

/singleton/recipe/stuffing
	appliance = OVEN | MICROWAVE
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing

/singleton/recipe/stuffing_alt
	appliance = OVEN | MICROWAVE
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing


/singleton/recipe/angry_bread
	appliance = OVEN
	fruit = list("carrot" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/angry_bread

/singleton/recipe/angry_bread/make_food(obj/container) // removing some reagents instead of using RECIPE_REAGENT_REPLACE so anything that's in the original meat you use is still in the final dish (namely whether or not the meat you use has polytrinic acid).
	. = ..()
	var/list/results = .
	for(var/thing in results)
		var/obj/item/xmg = thing
		xmg.reagents.del_reagent(/singleton/reagent/drink/carrotjuice)
		xmg.reagents.del_reagent(/singleton/reagent/nutriment/protein/cheese)

//================================
// Toasts and Toasted Sandwiches
//================================
/singleton/recipe/toast // Needs to be here otherwise it fucking kills itself
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/triglyceride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/toast

/singleton/recipe/twobread
	appliance = SKILLET | MIX
	reagents = list(/singleton/reagent/alcohol/wine = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/twobread

/singleton/recipe/slimetoast_alt
	appliance = MIX
	reagents = list(/singleton/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/singleton/recipe/jelliedtoast_alt
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/singleton/recipe/pbtoast_alt
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/peanutbutter = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast
	)
	result = /obj/item/reagent_containers/food/snacks/pbtoast

/singleton/recipe/ntella_bread
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/choconutspread = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/ntella_bread

/singleton/recipe/slimetoast
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/singleton/recipe/jelliedtoast
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/singleton/recipe/pbtoast
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/nutriment/peanutbutter = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/pbtoast

/singleton/recipe/egginthebasket
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/egginthebasket

/singleton/recipe/garlicbread
	appliance = SKILLET | OVEN
	reagents = list(/singleton/reagent/nutriment/garlicsauce = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE // Yeah that butter though
	result = /obj/item/reagent_containers/food/snacks/garlicbread

/singleton/recipe/honeytoast
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/nutriment/honey = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast

/singleton/recipe/fairy_bread
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/sprinkles = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/fairy_bread

/singleton/recipe/cheese_cracker
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list(/singleton/reagent/spacespice = 1)
	result = /obj/item/reagent_containers/food/snacks/cheese_cracker
	result_quantity = 4

/singleton/recipe/sandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich

/singleton/recipe/toastedsandwich
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/singleton/recipe/grilledcheese
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/singleton/recipe/grilled_mac_and_cheese_sandwich
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/macandcheese
	)
	result = /obj/item/reagent_containers/food/snacks/grilled_mac_and_cheese

/singleton/recipe/grilled_triple_cheese_crunch_sandwich
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/nakarka_wedge,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/grilled_triple_cheese_crunch_sandwich

/singleton/recipe/crab_leg_grilled_cheese_sandwich
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/crabmeat
	)
	result = /obj/item/reagent_containers/food/snacks/crab_leg_grilled_cheese_sandwich

/singleton/recipe/reubensandwich
	reagents = list(/singleton/reagent/nutriment/mayonnaise = 5, /singleton/reagent/nutriment/ketchup = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/sauerkraut,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/toast
	)
	reagent_mix = RECIPE_REAGENT_MIN
	result = /obj/item/reagent_containers/food/snacks/reubensandwich

/singleton/recipe/slimesandwich
	reagents = list(/singleton/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/slime

/singleton/recipe/cherrysandwich
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry

/singleton/recipe/pbjsandwich
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 5, /singleton/reagent/nutriment/peanutbutter = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/pbjsandwich

/singleton/recipe/blt
	fruit = list("tomato" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/blt


//pita (these are all under bread for icon reasons)
/singleton/recipe/pita
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	reagents = list(/singleton/reagent/sugar = 5 , /singleton/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/pita

/singleton/recipe/falafel
	items = list(
	/obj/item/reagent_containers/food/snacks/falafelballs,
	/obj/item/reagent_containers/food/snacks/dip/hummus,
	/obj/item/reagent_containers/food/snacks/pita
	)
	fruit = list("tomato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/falafel

/singleton/recipe/sabich
	appliance = FRYER
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	/obj/item/reagent_containers/food/snacks/dip/hummus,
	/obj/item/reagent_containers/food/snacks/boiledegg
	)
	fruit = list("eggplant" = 1)
	result = /obj/item/reagent_containers/food/snacks/pita/sabich
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/singleton/recipe/tunapita
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	/obj/item/reagent_containers/food/snacks/salad/tunasalad
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/tuna

/singleton/recipe/chocolatepita
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	)
	reagents = list(/singleton/reagent/nutriment/choconutspread = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/chocolate

/singleton/recipe/hummuspita
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	/obj/item/reagent_containers/food/snacks/dip/hummus
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/hummus

/singleton/recipe/falafel_alt
	items = list(
	/obj/item/reagent_containers/food/snacks/falafelballs,
	/obj/item/reagent_containers/food/snacks/pita/hummus
	)
	fruit = list("tomato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/falafel

/singleton/recipe/peanut_butter_pita
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	)
	reagents = list(/singleton/reagent/nutriment/peanutbutter = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/peanut_butter

/singleton/recipe/omelette_pita //this recipe might get changed in the future
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	/obj/item/reagent_containers/food/snacks/omelette
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pita/omelette

/singleton/recipe/schnitzel_pita
	items = list(
	/obj/item/reagent_containers/food/snacks/pita,
	/obj/item/reagent_containers/food/snacks/schnitzel
	)
	result = /obj/item/reagent_containers/food/snacks/pita/schnitzel
