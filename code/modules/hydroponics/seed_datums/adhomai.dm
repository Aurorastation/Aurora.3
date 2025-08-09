/////////////////////////////
//  Adhomai-native plants  //
/////////////////////////////
/datum/seed/shand
	name = "shand"
	seed_name = "S'rendarr's hand"
	display_name = "S'rendarr's hand leaves"
	product_desc = "a medicinal brush traditionally smoked by the Tajara."
	product_desc_extended = "A dark green bush that grows above ground in areas around bodies of water. S'rendarr's hand, or Alyad'al S'rendarr, are typically planted on church properties as well as plantations. These bushes are prolific due to their medicinal fruits which are both eaten and used in salves. Another use that is prolific among Tajara is to dry them out and stuff them in pipes or roll them into cigars for smoking. S'rendarr's hand's smokables are still popular despite the growing popularity of alien tobacco."
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
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_ADHOMAI)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_DIM)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/shandseed
	seed_type = "shand"

/datum/seed/mtear
	name = "mtear"
	seed_name = "Messa's tear"
	display_name = "Messa's tear leaves"
	product_desc = "a medicinal Adhomian leaf used to treat burns."
	product_desc_extended = "Growing in patches in many places in the Adhomai wilderness, this grassy medicinal herb can also be found on many church properties much like S'rendarr's Hand. These plants grow to heights between 50 and 75 centimeters and are harvested by scythes. The harvested plants can be eaten, but more typically are ground up and used as ointments for burn treatments."
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
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_ADHOMAI)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_DIM)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/mtearseed
	seed_type = "mtear"

/datum/seed/earthenroot
	name = "earthenroot"
	seed_name = "earthen-root"
	display_name = "earthen-roots"
	product_desc = "a sweet and firm blue-colored vegetable with no visible soft areas."
	product_desc_extended = "The Earthen-Root, or Binajr-nab'at, is a herbaceous plant native to the region of the Northern Harr'masir, and is popular in the New Kingdom of Adhomai due to it's resilience in harsh environments. Common uses for the Earth-Root, besides being used in dishes, include distillation to brew alcoholic beverages, extraction of the blue pigment for the fabrication of dyes, and the production of sugar."
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
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_ADHOMAI)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_DIM)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)

/obj/item/seeds/earthenroot
	seed_type = "earthenroot"

/datum/seed/dirtberries
	name = "dirtberries"
	seed_name = "dirtberries"
	display_name = "dirt berries shrub"
	product_desc = "a pile of Adhomian berries used by the Tajara for its oil."
	product_desc_extended = "An above-ground evergreen shrub that grows sweet, starchy legumes underground in thick pods. 'Dirt Berries', or Zhu'hagha Nifs, grow like peanuts but bear several nuts like peas in a pod, typically around 8 thumb-sized nifs in each pod. Their flavor is rich, fatty, and savory, and they are used to produce oil."
	chems = list(/singleton/reagent/nutriment = list(0, 15), /singleton/reagent/nutriment/triglyceride/oil = list(1, 5), /singleton/reagent/drink/dirtberryjuice = list(10,10))
	kitchen_tag = "dirtberries"

/datum/seed/dirtberries/setup_traits()
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
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_ADHOMAI)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_DIM)

/obj/item/seeds/dirtberries
	seed_type = "dirtberries"

/datum/seed/mushroom/nfrihi
	name = "nfrihi"
	seed_name = "blizzard ears"
	seed_noun = SEED_NOUN_NODES
	display_name = "blizzard ear stalks"
	product_desc = "a large, meaty, tough fungus with an earthy taste, resembling a more savory jicama."
	product_desc_extended = "Blizard ears, or N'fri-hi, are a flour-producing plant that forms a meal that can be dried and stored for a long period of time. It grows underground with a thick starchy rind, which is peeled off and is not edible raw. The rind dries, and is pounded into flour, which dries to a fine meal, and has similar usage to potato flour. The raw peeled lobes can be dried, and ground into a more hearty, coarse meal, used like both cornmeal and whole-wheat flour."
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
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_DIM)
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_ADHOMAI)

/obj/item/seeds/blizzard
	seed_type = "nfrihi"

/datum/seed/sugartree
	name = "sugar tree"
	seed_name = "sugar tree"
	display_name = "sugar trees"
	product_desc = "The fruit of the Sugar Tree, native to Adhomai. It is sweet and commonly used in candies."
	product_desc_extended = "Sugar Tree, or Nm'shaan, are hardy snow bamboo invaluable for sugar production on the planet. They are unique in that on every stem it bears a single spherical fruit at the very top, surrounded by a white woolly rind. Short stems which end in thick-leafed fronds grow along the length of the 'trunk', giving it an appearance like Terran bamboo. The stalks tend to be as thick as one's thigh with very hard, protective woody shells around its vulnerable interior."
	seed_noun = SEED_NOUN_SEEDS
	mutants = null
	chems = list(/singleton/reagent/sugar = list(2, 10), /singleton/reagent/nutriment/gelatin = list(2, 5))
	kitchen_tag = "sugartree"

/datum/seed/sugartree/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT, 1)
	set_trait(TRAIT_MATURATION, 9)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 2)
	set_trait(TRAIT_PRODUCT_ICON,"nmshaan")
	set_trait(TRAIT_PRODUCT_COLOUR,"#fffdf7")
	set_trait(TRAIT_PLANT_COLOUR,"#31331c")
	set_trait(TRAIT_PLANT_ICON,"nmshaan")
	set_trait(TRAIT_IDEAL_HEAT, IDEAL_HEAT_ADHOMAI)
	set_trait(TRAIT_WATER_CONSUMPTION, 4)
	set_trait(TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_DIM)

/obj/item/seeds/sugartree
	seed_type = "sugar tree"
