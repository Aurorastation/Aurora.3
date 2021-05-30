// Tajaran breads
/decl/recipe/tajaran_bread
	appliance = OVEN
	fruit = list("nifberries" = 1)
	reagents = list(/decl/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread
	)
	result = /obj/item/reagent_containers/food/snacks/tajaran_bread
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/hardbread
	appliance = OVEN
	reagents = list(/decl/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/hardbread

// Tajaran peasant food
/decl/recipe/tajaran_stew
	appliance = SAUCEPAN | POT
	fruit = list("nifberries" = 2, "mushroom" = 1, "mtear" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/stew/tajaran

/decl/recipe/earthenroot_soup
	appliance = SAUCEPAN | POT
	fruit = list("earthenroot" = 2)
	reagents = list(/decl/reagent/water = 10, /decl/reagent/spacespice = 1, /decl/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/soup/earthenroot

/decl/recipe/bloodpudding
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/nutriment/flour/nfrihi = 5, /decl/reagent/blood = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/lard,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/adhomian_sausage

/decl/recipe/nomadskewer
	appliance = MIX
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/stack/rods
	)
	fruit = list("earthenroot" = 1, "nifberries" = 1)
	result = /obj/item/reagent_containers/food/snacks/nomadskewer

/datum/chemical_reaction/fermentedworm
	name = "Fermented Hma'trra Meat"
	id = "fermentedworm"
	result = null
	required_reagents = list(/decl/reagent/enzyme = 5)

/datum/chemical_reaction/fermentedworm/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/reagent_containers/food/snacks/fermented_worm(holder.my_atom.loc)
	qdel(holder.my_atom)
	return

/datum/chemical_reaction/fermentedworm/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/reagent_containers/food/snacks/hmatrrameat))
		if(holder.has_all_reagents(holder.my_atom.reagents_to_add)) // Make sure we haven't removed anything.
			return ..()
	return FALSE

// Tajaran cakes
/decl/recipe/conecake
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk/adhomai = 5, /decl/reagent/nutriment/flour/nfrihi = 15, /decl/reagent/water = 5, /decl/reagent/sugar = 15)
	result = /obj/item/reagent_containers/food/snacks/cone_cake

/decl/recipe/avah
	appliance = FRYER
	reagents = list(/decl/reagent/drink/milk/adhomai = 5, /decl/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/avah

// Tajaran pies
/decl/recipe/fruitrikazu
	appliance = OVEN
	reagents = list(/decl/reagent/sugar = 5)
	fruit = list("mtear" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/fruit_rikazu

/decl/recipe/meatrikazu
	appliance = OVEN
	reagents = list(/decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/meat_rikazu

/decl/recipe/vegetablerikazu
	appliance = OVEN
	reagents = list(/decl/reagent/nutriment/flour/nfrihi = 5)
	fruit = list("earthenroot" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/vegetable_rikazu

/decl/recipe/chocolaterikazu
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolate_rikazu

/decl/recipe/dirt_roast
	appliance = OVEN
	reagents = list(/decl/reagent/spacespice = 1, /decl/reagent/sugar = 5)
	fruit = list("nifberries" = 1)
	result = /obj/item/reagent_containers/food/snacks/dirt_roast

/decl/recipe/fatshouter_fillet
	appliance = OVEN
	reagents = list(/decl/reagent/spacespice = 1, /decl/reagent/nutriment/flour/nfrihi = 5, /decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1, /decl/reagent/alcohol/messa_mead = 5)
	fruit = list("earthenroot" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/spreads/lard
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/fatshouter_fillet

/decl/recipe/zkahnkowafull
	appliance = POT | SAUCEPAN
	reagents = list(/decl/reagent/blood = 10, /decl/reagent/nutriment/flour/nfrihi = 5, /decl/reagent/sodiumchloride = 1, /decl/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/zkahnkowafull

/decl/recipe/creamice
	reagents = list(/decl/reagent/drink/milk/adhomai = 10, /decl/reagent/sugar = 10, /decl/reagent/drink/ice = 10)
	fruit = list("nifberries" = 1)
	result = /obj/item/reagent_containers/food/snacks/creamice

// Tajaran Seafood
/decl/recipe/spicy_clams
	fruit = list("chili" = 1, "cabbage" = 1)
	reagents = list(/decl/reagent/capsaicin = 1, /decl/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/clam
	)
	result = /obj/item/reagent_containers/food/snacks/spicy_clams

// Tajaran candy
/decl/recipe/tajcandy
	appliance = OVEN
	fruit = list("nmshaan" = 2)
	reagents = list(/decl/reagent/drink/milk/adhomai = 5, /decl/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/tajcandy

/decl/recipe/scoutration
	appliance = OVEN
	fruit = list("nifberries" = 2)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/explorer_ration
