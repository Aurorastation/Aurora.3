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
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b7f0b1")
	set_trait(TRAIT_PLANT_COLOUR,"#4D8F53")
	set_trait(TRAIT_PLANT_ICON,"tree3")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

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
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#bf8fbc")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

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
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"algae")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e93e1c")
	set_trait(TRAIT_PLANT_COLOUR,"#6d9c6b")
	set_trait(TRAIT_PLANT_ICON,"algae")
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

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
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"nuts")
	set_trait(TRAIT_PRODUCT_COLOUR,"#866523")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

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
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d40606")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/sthberryseed
	seed_type = "sthberry"

/datum/seed/flower/serkiflower
	name = "serkiflower"
	seed_name = "S'erki flower"
	display_name = "S'erki flowers"

/datum/seed/flower/serkiflower/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"[pick("#ffbc05", "#7400a6")]")
	set_trait(TRAIT_PLANT_ICON,"flower3")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_MOGHES)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)

/obj/item/seeds/serkiflowerseed
	seed_type = "serkiflower"
