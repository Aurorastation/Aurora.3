// Skrellian plants

/datum/seed/dyn
	name = "dyn"
	seed_name = "dyn"
	display_name = "dyn bush"
	mutants = null
	chems = list(/datum/reagent/drink/dynjuice = list(2,2), /datum/reagent/dylovene = list(0,1))
	kitchen_tag = "dyn leaf"

/datum/seed/dyn/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"leaves")
	set_trait(TRAIT_PRODUCT_COLOUR,"#00e0e0")
	set_trait(TRAIT_PLANT_ICON,"bush8")

/obj/item/seeds/dynseed
	seed_type = "dyn"

/datum/seed/wulumunusha
	name = "wulumunusha"
	seed_name = "wulumunusha"
	display_name = "wulumunusha vines"
	chems = list(/datum/reagent/wulumunusha = list(3,5))
	kitchen_tag = "wulumunusha"

/datum/seed/wulumunusha/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"wumpafruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#61E2EC")
	set_trait(TRAIT_PLANT_ICON,"wumpavines")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)

/obj/item/seeds/wulumunushaseed
	seed_type = "wulumunusha"