// Key:
// Juices
// Dry Coffee/Tea
// Milkshakes
// Tea
// Coffee
// Coco
// Carbonated Drinks
// Diet Soda
// Lemonade
// Cider
// Non-Alcoholic/Other
// Alcohol
// Cocktails
// To Be Removed
//
/singleton/reagent/drink
	name = "Drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	metabolism = REM * 10
	color = "#E78108"
	var/nutrition = 0 // Per unit
	var/hydration = 8 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0 //do NOT use for temp changes based on the temperature of the drinks, only for things such as spices.

	///Strength of stimulant effect, since so many drinks use it - how fast it makes you move
	var/caffeine = 0

	unaffected_species = IS_MACHINE
	var/blood_to_ingest_scale = 2
	fallback_specific_heat = 1.75
	value = 0.1

/singleton/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	digest(M,alien,removed * blood_to_ingest_scale, FALSE, holder)

/singleton/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	digest(M, alien, removed, holder = holder)

/singleton/reagent/drink/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()

	if(caffeine && (alien != IS_DIONA))
		M.add_movespeed_modifier(/datum/movespeed_modifier/reagent/caffeine)
		M.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/reagent/caffeine, TRUE, (caffeine * -1))

/singleton/reagent/drink/proc/digest(var/mob/living/carbon/M, var/alien, var/removed, var/add_nutrition = TRUE, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness + adj_dizzy)
		M.drowsiness = max(0, M.drowsiness + adj_drowsy)
		M.sleeping = max(0, M.sleeping + adj_sleepy)

	if(add_nutrition == TRUE)
		M.adjustHydrationLoss(-hydration * removed)
		M.adjustNutritionLoss(-nutrition * removed)

	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

/singleton/reagent/drink/final_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(caffeine && (alien != IS_DIONA))
		M.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/caffeine)

	. = ..()

// Juices
/singleton/reagent/drink/banana
	name = "Banana Juice"
	description = "The raw essence of a banana."
	color = "#C3AF00"
	taste_description = "banana"
	glass_icon_state = "banana"
	glass_name = "glass of banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/singleton/reagent/drink/berryjuice
	name = "Berry Juice"
	description = "A delicious blend of several different kinds of berries."
	color = "#990066"
	taste_description = "berries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/glowberryjuice
	name = "Glow Berry Juice"
	description = "A delicious blend of several glow berries."
	color = "#c9fa16"
	taste_description = "glow berries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of glow berry juice"
	glass_desc = "Glowberry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/strawberryjuice
	name = "Strawberry Juice"
	description = "A delicious blend of several strawberries."
	color = "#bb0202"
	taste_description = "strawberries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of strawberry juice"
	glass_desc = "Strawberry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/blueberryjuice
	name = "Blueberry Juice"
	description = "A delicious blend of several blueberries."
	color = "#1C225C"
	taste_description = "blueberries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of blueberry juice"
	glass_desc = "Blueberry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/raspberryjuice
	name = "Raspberry Juice"
	description = "A delicious blend of several raspberries."
	color = "#ff0000"
	taste_description = "raspberries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of raspberry juice"
	glass_desc = "Raspberry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/blueraspberryjuice
	name = "Blue Raspberry Juice"
	description = "A delicious blend of several dark raspberries."
	color = "#030145"
	taste_description = "blue raspberries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of blue raspberry juice"
	glass_desc = "Blue Raspberry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/blackraspberryjuice
	name = "Black Raspberry Juice"
	description = "A delicious blend of several black raspberries."
	color = "#1a063f"
	taste_description = "black raspberries"
	glass_icon_state = "berryjuice"
	glass_name = "glass of black raspberry juice"
	glass_desc = "Black Raspberry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353"
	strength = 5
	taste_description = "berries"
	glass_icon_state = "poisonberryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?."

/singleton/reagent/toxin/deathberryjuice
	name = "Death Berry Juice"
	description = "A delicious blend of several toxic death berries."
	color = "#7A5454"
	strength = 10
	taste_description = "death and decay"
	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice?"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/singleton/reagent/drink/carrotjuice
	name = "Carrot Juice"
	description = "It is just like a carrot but without crunching."
	color = "#FF8C00" // rgb: 255, 140, 0
	taste_description = "carrots"
	glass_icon_state = "carrotjuice"
	glass_name = "glass of carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/singleton/reagent/drink/carrotjuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	holder.add_reagent(/singleton/reagent/oculine, removed * 0.2)

/singleton/reagent/drink/grapejuice
	name = "Grape Juice"
	description = "It's grrrrrape!"
	color = "#660099"
	taste_description = "grapes"
	glass_icon_state = "grapejuice"
	glass_name = "glass of grape juice"
	glass_desc = "It's grrrrrape!"

/singleton/reagent/drink/whitegrapejuice
	name = "White Grape Juice"
	description = "It's tart grape!"
	color = "#863333"
	taste_description = "tarty grapes"
	glass_icon_state = "glass_clear"
	glass_name = "glass of white grape juice"
	glass_desc = "It's tart grape!"

/singleton/reagent/drink/lemonjuice
	name = "Lemon Juice"
	description = "This juice is VERY sour."
	color = "#FFFF40"
	taste_description = "sourness"

	glass_icon_state = "lemonjuice"
	glass_name = "glass of lemon juice"
	glass_desc = "Sour..."

	condiment_name = "lemon juice"
	condiment_desc = "This juice is VERY sour."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "lemonjuice"

/singleton/reagent/drink/limejuice
	name = "Lime Juice"
	description = "The sweet-sour juice of limes."
	color = "#6dbd61"
	taste_description = "tart citrus"
	taste_mult = 1.1

	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

	condiment_name = "lime juice"
	condiment_desc = "Sweet-sour goodness."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "limejuice"

/singleton/reagent/drink/orangejuice
	name = "Orange Juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108"
	taste_description = "oranges"

	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

	condiment_name = "orange juice"
	condiment_desc = "Full of vitamins and deliciousness!"
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "orangejuice"

/singleton/reagent/drink/orangejuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/singleton/reagent/drink/cranberryjuice
	name = "Cranberry Juice"
	description = "Rich cranberry juice. Bright and tart."
	color = "#a0274b"
	taste_description = "tart cranberries"

	glass_icon_state = "berryjuice"
	glass_name = "glass of cranberry juice"
	glass_desc = "Fresh, tart, and sweet cranberry juice."

	condiment_name = "cranberry juice"
	condiment_desc = "Tart and sweet. A unique flavor for a unique berry."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "cranberryjuice"

/singleton/reagent/drink/potatojuice
	name = "Potato Juice"
	description = "Juice of the potato. Bleh."
	nutrition = 2
	color = "#a07727"
	taste_description = "potato"

	glass_icon_state = "glass_brown"
	glass_name = "glass of potato juice"
	glass_desc = "Juice from a potato. Bleh."

/singleton/reagent/drink/tomatojuice
	name = "Tomato Juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008"
	taste_description = "tomatoes"

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

	condiment_name = "tomato juice"
	condiment_desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "tomatojuice"

/singleton/reagent/drink/tomatojuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 0.1 * removed)

/singleton/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	description = "Delicious juice made from watermelon."
	color = "#d12323"
	taste_description = "watermelon"

	glass_icon_state = "glass_red"
	glass_name = "glass of watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

/singleton/reagent/drink/pineapplejuice
	name = "Pineapple Juice"
	description = "From freshly canned pineapples."
	color = "#FFFF00"
	taste_description = "pineapple"

	glass_icon_state = "lemonjuice"
	glass_name = "glass of pineapple juice"
	glass_desc = "What the hell is this?"

/singleton/reagent/drink/garlicjuice
	name = "Garlic Juice"
	description = "Who would even drink this?"
	taste_description = "garlic"
	nutrition = 1
	color = "#eeddcc"

	glass_name = "glass of garlic juice"
	glass_desc = "Who would even drink juice from garlic?"

	germ_adjust = 7.5 // has allicin, an antibiotic

/singleton/reagent/drink/garlicjuice/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	if(.)
		M.add_chemical_effect(CE_ANTIPARASITE, 10)

/singleton/reagent/drink/onionjuice
	name = "Onion Juice"
	description = "Juice from an onion, for when you need to cry."
	taste_description = "onion"
	nutrition = 1
	color = "#ffeedd"

	glass_name = "glass of onion juice"
	glass_desc = "Juice from an onion, for when you need to cry."

/singleton/reagent/drink/applejuice
	name = "Apple Juice"
	description = "Juice from an apple. The most basic beverage you can imagine."
	taste_description = "sweet apples"
	color = "#f2d779"

	glass_icon_state = "glass_apple"
	glass_name = "glass of apple juice"
	glass_desc = "Juice from an apple. The most basic beverage you can imagine."

	condiment_name = "apple juice"
	condiment_desc = "Juice from an apple. Yes."
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "applejuice"

/singleton/reagent/drink/pearjuice
	name = "Pear Juice"
	description = "Delicious sweet juice made from pears."
	taste_description = "sweet pears"
	color = "#ffff66"

	glass_name = "pear juice"
	glass_desc = "Delicious juice made from pears."

//
//Dry Coffee/Tea
//
/singleton/reagent/nutriment/coffeegrounds
	name = "Coffee Grounds"
	description = "Enjoy the great taste of coffee."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#5c4a11"
	taste_description = "earthy gritty coffee"
	taste_mult = 0.4
	condiment_name = "ground coffee"
	condiment_icon_state = "coffee"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/coffeegrounds/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsiness = max(0, M.drowsiness - 3)
		M.sleeping = max(0, M.sleeping - 2)
		M.intoxication = max(0, (M.intoxication - (removed*0.25)))
		//copied from coffee

/singleton/reagent/nutriment/coffeegrounds/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.make_jittery(5)
		//copied from coffee

/singleton/reagent/nutriment/darkcoffeegrounds
	name = "Rich Coffee Grounds"
	description = "Enjoy the great taste of espresso."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#5c4a11"
	taste_description = "earthy gritty coffee"
	taste_mult = 0.4
	condiment_name = "rich ground coffee"
	condiment_icon_state = "coffee"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/darkcoffeegrounds/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsiness = max(0, M.drowsiness - 3)
		M.sleeping = max(0, M.sleeping - 2)
		M.intoxication = max(0, (M.intoxication - (removed*0.25)))
		//copied from coffee

/singleton/reagent/nutriment/darkcoffeegrounds/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.make_jittery(5)
		//copied from coffee

/singleton/reagent/nutriment/teagrounds
	name = "Tea Grounds"
	description = "Enjoy the great taste of tea."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#4fd24d"
	taste_description = "potent gritty tea"
	taste_mult = 0.4
	condiment_name = "ground tea"
	condiment_icon_state = "tea"
	condiment_center_of_mass = list("x"=16, "y"=8)
	var/last_taste_time = -100

/singleton/reagent/nutriment/teagrounds/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		if(last_taste_time + 800 < world.time) // Not to spam message
			to_chat(M, SPAN_DANGER("Your body withers as you feel slight pain throughout."))
			last_taste_time = world.time
		metabolism = REM * 0.33
		M.adjustToxLoss(1.5 * removed)
		//Copied from tea. though i feel it should be stronger as its not diluted with water

/singleton/reagent/nutriment/teagrounds/sencha
	name = "Sencha Leaves"
	description = "A type of green tea originating from Japan on Earth, sencha is unique in that it is steamed instead of pan-roasted like most teas. \
			It has a fresh flavor profile as a result, with flavors like seaweed, grass, or spinach greens predominant. On Konyang, it is most popular in Aoyama."
	color = "#0E1F0E"
	taste_description = "bitter seaweed and even more bitter grass"
	condiment_name = "ground sencha"

/singleton/reagent/nutriment/teagrounds/tieguanyin
	name = "Tieguanyin Leaves"
	description = "A type of oolong tea originating from China on Earth. Like most oolongs, its flavor is somewhere between green and black tea. \
				It has a nutty, peppery, and floral flavor profile. On Konyang, it is most popular in Ganzaodeng and New Hong Kong."
	color = "#5C6447"
	taste_description = "rough floral peppercorns"
	condiment_name = "ground tieguanyin"

/singleton/reagent/nutriment/teagrounds/jaekseol
	name = "jaekseol Leaves"
	description = "A type of black tea originating from Korea on Earth. It has a relatively typical flavor for a black tea, with a sweet, toasty flavor. \
				On Konyang, it is most popular in Suwon, although coffee is still a more popular beverage in general."
	color = "#534337"
	taste_description = "harsh burnt toast"
	condiment_name = "ground jaekseol"

/singleton/reagent/nutriment/cocagrounds
	name = "Coca Grounds"
	description = "Enjoy the great taste of tea."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#056608"
	taste_description = "potent gritty tea"
	taste_mult = 0.4
	condiment_name = "ground tea"
	condiment_icon_state = "tea"
	condiment_center_of_mass = list("x"=16, "y"=8)

