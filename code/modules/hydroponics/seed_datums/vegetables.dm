////////////////////
//  Chili plants  //
////////////////////
/datum/seed/chili
	name = "chili"
	seed_name = "chili"
	display_name = "chili plants"
	chems = list(/singleton/reagent/capsaicin = list(3,5), /singleton/reagent/nutriment = list(1,25))
	mutants = list("icechili")
	kitchen_tag = "chili"

/datum/seed/chili/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ED3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/obj/item/seeds/chiliseed
	seed_type = "chili"

/datum/seed/chili/ice
	name = "icechili"
	seed_name = "ice pepper"
	display_name = "ice-pepper plants"
	mutants = null
	chems = list(/singleton/reagent/frostoil = list(3,5), /singleton/reagent/nutriment = list(1,50))
	kitchen_tag = "icechili"

/datum/seed/chili/ice/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00EDC6")

/obj/item/seeds/icepepperseed
	seed_type = "icechili"

///////////////
//  Nettles  //
///////////////
/datum/seed/nettle
	name = "nettle"
	seed_name = "nettle"
	display_name = "nettles"
	mutants = list("deathnettle")
	chems = list(/singleton/reagent/nutriment = list(1,50), /singleton/reagent/acid = list(0,1))
	kitchen_tag = "nettle"
	kitchen_tag = "nettle"

/datum/seed/nettle/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_STINGS,1)
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"nettles")
	set_trait(TRAIT_PRODUCT_COLOUR,"#728A54")

/obj/item/seeds/nettleseed
	seed_type = "nettle"

/datum/seed/nettle/death
	name = "deathnettle"
	seed_name = "death nettle"
	display_name = "death nettles"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(1,50), /singleton/reagent/acid/polyacid = list(0,1))
	kitchen_tag = "deathnettle"

/datum/seed/nettle/death/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#8C5030")
	set_trait(TRAIT_PLANT_COLOUR,"#634941")

/obj/item/seeds/deathnettleseed
	seed_type = "deathnettle"

/////////////////
//  Eggplants  //
/////////////////
/datum/seed/eggplant
	name = "eggplant"
	seed_name = "eggplant"
	display_name = "eggplants"
	mutants = list("realeggplant")
	chems = list(/singleton/reagent/nutriment = list(1,10))
	kitchen_tag = "eggplant"

/datum/seed/eggplant/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/obj/item/seeds/eggplantseed
	seed_type = "eggplant"

/datum/seed/realeggplant
	name = "huge eggplant"
	seed_name = "realeggplant"
	display_name = "eggplants"
	chems = list(/singleton/reagent/nutriment = list(15,30))
	kitchen_tag = "realeggplant"

/datum/seed/realeggplant/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,40)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

///////////////
//  Legumes  //
///////////////
/datum/seed/peanuts
	name = "peanut"
	seed_name = "peanut"
	display_name = "peanut vines"
	chems = list(/singleton/reagent/nutriment = list(1,10))
	kitchen_tag = "peanut"

/datum/seed/peanuts/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"peanut")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F2B369")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/peanutseed
	seed_type = "peanut"

/datum/seed/soybean
	name = "soybean"
	seed_name = "soybean"
	display_name = "soybeans"
	chems = list(/singleton/reagent/nutriment = list(1,20), /singleton/reagent/drink/milk/soymilk = list(10,20))
	kitchen_tag = "soybeans"

/datum/seed/soybean/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EBE7C0")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/obj/item/seeds/soyaseed
	seed_type = "soybean"


/datum/seed/chickpea
	name = "chickpea"
	seed_name = "chickpea"
	display_name = "chickpeas"
	chems = list(/singleton/reagent/nutriment = list(1, 20))
	kitchen_tag = "chickpeas"

/datum/seed/chickpea/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION, 4)
	set_trait(TRAIT_PRODUCTION, 4)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 5)
	set_trait(TRAIT_PRODUCT_ICON, "bean")
	set_trait(TRAIT_PRODUCT_COLOUR, "#e0ce25")
	set_trait(TRAIT_PLANT_ICON, "bush2")

/obj/item/seeds/chickpeas
	seed_type = "chickpea"

///////////////
//  Cabbage  //
///////////////

/datum/seed/cabbage
	name = "cabbage"
	seed_name = "cabbage"
	display_name = "cabbages"
	chems = list(/singleton/reagent/nutriment = list(1,10))
	kitchen_tag = "cabbage"

/datum/seed/cabbage/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cabbage")
	set_trait(TRAIT_PRODUCT_COLOUR,"#84BD82")
	set_trait(TRAIT_PLANT_COLOUR,"#6D9C6B")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/cabbageseed
	seed_type = "cabbage"
