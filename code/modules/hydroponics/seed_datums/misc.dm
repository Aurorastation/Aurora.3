/datum/seed/weeds
	name = "weeds"
	seed_name = "weed"
	display_name = "weeds"

/datum/seed/weeds/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, -1)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, -1)
	SET_SEED_TRAIT(src, TRAIT_IMMUTABLE, -1)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "flower4")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FCEB2B")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#59945A")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush6")

/obj/item/seeds/weeds
	seed_type = "weeds"

/datum/seed/sugarcane
	name = "sugarcane"
	seed_name = "sugarcane"
	display_name = "sugarcanes"
	chems = list(/singleton/reagent/sugar = list(4,5))

/datum/seed/sugarcane/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "stalk")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#B4D6BD")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#6BBD68")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "stalk3")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"

/datum/seed/grass
	name = "grass"
	seed_name = "grass"
	display_name = "grass"
	product_desc = "You should probably touch some of this sometime."
	chems = list(/singleton/reagent/nutriment = list(1,20))
	kitchen_tag = "grass"

/datum/seed/grass/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "grass")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#09FF00")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#07D900")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "grass")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 0.5)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/grassseed
	seed_type = "grass"

/datum/seed/grass/moss
	name = "moss"
	seed_name = "moss"
	display_name = "moss"
	kitchen_tag = "moss"

/datum/seed/grass/moss/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "moss")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#83D27F")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#589755")

/obj/item/seeds/mossseed
	seed_type = "moss"

/datum/seed/peppercorn
	name = "peppercorn"
	seed_name = "peppercorn"
	display_name = "black pepper"
	chems = list(/singleton/reagent/blackpepper = list(10,10))

/datum/seed/peppercorn/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 4)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "nuts")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#4d4d4d")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/peppercornseed
	seed_type = "peppercorn"

/datum/seed/kudzu
	name = "kudzu"
	seed_name = "kudzu"
	display_name = "kudzu vines"
	chems = list(/singleton/reagent/nutriment = list(1,50), /singleton/reagent/dylovene = list(1,25))

/datum/seed/kudzu/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_SPREAD, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "treefruit")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#96D278")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#6F7A63")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 0.5)

/obj/item/seeds/kudzuseed
	seed_type = "kudzu"

/datum/seed/diona
	name = "diona"
	seed_name = "diona"
	seed_noun = "node"
	display_name = "diona pod"
	can_self_harvest = 1
	product_type = /mob/living/carbon/alien/diona

/datum/seed/diona/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_IMMUTABLE, 1)
	SET_SEED_TRAIT(src, TRAIT_ENDURANCE, 8)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 10)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 1)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 30)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "diona")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#799957")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#66804B")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "alien4")

/obj/item/seeds/replicapod
	seed_type = "diona"