//
// Milkshakes
//
/singleton/reagent/drink/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	color = "#DADADA"
	taste_description = "creamy vanilla"

	value = 0.12

	glass_icon_state = "milkshake"
	glass_name = "glass of milkshake"
	glass_desc = "Glorious brainfreezing mixture."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/meatshake
	name = "Meatshake"
	color = "#bc1e00"
	description = "Blended meat and cream for those who want crippling heart failure down the road."
	taste_description = "liquified meat"

	glass_icon_state = "meatshake"
	glass_name = "Meatshake"
	glass_desc = "Blended meat and cream for those who want crippling health issues down the road. Has two straws for sharing! Perfect for dates!"

/singleton/reagent/drink/ntella_milkshake
	name = "NTella Milkshake"
	description = "An intensely sweet chocolatey concoction with whipped cream on top."
	color = "#6d4124"
	taste_description = "overwhelmingly sweet chocolate"

	value = 0.14

	glass_icon_state = "NTellamilkshake"
	glass_name = "glass of NTella milkshake"
	glass_desc = "Oh look, it's that thing you actually want to get but probably shouldn't."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_strawberry
	name = "Strawberry Milkshake"
	description = "Milkshake with a healthy heaping of strawberry syrup mixed in."
	color = "#ff7575"
	taste_description = "sugary strawberry"

	value = 0.13

	glass_icon_state = "shake_strawberry"
	glass_name = "glass of strawberry milkshake"
	glass_desc = "A sweet, chilly milkshake with neon red syrup. So sweet you could pop!"
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_caramel
	name = "Caramel Milkshake"
	description = "Milkshake with a healthy heaping of caramel syrup mixed in."
	color = "#d19d4e"
	taste_description = "smooth caramel"

	value = 0.13

	glass_icon_state = "shake_caramel"
	glass_name = "glass of caramel milkshake"
	glass_desc = "In case there wasn't enough sugar in your sugar."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_blueberry
	name = "Blueberry Milkshake"
	description = "Milkshake with some neon blue blueberry syrup mixed in."
	color = "#0c00b3"
	taste_description = "creamy blueberries"

	value = 0.13

	glass_icon_state = "shake_blueberry"
	glass_name = "glass of blueberry milkshake"
	glass_desc = "This is an alarming level of neon blue for something that's supposed to be ingested. Probably still delicious though!"
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_chocolate
	name = "Chocolate Milkshake"
	description = "Vanilla milkshake with a heaping of chocolate syrup mixed in."
	color = "#79452c"
	taste_description = "chocolatey vanilla"

	value = 0.13

	glass_icon_state = "shake_chocolate"
	glass_name = "glass of chocolate milkshake"
	glass_desc = "A vanilla milkshake with a hefty heap of delicious chocolate syrup mixed in. Eh, that diet can wait until tomorrow, right?"
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_blue_raspberry
	name = "Blue Raspberry Milkshake"
	description = "A milkshake with a heaping of blue raspberry syrup mixed in."
	color = "#3955a3"
	taste_description = "creamy raspberry"

	value = 0.13

	glass_icon_state = "shake_blue_raspberry"
	glass_name = "glass of blue raspberry milkshake"
	glass_desc = "Formerly this used to be created with artificial food dyes. Now it's made with real blue raspberries! Make no mistake, though, this is still absolutely and deliciously bad for you."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_raspberry
	name = "Raspberry Milkshake"
	description = "A milkshake with a heaping of raspberry syrup mixed in."
	color = "#a03257"
	taste_description = "creamy raspberry"

	value = 0.13

	glass_icon_state = "shake_purplered"
	glass_name = "glass of raspberry milkshake"
	glass_desc = "Oh Raspberries, is there any dessert you can't improve?"
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_berry
	name = "Berry Milkshake"
	description = "A milkshake with a heaping of berry syrup mixed in."
	color = "#f1315b"
	taste_description = "smooth berries"

	value = 0.13

	glass_icon_state = "shake_berry"
	glass_name = "glass of berry milkshake"
	glass_desc = "Why settle for just one Milkshake flavor when you can have the wide, delicious vagueness of 'berries'?"
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/drink/shake_choco_mint
	name = "Choco-Mint Milkshake"
	description = "A milkshake with a heaping of mint syrup mixed in and some little chocolate chips as well!"
	color = "#6ecf73"
	taste_description = "chocolatey mint"

	value = 0.13

	glass_icon_state = "shake_choco_mint"
	glass_name = "glass of choco-mint milkshake"
	glass_desc = "For everyone who liked to eat their toothpaste as a kid and never grew out of it."
	glass_center_of_mass = list("x"=16, "y"=7)

//
// Tea
//
/singleton/reagent/drink/tea
	name = "Tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	taste_description = "tart black tea"

	glass_icon_state = "bigteacup"
	glass_name = "cup of tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

	var/last_taste_time = -100

/singleton/reagent/drink/tea/sencha
	name = "Sencha"
	description = "A type of green tea originating from Japan on Earth, sencha is unique in that it is steamed instead of pan-roasted like most teas. \
					It has a fresh flavor profile as a result, with flavors like seaweed, grass, or spinach greens predominant. \
					On Konyang, it is most popular in Aoyama."
	taste_description = "seaweed and bitter grass"
	glass_name = "cup of sencha"
	glass_desc = "A type of green tea originating from Japan on Earth, sencha is unique in that it is steamed instead of pan-roasted like most teas. \
					It has a fresh flavor profile as a result, with flavors like seaweed, grass, or spinach greens predominant. \
					On Konyang, it is most popular in Aoyama."
	color = "#0E1F0E"

/singleton/reagent/drink/tea/tieguanyin
	name = "Tieguanyin"
	description = "A type of oolong tea originating from China on Earth. Like most oolongs, its flavor is somewhere between green and black tea. \
					It has a nutty, peppery, and floral flavor profile. \
					On Konyang, it is most popular in Ganzaodeng and New Hong Kong."
	taste_description = "floral peppercorns"
	glass_name = "cup of tieguanyin"
	glass_desc = "A type of oolong tea originating from China on Earth. Like most oolongs, its flavor is somewhere between green and black tea. \
					It has a nutty, peppery, and floral flavor profile. \
					On Konyang, it is most popular in Ganzaodeng and New Hong Kong."
	color = "#5C6447"

/singleton/reagent/drink/tea/jaekseol
	name = "jaekseol"
	description = "A type of black tea originating from Korea on Earth. It has a relatively typical flavor for a black tea, with a sweet, toasty flavor. \
					On Konyang, it is most popular in Suwon, although coffee is still a more popular beverage in general."
	taste_description = "sweet burnt toast"
	glass_name = "cup of jaekseol"
	glass_desc = "A type of black tea originating from Korea on Earth. It has a relatively typical flavor for a black tea, with a sweet, toasty flavor. \
				On Konyang, it is most popular in Suwon, although coffee is still a more popular beverage in general."
	color = "#534337"

/singleton/reagent/drink/icetea
	name = "Iced Tea"
	description = "No relation to a certain rap artist/ actor."
	color = "#984707"
	taste_description = "sweet tea"

	glass_icon_state = "icedteaglass"
	glass_name = "glass of iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/drink/tea/chaitea
	name = "Chai Tea"
	description = "A tea spiced with cinnamon and cloves."
	color = "#DBAD81"
	taste_description = "creamy cinnamon and spice"

	glass_icon_state = "chaitea"
	glass_name = "cup of chai tea"
	glass_desc = "A tea spiced with cinnamon and cloves."

/singleton/reagent/drink/tea/coco_chaitea
	name = "Chocolate Chai"
	description = "A surprisingly pleasant mix of chocolate and spice."
	color = "#664300"
	taste_description = "creamy spiced cocoa"

	glass_icon_state = "coco_chaitea"
	glass_name = "cup of chocolate chai tea"
	glass_desc = "A surprisingly pleasant mix of chocolate and spice."

/singleton/reagent/drink/tea/neapolitan_chaitea
	name = "Neapolitan Chai"
	description = "A Xanan innovation; spiced tea with notes of vanilla, chocolate, and strawberry."
	color = "#DBAD81"
	taste_description = "neapolitan ice cream"

	glass_icon_state = "chaitea"
	glass_name = "cup of neapolitan chai tea"
	glass_desc = "A Xanan innovation; spiced tea with notes of vanilla, chocolate, and strawberry."

/singleton/reagent/drink/tea/chaitealatte
	name = "Chai Latte"
	description = "A frothy spiced tea."
	color = "#DBAD81"
	taste_description = "spiced milk foam"

	glass_icon_state = "chailatte"
	glass_name = "cup of chai latte"
	glass_desc = "For when you need the energy to yell at the barista for making your drink wrong."

/singleton/reagent/drink/tea/chaitealatte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) //milk effects
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/singleton/reagent/capsaicin, 10 * removed)


/singleton/reagent/drink/tea/coco_chailatte
	name = "Chocolate Chai Latte"
	description = "Sweet, liquid chocolate. Have a cup of this and maybe you'll calm down."
	color = "#664300"
	taste_description = "spiced milk chocolate"

	glass_icon_state = "coco_chailatte"
	glass_name = "cup of chocolate chai latte"
	glass_desc = "Sweet, liquid chocolate. Have a cup of this and maybe you'll calm down."

/singleton/reagent/drink/tea/coco_chailatte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) //milk effects
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/singleton/reagent/capsaicin, 10 * removed)

/singleton/reagent/drink/tea/cofftea
	name = "Cofftea"
	description = "The only neutral ground in the tea versus coffee debate."
	color = "#292303"
	adj_dizzy = -3
	adj_drowsy = -3
	adj_sleepy = -2
	caffeine = 0.1
	taste_description = "lightly tart coffee"

	glass_icon_state = "cofftea"
	glass_name = "cup of cofftea"
	glass_desc = "The only neutral ground in the tea versus coffee debate."

/singleton/reagent/drink/tea/bureacratea
	name = "Bureacratea"
	description = "An Eridani favorite for long nights of contract review."
	color = "#2B1902"
	adj_dizzy = -2
	adj_drowsy = -3
	adj_sleepy = -3
	caffeine = 0.3
	taste_description = "properly completed paperwork, filed well before the deadline, with all the necessary signatures"

	glass_icon_state = "bureacratea"
	glass_name = "cup of bureacratea"
	glass_desc = "An Eridani favorite for long nights of contract review."


/singleton/reagent/drink/tea/greentea
	name = "Green Tea"
	description = "Tasty green tea. It's good for you!"
	color = "#99a87b"
	taste_description = "light, refreshing tea"

	glass_icon_state = "bigteacup"
	glass_name = "cup of green tea"
	glass_desc = "Tasty green tea. It's good for you!"

/singleton/reagent/drink/tea/halfandhalf
	name = "Half and Half"
	description = "Tea and lemonade; not to be confused with the dairy creamer."
	color = "#997207"
	taste_description = "refreshing tea mixed with crisp lemonade"

	glass_icon_state = "halfandhalf"
	glass_name = "glass of half and half"
	glass_desc = "Tea and lemonade; not to be confused with the dairy creamer."

/singleton/reagent/drink/tea/heretic_tea
	name = "Heretics' Tea"
	description = "A non-alcoholic take on a bloody brew."
	color = "#820000"
	taste_description = "fizzy, heretically sweet iron"
	carbonated = TRUE

	glass_icon_state = "heretictea"
	glass_name = "glass of Heretics' Tea"
	glass_desc = "A non-alcoholic take on a bloody brew."

/singleton/reagent/drink/tea/librarian_special
	name = "Librarian Special"
	description = "Shhhhhh!"
	color = "#101000"
	taste_description = "peace and quiet"

	glass_icon_state = "bureacratea"
	glass_name = "cup of Librarian Special"
	glass_desc = "Shhhhhh!"

/singleton/reagent/drink/tea/librarian_special/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.silent += 3

/singleton/reagent/drink/tea/berry_tea
	name = "Mixed Berry Tea"
	description = "Hot tea with a sweet, fruity taste!"
	color = "#2E0206"
	taste_description = "tart, fruity tea"

	glass_icon_state = "berrytea"
	glass_name = "cup of mixed berry tea"
	glass_desc = "Hot tea with a sweet, fruity taste!"

/singleton/reagent/drink/tea/pomegranate_icetea
	name = "Pomegranate Iced Tea"
	description = "A refreshing, fruity tea. No fruit was harmed in the making of this drink."
	color = "#7C334C"
	taste_description = "sweet pomegranate"

	glass_icon_state = "pomegranatetea"
	glass_name = "glass of pomegranate iced tea"
	glass_desc = "A refreshing, fruity tea. No fruit was harmed in the making of this drink."

/singleton/reagent/drink/tea/potatea
	name = "Potatea"
	description = "Why would you ever drink this?"
	color = "#2B2710"
	nutrition = 0.2
	taste_description = "starchy regret"

	glass_icon_state = "bigteacup"
	glass_name = "cup of potatea"
	glass_desc = "Why would you ever drink this?"

