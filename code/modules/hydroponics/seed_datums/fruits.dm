/////////////////////
//  Citrus fruits  //
/////////////////////
/datum/seed/citrus
	name = "lime"
	seed_name = "lime"
	display_name = "lime trees"
	chems = list(/singleton/reagent/nutriment = list(1,20), /singleton/reagent/drink/limejuice = list(10,20))
	kitchen_tag = "lime"

/datum/seed/citrus/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 15)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "treefruit")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#3AF026")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#3AF026")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/limeseed
	seed_type = "lime"

/datum/seed/citrus/lemon
	name = "lemon"
	seed_name = "lemon"
	display_name = "lemon trees"
	chems = list(/singleton/reagent/nutriment = list(1,20), /singleton/reagent/drink/lemonjuice = list(10,20))
	kitchen_tag = "lemon"

/datum/seed/citrus/lemon/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCES_POWER, 1)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#F0E226")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#F0E226")

/obj/item/seeds/lemonseed
	seed_type = "lemon"

/datum/seed/citrus/orange
	name = "orange"
	seed_name = "orange"
	display_name = "orange trees"
	kitchen_tag = "orange"
	chems = list(/singleton/reagent/nutriment = list(1,20), /singleton/reagent/drink/orangejuice = list(10,20))

/datum/seed/citrus/orange/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FFC20A")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#FFC20A")

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
	kitchen_tag = "grapes"
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/sugar = list(1,5), /singleton/reagent/drink/grapejuice = list(10,10), /singleton/reagent/nutriment/grapejelly = list(1,8))

/datum/seed/grapes/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "grapes")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#BB6AC4")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#378F2E")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/grapeseed
	seed_type = "grapes"

/datum/seed/grapes/green
	name = "greengrapes"
	seed_name = "green grape"
	display_name = "green grapevines"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/kelotane = list(3,5), /singleton/reagent/drink/whitegrapejuice = list(10,10))

/datum/seed/grapes/green/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#42ED2F")

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
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/berryjuice = list(10,10))
	kitchen_tag = "berries"

/datum/seed/berry/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "berry")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FA1616")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/obj/item/seeds/berryseed
	seed_type = "berries"

/datum/seed/berry/blue
	name = "blueberries"
	seed_name = "blueberry"
	display_name = "blueberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/blueberryjuice = list(10,10))
	kitchen_tag = "blueberries"

/datum/seed/berry/blue/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#1C225C")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 5)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.2)

/obj/item/seeds/blueberryseed
	seed_type = "blueberries"

/datum/seed/berry/glow
	name = "glowberries"
	seed_name = "glowberry"
	display_name = "glowberry bush"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/uranium = list(3,5), /singleton/reagent/drink/glowberryjuice = list(10,10))

/datum/seed/berry/glow/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_SPREAD, 1)
	SET_SEED_TRAIT(src, TRAIT_BIOLUM, 1)
	SET_SEED_TRAIT(src, TRAIT_BIOLUM_COLOUR, "#006622")
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#c9fa16")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 3)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/obj/item/seeds/glowberryseed
	seed_type = "glowberries"

/datum/seed/berry/poison
	name = "poisonberries"
	seed_name = "poison berry"
	display_name = "poison berry bush"
	mutants = list("deathberries")
	chems = list(/singleton/reagent/nutriment = list(1), /singleton/reagent/toxin = list(3,5), /singleton/reagent/toxin/poisonberryjuice = list(10,5))

/datum/seed/berry/poison/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#6DC961")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 3)
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"

/datum/seed/berry/poison/death
	name = "deathberries"
	seed_name = "death berry"
	display_name = "death berry bush"
	mutants = null
	chems = list(/singleton/reagent/nutriment = list(1), /singleton/reagent/toxin = list(3,3), /singleton/reagent/lexorin = list(1,5), /singleton/reagent/toxin/deathberryjuice = list(10,10))

/datum/seed/berry/poison/death/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 50)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#7A5454")
	SET_SEED_TRAIT(src, TRAIT_NUTRIENT_CONSUMPTION, 0.35)

/obj/item/seeds/deathberryseed
	seed_type = "deathberries"

/datum/seed/berry/raspberry
	name = "raspberries"
	seed_name = "raspberry"
	display_name = "raspberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/raspberryjuice = list(10,10))

/datum/seed/berry/raspberry/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#ff0000")

/obj/item/seeds/raspberryseed
	seed_type = "raspberries"

/datum/seed/berry/raspberry/blue
	name = "blue raspberries"
	seed_name = "blue raspberry"
	display_name = "blue raspberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/blueraspberryjuice = list(10,10))
	kitchen_tag = "blue raspberry"

/datum/seed/berry/raspberry/blue/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#030145")

/obj/item/seeds/blueraspberryseed
	seed_type = "blue raspberries"

/datum/seed/berry/raspberry/black
	name = "blackberries"
	seed_name = "blackberry"
	display_name = "blackberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/blackraspberryjuice = list(10,10))

/datum/seed/berry/raspberry/black/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#1a063f")

/obj/item/seeds/blackraspberryseed
	seed_type = "blackberries"

/datum/seed/berry/strawberry
	name = "strawberries"
	seed_name = "strawberry"
	display_name = "strawberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/strawberryjuice = list(10,10))
	kitchen_tag = "strawberries"

/datum/seed/berry/strawberry/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#bb0202")

/obj/item/seeds/strawberryseed
	seed_type = "strawberries"

/datum/seed/berry/cranberry
	name = "cranberries"
	seed_name = "cranberry"
	display_name = "cranberry bush"
	mutants = list("berries","poisonberries","glowberries")
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/drink/cranberryjuice = list(10,10))
	kitchen_tag = "cranberries"

