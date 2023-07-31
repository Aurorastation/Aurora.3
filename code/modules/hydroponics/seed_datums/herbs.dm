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