/singleton/reagent/drink/tea/securitea
	name = "Securitea"
	description = "The safest drink around."
	color = "#030B36"
	taste_description = "freshly polished boots"

	glass_icon_state = "securitea"
	glass_name = "cup of securitea"
	glass_desc = "Help, maint!!"

/singleton/reagent/drink/tea/sleepytime_tea
	name = "Sleepytime Tea"
	description = "The perfect drink to enjoy before falling asleep in your favorite chair."
	color = "#101000"
	adj_drowsy = 1
	adj_sleepy = 1
	taste_description = "liquid relaxation"

	glass_icon_state = "sleepytea"
	glass_name = "cup of sleepytime tea"
	glass_desc = "The perfect drink to enjoy before falling asleep in your favorite chair."

/singleton/reagent/drink/tea/sweet_tea
	name = "Sweet Tea"
	description = "Hope you have a good dentist!"
	color = "#984707"
	taste_description = "sweet sugary comfort"

	glass_icon_state = "icedteaglass"
	glass_name = "glass of sweet tea"
	glass_desc = "Hope you have a good dentist!"

/singleton/reagent/drink/tea/tomatea
	name = "Tomatea"
	description = "Basically tomato soup in a mug."
	color = "#9F3400"
	taste_description = "sad tomato soup"

	glass_icon_state = "bigteacup"
	glass_name = "cup of tomatea"
	glass_desc = "Basically tomato soup in a mug."

/singleton/reagent/drink/tea/tomatea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 0.1 * removed) //has tomato juice

/singleton/reagent/drink/tea/tropical_icetea
	name = "Tropical Iced Tea"
	description = "For maximum enjoyment, drink while at the beach on a warm summer day."
	color = "#CC0066"
	taste_description = "sweet beachside fruit"

	glass_icon_state = "junglejuice"
	glass_name = "glass of tropical iced tea"
	glass_desc = "For maximum enjoyment, drink while at the beach on a warm summer day."

/singleton/reagent/drink/boba_tea
	name = "Boba Tea"
	description = "A tall glass of milky tea with tapioca pearls at the bottom."
	nutrition = 3
	color = "#caa55f"
	taste_description = "tapioca tea"
	glass_icon_state = "boba_tea"
	glass_name = "boba tea"
	glass_desc = "A basic drink for a basic you."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/drink/lemon_lime_boba
	name = "Lemon Lime Boba Tea"
	description = "A fruit boba drink, this one is lemon-lime flavored"
	nutrition = 3
	color = "#95db45"
	taste_description = "lemon lime tapioca tea"
	glass_icon_state = "boba_lemonlime"
	glass_name = "lemon lime boba tea"
	glass_desc = "Fruit boba with a sour citrusy sweetness."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/drink/boba_strawberry
	name = "Strawberry Boba Tea"
	description = "A tall glass of milky strawberry tea with tapioca pearls at the bottom."
	nutrition = 3
	color = "#da76b8"
	taste_description = "strawberry tapioca tea"
	glass_icon_state = "boba_strawberry"
	glass_name = "strawberry boba"
	glass_desc = "Let loose your inner glamazon."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/drink/boba_banana
	name = "Banana Boba Tea"
	description = "A tall glass of milky tea-infused banana juice with tapioca pearls at the bottom."
	nutrition = 3
	color = "#ffd255"
	taste_description = "banana tapioca tea"
	glass_icon_state = "boba_banana"
	glass_name = "banana boba"
	glass_desc = "Banana boba bo boba, banana fanna fo foba..."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/drink/summertime_boba
	name = "Summertime Boba Tea"
	description = "A fruit boba drink, this one is watermelon-lime flavored"
	nutrition = 3
	color = "#95db45"
	taste_description = "watermelon lime tapioca tea"
	glass_icon_state = "boba_melonlime"
	glass_name = "summertime boba"
	glass_desc = "Refreshing, sweet and citrusy fruit boba"
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/drink/lovebug_boba
	name = "Lovebug Boba Tea"
	description = "A fruit boba drink, this one is cherry-strawberry flavored"
	nutrition = 3
	color = "#941450"
	taste_description = "cherry and strawberry tapioca tea"
	glass_icon_state = "boba_lovebug"
	glass_name = "lovebug boba"
	glass_desc = "Ancient boba-tea marketing teams believed this cherry-strawberry flavored drink holds magical powers of love! What does that mean? Nobody knows!"
	glass_center_of_mass = list("x"=15, "y"=10)

//
// Coffee
//
/singleton/reagent/drink/coffee
	name = "Coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	overdose = 45
	caffeine = 0.3
	taste_description = "coffee"
	taste_mult = 1.3

	glass_icon_state = "hot_coffee"
	glass_name = "cup of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/singleton/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(adj_temp > 0)
		holder.remove_reagent(/singleton/reagent/frostoil, 10 * removed)

	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsiness = max(0, M.drowsiness - 3)
		M.sleeping = max(0, M.sleeping - 2)
		M.intoxication = max(0, (M.intoxication - (removed*0.25)))

/singleton/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.make_jittery(5)

/singleton/reagent/drink/coffee/icecoffee
	name = "Frappe Coffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#804000"

	glass_icon_state = "frappe"
	glass_name = "glass of frappe coffee"
	glass_desc = "A drink to perk you up and refresh you!"

/singleton/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	description = "A nice and tasty beverage to enjoy while reading your hippie books."
	color = "#664300"
	taste_description = "creamy coffee"

	value = 0.13

	glass_icon_state = "soy_latte_vended"
	glass_name = "glass of soy latte"
	glass_desc = "A nice and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.1 * removed, 0)

/singleton/reagent/drink/coffee/caffe_misto
	name = "Caffe Misto"
	description = "A nice, strong and tasty beverage to enjoy while reading."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "slightly bitter cream"

	glass_icon_state = "caffe_latte"
	glass_name = "glass of caffe misto"
	glass_desc = "A nice, strong and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/caffe_misto/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.1 * removed, 0)

/singleton/reagent/drink/coffee/espresso
	name = "Espresso"
	description = "A strong coffee made by passing nearly boiling water through coffee seeds at high pressure."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "shot of espresso"
	glass_desc = "A strong coffee made by passing nearly boiling water through coffee seeds at high pressure."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/ration
	name = "Ration Coffee"
	description = "Watered-down coffee. One cup now becomes four!"
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "weak, watered-down coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of ration coffee"
	glass_desc = "Coffee, watered-down."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/freddo_espresso
	name = "Freddo Espresso"
	description = "Espresso with ice cubes poured over ice."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "cold and bitter coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of freddo espresso"
	glass_desc = "Espresso with ice cubes poured over ice."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/flat_white
	name = "Flat White"
	description = "A nice, strong, and refreshing beverage to enjoy while reading."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "slightly bitter cream"

	glass_icon_state = "caffe_latte"
	glass_name = "glass of flat white"
	glass_desc = "A nice, strong, and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/caffe_americano
	name = "Caffe Americano"
	description = "Espresso diluted with hot water."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "delicious coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of caffe Americano"
	glass_desc = "delicious coffee"
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/flat_white
	name = "Flat White Espresso"
	description = "Short espresso with steamy hot milk."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "hot creamy coffee"

	glass_icon_state = "caffe_latte"
	glass_name = "glass of flat white"
	glass_desc = "Short espresso with steamy hot milk."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/latte
	name = "Caffe Latte"
	description = "A nice, strong, and refreshing beverage to enjoy while reading."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter foamy cream"

	glass_icon_state = "caffe_latte"
	glass_name = "glass of caffe latte"
	glass_desc = "A nice, strong, and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.1 * removed, 0)

/singleton/reagent/drink/coffee/latte/caramel
	name = "Caramel Latte"
	description = "A latte with caramel flavoring syrup added."
	taste_description = "bitter caramel cream"

	glass_icon_state = "caramel_latte"
	glass_name = "glass of caramel latte"
	glass_desc = "A latte with caramel syrup drizzled into it. Lovely!"
/singleton/reagent/drink/coffee/latte/mocha
	name = "Mocha Latte"
	description = "A latte with chocolate flavoring syrup added."
	taste_description = "bitter chocolate cream"

	glass_icon_state = "mocha_latte"
	glass_name = "glass of chocolate latte"
	glass_desc = "A latte with chocolate syrup drizzled into it. Lovely!"
/singleton/reagent/drink/coffee/latte/vanilla
	name = "Vanilla Latte"
	description = "A latte with vanilla flavoring syrup added."
	taste_description = "bitter vanilla cream"

	glass_icon_state = "caramel_latte"
	glass_name = "glass of vanilla latte"
	glass_desc = "A latte with vanilla syrup drizzled into it. Lovely!"

/singleton/reagent/drink/coffee/cappuccino
	name = "Cappuccino"
	description = "Espresso with steamed milk foam."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of cappuccino"
	glass_desc = "Espresso with steamed milk foam."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/freddo_cappuccino
	name = "Freddo Cappuccino"
	description = "Espresso with steamed milk foam, on ice."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "cold and bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of freddo cappuccino"
	glass_desc = "Espresso with steamed milk foam, on ice."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/macchiato
	name = "Macchiato"
	description = "Espresso with milk foam."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "very bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of macchiato"
	glass_desc = "Espresso with milk foam."
	glass_center_of_mass = list("x"=15, "y"=9)

/singleton/reagent/drink/coffee/icecoffee/psfrappe
	name = "Pumpkin Spice Frappe"
	description = "A seasonal treat popular around the autumn times."
	color = "#9C6B19"
	taste_description = "autumn bliss and coffee"

	glass_icon_state = "frappe_psl"
	glass_name = "glass of pumpkin spice frappe"
	glass_desc = "A seasonal treat popular around the autumn times."

/singleton/reagent/drink/coffee/latte/pumpkinspice
	name = "Pumpkin Spice Latte"
	description = "A seasonal drink favored in autumn."
	color = "#9C6B19"
	taste_description = "hot creamy coffee and autumn bliss"

	glass_icon_state = "psl_cheap"
	glass_name = "cup of pumpkin spice latte"
	glass_desc = "A hot cup of pumpkin spiced coffee. Autumn really is the best season!"

/singleton/reagent/drink/coffee/sadpslatte
	name = "Processed Pumpkin Latte"
	description = "A processed drink vaguely reminicent of autumn bliss."
	color = "#9C6B19"
	taste_description = "a disappointing approximation of autumn bliss"

	glass_icon_state = "psl_cheap"
	glass_name = "cup of cheap pumpkin latte"
	glass_desc = "Maybe you should just go ask the barista for something more authentic..."

//
// Coco
//
/singleton/reagent/drink/hot_coco
	name = "Hot Chocolate"
	description = "Made with love! And cocoa beans."
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	taste_description = "creamy chocolate"

	value = 0.11

	glass_icon_state = "chocolateglass"
	glass_name = "cup of hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/singleton/reagent/drink/ntella_hot_chocolate
	name = "NTella Hot Chocolate"
	description = "It's like a cup of hot chocolate except... More everything."
	color = "#63432e"
	taste_description = "hazelnutty, creamy chocolate"

	value = 0.13

	glass_icon_state = "NTellahotchocolate"
	glass_name = "glass of NTella hot chocolate"
	glass_desc = "A very chocolatey drink for the days so rough, so cold, or so celebratory that a regular hot chocolate just won't cut it. It has marshmallows!"
	glass_center_of_mass = list("x"=16, "y"=7)

//
// Carbonated Drinks
//
/singleton/reagent/drink/sodawater
	name = "Soda Water"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	taste_description = "carbonated water"
	carbonated = TRUE

	glass_icon_state = "glass_clear"
	glass_name = "glass of soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"

/singleton/reagent/drink/tonic
	name = "Tonic Water"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#AEE5E4"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	taste_description = "tart and fresh"
	carbonated = TRUE

	glass_icon_state = "glass_clear"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/singleton/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	color = "#485000"
	caffeine = 0.4
	taste_description = "soda and coffee"
	carbonated = TRUE

	value = 0.11

	glass_icon_state = "rewriter"
	glass_name = "glass of Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(5)

/singleton/reagent/drink/melon_soda
	name = "Melon Soda"
	description = "A neon green hit of nostalgia."
	color = "#6FEB48"
	taste_description = "fizzy melon"
	carbonated = TRUE

	glass_icon_state = "melon_soda"
	glass_name = "glass of melon soda"
	glass_desc = "As enjoyed by Konyanger children and 30-something Konyang enthusiasts."

/singleton/reagent/drink/space_cola
	name = "Comet Cola"
	description = "A refreshing beverage."
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state  = "spacecola"
	glass_name = "glass of Comet Cola"
	glass_desc = "A glass of refreshing Comet Cola"
	glass_center_of_mass = list("x"=17, "y"=6)

/singleton/reagent/drink/coca_cola
	name = "Coca Cola"
	description = "A very refreshing beverage, not for children."
	reagent_state = LIQUID
	color = "#080400"
	adj_dizzy = -1
	adj_drowsy = -5
	adj_sleepy = -3
	taste_description = "a very strong cola"
	carbonated = TRUE

	glass_icon_state  = "spacecola"
	glass_name = "glass of coca cola"
	glass_desc = "A glass of very refreshing coca cola."
	glass_center_of_mass = list("x"=17, "y"=6)

