// Skrellian plants

/datum/seed/dyn
	name = "dyn"
	seed_name = "dyn"
	display_name = "dyn bush"
	mutants = null
	chems = list(/singleton/reagent/drink/dynjuice = list(2, 2), /singleton/reagent/dylovene = list(0, 1))
	kitchen_tag = "dyn leaf"

/datum/seed/dyn/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 10)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "leaves")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#00e0e0")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush8")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/dynseed
	seed_type = "dyn"

/datum/seed/wulumunusha
	name = "wulumunusha"
	seed_name = "wulumunusha"
	display_name = "wulumunusha vines"
	chems = list(/singleton/reagent/wulumunusha = list(3, 5))
	kitchen_tag = "wulumunusha"

/datum/seed/wulumunusha/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 8)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 3)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "wumpafruit")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#61E2EC")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "wumpavines")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 10)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/wulumunushaseed
	seed_type = "wulumunusha"

/datum/seed/qlort
	name = "qlort"
	seed_name = "q'lort bulb"
	display_name = "q'lort"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(3, 5))
	kitchen_tag = "q'lort"

/datum/seed/qlort/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 5)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "mushroom9")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#B1E4BE")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#9FE4B0")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "mushroom9")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/qlortseed
	seed_type = "qlort"

/datum/seed/guami
	name = "guami"
	seed_name = "guami fruit"
	display_name = "guami vine"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(5, 9))
	kitchen_tag = "guami"

/datum/seed/guami/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 15)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 30)
	SET_SEED_TRAIT(src, TRAIT_BIOLUM, 1)
	SET_SEED_TRAIT(src, TRAIT_BIOLUM_COLOUR, "#1F8DBA")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#1F8DBA")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "alien")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#E8F1Fa")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#4790DA")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "alien1")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 10)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/guamiseed
	seed_type = "guami"

/datum/seed/mushroom/eki
	name = "eki"
	seed_name = "eki"
	display_name = "eki"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(7, 11))
	kitchen_tag = "eki"

/datum/seed/mushroom/eki/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_SPREAD, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 15)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "mushroom11")
	SET_SEED_TRAIT(src, TRAIT_BIOLUM_COLOUR, "#F0EEE9")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#F1EAD9")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#F1EAD9")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "mushroom6")

/obj/item/seeds/eki
	seed_type = "eki"

/datum/seed/ylpha
	name = "ylpha"
	seed_name = "ylpha berry"
	display_name = "ylpha berry bush"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(3, 5), /singleton/reagent/drink/ylphaberryjuice = list(10,10))
	kitchen_tag = "ylpha"

/datum/seed/ylpha/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "berry")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#d46423")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 10)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/ylpha
	seed_type = "ylpha"

/datum/seed/fjylozyn
	name = "fjylozyn"
	seed_name = "fjylozyn"
	display_name = "fjylozyn"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(3, 5), /singleton/reagent/toxin = list(2, 3))
	kitchen_tag = "fjylozyn"

/datum/seed/fjylozyn/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 8)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "fjylozyn")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#990000")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#993333")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_YIELD, 6)
	SET_SEED_TRAIT(src, TRAIT_BIOLUM, 1)
	SET_SEED_TRAIT(src, TRAIT_BIOLUM_COLOUR, "#990033")
	SET_SEED_TRAIT(src, TRAIT_SPREAD, 1)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 10)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/fjylozyn
	seed_type = "fjylozyn"
