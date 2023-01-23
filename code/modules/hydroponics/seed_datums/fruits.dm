/////////////////////
//  Citrus fruits  //
/////////////////////
/datum/seed/citrus
	name = "lime"
	seed_name = "lime"
	display_name = "lime trees"
	chems = list(/decl/reagent/nutriment = list(1,20), /decl/reagent/drink/limejuice = list(10,20))
	kitchen_tag = "lime"

/datum/seed/citrus/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3AF026")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_FLESH_COLOUR,"#3AF026")

/obj/item/seeds/limeseed
	seed_type = "lime"

/datum/seed/citrus/lemon
	name = "lemon"
	seed_name = "lemon"
	display_name = "lemon trees"
	chems = list(/decl/reagent/nutriment = list(1,20), /decl/reagent/drink/lemonjuice = list(10,20))
	kitchen_tag = "lemon"

/datum/seed/citrus/lemon/setup_traits()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#F0E226")
	set_trait(TRAIT_FLESH_COLOUR,"#F0E226")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/lemonseed
	seed_type = "lemon"

/datum/seed/citrus/orange
	name = "orange"
	seed_name = "orange"
	display_name = "orange trees"
	kitchen_tag = "orange"
	chems = list(/decl/reagent/nutriment = list(1,20), /decl/reagent/drink/orangejuice = list(10,20))

/datum/seed/citrus/orange/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFC20A")
	set_trait(TRAIT_FLESH_COLOUR,"#FFC20A")

/obj/item/seeds/orangeseed
	seed_type = "orange"
//////////////
//  Grapes  //
//////////////
/datum/seed/grapes
	name = "grapes"
	seed_name = "grape"
	display_name = "grapevines"
	mutants = list("greengrapes")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/sugar = list(1,5), /decl/reagent/drink/grapejuice = list(10,10), /decl/reagent/nutriment/grapejelly = list(1,8))

/datum/seed/grapes/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#BB6AC4")
	set_trait(TRAIT_PLANT_COLOUR,"#378F2E")
	set_trait(TRAIT_PLANT_ICON,"vine")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/grapeseed
	seed_type = "grapes"

/datum/seed/grapes/green
	name = "greengrapes"
	seed_name = "green grape"
	display_name = "green grapevines"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/kelotane = list(3,5), /decl/reagent/drink/whitegrapejuice = list(10,10))

/datum/seed/grapes/green/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#42ED2F")

/obj/item/seeds/greengrapeseed
	seed_type = "greengrapes"

///////////////
//  Berries  //
///////////////
/datum/seed/berry
	name = "berries"
	seed_name = "berry"
	display_name = "berry bush"
	mutants = list("glowberries","poisonberries","blueberries")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/drink/berryjuice = list(10,10))
	kitchen_tag = "berries"

/datum/seed/berry/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FA1616")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/berryseed
	seed_type = "berries"

/datum/seed/berry/blue
	name = "blueberries"
	seed_name = "blueberry"
	display_name = "blueberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/drink/blueberryjuice = list(10,10))

/datum/seed/berry/blue/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#1C225C")
	set_trait(TRAIT_WATER_CONSUMPTION, 5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.2)

/obj/item/seeds/blueberryseed
	seed_type = "blueberries"

/datum/seed/berry/glow
	name = "glowberries"
	seed_name = "glowberry"
	display_name = "glowberry bush"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/uranium = list(3,5), /decl/reagent/drink/glowberryjuice = list(10,10))

/datum/seed/berry/glow/setup_traits()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#c9fa16")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/obj/item/seeds/glowberryseed
	seed_type = "glowberries"

/datum/seed/berry/poison
	name = "poisonberries"
	seed_name = "poison berry"
	display_name = "poison berry bush"
	mutants = list("deathberries")
	chems = list(/decl/reagent/nutriment = list(1), /decl/reagent/toxin = list(3,5), /decl/reagent/toxin/poisonberryjuice = list(10,5))

/datum/seed/berry/poison/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#6DC961")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"

/datum/seed/berry/poison/death
	name = "deathberries"
	seed_name = "death berry"
	display_name = "death berry bush"
	mutants = null
	chems = list(/decl/reagent/nutriment = list(1), /decl/reagent/toxin = list(3,3), /decl/reagent/lexorin = list(1,5), /decl/reagent/toxin/deathberryjuice = list(10,10))

/datum/seed/berry/poison/death/setup_traits()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,50)
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5454")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

/obj/item/seeds/deathberryseed
	seed_type = "deathberries"

/datum/seed/berry/raspberry
	name = "raspberries"
	seed_name = "raspberry"
	display_name = "raspberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/drink/raspberryjuice = list(10,10))

/datum/seed/berry/raspberry/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#ff0000")

/obj/item/seeds/raspberryseed
	seed_type = "raspberries"

/datum/seed/berry/raspberry/blue
	name = "blue raspberries"
	seed_name = "blue raspberry"
	display_name = "blue raspberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/drink/blueraspberryjuice = list(10,10))

/datum/seed/berry/raspberry/blue/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#030145")

/obj/item/seeds/blueraspberryseed
	seed_type = "blue raspberries"