/singleton/reagent/drink/spacemountainwind
	name = "Stellar Jolt"
	description = "For those who have a stronger need for caffeine than they have sense."
	color = "#a2ff8d"
	adj_drowsy = -7
	adj_sleepy = -1
	taste_description = "sweet citrus soda"
	carbonated = TRUE

	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Stellar Jolt"
	glass_desc = "Stellar Jolt. Lemony and full of sugar."

/singleton/reagent/drink/dr_gibb
	name = "Dr. Gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#93230b"
	adj_drowsy = -6
	taste_description = "cherry soda"
	carbonated = TRUE

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."


/singleton/reagent/drink/root_beer
	name = "Getmore Root Beer"
	description = "A classic Earth drink, made from various roots."
	color = "#211100"
	adj_drowsy = -6
	taste_description = "sassafras and anise soda"
	carbonated = TRUE

	glass_icon_state = "root_beer_glass"
	glass_name = "glass of Getmore Root Beer"
	glass_desc = "A glass of bubbly Getmore Root Beer."

/singleton/reagent/drink/gibbfloats
	name = "Root-Cola Floats"
	description = "A floating soda of icecream and Getmore Root-Cola."
	color = "#93230b"
	taste_description = "cherry soda and icecream"
	carbonated = TRUE

	glass_icon_state = "gibbfloats"
	glass_name = "glass of root-cola floats"
	glass_desc = "A floating soda of icecream and Getmore Root-Cola."

/singleton/reagent/drink/spaceup
	name = "Vacuum Fizz"
	description = "Tastes like a hull breach in your mouth."
	color = "#aee5e4"
	taste_description = "hull breach"
	carbonated = TRUE

	glass_icon_state = "space-up_glass"
	glass_name = "glass of Vacuum Fizz"
	glass_desc = "Vacuum Fizz. It helps keep your cool."

/singleton/reagent/drink/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	color = "#878F00"
	taste_description = "tangy lime and lemon soda"

	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"

/singleton/reagent/drink/grapesoda
	name = "Grape Soda"
	description = "Grapes made into a fine drank."
	color = "#421C52"
	adj_drowsy = -3
	taste_description = "grape soda"
	carbonated = TRUE

	glass_icon_state = "gsodaglass"
	glass_name = "glass of grape soda"
	glass_desc = "Looks like a delicious drink!"

/singleton/reagent/drink/brownstar
	name = "Orange Starshine"
	description = "A citrusy orange soda."
	color = "#9F3400"
	taste_description = "orange and cola soda"
	carbonated = TRUE

	glass_icon_state = "brownstar"
	glass_name = "glass of Orange Starshine"
	glass_desc = "A citrusy orange soda."

//
// Diet Soda
//
/singleton/reagent/drink/diet_cola
	name = "Diet Cola"
	description = "Comet cola! Now in diet!"
	color = "#100800"
	taste_description = "cola and less calories"
	carbonated = TRUE

	glass_icon_state = "spacecola"
	glass_name = "glass of diet cola"
	glass_desc = "Comet cola! Now in diet!"

/singleton/reagent/drink/dr_gibb_diet
	name = "Getmore Root-Cola"
	description = "A delicious blend of 42 different flavours, one of which is water."
	color = "#93230b"
	taste_description = "watered down liquid sunshine"
	carbonated = TRUE

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Diet Getmore Root Cola"
	glass_desc = "Regular Root Cola is probably healthier than this cocktail of artificial flavors."

//
// Lemonade
//
/singleton/reagent/drink/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	color = "#FFFF00"
	taste_description = "tartness"

	glass_icon_state = "lemonadeglass"
	glass_name = "glass of lemonade"
	glass_desc = "Oh the nostalgia..."

/singleton/reagent/drink/lemonade/pink
	name = "Pink Lemonade"
	description = "A fruity pink citrus drink."
	color = "#FFC0CB"
	taste_description = "girly tartness"

	glass_icon_state = "pinklemonade"
	glass_name = "glass of pink lemonade"
	glass_desc = "You feel girlier just looking at this."

//
// Cider
//
/singleton/reagent/drink/ciderhot
	name = "Apple Cider"
	description = "A great drink to warm up a crisp autumn afternoon!"
	color = "#e4c35e"
	taste_description = "fresh apples mixed with cinnamon"

	glass_icon_state = "ciderhot"
	glass_name = "cup of apple cider"
	glass_desc = "A great drink to warm up a crisp autumn afternoon!"

/singleton/reagent/drink/cidercold
	name = "Apple Cider"
	description = "A refreshing mug of fresh apples and cinnamon."
	color = "#e4c35e"
	taste_description = "fresh apples mixed with cinnamon"

	glass_icon_state = "meadglass"
	glass_name = "mug of apple cider"
	glass_desc = "A refreshing mug of fresh apples and cinnamon."

/singleton/reagent/drink/cidercheap
	name = "Apple Cider Juice"
	description = "It's just spiced up apple juice. Ugh."
	color = "#e4c35e"
	taste_description = "sad apple juice with cinnamon"

	glass_icon_state = "meadglass"
	glass_name = "mug of apple cider juice"
	glass_desc = "It's just spiced up apple juice. Sometimes the barista can't work miracles."

//
// Non-Alcoholic/Other
//
/singleton/reagent/drink/doctorsdelight
	name = "The Doctor's Delight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = LIQUID
	color = "#BA7CBA"
	nutrition = 1
	taste_description = "homely fruit"

	value = 0.3

	glass_icon_state = "doctorsdelightglass"
	glass_name = "glass of The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	glass_center_of_mass = list("x"=16, "y"=8)

	blood_to_ingest_scale = 1

/singleton/reagent/drink/doctorsdelight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.adjustOxyLoss(-4 * removed)
		M.heal_organ_damage(2 * removed, 2 * removed)
		if(M.dizziness)
			M.dizziness = max(0, M.dizziness - 15)
		if(M.confused)
			M.confused = max(0, M.confused - 5)

//
// Alcohol
//
/singleton/reagent/alcohol/absinthe
	name = "Absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#33EE00"
	strength = 75
	taste_description = "licorice"

	value = 0.13

	glass_icon_state = "absintheglass"
	glass_name = "glass of absinthe"
	glass_desc = "Wormwood, anise, oh my."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/ale
	name = "Ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#9f6568"
	strength = 6
	taste_description = "hearty barley ale"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A freezing pint of delicious ale."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/applejack
	name = "Applejack"
	description = "Hard apple cider that has been distilled. The result is much more flavorful and alcoholic."
	color = "#d4661b"
	strength = 14
	taste_description = "strong cider"

	glass_icon_state = "applejack"
	glass_name = "glass of applejack"
	glass_desc = "Hard apple cider that has been distilled. The result is much more flavorful and alcoholic."

/singleton/reagent/alcohol/snakebite
	name = "Snakebite"
	description = "An alcoholic beverage made of equal parts beer and alcoholic cider."
	color = "#ceab4a"
	strength = 9
	taste_description = "sweet apple-flavoured beer"

	glass_icon_state = "snakebite"
	glass_name = "glass of snakebite"
	glass_desc = "A glass of half-and-half beer and alcoholic cider."

/singleton/reagent/alcohol/beer
	name = "Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#e3e77b"
	strength = 5
	nutriment_factor = 1
	taste_description = "beer"
	carbonated = TRUE

	value = 0.12

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.jitteriness = max(M.jitteriness - 3, 0)

/singleton/reagent/alcohol/beer/light
	name = "Light Beer"
	description = "An alcoholic beverage brewed since ancient times on Earth. This variety has reduced calorie and alcohol content."
	strength = 1
	taste_description = "dish water"

	glass_name = "glass of light beer"
	glass_desc = "A freezing pint of watery light beer."

/singleton/reagent/alcohol/rice_beer
	name = "Rice Beer"
	description = "A light, rice-based lagered beer popular on Konyang."
	color = "#664300"
	strength = 5
	nutriment_factor = 1
	taste_description = "mild carbonated malt"
	carbonated = TRUE

	glass_icon_state = "rice_beer"
	glass_name = "glass of rice beer"
	glass_desc = "A glass of fine, light rice beer. Best enjoyed cold."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/rice_beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.jitteriness = max(M.jitteriness - 3, 0)

/singleton/reagent/alcohol/bitters
	name = "Aromatic Bitters"
	description = "A very, very concentrated and bitter herbal alcohol."
	color = "#223319"
	strength = 40
	taste_description = "bitter"

	value = 0.15

	glass_icon_state = "bittersglass"
	glass_name = "glass of bitters"
	glass_desc = "A pungent glass of bitters."
	glass_center_of_mass = list ("x"=17, "y"=8)

/singleton/reagent/alcohol/bluecuracao
	name = "Blue Curacao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD"
	strength = 25
	taste_description = "oranges"

	value = 0.16

	glass_icon_state = "curacaoglass"
	glass_name = "glass of blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/champagne
	name = "Champagne"
	description = "A classy sparkling wine, usually found in meeting rooms and basements."
	color = "#EBECC0"
	strength = 15
	taste_description = "bubbly bitter-sweetness"
	carbonated = TRUE

	value = 0.2

	glass_icon_state = "champagneglass"
	glass_name = "glass of champagne"
	glass_desc = "Off-white and bubbly. So passe."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/cognac
	name = "Cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#e0a866"
	strength = 40
	taste_description = "rich and smooth alcohol"

	value = 0.2

	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	glass_center_of_mass = list("x"=16, "y"=6)

/singleton/reagent/alcohol/deadrum
	name = "Deadrum"
	description = "Popular with the sailors. Not very popular with everyone else."
	color = "#cac17e"
	strength = 40
	taste_description = "salty sea water"

	value = 0.15

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/deadrum/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.dizziness +=5

/singleton/reagent/alcohol/fernet
	name = "Fernet"
	description = "A bitter, herbal spirit with strong ties to the Earth continent of South America. Commonly mixed with cola."
	color = "#4e1e12"
	strength = 30
	taste_description = "bitter herbs"

	glass_icon_state = "fernet_glass"
	glass_name = "glass of fernet"
	glass_desc = "A glass of raw, bitter fernet. Should probably mix this with something."

/singleton/reagent/alcohol/gin
	name = "Gin"
	description = "It's gin. In space. I say, good sir."
	color = "#dfeef0"
	strength = 30
	taste_description = "an alcoholic christmas tree"

	value = 0.1

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A crystal clear glass of Borovicka gin."
	glass_center_of_mass = list("x"=16, "y"=12)

//Base type for alchoholic drinks containing coffee
/singleton/reagent/alcohol/coffee
	overdose = 45

/singleton/reagent/alcohol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsiness = max(0, M.drowsiness - 3)
		M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/singleton/reagent/alcohol/coffee/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.make_jittery(5)

/singleton/reagent/alcohol/coffee/kahlua
	name = "Kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#8f8469"
	strength = 20
	caffeine = 0.25
	taste_description = "spiked latte"

	value = 0.14

	glass_icon_state = "kahluaglass"
	glass_name = "glass of RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/melonliquor
	name = "Melon Liquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	strength = 23
	taste_description = "fruity alcohol"

	value = 0.13

	glass_icon_state = "emeraldglass"
	glass_name = "glass of melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/limoncello
	name = "Limoncello"
	description = "A lemon liquor beloved in Italy and Assunzione alike."
	color = "#ffef16"
	strength = 24
	taste_description = "lemon liquor"

	value = 0.15

	glass_icon_state = "limoncello"
	glass_name = "glass of Limoncello"
	glass_desc = "A citrusy sweet and sour liquor originating in southern Italy."

/singleton/reagent/alcohol/bon_bon
	name = "Bon Bon"
	description = "A citrusy, sweet and sour blast from the past."
	color = "#fff891"
	strength = 32
	taste_description = "sour candy"

	value = 0.17

	glass_icon_state = "bonbon"
	glass_name = "glass of Bon Bon"
	glass_desc = "Candy is dandy but liquor is quicker!"

/singleton/reagent/alcohol/rum
	name = "Rum"
	description = "Yohoho and all that."
	color = "#cac17e"
	strength = 40
	taste_description = "spiked butterscotch"

	value = 0.1

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/sake
	name = "Sake"
	description = "Anime's favorite drink."
	color = "#bdcdc1"
	strength = 20
	taste_description = "mildly dry alcohol with a subtle sweetness"

	value = 0.11

	glass_icon_state = "sakeglass"
	glass_name = "glass of sake"
	glass_desc = "A glass of sake."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/tequila
	name = "Tequila"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	color = "#FFFF91"
	strength = 40
	taste_description = "paint stripper"

	value = 0.1

	glass_icon_state = "tequilaglass"
	glass_name = "glass of tequila"
	glass_desc = "Now all that's missing is the weird colored shades!"
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/thirteenloko
	name = "Getmore Energy"
	description = "A potent mixture of caffeine and alcohol."
	color = "#ffb928"
	strength = 10
	nutriment_factor = 1
	caffeine = 0.5
	taste_description = "jitters and death"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "thirteen_loko_glass"
	glass_name = "glass of Getmore Energy"
	glass_desc = "This is a glass of Getmore Energy, a potent mixture of caffeine and alcohol."