/datum/seed/berry/cranberry/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#bb0202")

/obj/item/seeds/cranberryseed
	seed_type = "cranberries"

//////////////
//  Apples  //
//////////////
/datum/seed/apple
	name = "apple"
	seed_name = "apple"
	display_name = "apple tree"
	mutants = list("poisonapple","goldapple")
	chems = list(/singleton/reagent/drink/applejuice = list(1,10), /singleton/reagent/nutriment = list(1,10))
	kitchen_tag = "apple"

/datum/seed/apple/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 5)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "apple")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FF540A")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree2")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#E8E39B")

/obj/item/seeds/appleseed
	seed_type = "apple"

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	chems = list(/singleton/reagent/toxin/cyanide = list(1,5))

/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"

/datum/seed/apple/gold
	name = "goldapple"
	seed_name = "golden apple"
	display_name = "gold apple tree"
	mutants = null
	chems = list(/singleton/reagent/drink/applejuice = list(1,10), /singleton/reagent/gold = list(1,5))
	kitchen_tag = "goldapple"

/datum/seed/apple/gold/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 10)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FFDD00")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#D6B44D")

/obj/item/seeds/goldappleseed
	seed_type = "goldapple"
////////////////////
//  Misc. fruits  //
////////////////////

/datum/seed/cocoa
	name = "cacao"
	seed_name = "cacao"
	display_name = "cacao tree"
	chems = list(/singleton/reagent/nutriment = list(1,10), /singleton/reagent/nutriment/coco = list(4,5))

/obj/item/seeds/cocoapodseed
	seed_type = "cacao"

/datum/seed/cocoa/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 2)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "treefruit")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#CCA935")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/datum/seed/banana
	name = "banana"
	seed_name = "banana"
	display_name = "banana tree"
	chems = list(/singleton/reagent/drink/banana = list(10,10))
	trash_type = /obj/item/bananapeel
	kitchen_tag = "banana"

/datum/seed/banana/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bananas")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#FFEC1F")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#69AD50")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree4")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/bananaseed
	seed_type = "banana"

/datum/seed/cherries
	name = "cherry"
	seed_name = "cherry"
	seed_noun = SEED_NOUN_PITS
	display_name = "cherry tree"
	chems = list(/singleton/reagent/nutriment = list(1,15), /singleton/reagent/sugar = list(1,15), /singleton/reagent/nutriment/cherryjelly = list(10,15))
	kitchen_tag = "cherries"

/datum/seed/cherries/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 5)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 5)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "cherry")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#A80000")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "tree2")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#2F7D2D")

/obj/item/seeds/cherryseed
	seed_type = "cherry"

/datum/seed/watermelon
	name = "watermelon"
	seed_name = "watermelon"
	display_name = "watermelon vine"
	kitchen_tag = "watermelon"
	chems = list(/singleton/reagent/nutriment = list(1,6), /singleton/reagent/drink/watermelonjuice = list(10,6))

/datum/seed/watermelon/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_JUICY, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 1)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "vine")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#5eca5a")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#49be45")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_FLESH_COLOUR, "#ff5858")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/watermelonseed
	seed_type = "watermelon"

/datum/seed/pumpkin
	name = "pumpkin"
	seed_name = "pumpkin"
	display_name = "pumpkin vine"
	chems = list(/singleton/reagent/nutriment/pumpkinpulp = list(5,6))
	kitchen_tag = "pumpkin"

/datum/seed/pumpkin/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 6)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 6)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 3)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 10)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#F9AB28")
	SET_SEED_TRAIT(src, TRAIT_PLANT_COLOUR, "#BAE8C1")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "vine2")
	SET_SEED_TRAIT(src, TRAIT_WATER_CONSUMPTION, 6)

/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"


//coffee beans are considered a fruit and seed, commonly considered a "cherry" of the plant
/datum/seed/coffee
	name = "coffee"
	seed_name = "coffee beans"
	display_name = "coffee bush"
	chems = list(/singleton/reagent/nutriment/coffeegrounds = list(2,10))
	kitchen_tag = "coffee"

/datum/seed/coffee/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 3)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bean2")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#be9109")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/coffeeseed
	seed_type = "coffee"

/datum/seed/richcoffee
	name = "rich coffee"
	seed_name = "rich coffee beans"
	display_name = "rich coffee bush"
	chems = list(/singleton/reagent/nutriment/darkcoffeegrounds = list(2,10))
	kitchen_tag = "richcoffee"

/datum/seed/richcoffee/setup_traits()
	..()
	SET_SEED_TRAIT(src, TRAIT_HARVEST_REPEAT, 1)
	SET_SEED_TRAIT(src, TRAIT_MATURATION, 3)
	SET_SEED_TRAIT(src, TRAIT_PRODUCTION, 3)
	SET_SEED_TRAIT(src, TRAIT_YIELD, 4)
	SET_SEED_TRAIT(src, TRAIT_POTENCY, 2)
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_ICON, "bean2")
	SET_SEED_TRAIT(src, TRAIT_PRODUCT_COLOUR, "#be9109")
	SET_SEED_TRAIT(src, TRAIT_PLANT_ICON, "bush2")
	SET_SEED_TRAIT(src, TRAIT_IDEAL_LIGHT, IDEAL_LIGHT_HIGH)
	SET_SEED_TRAIT(src, TRAIT_IDEAL_HEAT, IDEAL_HEAT_TROPICAL)

/obj/item/seeds/richcoffeeseed
	seed_type = "richcoffee"