/datum/seed/berry/raspberry/black
	name = "blackberries"
	seed_name = "blackberry"
	display_name = "blackberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/drink/blackraspberryjuice = list(10,10))

/datum/seed/berry/raspberry/black/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#1a063f")

/obj/item/seeds/blackraspberryseed
	seed_type = "blackberries"

/datum/seed/berry/strawberry
	name = "strawberries"
	seed_name = "strawberry"
	display_name = "strawberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/drink/strawberryjuice = list(10,10))

/datum/seed/berry/strawberry/setup_traits()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#bb0202")

/obj/item/seeds/strawberryseed
	seed_type = "strawberries"
//////////////
//  Apples  //
//////////////
/datum/seed/apple
	name = "apple"
	seed_name = "apple"
	display_name = "apple tree"
	mutants = list("poisonapple","goldapple")
	chems = list(/decl/reagent/drink/applejuice = list(1,10), /decl/reagent/nutriment = list(1,10))
	kitchen_tag = "apple"

/datum/seed/apple/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"apple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF540A")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_FLESH_COLOUR,"#E8E39B")
	set_trait(TRAIT_IDEAL_LIGHT, 4)

/obj/item/seeds/appleseed
	seed_type = "apple"

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	chems = list(/decl/reagent/toxin/cyanide = list(1,5))

/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"

/datum/seed/apple/gold
	name = "goldapple"
	seed_name = "golden apple"
	display_name = "gold apple tree"
	mutants = null
	chems = list(/decl/reagent/drink/applejuice = list(1,10), /decl/reagent/gold = list(1,5))
	kitchen_tag = "goldapple"

/datum/seed/apple/gold/setup_traits()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDD00")
	set_trait(TRAIT_PLANT_COLOUR,"#D6B44D")

/obj/item/seeds/goldappleseed
	seed_type = "goldapple"
////////////////////
//  Misc. fruits  //
////////////////////

/datum/seed/cocoa
	name = "cacao"
	seed_name = "cacao"
	display_name = "cacao tree"
	chems = list(/decl/reagent/nutriment = list(1,10), /decl/reagent/nutriment/coco = list(4,5))

/obj/item/seeds/cocoapodseed
	seed_type = "cacao"

/datum/seed/cocoa/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#CCA935")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/banana
	name = "banana"
	seed_name = "banana"
	display_name = "banana tree"
	chems = list(/decl/reagent/drink/banana = list(10,10))
	trash_type = /obj/item/bananapeel
	kitchen_tag = "banana"

/datum/seed/banana/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"bananas")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFEC1F")
	set_trait(TRAIT_PLANT_COLOUR,"#69AD50")
	set_trait(TRAIT_PLANT_ICON,"tree4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/bananaseed
	seed_type = "banana"

/datum/seed/cherries
	name = "cherry"
	seed_name = "cherry"
	seed_noun = SEED_NOUN_PITS
	display_name = "cherry tree"
	chems = list(/decl/reagent/nutriment = list(1,15), /decl/reagent/sugar = list(1,15), /decl/reagent/nutriment/cherryjelly = list(10,15))
	kitchen_tag = "cherries"

/datum/seed/cherries/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cherry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#A80000")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_PLANT_COLOUR,"#2F7D2D")

/obj/item/seeds/cherryseed
	seed_type = "cherry"

/datum/seed/watermelon
	name = "watermelon"
	seed_name = "watermelon"
	display_name = "watermelon vine"
	chems = list(/decl/reagent/nutriment = list(1,6), /decl/reagent/drink/watermelonjuice = list(10,6))

/datum/seed/watermelon/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#326B30")
	set_trait(TRAIT_PLANT_COLOUR,"#257522")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_FLESH_COLOUR,"#F22C2C")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/watermelonseed
	seed_type = "watermelon"

/datum/seed/pumpkin
	name = "pumpkin"
	seed_name = "pumpkin"
	display_name = "pumpkin vine"
	chems = list(/decl/reagent/nutriment/pumpkinpulp = list(5,6))
	kitchen_tag = "pumpkin"

/datum/seed/pumpkin/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"vine2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F9AB28")
	set_trait(TRAIT_PLANT_COLOUR,"#BAE8C1")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"


//coffee beans are considered a fruit and seed, commonly considered a "cherry" of the plant
/datum/seed/coffee
	name = "coffee"
	seed_name = "coffee beans"
	display_name = "coffee bush"
	chems = list(/decl/reagent/nutriment/coffeegrounds = list(2,10))
	kitchen_tag = "coffee"

/datum/seed/coffee/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"bean2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#be9109")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/coffeeseed
	seed_type = "coffee"

/datum/seed/richcoffee
	name = "rich coffee"
	seed_name = "rich coffee beans"
	display_name = "rich coffee bush"
	chems = list(/decl/reagent/nutriment/darkcoffeegrounds = list(2,10))
	kitchen_tag = "richcoffee"

/datum/seed/richcoffee/setup_traits()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,2)
	set_trait(TRAIT_PRODUCT_ICON,"bean2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#be9109")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/obj/item/seeds/richcoffeeseed
	seed_type = "richcoffee"