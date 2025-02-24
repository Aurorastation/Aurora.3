* Drinks */

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

/singleton/reagent/drink/limejuice
	name = "Lime Juice"
	description = "The sweet-sour juice of limes."
	color = "#6dbd61"
	taste_description = "tart citrus"
	taste_mult = 1.1

	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/singleton/reagent/drink/orangejuice
	name = "Orange Juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108"
	taste_description = "oranges"

	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

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
