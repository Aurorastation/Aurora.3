//Unathi plants

/datum/seed/xuizi
	name = "xuizi"
	seed_name = "xuizi"
	display_name = "xuizi cactus"
	mutants = null
	chems = list(/singleton/reagent/alcohol/butanol/xuizijuice = list(3, 5), /singleton/reagent/nutriment = list(2,2))
	kitchen_tag = "xuizi flesh"

/datum/seed/xuizi/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 6)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "stalk")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#b7f0b1")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#4D8F53")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree3")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/xuiziseed
	seed_type = "xuizi"

/datum/seed/sarezhi
	name = "sarezhi"
	seed_name = "sarezshi berry"
	display_name = "sarezhi berry bush"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(2,2), /singleton/reagent/drink/sarezhiberryjuice = list(1,10))
	kitchen_tag = "sarezhi berry"

/datum/seed/sarezhi/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "berry")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#bf8fbc")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/sarezhiseed
	seed_type = "sarezhi"

/datum/seed/gukhe
	name = "gukhe"
	seed_name = "gukhe bloom"
	display_name = "gukhe bloom"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(2,12), /singleton/reagent/capsaicin = list(10,10))
	kitchen_tag = "gukhe"

/datum/seed/gukhe/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "algae")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#e93e1c")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#6d9c6b")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "algae")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/gukheseed
	seed_type = "gukhe"

/datum/seed/aghrassh
	name = "aghrassh"
	seed_name = "aghrassh"
	display_name = "aghrassh tree"
	chems = list(/singleton/reagent/nutriment = list(1,20))
	kitchen_tag = "aghrassh nut"

/datum/seed/aghrassh/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 15)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "nuts")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#866523")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/aghrasshseed
	seed_type = "aghrassh"

/datum/seed/sthberry
	name = "sthberry"
	seed_name = "S'th berry"
	display_name = "S'th berry bush"
	chems = list(/singleton/reagent/nutriment = list(2,2), /singleton/reagent/drink/sthberryjuice = list(3,5))
	kitchen_tag = "S'th berry"

/datum/seed/sthberry/setup_traits()
	..()
	// SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "berry")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#d40606")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/sthberryseed
	seed_type = "sthberry"

/datum/seed/flower/serkiflower
	name = "serkiflower"
	seed_name = "S'erki flower"
	display_name = "S'erki flowers"

/datum/seed/flower/serkiflower/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "flower3")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "[pick("#ffbc05", "#7400a6")]")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "flower3")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, 7)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/serkiflowerseed
	seed_type = "serkiflower"
