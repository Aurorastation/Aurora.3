// Breads
//================================
/singleton/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun

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

/singleton/recipe/baguette
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/baguette


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

/singleton/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread

/singleton/recipe/moroz_flatbread
	appliance = OVEN
	fruit = list ("tomato" = 1)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/moroz_flatbread

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

/singleton/recipe/croissant
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/water = 5, /singleton/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/croissant

/singleton/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/singleton/recipe/cracker
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker
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

/singleton/recipe/slimetoast
	appliance = SKILLET
	reagents = list(/singleton/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/singleton/recipe/jelliedtoast
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/singleton/recipe/pbtoast
	appliance = SKILLET
	reagents = list(/singleton/reagent/nutriment/peanutbutter = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/pbtoast

/singleton/recipe/toastedsandwich
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/singleton/recipe/grilledcheese
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/singleton/recipe/egginthebasket
	appliance = SKILLET
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