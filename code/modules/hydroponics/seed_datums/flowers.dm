//Flowers/varieties
/datum/seed/flower
	name = "harebells"
	seed_name = "harebell"
	display_name = "harebells"
	chems = list(/singleton/reagent/nutriment = list(1,20))

/obj/item/seeds/harebell
	seed_type = "harebells"

/datum/seed/flower/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 7)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "flower5")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#C492D6")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#6B8C5E")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "flower")
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/poppy
	name = "poppies"
	seed_name = "poppy"
	display_name = "poppies"
	chems = list(/singleton/reagent/nutriment = list(1,20), /singleton/reagent/morphine = list(1,10))
	kitchen_tag = "poppy"

/datum/seed/flower/poppy/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 20)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 8)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "flower3")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#B33715")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "flower3")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 0.5)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/poppyseed
	seed_type = "poppies"

/datum/seed/flower/sunflower
	name = "sunflowers"
	seed_name = "sunflower"
	display_name = "sunflowers"

/datum/seed/flower/sunflower/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "flower2")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FFF700")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "flower2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/sunflowerseed
	seed_type = "sunflowers"

/datum/seed/flower/vanilla
	name = "vanilla"
	seed_name = "vanilla"
	display_name = "vanilla"
	chems = list(/singleton/reagent/nutriment/vanilla = list(3,10), /singleton/reagent/nutriment = list(1,20))

/obj/item/seeds/vanilla
	seed_type = "vanilla"

/datum/seed/flower/vanilla/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 7)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 1)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "flower5")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#e8efe5")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#6B8C5E")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "flower")
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

