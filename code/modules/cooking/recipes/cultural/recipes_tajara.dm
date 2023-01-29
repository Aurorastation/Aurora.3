// Tajaran breads
/singleton/recipe/tajaran_bread
	appliance = OVEN
	fruit = list("nifberries" = 1)
	reagents = list(/singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread
	)
	result = /obj/item/reagent_containers/food/snacks/tajaran_bread
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/hardbread
	appliance = OVEN
	reagents = list(/singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/hardbread

// Tajaran peasant food
/singleton/recipe/tajaran_stew
	appliance = SAUCEPAN | POT
	fruit = list("nifberries" = 2, "mushroom" = 1, "mtear" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/stew/tajaran

/singleton/recipe/earthenroot_soup
	appliance = SAUCEPAN | POT
	fruit = list("earthenroot" = 2)
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/spacespice = 1, /singleton/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/soup/earthenroot

/singleton/recipe/bloodpudding
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/nutriment/flour/nfrihi = 5, /singleton/reagent/blood = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/lard,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/adhomian_sausage

/singleton/recipe/nomadskewer
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
	required_reagents = list(/singleton/reagent/enzyme = 5)

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
/singleton/recipe/conecake
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk/adhomai = 5, /singleton/reagent/nutriment/flour/nfrihi = 15, /singleton/reagent/water = 5, /singleton/reagent/sugar = 15)
	result = /obj/item/reagent_containers/food/snacks/cone_cake

/singleton/recipe/avah
	appliance = FRYER
	reagents = list(/singleton/reagent/drink/milk/adhomai = 5, /singleton/reagent/sugar = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/avah

// Tajaran pies
/singleton/recipe/fruitrikazu
	appliance = OVEN
	reagents = list(/singleton/reagent/sugar = 5)
	fruit = list("mtear" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/fruit_rikazu

/singleton/recipe/meatrikazu
	appliance = OVEN
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/meat_rikazu

/singleton/recipe/vegetablerikazu
	appliance = OVEN
	reagents = list(/singleton/reagent/nutriment/flour/nfrihi = 5)
	fruit = list("earthenroot" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread
	)
	result = /obj/item/reagent_containers/food/snacks/vegetable_rikazu

/singleton/recipe/chocolaterikazu
	appliance = OVEN
	reagents = list(/singleton/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/tajaran_bread,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolate_rikazu

/singleton/recipe/dirt_roast
	appliance = OVEN
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/sugar = 5)
	fruit = list("nifberries" = 1)
	result = /obj/item/reagent_containers/food/snacks/dirt_roast

/singleton/recipe/fatshouter_fillet
	appliance = OVEN
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/nutriment/flour/nfrihi = 5, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/alcohol/messa_mead = 5)
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

/singleton/recipe/zkahnkowafull
	appliance = POT | SAUCEPAN
	reagents = list(/singleton/reagent/blood = 10, /singleton/reagent/nutriment/flour/nfrihi = 5, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/zkahnkowafull

/singleton/recipe/creamice
	reagents = list(/singleton/reagent/drink/milk/adhomai = 10, /singleton/reagent/sugar = 10, /singleton/reagent/drink/ice = 10)
	fruit = list("nifberries" = 1)
	result = /obj/item/reagent_containers/food/snacks/creamice

// Tajaran Seafood
/singleton/recipe/spicy_clams
	fruit = list("chili" = 1, "cabbage" = 1)
	reagents = list(/singleton/reagent/capsaicin = 1, /singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/clam
	)
	result = /obj/item/reagent_containers/food/snacks/spicy_clams

// Tajaran candy
/singleton/recipe/tajcandy
	appliance = OVEN
	fruit = list("nmshaan" = 2)
	reagents = list(/singleton/reagent/drink/milk/adhomai = 5, /singleton/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/tajcandy

/singleton/recipe/scoutration
	appliance = OVEN
	fruit = list("nifberries" = 2)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/explorer_ration
