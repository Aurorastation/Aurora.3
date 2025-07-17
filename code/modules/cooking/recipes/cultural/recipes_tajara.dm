// Tajaran breads
/singleton/recipe/tajaran_bread
	appliance = OVEN
	fruit = list("dirtberries" = 1)
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
	fruit = list("dirtberries" = 2, "mushroom" = 1, "mtear" = 1)
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
	fruit = list("earthenroot" = 1, "dirtberries" = 1)
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

/singleton/recipe/fermented_worm_sandwich
	appliance = MIX
	items = list(
		/obj/item/reagent_containers/food/snacks/hardbread_slice,
		/obj/item/reagent_containers/food/snacks/hardbread_slice,
		/obj/item/reagent_containers/food/snacks/fermented_worm
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/fermented_worm_sandwich

/singleton/recipe/earthenroot_mash
	appliance = MIX
	fruit = list("earthenroot" = 1)
	reagents = list(/singleton/reagent/blackpepper = 1, /singleton/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/earthenroot_mash

/singleton/recipe/earthenroot_fries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/earthenroot_chopped
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/earthenroot_fries

/singleton/recipe/earthenroot_wedges
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/earthenroot_chopped
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/earthenroot_wedges

/singleton/recipe/earthenroot_salad
	appliance = MIX
	fruit = list("earthenroot" = 1, "mtear" = 2, "dirtberries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/salad/earthenroot

/singleton/recipe/sarmikhir_sandwich
	appliance = MIX
	items = list(
		/obj/item/reagent_containers/food/snacks/hardbread_slice,
		/obj/item/reagent_containers/food/snacks/hardbread_slice,
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sarmikhir_sandwich

/singleton/recipe/tunneler_meategg
	appliance = SAUCEPAN | POT
	items = list(
		/obj/item/reagent_containers/food/snacks/hardbread_slice,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers
	)
	reagents = list(/singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/tunneler_meategg

/singleton/recipe/tunneler_souffle
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir,
		/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers
	)
	reagents = list(/singleton/reagent/nutriment/flour/nfrihi = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/tunneler_souffle

/singleton/recipe/adhomian_porridge
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/nutriment/flour/nfrihi = 10, /singleton/reagent/water = 10, /singleton/reagent/drink/milk/adhomai = 10)
	result = /obj/item/reagent_containers/food/snacks/adhomian_porridge
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

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

/singleton/recipe/miniavah
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(/singleton/reagent/nutriment/flour/nfrihi = 5, /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chipplate/miniavah_basket

/singleton/recipe/hardbread_pudding
	appliance = OVEN
	fruit = list("earthenroot" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/hardbread,
		/obj/item/reagent_containers/food/snacks/hardbread
	)
	reagents = list(/singleton/reagent/drink/milk/cream = 5, /singleton/reagent/sugar = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/hardbread_pudding

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
	fruit = list("dirtberries" = 1)
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
	fruit = list("dirtberries" = 1)
	result = /obj/item/reagent_containers/food/snacks/creamice

/singleton/recipe/stuffed_earthenroot
	appliance = OVEN
	fruit = list("earthenroot" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir,
		/obj/item/reagent_containers/food/snacks/zkahnkowaslice,
		/obj/item/reagent_containers/food/snacks/hardbread_slice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/stuffed_earthenroot

/singleton/recipe/lardwich
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread,
		/obj/item/reagent_containers/food/snacks/flatbread,
		/obj/item/reagent_containers/food/snacks/spreads/lard
	)
	result = /obj/item/reagent_containers/food/snacks/lardwich
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/scoutration
	appliance = OVEN
	fruit = list("dirtberries" = 2)
	reagents = list(/singleton/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/explorer_ration

// Tajaran Seafood
/singleton/recipe/spicy_clams
	fruit = list("chili" = 1, "cabbage" = 1)
	reagents = list(/singleton/reagent/capsaicin = 1, /singleton/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/clam
	)
	result = /obj/item/reagent_containers/food/snacks/spicy_clams

/singleton/recipe/clam_pasta
	appliance = POT | SAUCEPAN
	fruit = list("earthenroot" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam
	)
	reagents = list(/singleton/reagent/water = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/clam_pasta

/singleton/recipe/tajfishsoup
	appliance = POT | SAUCEPAN
	fruit = list("mtear" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir,
		/obj/item/reagent_containers/food/snacks/fish
	)
	reagents = list(/singleton/reagent/water = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/tajfish

// Tajaran candy
/singleton/recipe/tajcandy
	appliance = OVEN
	fruit = list("sugartree" = 2)
	reagents = list(/singleton/reagent/drink/milk/adhomai = 5, /singleton/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/tajcandy

// Tajaran Dips
/singleton/recipe/sarmikhir
	appliance = MIX
	reagents = list(/singleton/reagent/drink/milk/adhomai/fermented = 15, /singleton/reagent/drink/milk/cream = 15, /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/dip/sarmikhir

/singleton/recipe/tajhummus
	appliance = MIX
	fruit = list("mtear" = 1, "dirtberries" = 1)
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/nutriment/flour/nfrihi = 5)
	result = /obj/item/reagent_containers/food/snacks/dip/tajhummus

// Tajaran gelatin-based food
/singleton/recipe/seafoodmousse
	appliance = MIX
	fruit = list("dirtberries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir
	)
	reagents = list(/singleton/reagent/nutriment/gelatin = 10, /singleton/reagent/water = 5, /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/seafoodmousse

/singleton/recipe/vegello
	appliance = MIX
	fruit = list("dirtberries" = 2, "earthenroot" = 2, "mtear" = 2)
	reagents = list(/singleton/reagent/nutriment/gelatin = 10, /singleton/reagent/water = 5, /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sliceable/vegello

/singleton/recipe/fruitgello
	appliance = MIX
	fruit = list("sugartree" = 2, "dirtberries" = 1)
	reagents = list(/singleton/reagent/nutriment/gelatin = 10, /singleton/reagent/water = 5, /singleton/reagent/sugar = 5, /singleton/reagent/drink/milk/cream = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/fruitgello

/singleton/recipe/aspicfatshouter
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers,
		/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers,
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir
	)
	reagents = list(/singleton/reagent/nutriment/gelatin = 10, /singleton/reagent/water = 5,  /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sliceable/aspicfatshouter

/singleton/recipe/fatshouterbake
	appliance = OVEN
	fruit = list("sugartree" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/adhomian_can,
		/obj/item/reagent_containers/food/snacks/adhomian_can
	)
	reagents = list(/singleton/reagent/nutriment/gelatin = 5, /singleton/reagent/water = 5,  /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sliceable/fatshouterbake

/singleton/recipe/crownfurter
	appliance = OVEN
	fruit = list("dirtberries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/adhomian_sausage,
		/obj/item/reagent_containers/food/snacks/adhomian_sausage,
		/obj/item/reagent_containers/food/snacks/dip/sarmikhir
	)
	reagents = list(/singleton/reagent/nutriment/gelatin = 5, /singleton/reagent/water = 5,  /singleton/reagent/spacespice = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chipplate/crownfurter