/singleton/reagent/alcohol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	M.drowsiness = max(0, M.drowsiness - 7)
	M.make_jittery(5)

	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))


/singleton/reagent/alcohol/vermouth
	name = "Vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 17
	taste_description = "dry alcohol"
	taste_mult = 1.3

	value = 0.1

	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/vodka
	name = "Vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 50
	taste_description = "grain alcohol"

	value = 0.1

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of vodka"
	glass_desc = "The glass contain wodka. Xynta."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/vodka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.apply_effect(max(M.total_radiation - 1 * removed, 0), DAMAGE_RADIATION, blocked = 0)

/singleton/reagent/alcohol/whiskey
	name = "Whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#b5a288"
	strength = 40
	taste_description = "molasses"

	value = 0.1

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/wine
	name = "Wine"
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15
	taste_description = "bitter sweetness"

	value = 0.1

	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/wine/vintage
	name = "Fine Wine"
	description = "A high-class artisan wine, made in a small batch and aged for decades or centuries."
	strength = 20
	taste_description = "rich and full-bodied sweetness unlike anything you've ever had"

	value = 15

	glass_name = "glass of vintage wine"
	glass_desc = "A very classy and expensive-looking drink."

/singleton/reagent/alcohol/triplesec
	name = "Triple Sec"
	description = "An orangey liqueur made from bitter, dried orange peels. Usually mixed with cocktails."
	taste_description = "orange peel"
	color = "#fc782b"
	strength = 12

	glass_icon_state = "glass_orange"
	glass_name = "glass of triple sec"
	glass_desc = "An orangey liqueur made from bitter, dried orange peels. Usually mixed with cocktails."

//
// Cocktails
//
/singleton/reagent/alcohol/bahama_mama
	name = "Bahama Mama"
	description = "Tropical cocktail."
	color = "#f06820"
	strength = 15
	taste_description = "lime and orange"

	value = 0.15

	glass_icon_state = "bahama_mama"
	glass_name = "glass of Bahama Mama"
	glass_desc = "Tropical cocktail"
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/alliescocktail
	name = "Allies Cocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	color = "#33ccff"
	strength = 25
	taste_description = "bitter yet free"

	value = 0.16

	glass_icon_state = "alliescocktail"
	glass_name = "glass of Allies cocktail"
	glass_desc = "A drink made from your allies."
	glass_center_of_mass = list("x"=17, "y"=8)


/singleton/reagent/alcohol/antifreeze
	name = "Anti-freeze"
	description = "Ultimate refreshment."
	color = "#30f0ff"
	strength = 20
	adj_temp = 20
	targ_temp = 330
	taste_description = "cold cream"

	value = 0.16

	glass_icon_state = "antifreeze"
	glass_name = "glass of Anti-freeze"
	glass_desc = "The ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/bananahonk
	name = "Banana Mama"
	description = "Banana heaven."
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 15
	taste_description = "a bad joke"

	value = 0.15

	glass_icon_state = "bananahonkglass"
	glass_name = "glass of Banana Honk"
	glass_desc = "A drink from banana heaven."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/barefoot
	name = "Barefoot"
	description = "Creamy berries."
	color = "#ff66cc"
	strength = 15
	taste_description = "creamy berries"

	value = 0.14

	glass_icon_state = "b&p"
	glass_name = "glass of Barefoot"
	glass_desc = "A drink made of berry juice, cream, and vermouth."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/bilk
	name = "Bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C"
	strength = 4
	nutriment_factor = 2
	taste_description = "desperation and lactate"

	value = 0.12

	glass_icon_state = "glass_brown"
	glass_name = "glass of bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/singleton/reagent/alcohol/blackrussian
	name = "Black Russian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#993a38"
	strength = 20
	taste_description = "bitterness"

	value = 0.14

	glass_icon_state = "blackrussianglass"
	glass_name = "glass of Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/bloodymary
	name = "Bloody Mary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#c2707e"
	strength = 20
	taste_description = "tomatoes with a hint of lime"

	value = 0.14

	glass_icon_state = "bloodymaryglass"
	glass_name = "glass of Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/singleton/reagent/alcohol/booger
	name = "Booger"
	description = "Ewww..."
	color = "#8CFF8C"
	strength = 20
	taste_description = "sweet 'n creamy"

	value = 0.13

	glass_icon_state = "booger"
	glass_name = "glass of Booger"
	glass_desc = "Ewww..."

/singleton/reagent/alcohol/coffee/brave_bull
	name = "Brave Bull"
	description = "It's just as effective as Dutch-Courage!"
	color = "#95958f"
	strength = 30
	caffeine = 0.2
	taste_description = "alcoholic bravery"

	value = 0.16

	glass_icon_state = "bravebullglass"
	glass_name = "glass of Brave Bull"
	glass_desc = "Tequila and coffee liquor, brought together in a mouthwatering mixture. Drink up."
	glass_center_of_mass = list("x"=15, "y"=8)

/singleton/reagent/alcohol/cmojito
	name = "Champagne Mojito"
	description = "A fizzy, minty and sweet drink."
	color = "#5DBA40"
	strength = 15
	taste_description = "sweet mint alcohol"

	value = 0.14

	glass_icon_state = "cmojito"
	glass_name = "glass of champagne mojito"
	glass_desc = "Looks fun!"

/singleton/reagent/alcohol/classic
	name = "The Classic"
	description = "The classic bitter lemon cocktail."
	color = "#9a8922"
	strength = 20
	taste_description = "sour and bitter"
	carbonated = TRUE

	value = 0.14

	glass_icon_state = "classic"
	glass_name = "glass of the classic"
	glass_desc = "Just classic. Wow."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/martini
	name = "Classic Martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#ceddad"
	strength = 25
	taste_description = "dry class"

	value = 0.16

	glass_icon_state = "martiniglass"
	glass_name = "glass of classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/corkpopper
	name = "Cork Popper"
	description = "A fancy cocktail with a hint of lemon."
	color = "#766818"
	strength = 30
	taste_description = "sour and smokey"

	value = 0.13

	glass_icon_state = "corkpopper"
	glass_name = "glass of cork popper"
	glass_desc = "The confusing scent only proves all the more alluring."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/cubalibre
	name = "Cuba Libre"
	description = "A rum and coke with lime. Viva la revolucion."
	color = "#8a6167"
	strength = 10
	taste_description = "cola and a hint of lime"
	carbonated = TRUE

	value = 0.16

	glass_icon_state = "cubalibreglass"
	glass_name = "glass of Cuba Libre"
	glass_desc = "A classic mix of rum, cola, and lime."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/rumandcola
	name = "Rum and Cola"
	description = "A classic cocktail consisting of rum and cola."
	color = "#8a6167"
	strength = 10
	taste_description = "cola"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "rumandcolaglass"
	glass_name = "glass of Rum and Cola"
	glass_desc = "A classic mix of rum and cola."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/demonsblood
	name = "Demons Blood"
	description = "AHHHH!!!!"
	color = "#820000"
	strength = 15
	taste_description = "sweet tasting iron"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "demonsblood"
	glass_name = "glass of Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."
	glass_center_of_mass = list("x"=16, "y"=2)

/singleton/reagent/alcohol/devilskiss
	name = "Devils Kiss"
	description = "Creepy time!"
	color = "#ff0033"
	strength = 15
	taste_description = "bitter iron"

	value = 0.14

	glass_icon_state = "devilskiss"
	glass_name = "glass of Devil's Kiss"
	glass_desc = "Creepy time!"
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/fernet_con_coca
	name = "Fernet Con Coca"
	description = "Cola spiked with bitter fernet. A sweet and bitter punch, not for the faint of heart."
	color = "#382b20"
	strength = 20
	taste_description = "deeply bittersweet cola"
	carbonated = TRUE

	glass_icon_state = "root_beer_glass"
	glass_name = "glass of fernet con coca"
	glass_desc = "Cola spiked with bitter fernet. A sweet and bitter punch, not for the faint of heart."

/singleton/reagent/alcohol/driestmartini
	name = "Driest Martini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1
	color = "#2E6671"
	strength = 20
	taste_description = "a beach"

	value = 0.16

	glass_icon_state = "driestmartiniglass"
	glass_name = "glass of Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/french75
	name = "French 75"
	description = "A sharp and classy cocktail."
	color = "#F4E68D"
	strength = 25
	taste_description = "sour and classy"
	carbonated = TRUE

	value = 0.17

	glass_icon_state = "french75"
	glass_name = "glass of french 75"
	glass_desc = "It looks like a lemon shaved into your cocktail."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/ginfizz
	name = "Gin Fizz"
	description = "Refreshingly lemony, deliciously dry."
	color = "#ffffcc"
	strength = 20
	taste_description = "dry, tart lemons"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "ginfizzglass"
	glass_name = "glass of gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/alcohol/grog
	name = "Grog"
	description = "Watered-down rum, pirate approved!"
	reagent_state = LIQUID
	color = "#e3e45e"
	strength = 10
	taste_description = "a poor excuse for alcohol"

	value = 0.11

	glass_icon_state = "grogglass"
	glass_name = "glass of grog"
	glass_desc = "A fine and cepa drink for Space."

/singleton/reagent/alcohol/erikasurprise
	name = "Erika Surprise"
	description = "The surprise is, it's green!"
	color = "#67bc50"
	strength = 15
	taste_description = "tartness and bananas"

	value = 0.16

	glass_icon_state = "erikasurprise"
	glass_name = "glass of Erika Surprise"
	glass_desc = "The surprise is, it's green!"
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/gintonic
	name = "Gin and Tonic"
	description = "An all time classic, mild cocktail."
	color = "#c1dade"
	strength = 12
	taste_description = "mild and tart"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "gintonicglass"
	glass_name = "glass of gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/alcohol/goldschlager
	name = "Goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#97e9f0"
	strength = 50
	taste_description = "burning cinnamon"

	value = 0.2

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/hippiesdelight
	name = "Hippies' Delight"
	description = "You just don't get it maaaan."
	reagent_state = LIQUID
	color = "#cc7470"
	strength = 15
	druggy = 50
	taste_description = "giving peace a chance"

	value = 0.12

	glass_icon_state = "hippiesdelightglass"
	glass_name = "glass of Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/hooch
	name = "Hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	color = "#664300"
	strength = 65
	taste_description = "pure resignation"

	value = 0.11

	glass_icon_state = "glass_brown2"
	glass_name = "glass of Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/singleton/reagent/alcohol/iced_beer
	name = "Iced Beer"
	description = "A beer which is so cold the air around it freezes."
	color = "#c5dc99"
	strength = 5
	targ_temp = 270
	taste_description = "refreshingly cold"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "iced_beerglass"
	glass_name = "glass of iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/alcohol/irishcarbomb
	name = "Irish Car Bomb"
	description = "Mmm, tastes like chocolate cake..."
	color = "#0c0704"
	strength = 50
	taste_description = "delicious anger"
	carbonated = TRUE

	value = 0.14

	glass_icon_state = "irishcarbomb"
	glass_name = "glass of Irish Car Bomb"
	glass_desc = "An irish car bomb."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/coffee/irishcoffee
	name = "Irish Coffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	color = "#664300"
	strength = 50
	caffeine = 0.3
	taste_description = "giving up on the day"

	value = 0.12

	glass_icon_state = "irishcoffeeglass"
	glass_name = "glass of Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/alcohol/irishcream
	name = "Irish Cream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	color = "#664300"
	strength = 25
	taste_description = "creamy alcohol"

	value = 0.13

	glass_icon_state = "irishcreamglass"
	glass_name = "glass of Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/longislandicedtea
	name = "Long Island Iced Tea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	color = "#ff6633"
	strength = 40
	taste_description = "a mixture of cola and alcohol"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "longislandicedteaglass"
	glass_name = "glass of Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/manhattan
	name = "Manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#ff3300"
	strength = 30
	taste_description = "mild dryness"

	value = 0.14

	glass_icon_state = "manhattanglass"
	glass_name = "glass of Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/manhattan_proj
	name = "Manhattan Project"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#ff3300"
	strength = 30
	druggy = 30
	taste_description = "death, the destroyer of worlds"

	value = 0.2

	glass_icon_state = "proj_manhattanglass"
	glass_name = "glass of Manhattan Project"
	glass_desc = "A scientist's drink of choice, for thinking how to blow up the station."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/manly_dorf
	name = "The Manly Dorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	color = "#ce950f"
	strength = 45
	taste_description = "hair on your chest and your chin"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "manlydorfglass"
	glass_name = "glass of The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/singleton/reagent/alcohol/margarita
	name = "Margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#dce6d2"
	strength = 30
	taste_description = "dry and salty"

	value = 0.15

	glass_icon_state = "margaritaglass"
	glass_name = "glass of margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/mead
	name = "Mead"
	description = "A Viking's drink, though a cheap one."
	reagent_state = LIQUID
	color = "#e4c35e"
	strength = 25
	nutriment_factor = 1
	taste_description = "sweet yet alcoholic"

	value = 0.13

	glass_icon_state = "meadglass"
	glass_name = "glass of mead"
	glass_desc = "A Viking's beverage, though a cheap one."
	glass_center_of_mass = list("x"=17, "y"=10)

