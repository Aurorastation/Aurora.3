// Breads
//================================
/decl/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun

/decl/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bread

/decl/recipe/baguette
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/baguette


/decl/recipe/tofubread
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


/decl/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread

/decl/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread

/decl/recipe/moroz_flatbread
	appliance = OVEN
	fruit = list ("tomato" = 1)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/moroz_flatbread

/decl/recipe/meatbread
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

/decl/recipe/syntibread
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

/decl/recipe/xenomeatbread
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

/decl/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/sugar = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

/decl/recipe/croissant
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/water = 5, /decl/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/croissant

/decl/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/decl/recipe/cracker
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker
//================================
// Toasts and Toasted Sandwiches
//================================
/decl/recipe/toast // Needs to be here otherwise it fucking kills itself
	appliance = SKILLET
	reagents = list(/decl/reagent/nutriment/triglyceride = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/toast

/decl/recipe/slimetoast_alt
	appliance = MIX
	reagents = list(/decl/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/decl/recipe/jelliedtoast_alt
	appliance = MIX
	reagents = list(/decl/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/decl/recipe/pbtoast_alt
	appliance = MIX
	reagents = list(/decl/reagent/nutriment/peanutbutter = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/toast
	)
	result = /obj/item/reagent_containers/food/snacks/pbtoast

/decl/recipe/slimetoast
	appliance = SKILLET
	reagents = list(/decl/reagent/slimejelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/decl/recipe/jelliedtoast
	appliance = SKILLET
	reagents = list(/decl/reagent/nutriment/cherryjelly = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/decl/recipe/pbtoast
	appliance = SKILLET
	reagents = list(/decl/reagent/nutriment/peanutbutter = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/pbtoast

/decl/recipe/toastedsandwich
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/decl/recipe/grilledcheese
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/decl/recipe/egginthebasket
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	result = /obj/item/reagent_containers/food/snacks/egginthebasket

/decl/recipe/garlicbread
	appliance = SKILLET | OVEN
	reagents = list(/decl/reagent/nutriment/garlicsauce = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/breadslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE // Yeah that butter though
	result = /obj/item/reagent_containers/food/snacks/garlicbread