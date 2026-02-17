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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 20)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "chili")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#ED3300")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

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
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#00EDC6")

/obj/item/seeds/icepepperseed
	seed_type = "icechili"

/datum/seed/bellpepper
	name = "bellpepper"
	seed_name = "bell pepper"
	display_name = "bell peppers"
	chems = list(/singleton/reagent/nutriment = list(1,25))
	mutants = list("chili")
	kitchen_tag = "bellpepper"

/datum/seed/bellpepper/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "pepper")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#ff922d")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#35d65d")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 5)

/obj/item/seeds/bellpepperseed
	seed_type = "bellpepper"

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

/datum/seed/nettle/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_STINGS, 1)
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush5")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "nettles")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#728A54")

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
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 8)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#8C5030")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#634941")

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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 20)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "eggplant")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#892694")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush4")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 1)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 40)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "eggplant")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#892694")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush4")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, 298)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, 7)

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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 6)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "nuts")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#F2B369")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 4)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bean")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#EBE7C0")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "stalk")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 4)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 4)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bean")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#e0ce25")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")

/obj/item/seeds/chickpeas
	seed_type = "chickpea"

/datum/seed/peas
	name = "peas"
	seed_name = "peas"
	display_name = "peas"
	chems = list(/singleton/reagent/nutriment = list(1, 20))
	kitchen_tag = "peas"
	mutants = list("chickpeas")

/datum/seed/peas/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 3)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bean")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#70b74a")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")

/obj/item/seeds/peaseed
	seed_type = "peas"

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
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "cabbage")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#84BD82")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#6D9C6B")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/cabbageseed
	seed_type = "cabbage"

///////////////
//  Cucumber  //
///////////////

/datum/seed/cucumber
	name = "cucumber"
	seed_name = "cucumber"
	display_name = "cucumber plant"
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/water = list(3,10))
	kitchen_tag = "cucumber"

/datum/seed/cucumber/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 8)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "cucumber")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#2c9b44")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#3d803b")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/obj/item/seeds/cucumberseed
	seed_type = "cucumber"
x
