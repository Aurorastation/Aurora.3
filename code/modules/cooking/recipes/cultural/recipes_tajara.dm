// Tajaran breads
/decl/recipe/tajaran_bread
	appliance = OVEN
	fruit = list("nifberries" = 1)
	reagents = list(/datum/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/flatbread
	)
	result = /obj/item/reagent_containers/food/snacks/tajaran_bread
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/hardbread
	appliance = OVEN
	reagents = list(/datum/reagent/spacespice = 1)
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
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	result = /obj/item/reagent_containers/food/snacks/stew/tajaran

/decl/recipe/earthenroot_soup
	appliance = SAUCEPAN | POT
	fruit = list("earthenroot" = 2)
	reagents = list(/datum/reagent/water = 10, /datum/reagent/spacespice = 1, /datum/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/soup/earthenroot

/decl/recipe/bloodpudding
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/nutriment/flour/nfrihi = 5, /datum/reagent/blood = 10)
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
	required_reagents = list(/datum/reagent/enzyme = 5)

/datum/chemical_reaction/fermentedworm/on_reaction(var/datum/reagents/holder, var/created_volume)
	new /obj/item/reagent_containers/food/snacks/fermented_worm(holder.my_atom.loc)
	qdel(holder.my_atom)
	return

/datum/chemical_reaction/fermentedworm/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/reagent_containers/food/snacks/hmatrrameat))
		if(holder.has_all_reagents(holder.my_atom.reagents_to_add)) // Make sure we haven't removed anything.
			return ..()
	return FALSE

// Tajaran Seafood
/decl/recipe/spicy_clams
	fruit = list("chili" = 1, "cabbage" = 1)
	reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/spacespice = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/clam,
		/obj/item/reagent_containers/food/snacks/clam
	)
	result = /obj/item/reagent_containers/food/snacks/spicy_clams

// Tajaran candy
/decl/recipe/tajcandy
	appliance = OVEN
	fruit = list("sugartree" = 2)
	reagents = list(/datum/reagent/drink/milk/adhomai = 5, /datum/reagent/nutriment/protein/egg = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/tajcandy
