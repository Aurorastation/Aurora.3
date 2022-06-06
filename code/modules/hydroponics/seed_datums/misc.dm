/datum/seed/weeds
	name = "weeds"
	seed_name = "weed"
	display_name = "weeds"

/datum/seed/weeds/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_POTENCY,-1)
	set_trait(TRAIT_IMMUTABLE,-1)
	set_trait(TRAIT_PRODUCT_ICON,"flower4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FCEB2B")
	set_trait(TRAIT_PLANT_COLOUR,"#59945A")
	set_trait(TRAIT_PLANT_ICON,"bush6")

/obj/item/seeds/weeds
	seed_type = "weeds"

/datum/seed/sugarcane
	name = "sugarcane"
	seed_name = "sugarcane"
	display_name = "sugarcanes"
	chems = list(/decl/reagent/sugar = list(4,5))

/datum/seed/sugarcane/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B4D6BD")
	set_trait(TRAIT_PLANT_COLOUR,"#6BBD68")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
	set_trait(TRAIT_IDEAL_HEAT, 298)

/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"

/datum/seed/grass
	name = "grass"
	seed_name = "grass"
	display_name = "grass"
	chems = list(/decl/reagent/nutriment = list(1,20))
	kitchen_tag = "grass"

/datum/seed/grass/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,2)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#09FF00")
	set_trait(TRAIT_PLANT_COLOUR,"#07D900")
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/grassseed
	seed_type = "grass"

/datum/seed/grass/sea
	name = "seaweed"
	seed_name = "seaweed"
	display_name = "seaweed"
	kitchen_tag = "seaweed"

/datum/seed/grass/sea/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR, "#0F6E56")
	set_trait(TRAIT_PLANT_COLOUR, "#0D4836")

/obj/item/seeds/seaweed
	seed_type = "seaweed"

/datum/seed/grass/moss
	name = "moss"
	seed_name = "moss"
	display_name = "moss"
	kitchen_tag = "moss"

/datum/seed/grass/moss/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_ICON,"moss")
	set_trait(TRAIT_PRODUCT_COLOUR, "#83D27F")
	set_trait(TRAIT_PLANT_COLOUR, "#589755")

/obj/item/seeds/mossseed
	seed_type = "moss"

/datum/seed/peppercorn
	name = "peppercorn"
	seed_name = "peppercorn"
	display_name = "black pepper"
	chems = list(/decl/reagent/blackpepper = list(10,10))

/datum/seed/peppercorn/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d4d4d")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/peppercornseed
	seed_type = "peppercorn"

/datum/seed/kudzu
	name = "kudzu"
	seed_name = "kudzu"
	display_name = "kudzu vines"
	chems = list(/decl/reagent/nutriment = list(1,50), /decl/reagent/dylovene = list(1,25))

/datum/seed/kudzu/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96D278")
	set_trait(TRAIT_PLANT_COLOUR,"#6F7A63")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

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
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_ENDURANCE,8)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_PRODUCT_ICON,"diona")
	set_trait(TRAIT_PRODUCT_COLOUR,"#799957")
	set_trait(TRAIT_PLANT_COLOUR,"#66804B")
	set_trait(TRAIT_PLANT_ICON,"alien4")

/obj/item/seeds/replicapod
	seed_type = "diona"
