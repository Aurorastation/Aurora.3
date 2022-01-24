/datum/seed/mollusc
	name = "mollusc"
	seed_name = "mollusc"
	display_name = "mollusc bed"
	product_type = /obj/item/mollusc
	seed_noun = SEED_NOUN_EGGS
	mutants = null

/datum/seed/mollusc/New()
	..()
	set_trait(TRAIT_MATURATION,        10)
	set_trait(TRAIT_PRODUCTION,        1)
	set_trait(TRAIT_YIELD,             3)
	set_trait(TRAIT_POTENCY,           1)
	set_trait(TRAIT_PRODUCT_ICON,      "mollusc")
	set_trait(TRAIT_PLANT_ICON,        "mollusc")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT,        288)
	set_trait(TRAIT_LIGHT_TOLERANCE,   6)
	set_trait(TRAIT_PRODUCT_COLOUR,    "#aaabba")
	set_trait(TRAIT_PLANT_COLOUR,      "#aaabba")

/obj/item/seeds/mollusc
	seed_type = "mollusc"

/datum/seed/mollusc/clam
	name = "clam"
	seed_name = "clam"
	display_name = "clam bed"
	product_type = /obj/item/mollusc/clam

/datum/seed/mollusc/clam/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR, "#9aaca6")
	set_trait(TRAIT_PLANT_COLOUR,   "#9aaca6")

/obj/item/seeds/clam
	seed_type = "clam"

/datum/seed/mollusc/barnacle
	name = "barnacle"
	seed_name = "barnacle"
	display_name = "barnacle bed"
	product_type = /obj/item/mollusc/barnacle

/datum/seed/mollusc/barnacle/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR, "#c1c0b6")
	set_trait(TRAIT_PLANT_COLOUR,   "#c1c0b6")

/obj/item/seeds/barnacle
	seed_type = "barnacle"

/datum/seed/mollusc/clam/rasval
	name = "rasval clam"
	seed_name = "rasval clam"
	display_name = "rasval clam bed"
	product_type = /obj/item/mollusc/clam/rasval

/datum/seed/mollusc/clam/rasval/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR, "#9aaca6")
	set_trait(TRAIT_PLANT_COLOUR,   "#9aaca6")

/obj/item/seeds/clam/rasval
	seed_type = "rasval clam"