/singleton/reagent/alcohol/moonshine
	name = "Moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#86d0cb"
	strength = 65
	taste_description = "bitterness"

	value = 0.11

	glass_icon_state = "glass_clear"
	glass_name = "glass of moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/singleton/reagent/alcohol/muscmule
	name = "Muscovite Mule"
	description = "A surprisingly gentle cocktail, with a hidden punch."
	color = "#8EEC5F"
	strength = 40
	taste_description = "mint and a mule's kick"

	value = 0.14

	glass_icon_state = "muscmule"
	glass_name = "glass of muscovite mule"
	glass_desc = "Such a pretty green, this couldn't possible go wrong!"
	glass_center_of_mass = list("x"=17, "y"=10)

/singleton/reagent/alcohol/neurotoxin
	name = "Neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = LIQUID
	color = "#2E2E61"
	strength = 50
	taste_description = "a numbing sensation"

	value = 0.2

	glass_icon_state = "neurotoxinglass"
	glass_name = "glass of Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_center_of_mass = list("x"=16, "y"=8)

	blood_to_ingest_scale = 1
	metabolism = REM * 5

/singleton/reagent/alcohol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	M.Weaken(3)
	M.add_chemical_effect(CE_PULSE, -2)

/singleton/reagent/alcohol/omimosa
	name = "Orange Mimosa"
	description = "Wonderful start to any day."
	color = "#F4A121"
	strength = 15
	taste_description = "fizzy orange"
	carbonated = TRUE

	value = 0.18

	glass_icon_state = "omimosa"
	glass_name = "glass of orange mimosa"
	glass_desc = "Smells like a fresh start."

/singleton/reagent/alcohol/patron
	name = "Patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#c5c59c"
	strength = 20
	taste_description = "metallic and expensive"

	value = 0.16

	glass_icon_state = "patronglass"
	glass_name = "glass of Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/alcohol/pinkgin
	name = "Pink Gin"
	description = "Bitters and Gin."
	color = "#DB80B2"
	strength = 25
	taste_description = "bitter christmas tree"

	value = 0.11

	glass_icon_state = "pinkgin"
	glass_name = "glass of pink gin"
	glass_desc = "What an eccentric cocktail."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/pinkgintonic
	name = "Pink Gin and Tonic"
	description = "Bitterer gin and tonic."
	color = "#F4BDDB"
	strength = 25
	taste_description = "very bitter christmas tree"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "pinkgintonic"
	glass_name = "glass of pink gin and tonic"
	glass_desc = "You made gin and tonic more bitter... you madman!"

/singleton/reagent/alcohol/piratepunch
	name = "Pirate's Punch"
	description = "Nautical punch!"
	color = "#ECE1A0"
	strength = 25
	taste_description = "spiced fruit cocktail"

	value = 0.14

	glass_icon_state = "piratepunch"
	glass_name = "glass of pirate's punch"
	glass_desc = "Yarr harr fiddly dee, drink whatcha want 'cause a pirate is ye!"
	glass_center_of_mass = list("x"=17, "y"=10)

/singleton/reagent/alcohol/planterpunch
	name = "Planter's Punch"
	description = "A popular beach cocktail."
	color = "#F27900"
	strength = 25
	taste_description = "jamaica"

	value = 0.13

	glass_icon_state = "planterpunch"
	glass_name = "glass of planter's punch"
	glass_desc = "This takes you back, back to those endless white beaches of yore."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/pwine
	name = "Poison Wine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000"
	strength = 15
	druggy = 50
	halluci = 10
	taste_description = "purified alcoholic death"

	value = 0.19

	glass_icon_state = "pwineglass"
	glass_name = "glass of ???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_HALLUCINATE, 1)
	M.hallucination = max(M.hallucination, 25)
	var/dose = M.chem_doses[type]
	if(dose > 30)
		M.adjustToxLoss(2 * removed)

	if(dose > 60 && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (L && istype(L))
			if(dose < 120)
				L.take_damage(10 * removed, 0)
			else
				L.take_damage(100, 0)

/singleton/reagent/alcohol/red_mead
	name = "Red Mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	color = "#C73C00"
	strength = 21
	taste_description = "sweet and salty alcohol"

	value = 0.14

	glass_icon_state = "red_meadglass"
	glass_name = "glass of red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."
	glass_center_of_mass = list("x"=17, "y"=10)

/singleton/reagent/alcohol/sbiten
	name = "Sbiten"
	description = "A spicy mix of mead and spices! Might be a little hot for the little guys!"
	color = "#d8d7ae"
	strength = 40
	adj_temp = 50
	targ_temp = 360
	taste_description = "hot and spice"

	value = 0.13

	glass_icon_state = "sbitenglass"
	glass_name = "glass of Sbiten"
	glass_desc = "A spicy mix of Mead and Spices. Very hot."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/screwdrivercocktail
	name = "Screwdriver"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#d9ab92"
	strength = 15
	taste_description = "oranges"

	value = 0.13

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
	glass_center_of_mass = list("x"=15, "y"=10)

/singleton/reagent/alcohol/sidewinderfang
	name = "Sidewinder Fang"
	description = "Mess with the viper, and you get the fangs."
	color = "#EA8600"
	strength = 30
	taste_description = "fruity rum and bittersweet nostalgia"

	value = 0.14

	glass_icon_state = "sidewinderglass"
	glass_name = "glass of Sidewinder Fang"
	glass_desc = "An eclectic cocktail of fruit juices and dark rum. Mess with the viper, and you get the fangs."

/singleton/reagent/alcohol/snowwhite
	name = "Snow White"
	description = "A cold refreshment"
	color = "#FFFFFF"
	strength = 7
	taste_description = "refreshing cold"
	carbonated = TRUE

	value = 0.125

	glass_icon_state = "snowwhite"
	glass_name = "glass of Snow White"
	glass_desc = "A cold refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/alcohol/ssroyale
	name = "Southside Royale"
	description = "Classy cocktail containing citrus."
	color = "#66F446"
	strength = 20
	taste_description = "lime christmas tree"

	value = 0.14

	glass_icon_state = "ssroyale"
	glass_name = "glass of southside royale"
	glass_desc = "This cocktail is better than you. Maybe it's the crossed arms that give it away. Or the rich parents."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/suidream
	name = "Sui Dream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	color = "#00A86B"
	strength = 5
	taste_description = "fruit"
	carbonated = TRUE

	value = 0.12

	glass_icon_state = "sdreamglass"
	glass_name = "glass of Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."
	glass_center_of_mass = list("x"=16, "y"=5)

/singleton/reagent/alcohol/tequila_sunrise
	name = "Tequila Sunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	color = "#FFE48C"
	strength = 15
	taste_description = "oranges"

	value = 0.13

	glass_icon_state = "tequilasunriseglass"
	glass_name = "glass of Tequila Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/singleton/reagent/alcohol/threemileisland
	name = "Three Mile Island Iced Tea"
	description = "Made for a woman, strong enough for a man."
	color = "#666340"
	strength = 60
	druggy = 50
	taste_description = "dry"
	carbonated = TRUE

	value = 0.2

	glass_icon_state = "threemileislandglass"
	glass_name = "glass of Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."
	glass_center_of_mass = list("x"=16, "y"=2)

/singleton/reagent/alcohol/toxins_special
	name = "Toxins Special"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	reagent_state = LIQUID
	color = "#8880aa"
	strength = 40
	adj_temp = 15
	targ_temp = 330
	taste_description = "spicy toxins"

	value = 0.2

	glass_icon_state = "toxinsspecialglass"
	glass_name = "glass of Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"

/singleton/reagent/alcohol/vodkamartini
	name = "Vodka Martini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#76be8a"
	strength = 32
	taste_description = "shaken, not stirred"

	value = 0.135

	glass_icon_state = "martiniglass"
	glass_name = "glass of vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/vodkatonic
	name = "Vodka and Tonic"
	description = "For when a gin and tonic isn't russian enough."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 35
	taste_description = "tart bitterness"

	value = 0.145

	glass_icon_state = "vodkatonicglass"
	glass_name = "glass of vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/alcohol/white_russian
	name = "White Russian"
	description = "That's just, like, your opinion, man..."
	color = "#f0dfc0"
	strength = 30
	taste_description = "bitter cream"

	value = 0.125

	glass_icon_state = "whiterussianglass"
	glass_name = "glass of White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/whiskeycola
	name = "Whiskey Cola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#aa8979"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/whiskeysoda
	name = "Whiskey Soda"
	description = "For the more refined griffon."
	color = "#a78779"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "whiskeysodaglass2"
	glass_name = "glass of whiskey soda"
	glass_desc = "Ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=9)

/singleton/reagent/alcohol/specialwhiskey
	name = "Special Blend Whiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	color = "#b5a288"
	strength = 45
	taste_description = "silky, amber goodness"

	value = 0.3

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	glass_center_of_mass = list("x"=16, "y"=12)

/singleton/reagent/alcohol/drdaniels
	name = "Dr. Daniels"
	description = "A limited edition tallboy of Getmore Root Cola's Infusions."
	color = "#35240f"
	caffeine = 0.2
	overdose = 80
	strength = 20
	nutriment_factor = 2
	taste_description = "smooth, honeyed carbonation"
	carbonated = TRUE

	glass_icon_state = "drdaniels"
	glass_name = "glass of Dr. Daniels"
	glass_desc = "A tall glass of honey, whiskey, and diet Getmore Root Cola. The perfect blend of throat-soothing liquid."

/singleton/reagent/alcohol/daiquiri
	name = "Daiquiri"
	description = "A splendid looking cocktail."
	color = "#efd08d"
	strength = 15
	taste_description = "lime and sugar"

	value = 0.15

	glass_icon_state = "daiquiri"
	glass_name = "glass of Daiquiri"
	glass_desc = "A splendid looking cocktail."

/singleton/reagent/alcohol/icepick
	name = "Ice Pick"
	description = "Big. And red. Hmm...."
	color = "#c42801"
	strength = 10
	taste_description = "vodka and lemon"

	value = 0.15

	glass_icon_state = "icepick"
	glass_name = "glass of Ice Pick"
	glass_desc = "Big. And red. Hmm..."

/singleton/reagent/alcohol/poussecafe
	name = "Pousse-Cafe"
	description = "Smells of French and liquore."
	color = "#e0d7c5"
	strength = 15
	taste_description = "layers of liquors"

	value = 0.17

	glass_icon_state = "pousseecafe"
	glass_name = "glass of Pousse-Cafe"
	glass_desc = "Smells of French and liquore."

/singleton/reagent/alcohol/mintjulep
	name = "Mint Julep"
	description = "As old as time itself, but how does it taste?"
	color = "#d28a20"
	strength = 25
	taste_description = "old as time"

	value = 0.15

	glass_icon_state = "mintjulep"
	glass_name = "glass of Mint Julep"
	glass_desc = "As old as time itself, but how does it taste?"

/singleton/reagent/alcohol/johncollins
	name = "John Collins"
	description = "Crystal clear, yellow, and smells of whiskey. How could this go wrong?"
	color = "#ffcc60"
	strength = 25
	taste_description = "whiskey"
	carbonated = TRUE

	value = 0.17

	glass_icon_state = "johnscollins"
	glass_name = "glass of John Collins"
	glass_desc = "Named after a man, perhaps?"

/singleton/reagent/alcohol/gimlet
	name = "Gimlet"
	description = "Small, elegant, and kicks."
	color = "#d1d214"
	strength = 20
	taste_description = "gin and class"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "gimlet"
	glass_name = "glass of Gimlet"
	glass_desc = "Small, elegant, and packs a punch."

/singleton/reagent/alcohol/starsandstripes
	name = "Stars and Stripes"
	description = "Someone, somewhere, is saluting."
	color = "#9f6671"
	strength = 10
	taste_description = "freedom"

	value = 0.15

	glass_icon_state = "starsandstripes"
	glass_name = "glass of Stars and Stripes"
	glass_desc = "Someone, somewhere, is saluting."

/singleton/reagent/alcohol/cosmopolitan
	name = "Cosmopolitan"
	description = "Sweet, sour, and chic. The Cosmopolitan is a legendary, upscale classic."
	color = "#f3174e"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "cosmopolitan"
	glass_name = "glass of Cosmopolitan"
	glass_desc = "Sweet, sour, and chic. The Cosmopolitan is a legendary, upscale classic."

/singleton/reagent/alcohol/metropolitan
	name = "Metropolitan"
	description = "What more could you ask for?"
	color = "#ff0000"
	strength = 27
	taste_description = "fruity sweetness"

	value = 0.13

	glass_icon_state = "metropolitan"
	glass_name = "glass of Metropolitan"
	glass_desc = "What more could you ask for?"

/singleton/reagent/alcohol/primeminister
	name = "Prime Minister"
	description = "All the fun of power, none of the assassination risk!"
	color = "#FF3C00"
	strength = 30
	taste_description = "political power"

	value = 0.13

	glass_icon_state = "primeministerglass"
	glass_name = "glass of Prime Minister"
	glass_desc = "All the fun of power, none of the assassination risk!"

/singleton/reagent/alcohol/peacetreaty
	name = "Peace Treaty"
	description = "A diplomatic overture in a glass."
	color = "#DFDF93"
	strength = 21
	taste_description = "tart, oily honey"

	value = 0.15

	glass_icon_state = "peacetreatyglass"
	glass_name = "glass of Peace Treaty"
	glass_desc = "A diplomatic overture in a glass."

/singleton/reagent/alcohol/caruso
	name = "Caruso"
	description = "Green, almost alien."
	color = "#009652"
	strength = 25
	taste_description = "dryness"

	value = 0.18

	glass_icon_state = "caruso"
	glass_name = "glass of Caruso"
	glass_desc = "Green, almost alien."

/singleton/reagent/alcohol/aprilshower
	name = "April Shower"
	description = "Smells of brandy."
	color = "#c99718"
	strength = 25
	taste_description = "brandy and oranges"

	value = 0.15

	glass_icon_state = "aprilshower"
	glass_name = "glass of April Shower"
	glass_desc = "Smells of brandy."

/singleton/reagent/alcohol/carthusiansazerac
	name = "Carthusian Sazerac"
	description = "Whiskey and... Syrup?"
	color = "#e2da3b"
	strength = 15
	taste_description = "sweetness"

	value = 0.17

	glass_icon_state = "carthusiansazerac"
	glass_name = "glass of Carthusian Sazerac"
	glass_desc = "Whiskey and... Syrup?"

/singleton/reagent/alcohol/deweycocktail
	name = "Dewey Cocktail"
	description = "Colours, look at all the colours!"
	color = "#743e99"
	strength = 25
	taste_description = "dry gin"

	value = 0.15

	glass_icon_state = "deweycocktail"
	glass_name = "glass of Dewey Cocktail"
	glass_desc = "Colours, look at all the colours!"

/singleton/reagent/alcohol/chartreusegreen
	name = "Green Chartreuse"
	description = "A green, strong liqueur."
	color = "#9cad3e"
	strength = 40
	taste_description = "a mixture of herbs"

	value = 0.18

	glass_icon_state = "greenchartreuseglass"
	glass_name = "glass of Green Chartreuse"
	glass_desc = "A green, strong liqueur."

/singleton/reagent/alcohol/chartreuseyellow
	name = "Yellow Chartreuse"
	description = "A yellow, strong liqueur."
	color = "#eadd25"
	strength = 40
	taste_description = "a sweet mixture of herbs"

	value = 0.18

	glass_icon_state = "chartreuseyellowglass"
	glass_name = "glass of Yellow Chartreuse"
	glass_desc = "A yellow, strong liqueur."

/singleton/reagent/alcohol/cremewhite
	name = "White Creme de Menthe"
	description = "Mint-flavoured alcohol, in a bottle."
	color = "#d8d7d6"
	strength = 20
	taste_description = "mint"

	value = 0.14

	glass_icon_state = "whitecremeglass"
	glass_name = "glass of White Creme de Menthe"
	glass_desc = "Mint-flavoured alcohol."

/singleton/reagent/alcohol/cremeyvette
	name = "Creme de Yvette"
	description = "Berry-flavoured alcohol, in a bottle."
	color = "#b57777"
	strength = 20
	taste_description = "berries"

	value = 0.17

	glass_icon_state = "cremedeyvetteglass"
	glass_name = "glass of Creme de Yvette"
	glass_desc = "Berry-flavoured alcohol."

/singleton/reagent/alcohol/brandy
	name = "Brandy"
	description = "Cheap knock off for cognac."
	color = "#b55100"
	strength = 40
	taste_description = "cheap cognac"

	value = 0.2

	glass_icon_state = "brandyglass"
	glass_name = "glass of Brandy"
	glass_desc = "Cheap knock off for cognac."

/singleton/reagent/alcohol/guinness
	name = "Guinness"
	description = "Special Guinnes drink."
	color = "#4b4c4a"
	strength = 8
	taste_description = "dryness"
	carbonated = TRUE

	value = 0.1

	glass_icon_state = "guinnessglass"
	glass_name = "glass of Guinness"
	glass_desc = "A glass of Guinness."

/singleton/reagent/alcohol/drambuie
	name = "Drambuie"
	description = "A drink that smells like whiskey but tastes different."
	color = "#e5ee98"
	strength = 40
	taste_description = "sweet whisky"

	value = 0.18

	glass_icon_state = "drambuieglass"
	glass_name = "glass of Drambuie"
	glass_desc = "A drink that smells like whiskey but tastes different."

/singleton/reagent/alcohol/oldfashioned
	name = "Old Fashioned"
	description = "That looks like it's from the sixties."
	color = "#a67257"
	strength = 30
	taste_description = "bitterness"

	value = 0.15

	glass_icon_state = "oldfashioned"
	glass_name = "glass of Old Fashioned"
	glass_desc = "That looks like it's from the sixties."

/singleton/reagent/alcohol/blindrussian
	name = "Blind Russian"
	description = "You can't see?"
	color = "#c8b29a"
	strength = 40
	taste_description = "bitterness blindness"

	value = 0.16

	glass_icon_state = "blindrussian"
	glass_name = "glass of Blind Russian"
	glass_desc = "You can't see?"

/singleton/reagent/alcohol/rustynail
	name = "Rusty Nail"
	description = "Smells like lemon."
	color = "#b22b18"
	strength = 25
	taste_description = "lemons"

	value = 0.13

	glass_icon_state = "rustynail"
	glass_name = "glass of Rusty Nail"
	glass_desc = "Smells like lemon."

/singleton/reagent/alcohol/tallrussian
	name = "Tall Black Russian"
	description = "Just like black russian but taller."
	color = "#993a38"
	strength = 25
	taste_description = "tall bitterness"
	carbonated = TRUE

	value = 0.15

	glass_icon_state = "tallblackrussian"
	glass_name = "glass of Tall Black Russian"
	glass_desc = "Just like black russian but taller."

/singleton/reagent/alcohol/badtouch
	name = "Bad Touch"
	description = "We're nothing but mammals, after all."
	color = "#42f456"
	strength = 50
	taste_description = "naughtiness"

	glass_icon_state = "badtouch"
	glass_name = "glass of Bad Touch"
	glass_desc = "We're nothing but mammals, after all."

/singleton/reagent/alcohol/bluelagoon
	name = "Blue Lagoon"
	description = "Because lagoons shouldn't come in other colors."
	color = "#51b8ef"
	strength = 25
	taste_description = "electric lemonade"

	glass_icon_state = "bluelagoon"
	glass_name = "glass of Blue Lagoon"
	glass_desc = "Because lagoons shouldn't come in other colors."

/singleton/reagent/alcohol/fireball
	name = "Fireball"
	description = "Whiskey that's been infused with cinnamon and hot pepper. Meant for mixing."
	color = "#be8e89"
	strength = 35
	taste_description = "cinnamon whiskey"

	glass_icon_state = "fireballglass"
	glass_name = "glass of fireball"
	glass_desc = "Whiskey that's been infused with cinnamon and hot pepper. Is this safe to drink?"
	taste_mult = 1.2
	var/agony_dose = 5
	var/agony_amount = 1
	var/discomfort_message = SPAN_DANGER("Your insides feel uncomfortably hot!")
	var/slime_temp_adj = 3

/singleton/reagent/alcohol/fireball/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.1 * removed)

