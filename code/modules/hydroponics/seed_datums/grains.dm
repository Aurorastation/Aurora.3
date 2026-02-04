/datum/seed/wheat
	name = "wheat"
	seed_name = "wheat"
	display_name = "wheat stalks"
	chems = list(/singleton/reagent/nutriment = list(1,25), /singleton/reagent/nutriment/flour = list(15,15))
	kitchen_tag = "wheat"

/datum/seed/wheat/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "wheat")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#DBD37D")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#BFAF82")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "stalk2")
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/wheatseed
	seed_type = "wheat"

/datum/seed/corn
	name = "corn"
	seed_name = "corn"
	display_name = "ears of corn"
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/nutriment/triglyceride/oil/corn = list(1,10))
	kitchen_tag = "corn"
	trash_type = /obj/item/corncob

/datum/seed/corn/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 8)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 20)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "corn")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FFF23B")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#87C969")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "corn")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/cornseed
	seed_type = "corn"

/datum/seed/rice
	name = "rice"
	seed_name = "rice"
	display_name = "rice stalks"
	chems = list(/singleton/reagent/nutriment = list(1,25), /singleton/reagent/nutriment/rice = list(10,15))
	kitchen_tag = "rice"

/datum/seed/rice/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "rice")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#D5E6D1")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#8ED17D")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "stalk2")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/riceseed
	seed_type = "rice"
