/datum/seed/mint
	name = "mint"
	seed_name = "mint leaf"
	display_name = "mint plant"
	chems = list(/singleton/reagent/nutriment/mint = list(2,10))
	kitchen_tag = "mint"

//I wasnt sure if tea and mint would be a flower or something, so i just made a herb file..

/datum/seed/mint/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"herb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4dd298")
	set_trait(TRAIT_PLANT_ICON,"herb")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/mintseed
	seed_type = "mint"


/datum/seed/tea
	name = "tea"
	seed_name = "tea leaf"
	display_name = "tea plant"
	chems = list(/singleton/reagent/nutriment/teagrounds = list(2,10))
	kitchen_tag = "tea"

/datum/seed/tea/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"herb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4fd24d")
	set_trait(TRAIT_PLANT_ICON,"herb")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/teaseed
	seed_type = "tea"

/datum/seed/sencha
	name = "sencha"
	seed_name = "sencha leaves"
	display_name = "sencha plant"
	chems = list(/singleton/reagent/nutriment/teagrounds/sencha = list(4,9))

/datum/seed/sencha/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"herb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#0E1F0E")
	set_trait(TRAIT_PLANT_ICON,"herb")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/sencha
	seed_type = "sencha"

/datum/seed/tieguanyin
	name = "tieguanyin"
	seed_name = "tieguanyin leaves"
	display_name = "tieguanyin plant"
	chems = list(/singleton/reagent/nutriment/teagrounds/tieguanyin = list(3,8))

/datum/seed/tieguanyin/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"herb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#5C6447")
	set_trait(TRAIT_PLANT_ICON,"herb")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/tieguanyin
	seed_type = "tieguanyin"

/datum/seed/jaekseol
	name = "jaekseol"
	seed_name = "jaekseol leaves"
	display_name = "jaekseol plant"
	chems = list(/singleton/reagent/nutriment/teagrounds/jaekseol = list(4,7))

/datum/seed/jaekseol/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD, 2)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"herb")
	set_trait(TRAIT_PRODUCT_COLOUR,"#534337")
	set_trait(TRAIT_PLANT_ICON,"herb")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/jaekseol
	seed_type = "jaekseol"

/datum/seed/coca
	name = "coca"
	seed_name = "coca leaf"
	display_name = "coca plant"
	chems = list(/singleton/reagent/nutriment/cocagrounds = list(2,10))
	kitchen_tag = "coca"

/datum/seed/coca/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 3)
	set_trait(TRAIT_PRODUCTION, 3)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 2)
	set_trait(TRAIT_PRODUCT_ICON, "herb")
	set_trait(TRAIT_PRODUCT_COLOUR, "#056608")
	set_trait(TRAIT_PLANT_ICON, "herb")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/cocaseed
	seed_type = "coca"
