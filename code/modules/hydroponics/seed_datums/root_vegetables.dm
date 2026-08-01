/datum/seed/carrots
	name = "carrot"
	seed_name = "carrot"
	display_name = "carrots"
	chems = list(/singleton/reagent/nutriment = list(1,20), /singleton/reagent/oculine = list(3,5), /singleton/reagent/drink/carrotjuice = list(10,20))
	kitchen_tag = "carrot"

/datum/seed/carrots/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 5)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "carrot")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FFDB4A")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "carrot")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/carrotseed
	seed_type = "carrot"

/datum/seed/garlic
	name = "garlic"
	seed_name = "garlic"
	display_name = "garlic"
	chems = list(/singleton/reagent/drink/garlicjuice = list(1,5))
	kitchen_tag = "garlic"

/datum/seed/garlic/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 5)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 12)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bulb")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#fff8dd")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "stalk")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 7)

/obj/item/seeds/garlicseed
	seed_type = "garlic"

/datum/seed/onion
	name = "onion"
	seed_name = "onion"
	display_name = "onions"
	chems = list(/singleton/reagent/drink/onionjuice = list(1,5))
	kitchen_tag = "onion"

/datum/seed/onion/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bulb")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#ffeedd")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "stalk")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 5)

/obj/item/seeds/onionseed
	seed_type = "onion"

/datum/seed/potato
	name = "potato"
	seed_name = "potato"
	display_name = "potatoes"
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/potatojuice = list(10,10))
	kitchen_tag = "potato"

/datum/seed/potato/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCES_POWER, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "potato")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#D4CAB4")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/potatoseed
	seed_type = "potato"

/datum/seed/whitebeets
	name = "whitebeet"
	seed_name = "white-beet"
	display_name = "white-beets"
	chems = list(/singleton/reagent/nutriment = list(0,20), /singleton/reagent/sugar = list(1,5))
	kitchen_tag = "whitebeet"

/datum/seed/whitebeets/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 6)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "carrot2")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#EEF5B0")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#4D8F53")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "carrot2")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/whitebeetseed
	seed_type = "whitebeet"
