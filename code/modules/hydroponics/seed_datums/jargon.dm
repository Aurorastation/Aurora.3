// Skrellian plants

/datum/seed/dyn
	name = "dyn"
	seed_name = "dyn"
	display_name = "dyn bush"
	mutants = null
	chems = list(/decl/reagent/drink/dynjuice = list(2, 2), /decl/reagent/dylovene = list(0, 1))
	kitchen_tag = "dyn leaf"

/datum/seed/dyn/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 10)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"leaves")
	set_trait(TRAIT_PRODUCT_COLOUR,"#00e0e0")
	set_trait(TRAIT_PLANT_ICON,"bush8")

/obj/item/seeds/dynseed
	seed_type = "dyn"

/datum/seed/wulumunusha
	name = "wulumunusha"
	seed_name = "wulumunusha"
	display_name = "wulumunusha vines"
	chems = list(/decl/reagent/wulumunusha = list(3, 5))
	kitchen_tag = "wulumunusha"

/datum/seed/wulumunusha/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 8)
	set_trait(TRAIT_PRODUCTION, 3)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 5)
	set_trait(TRAIT_PRODUCT_ICON,"wumpafruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#61E2EC")
	set_trait(TRAIT_PLANT_ICON,"wumpavines")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)

/obj/item/seeds/wulumunushaseed
	seed_type = "wulumunusha"

/datum/seed/qlort
	name = "qlort"
	seed_name = "q'lort bulb"
	display_name = "q'lort"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(3, 5))
	kitchen_tag = "q'lort"

/datum/seed/qlort/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 1)
	set_trait(TRAIT_YIELD, 5)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom9")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B1E4BE")
	set_trait(TRAIT_FLESH_COLOUR, "#9FE4B0")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/qlortseed
	seed_type = "qlort"

/datum/seed/guami
	name = "guami"
	seed_name = "guami fruit"
	display_name = "guami vine"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(5, 9))
	kitchen_tag = "guami"

/datum/seed/guami/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 15)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 30)
	set_trait(TRAIT_BIOLUM, 1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#1F8DBA")
	set_trait(TRAIT_FLESH_COLOUR, "#1F8DBA")
	set_trait(TRAIT_PRODUCT_ICON,"alien")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E8F1Fa")
	set_trait(TRAIT_PLANT_COLOUR,"#4790DA")
	set_trait(TRAIT_PLANT_ICON,"alien")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)

/obj/item/seeds/guamiseed
	seed_type = "guami"

/datum/seed/eki
	name = "eki"
	seed_name = "eki"
	display_name = "eki"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(7, 11))
	kitchen_tag = "eki"

/datum/seed/eki/setup_traits()
	..()
	set_trait(TRAIT_SPREAD, 1)
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 4)
	set_trait(TRAIT_POTENCY, 15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_BIOLUM_COLOUR,"#F0EEE9")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F1EAD9")
	set_trait(TRAIT_PLANT_COLOUR,"#F1EAD9")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")

/obj/item/seeds/eki
	seed_type = "eki"

/datum/seed/ylpha
	name = "ylpha"
	seed_name = "ylpha berry"
	display_name = "ylpha berry bush"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(3, 5), /decl/reagent/drink/ylphaberryjuice = list(10,10))
	kitchen_tag = "ylpha"

/datum/seed/ylpha/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT, 1)
	set_trait(TRAIT_JUICY, 1)
	set_trait(TRAIT_MATURATION, 5)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 2)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#d46423")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/ylpha
	seed_type = "ylpha"

/datum/seed/fjylozyn
	name = "fjylozyn"
	seed_name = "fjylozyn"
	display_name = "fjylozyn"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(3, 5), /decl/reagent/toxin = list(2, 3))
	kitchen_tag = "fjylozyn"

/datum/seed/fjylozyn/setup_traits()
	..()
	set_trait(TRAIT_MATURATION, 8)
	set_trait(TRAIT_PRODUCTION, 3)
	set_trait(TRAIT_POTENCY, 5)
	set_trait(TRAIT_PRODUCT_ICON,"fjylozyn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#990000")
	set_trait(TRAIT_PLANT_COLOUR,"#993333")
	set_trait(TRAIT_PLANT_ICON,"wumpavines")
	set_trait(TRAIT_YIELD, 6)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#990033")
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_WATER_CONSUMPTION, 10)

/obj/item/seeds/fjylozyn
	seed_type = "fjylozyn"