/singleton/reagent/alcohol/fireball/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	to_chat(M, discomfort_message)

/singleton/reagent/alcohol/fireball/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.can_feel_pain())
				return
		if(M.chem_doses[type] < agony_dose)
			if(prob(5))
				to_chat(M, discomfort_message)
		else
			M.apply_effect(agony_amount, DAMAGE_PAIN, 0)
			if(prob(5))
				M.visible_message("<b>[M]</b> [pick("dry heaves!","coughs!","splutters!")]")
				to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
		if(istype(M, /mob/living/carbon/slime))
			M.bodytemperature += rand(0, 15) + slime_temp_adj
		holder.remove_reagent(/singleton/reagent/frostoil, 2)

/singleton/reagent/alcohol/cherrytreefireball
	name = "Cherry Tree Fireball"
	description = "An iced fruit cocktail shaken with cinnamon whiskey. Hot, cold and sweet all at once."
	color = "#e87727"
	strength = 15
	taste_description = "sweet spiced cherries"

	glass_icon_state = "cherrytreefireball"
	glass_name = "glass of Cherry Tree Fireball"
	glass_desc = "An iced fruit cocktail shaken with cinnamon whiskey. Hot, cold and sweet all at once."

/singleton/reagent/alcohol/cobaltvelvet
	name = "Cobalt Velvet"
	description = "An electric blue champagne cocktail that's popular on the club scene."
	color = "#a3ecf7"
	strength = 25
	taste_description = "neon champagne"
	carbonated = TRUE

	glass_icon_state = "cobaltvelvet"
	glass_name = "glass of Cobalt Velvet"
	glass_desc = "An electric blue champagne cocktail that's popular on the club scene."

/singleton/reagent/alcohol/fringeweaver
	name = "Fringe Weaver"
	description = "Effectively pure alcohol with a dose of sugar. It's as simple as it is strong."
	color = "#f78888"
	strength = 65
	taste_description = "liquid regret"

	glass_icon_state = "fringeweaver"
	glass_name = "glass of Fringe Weaver"
	glass_desc = "Effectively pure alcohol with a dose of sugar. It's as simple as it is strong."

/singleton/reagent/alcohol/junglejuice
	name = "Jungle Juice"
	description = "You're in the jungle now, baby."
	color = "#d70091"
	strength = 35
	taste_description = "a fraternity house party"

	glass_icon_state = "junglejuice"
	glass_name = "glass of Jungle Juice"
	glass_desc = "You're in the jungle now, baby."

/singleton/reagent/drink/meloncooler
	name = "Melon Cooler"
	description = "Summertime on the beach, in liquid form."
	color = "#d8457b"
	taste_description = "minty melon"

	glass_icon_state = "meloncooler"
	glass_name = "glass of Melon Cooler"
	glass_desc = "Summertime on the beach, in liquid form."

/singleton/reagent/alcohol/midnightkiss
	name = "Midnight Kiss"
	description = "A champagne cocktail, quietly bubbling in a slender glass."
	color = "#13144c"
	strength = 25
	taste_description = "a late-night promise"
	carbonated = TRUE

	glass_icon_state = "midnightkiss"
	glass_name = "glass of Midnight Kiss"
	glass_desc = "A champagne cocktail, quietly bubbling in a slender glass."

/singleton/reagent/drink/millionairesour
	name = "Millionaire Sour"
	description = "It's a good mix, a great mix. The best mix in known space. It's terrific, you're gonna love it."
	color = "#13144c"
	taste_description = "tart fruit"

	glass_icon_state = "millionairesour"
	glass_name = "glass of Millionaire Sour"
	glass_desc = "It's a good mix, a great mix. Best mix in the galaxy. It's terrific, you're gonna love it."

/singleton/reagent/drink/lemonlimebitters
	name = "Lemon Lime & Bitters"
	color = "#ffa238"
	description = "A balanced, summery cocktail great for drinking on upside-down December summers."
	taste_description = "punchy lemonade with a splash of medicine"

	glass_icon_state = "lemonlimebitters_glass"
	glass_name = "glass of Lemon Lime & Bitters"
	glass_desc = "A balanced, summery cocktail great for drinking on upside-down December summers."

/singleton/reagent/drink/shirleytemple
	name = "Shirley Temple"
	description = "Straight from the good ship Lollipop."
	color = "#ce2727"
	taste_description = "innocence"

	glass_icon_state = "shirleytemple"
	glass_name = "glass of Shirley Temple"
	glass_desc = "Straight from the good ship Lollipop."

/singleton/reagent/alcohol/sugarrush
	name = "Sugar Rush"
	description = "Sweet, light and fruity. As girly as it gets."
	color = "#d51d5d"
	strength = 15
	taste_description = "sweet soda"
	carbonated = TRUE

	glass_icon_state = "sugarrush"
	glass_name = "glass of Sugar Rush"
	glass_desc = "Sweet, light and fruity. As girly as it gets."

/singleton/reagent/alcohol/sangria
	name = "Sangria"
	description = "Red wine, splashed with brandy and infused with fruit."
	color = "#960707"
	strength = 30
	taste_description = "sweet wine"

	glass_icon_state = "sangria"
	glass_name = "glass of Sangria"
	glass_desc = "Red wine, splashed with brandy and infused with fruit."

