/////////////////////////////
//  Adhomai-native plants  //
/////////////////////////////
/datum/seed/shand
	name = "shand"
	seed_name = "S'Rendarr's hand"
	display_name = "S'Rendarr's hand leaves"
	chems = list(/singleton/reagent/toxin/tobacco = list(1, 5), /singleton/reagent/bicaridine = list(3, 5), /singleton/reagent/mental/nicotine = list(1, 3))
	kitchen_tag = "shand"

/datum/seed/shand/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 3)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 4)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#378C61")
	set_trait(TRAIT_PLANT_COLOUR,"#378C61")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/shandseed
	seed_type = "shand"

/datum/seed/mtear
	name = "mtear"
	seed_name = "Messa's tear"
	display_name = "Messa's tear leaves"
	chems = list(/singleton/reagent/nutriment/honey = list(1, 10), /singleton/reagent/kelotane = list(3, 5))
	kitchen_tag = "mtear"

/datum/seed/mtear/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 3)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 4)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4CC5C7")
	set_trait(TRAIT_PLANT_COLOUR,"#4CC789")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/mtearseed
	seed_type = "mtear"

/datum/seed/earthenroot
	name = "earthenroot"
	seed_name = "earthen-root"
	display_name = "earthen-roots"
	chems = list(/singleton/reagent/nutriment = list(0, 5), /singleton/reagent/sugar = list(1, 5), /singleton/reagent/drink/earthenrootjuice = list(4, 8))
	kitchen_tag = "earthenroot"

/datum/seed/earthenroot/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 7)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 5)
	set_trait(TRAIT_POTENCY, 8)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#87CEEB")
	set_trait(TRAIT_PLANT_COLOUR,"#4D8F53")
	set_trait(TRAIT_PLANT_ICON,"alien2")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)

/obj/item/seeds/earthenroot
	seed_type = "earthenroot"

/datum/seed/nifberries
	name = "nifberries"
	seed_name = "dirt berries"
	display_name = "dirt berries shrub"
	chems = list(/singleton/reagent/nutriment = list(0, 15), /singleton/reagent/nutriment/triglyceride/oil = list(1, 5), /singleton/reagent/drink/dirtberryjuice = list(10,10))
	kitchen_tag = "nifberries"

/datum/seed/nifberries/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT, 1)
	set_trait(TRAIT_JUICY, 1)
	set_trait(TRAIT_MATURATION, 5)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 2)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#C4AE7A")
	set_trait(TRAIT_PLANT_COLOUR,"#4D8F53")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/nifberries
	seed_type = "nifberries"

/datum/seed/mushroom/nfrihi
	name = "nfrihi"
	seed_name = "blizzard ears"
	seed_noun = SEED_NOUN_NODES
	display_name = "blizzard ear stalks"
	mutants = null
	chems = list(/singleton/reagent/nutriment/flour/nfrihi = list(10, 10))
	splat_type = /obj/effect/plant
	kitchen_tag = "nfrihi"

/datum/seed/mushroom/nfrihi/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 6)
	set_trait(TRAIT_PRODUCTION, 1)
	set_trait(TRAIT_YIELD, 4)
	set_trait(TRAIT_POTENCY, 1)
	set_trait(TRAIT_PRODUCT_ICON,"nfrihi")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBDA72")
	set_trait(TRAIT_PLANT_COLOUR,"#31331c")
	set_trait(TRAIT_PLANT_ICON,"nfrihi")
	set_trait(TRAIT_WATER_CONSUMPTION, 4)
	set_trait(TRAIT_IDEAL_LIGHT, 3)
	set_trait(TRAIT_IDEAL_HEAT, 253)

/obj/item/seeds/blizzard
	seed_type = "nfrihi"

/datum/seed/nmshaan
	name = "nmshaan"
	seed_name = "sugar tree"
	display_name = "sugar trees"
	seed_noun = SEED_NOUN_SEEDS
	mutants = null
	chems = list(/singleton/reagent/sugar = list(2, 10))
	kitchen_tag = "nmshaan"

/datum/seed/nmshaan/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT, 1)
	set_trait(TRAIT_MATURATION, 9)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 2)
	set_trait(TRAIT_PRODUCT_ICON,"nmshaan")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fffdf7")
	set_trait(TRAIT_PLANT_COLOUR,"#31331c")
	set_trait(TRAIT_PLANT_ICON,"nmshaan")
	set_trait(TRAIT_IDEAL_HEAT, 253)
	set_trait(TRAIT_WATER_CONSUMPTION, 4)
	set_trait(TRAIT_IDEAL_LIGHT, 3)

/obj/item/seeds/sugartree
	seed_type = "nmshaan"