/singleton/reagent/alcohol/bassline
	name = "Bassline"
	description = "A vodka cocktail from Vega De Rosa, Mendell City's entertainment district. Purple and deep."
	color = "#6807b2"
	strength = 25
	taste_description = "the groove"

	glass_icon_state = "bassline"
	glass_name = "glass of Bassline"
	glass_desc = "A vodka cocktail from Vega De Rosa, Mendell City's entertainment district. Purple and deep."

/singleton/reagent/alcohol/bluebird
	name = "Bluebird"
	description = "A gin drink popularized by a spy thriller in 2452."
	color = "#4286f4"
	strength = 30
	taste_description = "a blue christmas tree"

	glass_icon_state = "bluebird"
	glass_name = "glass of Bluebird"
	glass_desc = "A gin drink popularized by a spy thriller in 2452."

/singleton/reagent/alcohol/whitewine
	name = "White Wine"
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#e5d272"
	strength = 15
	taste_description = "dry sweetness"

	glass_icon_state = "whitewineglass"
	glass_name = "glass of white wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/blushwine
	name = "Blush Wine"
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#e5d272"
	strength = 10
	taste_description = "delightful sweetness"
	glass_icon_state = "blushwineglass"
	glass_name = "glass of blush wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/melonwine
	name = "Melon Wine"
	description = "A fruity alchoholic beverage made from wine and melon liquor."
	color = "#11cf39" // rgb: 126, 64, 67
	strength = 20
	taste_description = "mouth watering fruity sweetness"
	glass_icon_state = "melonwine"
	glass_name = "glass of Melon-Wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/cinnamonapplewhiskey
	name = "Cinnamon Apple Whiskey"
	description = "Cider with cinnamon whiskey. It's like drinking a hot apple pie!"
	color = "#b88a04"
	strength = 20
	taste_description = "sweet spiced apples"

	glass_icon_state = "manlydorfglass"
	glass_name = "mug of cinnamon apple whiskey"
	glass_desc = "Cider with cinnamon whiskey. It's like drinking a hot apple pie!"

/singleton/reagent/alcohol/martyrgarita
	name = "The Martyrgarita"
	color = "#801a1a"
	description = "A drink worth dying for."
	strength = 20
	taste_description = "fizzy communion wine"

	glass_icon_state = "martyrgaritaglass"
	glass_name = "glass of the martyrgarita"
	glass_desc = "A drink worth dying for."

/singleton/reagent/alcohol/rose_tinted_glasses
	name = "Rose Tinted Glasses"
	color = "#f1b2bf"
	description = "When looking through this, all the red flags just look like flags."
	strength = 20
	taste_description = "pink-colored nostalgia"

	glass_icon_state = "rose_tinted_glasses_glass"
	glass_name = "glass of Rose-Tinted Glasses"
	glass_desc = "When looking through this, all the red flags just look like flags."

/singleton/reagent/alcohol/twisted_lime
	name = "Twisted Lime"
	color = "#6bd151"
	description = "A pungent, unforgiving drink made with lime juice, fernet, and ale, intended for hardcore drinkers as a pick-me-up. The evil brother of the Millionaire Sour."
	strength = 30
	taste_description = "bitter sourness"

	glass_icon_state = "twisted_lime_glass"
	glass_name = "glass of Twisted Lime"
	glass_desc = "A pungent, unforgiving drink made with lime juice, fernet, and ale, intended for hardcore drinkers as a pick-me-up. The evil brother of the Millionaire Sour."

/singleton/reagent/alcohol/cinnamon_orchard
	name = "Cinnamon Orchard"
	color = "#d3954e"
	description = "A spiced, warm liquor that makes you feel fuzzy inside. Punctuated by a lemon twist that balances the flavor profile."
	strength = 20
	taste_description = "cinnamon bliss"

	glass_icon_state = "cinnamon_orchard_glass"
	glass_name = "glass of Cinnamon Orchard"
	glass_desc = "A spiced, warm liquor that makes you feel fuzzy inside. Punctuated by a lemon twist that balances the flavor profile."

/singleton/reagent/alcohol/harvest_moon
	name = "Harvest Moon"
	color = "#c76617"
	description = "The taste of autumn itself, distilled into drinkable format. Applejack and pumpkin spice are emphasized by a splash of soda water to give it a refreshing taste that reminds you of falling leaves."
	strength = 35
	taste_description = "sparkling pumpkin pie and spiced apples"

	glass_icon_state = "harvest_moon_glass"
	glass_name = "glass of Harvest Moon"
	glass_desc = "The taste of autumn itself, distilled into drinkable format. Applejack and pumpkin spice are emphasized by a splash of soda water to give it a refreshing taste that reminds you of falling leaves."

/singleton/reagent/alcohol/espratini
	name = "Espratini"
	color = "#4b2d0b"
	description = "Coffee liqueur blended with espresso and spiked with vodka. Strong, highly caffeinated, and sure to wake anyone up at the beginning of the day."
	strength = 50
	taste_description = "powerful black coffee"

	glass_icon_state = "espratini_glass"
	glass_name = "glass of Espratini"
	glass_desc = "Coffee liqueur blended with espresso and spiked with vodka. Strong, highly caffeinated, and sure to wake anyone up at the beginning of the day."

/singleton/reagent/alcohol/pretty_in_pink
	name = "Pretty in Pink"
	color = "#efa1ff"
	description = "Fruity pink wine meets fruity pink lemonade. You half expect a fairy to pop out of this."
	strength = 10
	taste_description = "rosy fruity pinkness"

	glass_icon_state = "pink_glass"
	glass_name = "glass of Pretty in Pink"
	glass_desc = "Fruity pink wine meets fruity pink lemonade. You half expect a fairy to pop out of this."

/singleton/reagent/alcohol/eggnog
	name = "Eggnog"
	color = "#619494"
	description = "A true Christmas classic, consisting of egg, cream, sugar and of course alcohol."
	taste_description = "egg and alcohol"
	strength = 15

	glass_icon_state = "snowwhite"
	glass_name = "glass of eggnog"
	glass_desc = "Technically a longdrink, made out of egg, sugar, cream and alcohol. Merry Christmas!"

/singleton/reagent/alcohol/mojito
	name = "Mojito"
	description = "Originated from Sol, now popular all around the Spur."
	strength = 30
	color = "#b6ecaa"
	taste_description = "refreshing mint"

	glass_icon_state = "mojito"
	glass_name = "glass of mojito"
	glass_desc = "Originated from Sol, now popular all around the Spur."

/singleton/reagent/alcohol/zavdoskoi_mule
	name = "Zavodskoi Mule"
	description = "It is said to be Lyudmila Zavodskoi's favorite."
	strength = 40
	color = "#EEF1AA"
	taste_description = "refreshing spiciness"

	glass_icon_state = "zavodskoi_mule"
	glass_name = "glass of zavodskoi mule"
	glass_desc = "It is said to be Lyudmila Zavodskoi's favorite."

/singleton/reagent/alcohol/forbidden_apple
	name = "Forbidden Apple"
	description = "A champagne cocktail spiked with applejack and orange liqueur."
	strength = 25
	color = "#bd6717"
	taste_description = "champagne, a hint of apples, and orange sweetness"

	glass_icon_state = "forbiddenapple"
	glass_name = "glass of forbidden apple"
	glass_desc = "A champagne cocktail spiked with applejack and orange liqueur."

/singleton/reagent/alcohol/andalusia
	name = "Andalusia"
	description = "A nice, strangely named drink."
	color = "#ffff66"
	strength = 35
	taste_description = "lemons"

	value = 0.15

	glass_icon_state = "andalusia"
	glass_name = "glass of Andalusia"
	glass_desc = "A nice, strange named drink."
	glass_center_of_mass = list("x"=16, "y"=9)
//
// To Be Removed
//
// This section exists for drinks that, in my opinion, need to be removed. These drinks are just direct copy's of drinks from other media with no relevance to aurora.
// Or they're non existant drinks from Bay/Other servers with no relevance to aurora, though they can be reused.

/singleton/reagent/drink/nuka_cola //Blatant fallout reference
	name = "Nuka Cola"
	description = "Cola, cola never changes."
	color = "#706a58"
	adj_sleepy = -2
	caffeine = 1
	taste_description = "cola"
	carbonated = TRUE

	value = 0.13

	glass_icon_state = "nuka_colaglass"
	glass_name = "glass of Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_center_of_mass = list("x"=16, "y"=6)

/singleton/reagent/drink/nuka_cola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(20)
		M.druggy = max(M.druggy, 30)
		M.dizziness += 5
		M.drowsiness = 0

/singleton/reagent/alcohol/amasec //Blatant warhammer40k reference
	name = "Amasec"
	description = "Official drink of the Gun Club!"
	reagent_state = LIQUID
	color = "#e3e45e"
	strength = 25
	taste_description = "dark and metallic"

	value = 0.16

	glass_icon_state = "amasecglass"
	glass_name = "glass of Amasec"
	glass_desc = "Always handy before COMBAT!!!"
	glass_center_of_mass = list("x"=16, "y"=9)

// Seems to be a player character reference?
/singleton/reagent/drink/tea/kira_tea
	name = "Kira Tea"
	description = "A sweet take on a fizzy favorite."
	color = "#B98546"
	taste_description = "fizzy citrus tea"
	carbonated = TRUE

	glass_icon_state = "kiratea"
	glass_name = "glass of kira tea"
	glass_desc = "A sweet take on a fizzy favorite."


/singleton/reagent/drink/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	color = "#CCCC99"
	taste_description = "fruity sweetness"
	carbonated = TRUE

	glass_icon_state = "kiraspecial"
	glass_name = "glass of Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_center_of_mass = list("x"=16, "y"=12)

//Beepsky is more of an lrp meme.
/singleton/reagent/alcohol/beepsky_smash
	name = "Beepsky Smash"
	description = "Deny drinking this and prepare for THE LAW."
	reagent_state = LIQUID
	color = "#808000"
	strength = 35
	taste_description = "JUSTICE"

	value = 0.2

	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
	glass_center_of_mass = list("x"=18, "y"=10)

/singleton/reagent/alcohol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.Stun(2)

//Blatant hitchhikers reference. however, could be considered for keeping around because its soul.
/singleton/reagent/alcohol/gargleblaster
	name = "Pan-Galactic Gargle Blaster"
	description = "Whoah, this stuff looks volatile!"
	reagent_state = LIQUID
	color = "#afb4e7"
	strength = 50
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"

	value = 0.21

	glass_icon_state = "gargleblasterglass"
	glass_name = "glass of Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
	glass_center_of_mass = list("x"=17, "y"=6)

// Mime reference drink
/singleton/reagent/alcohol/silencer
	name = "Silencer"
	description = "A drink from Mime Heaven."
	nutriment_factor = 1
	color = "#7f7f7f"
	strength = 50
	taste_description = "a pencil eraser"

	value = 0.135

	glass_icon_state = "silencerglass"
	glass_name = "glass of Silencer"
	glass_desc = "A drink from mime Heaven."
	glass_center_of_mass = list("x"=16, "y"=9)

// Singulo meme drink
/singleton/reagent/alcohol/singulo
	name = "Singulo"
	description = "A blue-space beverage!"
	color = "#2E6671"
	strength = 50
	taste_description = "concentrated matter"

	value = 0.2

	glass_icon_state = "singulo"
	glass_name = "glass of Singulo"
	glass_desc = "A blue-space beverage."
	glass_center_of_mass = list("x"=17, "y"=4)

// This whole section is stuff that seems to be ported over from Bay that as far as I can tell, has no in game reason to exist. That being said,
// I'll talk to a lore master about either these things being removed or repurposed.
/singleton/reagent/alcohol/aloe
	name = "Aloe"
	description = "So very, very, very good."
	color = "#ffff00"
	strength = 15
	taste_description = "sweet 'n creamy"

	value = 0.17

	glass_icon_state = "aloe"
	glass_name = "glass of Aloe"
	glass_desc = "Very, very, very good."
	glass_center_of_mass = list("x"=17, "y"=8)

/singleton/reagent/alcohol/acid_spit
	name = "Acid Spit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	reagent_state = LIQUID
	color = "#8de45e"
	strength = 25
	taste_description = "stomach acid"

	value = 0.15

	glass_icon_state = "acidspitglass"
	glass_name = "glass of Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."
	glass_center_of_mass = list("x"=16, "y"=7)

/singleton/reagent/alcohol/atomicbomb
	name = "Atomic Bomb"
	description = "Nuclear proliferation never tasted so good."
	reagent_state = LIQUID
	color = "#996633"
	strength = 50
	druggy = 50
	taste_description = "da bomb"

	value = 0.21

	glass_icon_state = "atomicbombglass"
	glass_name = "glass of Atomic Bomb"
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."
	glass_center_of_mass = list("x"=15, "y"=7)

/singleton/reagent/alcohol/coffee/b52
	name = "B-52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#996633"
	strength = 35
	taste_description = "angry and irish"

	value = 0.17

	glass_icon_state = "b52glass"
	glass_name = "glass of B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."
