/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.

	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/
/singleton/reagent/nutriment/coating
	nutriment_factor = 4 //Less dense than the food itself, but coatings still add extra calories
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"
	taste_description = "some sort of frying coating"

/singleton/reagent/nutriment/coating/digest(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	var/nut_fact = holder.reagent_data[type]["cooked"] ? nutriment_factor : nutriment_factor / 2 // it's the nut fact
	M.heal_organ_damage(regen_factor * removed, 0)
	M.adjustNutritionLoss(-nut_fact * removed)
	M.nutrition_attrition_rate = clamp(M.nutrition_attrition_rate + attrition_factor, 1, 2)
	M.add_chemical_effect(CE_BLOODRESTORE, blood_factor * removed)
	M.intoxication -= min(M.intoxication,nut_fact*removed*0.05) //Nutrients can absorb alcohol.

/singleton/reagent/nutriment/coating/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if (!holder.reagent_data[type]["cooked"])
		//Raw coatings will sometimes cause vomiting
		if (ishuman(M) && prob(1))
			var/mob/living/carbon/human/H = M
			H.delayed_vomit()
	. = ..()

/singleton/reagent/nutriment/coating/initialize_data(var/list/newdata, var/datum/reagents/holder) // Called when the reagent is created.
	var/list/data = ..()
	LAZYSET(data, "cooked", istype(holder?.my_atom,/obj/item/reagent_containers/food/snacks))
	if(data["cooked"])
		name = cooked_name
	return data

		//Batter which is part of objects at compiletime spawns in a cooked state

/singleton/reagent/nutriment/coating/mix_data(var/list/newdata, var/newamount, var/datum/reagents/holder)
	var/list/data = ..()
	LAZYSET(data, "cooked", LAZYACCESS(newdata, "cooked"))
	return data

/singleton/reagent/nutriment/coating/batter
	name = "Batter Mix"
	cooked_name = "batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"
	taste_description = "batter"
	condiment_name = "Batter Jar"
	condiment_desc = "A vat of the most artery clogging frying ingredient around. Pour into beaker before attempting to coat ingredients."
	condiment_icon_state = "batter"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/coating/beerbatter
	name = "Beer Batter Mix"
	cooked_name = "beer batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"
	taste_description = "beer-batter"

/singleton/reagent/nutriment/coating/beerbatter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.intoxication += removed*0.02 //Very slightly alcoholic

//
//Instant Juice
//
/singleton/reagent/nutriment/instantjuice
	name = "Juice Powder"
	description = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/singleton/reagent/nutriment/instantjuice/grape
	name = "Grape Juice Powder"
	description = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/singleton/reagent/nutriment/instantjuice/orange
	name = "Orange Juice Powder"
	description = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/singleton/reagent/nutriment/instantjuice/watermelon
	name = "Watermelon Juice Powder"
	description = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/singleton/reagent/nutriment/instantjuice/apple
	name = "Apple Juice Powder"
	description = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

//
// Condiments
//
/singleton/reagent/nutriment/soysauce
	name = "Soy Sauce"
	description = "A salty sauce made from the soy plant."
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"
	taste_description = "umami"
	taste_mult = 1.1
	condiment_name = "soy sauce"
	condiment_desc = "A salty soy-based flavoring."
	condiment_icon_state = "soysauce"

/singleton/reagent/nutriment/ketchup
	name = "Ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"
	taste_description = "ketchup"
	condiment_name = "ketchup"
	condiment_desc = "You feel more American already."
	condiment_icon_state = "ketchup"
	condiment_center_of_mass = list("x"=16, "y"=6)

/singleton/reagent/nutriment/sprinkles
	name = "Sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1
	color = "#FF00FF"
	taste_description = "sweetness"
	condiment_name = "bottle of sprinkles"
	condiment_icon_state = "sprinklesbottle"
	condiment_center_of_mass = list("x"=16, "y"=10)
	value = 0.05

/singleton/reagent/nutriment/barbecue
	name = "Barbecue Sauce"
	description = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#4F330F"
	condiment_name = "barbecue sauce"
	condiment_icon_state = "barbecue"

/singleton/reagent/nutriment/garlicsauce
	name = "Garlic Sauce"
	description = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	reagent_state = LIQUID
	nutriment_factor = 4
	color = "#d8c045"
	condiment_name = "garlic sauce"
	condiment_desc = "Perfect for repelling vampires and/or potential dates."
	condiment_icon_state = "garlic_sauce"

/singleton/reagent/nutriment/garlicsauce/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(.)
		M.add_chemical_effect(CE_ANTIPARASITE, 10)

/singleton/reagent/nutriment/sweet_chili
	name = "Sweet Chili Sauce"
	description = "Spicy AND sweet!"
	reagent_state = LIQUID
	color = "#dd4103"
	taste_description = "sweet chili"
	taste_mult = 1.5
	value = 0.2
	condiment_name = "sweet chili"
	condiment_desc = "Sweet chili sauce, for those who want spicy food but are afraid to commit."
	condiment_icon_state = "sweet_chili"

/singleton/reagent/nutriment/mayonnaise
	name = "Mayonnaise"
	description = "Mayonnaise, a staple classic for sandwiches."
	taste_description = "mayonnaise"
	reagent_state = LIQUID
	nutriment_factor = 4
	color = "#F0EBD8"
	condiment_name = "mayonnaise"
	condiment_desc = "Great for sandwiches!"
	condiment_icon_state = "mayonnaise"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/sodiumchloride
	name = "Salt"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = 30
	taste_description = "salt"
	condiment_name = "salt shaker"
	condiment_desc = "Salt. From space oceans, presumably."
	condiment_icon_state = "saltshakersmall"
	condiment_center_of_mass = list("x"=17, "y"=11)
	value = 0.11

/singleton/reagent/sodiumchloride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.intoxication -= min(M.intoxication,removed*2) //Salt absorbs alcohol
	M.adjustHydrationLoss(2*removed)

/singleton/reagent/sodiumchloride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	overdose(M, alien, removed, holder)

/singleton/reagent/sodiumchloride/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.intoxication -= min(M.intoxication,removed*20)
	M.adjustHydrationLoss(20*removed)
	M.adjustToxLoss(removed*2)
	M.confused = max(M.confused, 20)
	if(prob(2))
		M.emote("twitch")
	if(prob(5))
		to_chat(M, SPAN_WARNING(pick("You're beginning to lose your appetite.","Your mouth is so incredibly dry.","You feel really confused.","What was I just thinking of?","Where am I?","Your muscles are tingling.")))

/singleton/reagent/blackpepper
	name = "Black Pepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	color = "#000000"
	taste_description = "pepper"
	fallback_specific_heat = 1.25
	condiment_name = "pepper mill"
	condiment_desc = "Often used to flavor food or make people sneeze."
	condiment_icon_state = "peppermillsmall"
	condiment_center_of_mass = list("x"=17, "y"=11)
	value = 0.1

/singleton/reagent/frostoil
	name = "Frost Oil"
	description = "A special oil that chemically chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#005BCC"
	taste_description = "mint"
	taste_mult = 1.5
	value = 0.2

	fallback_specific_heat = 15
	default_temperature = T0C - 20
	condiment_name = "coldsauce"
	condiment_desc = "Leaves the tongue numb in its passage."
	condiment_icon_state = "coldsauce"

/singleton/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.bodytemperature = max(M.bodytemperature - 5 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent(/singleton/reagent/capsaicin, 5)

/singleton/reagent/capsaicin
	name = "Capsaicin Oil"
	description = "This is what makes chilis hot."
	reagent_state = LIQUID
	color = "#B31008"
	taste_description = "hot peppers"
	taste_mult = 1.5
	fallback_specific_heat = 2
	value = 0.2
	condiment_name = "hotsauce"
	condiment_desc = "Hot sauce. It's in the name."
	condiment_icon_state = "hotsauce"

	var/agony_dose = 15 // Capsaicin required to proc agony. (3 to 5 chilis.)
	var/agony_amount = 1
	var/discomfort_message = SPAN_DANGER("Your insides feel uncomfortably hot.")
	var/slime_temp_adj = 10

/singleton/reagent/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.5 * removed)

/singleton/reagent/capsaicin/initial_effect(var/mob/living/carbon/M, var/alien)
	if(HAS_TRAIT(M, TRAIT_ORIGIN_IGNORE_CAPSAICIN))
		return
	to_chat(M, discomfort_message)

/singleton/reagent/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return

		if(HAS_TRAIT(H, TRAIT_ORIGIN_IGNORE_CAPSAICIN))
			return

	if(M.chem_doses[type] >= agony_dose && prob(5))
		to_chat(M, discomfort_message)

		M.visible_message("<b>[M]</b> [pick("dry heaves!", "coughs!", "splutters!")]")
		M.apply_effect(agony_amount, DAMAGE_PAIN, 0)

	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj

	holder.remove_reagent(/singleton/reagent/frostoil, 5)

#define EYES_PROTECTED 1
#define EYES_MECH 2

/singleton/reagent/capsaicin/condensed
	name = "Condensed Capsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly.
	color = "#B31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = SPAN_DANGER("You feel like your insides are burning!")
	slime_temp_adj = 15
	fallback_specific_heat = 4
	value = 0.5

/singleton/reagent/capsaicin/condensed/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/no_pain = 0
	var/obj/item/eye_protection = null
	var/obj/item/face_protection = null

	var/list/protection
	if(istype(M, /mob/living/carbon/human))
		if(M.isSynthetic())
			return
		var/mob/living/carbon/human/H = M
		protection = list(H.head, H.glasses, H.wear_mask)
		if(!H.can_feel_pain())
			no_pain = 1

		// Robo-eyes are immune to pepperspray now. Wee.
		var/obj/item/organ/internal/eyes/E = H.get_eyes()
		if (istype(E) && (E.status & (ORGAN_ROBOT|ORGAN_ADV_ROBOT)))
			eyes_covered |= EYES_MECH
	else
		protection = list(M.wear_mask)

	for(var/obj/item/I in protection)
		if(I)
			if(I.body_parts_covered & EYES)
				eyes_covered |= EYES_PROTECTED
				eye_protection = I.name
			if((I.body_parts_covered & FACE) && !(I.item_flags & ITEM_FLAG_FLEXIBLE_MATERIAL))
				mouth_covered = 1
				face_protection = I.name

	var/message = null
	if(eyes_covered)
		if (!mouth_covered && (eyes_covered & EYES_PROTECTED))
			message = SPAN_WARNING("Your [eye_protection] protects your eyes from the pepperspray!")
		else if (eyes_covered & EYES_MECH)
			message = SPAN_WARNING("Your mechanical eyes are invulnerable to pepperspray!")
	else
		message = SPAN_WARNING("The pepperspray gets in your eyes!")
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, 15)
			M.eye_blind = max(M.eye_blind, 5)
		else
			M.eye_blurry = max(M.eye_blurry, 25)
			M.eye_blind = max(M.eye_blind, 10)

	if(mouth_covered)
		if(!message)
			message = SPAN_WARNING("Your [face_protection] protects you from the pepperspray!")
	else if(!no_pain)
		message = SPAN_DANGER("Your face and throat burn!")
		if(prob(25))
			M.visible_message("<b>[M]</b> [pick("coughs!","coughs hysterically!","splutters!")]")
		M.apply_effect(30, DAMAGE_PAIN)

/singleton/reagent/capsaicin/condensed/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	M.apply_effect(10, DAMAGE_PAIN)
	if(prob(5))
		M.visible_message(SPAN_WARNING("[M] [pick("dry heaves!","coughs!","splutters!")]"),
							SPAN_DANGER("You feel like your insides are burning!"))
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent(/singleton/reagent/frostoil, 5)

#undef EYES_PROTECTED
#undef EYES_MECH

//
// Ingredients
//
/singleton/reagent/nutriment/honey
	name = "Honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	nutriment_factor = 8
	color = "#FFFF00"
	taste_description = "honey"
	condiment_name = "honey"
	condiment_desc = "A jar of sweet and viscous honey."
	condiment_icon_state = "honey"
	germ_adjust = 5

/singleton/reagent/nutriment/flour
	name = "Flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	taste_description = "chalky wheat"
	condiment_name = "flour sack"
	condiment_desc = "A big bag of flour. Good for baking!"
	condiment_icon_state = "flour"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/flour/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T, /turf/space))
		if(locate(/obj/effect/decal/cleanable/flour) in T)
			return

		new /obj/effect/decal/cleanable/flour(T)

/singleton/reagent/nutriment/coco
	name = "Coco Powder"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"
	taste_description = "bitterness"
	taste_mult = 1.3
	condiment_name = "Cocoa Powder Can"
	condiment_icon_state = "cocoapowder"
	condiment_desc = "A can full of chocolately powder. Try not to think of the calories."
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/rice
	name = "Rice"
	description = "Enjoy the great taste of nothing."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	taste_description = "rice"
	taste_mult = 0.4
	condiment_name = "rice sack"
	condiment_icon_state = "rice"
	condiment_desc = "A big bag of rice. Good for cooking!"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/moss
	name = "Moss"
	description = "Enjoy the Konyanger taste of nothing."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	taste_description = "moss"
	taste_mult = 0.4
	condiment_name = "moss sack"
	condiment_icon_state = "moss"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/grapejelly
	name = "Grape Jelly"
	description = "A jelly produced from blending grapes."
	color = "#410083"
	taste_description = "grapes"
	condiment_name = "Grape Jelly"
	condiment_desc = "A jar of jelly derived from grapes. Superior to cherry jelly."
	condiment_icon_state = "grapejelly"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801E28"
	taste_description = "cherry"
	taste_mult = 1.3
	condiment_name = "cherry jelly jar"
	condiment_desc = "Great with peanut butter!"
	condiment_icon_state = "jellyjar"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/peanutbutter
	name = "Peanut Butter"
	description = "Clearer the better spread, exception for those who are deathly allergic."
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#AD7937"
	taste_description = "peanut butter"
	taste_mult = 2
	condiment_name = "peanut butter jar"
	condiment_desc = "Great with jelly!"
	condiment_icon_state = "pbjar"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/choconutspread
	name = "Choco-Nut Spread"
	description = "Creamy chocolate spread with a nutty undertone."
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#2c1000"
	taste_description = "nutty chocolate"
	taste_mult = 2
	condiment_name = "NTella jar"
	condiment_desc = "Originally called 'Entella', it was rebranded after being bought by Getmore. Some Humans insist this chocolate hazelnut spread might be the best thing they've ever created."
	condiment_icon_state = "NTellajar"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/groundpeanuts
	name = "Ground Roasted Peanuts"
	description = "Roughly ground roasted peanuts."
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#AD7937"
	taste_description = "roasted peanuts"
	taste_mult = 2
	condiment_name = "ground roasted peanuts sack"
	condiment_icon_state = "peanut"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/mint
	name = "Mint"
	description = "Also known as Mentha."
	reagent_state = LIQUID
	color = "#CFFFE5"
	taste_description = "mint"
	value = 0.14

/singleton/reagent/nutriment/glucose
	name = "Glucose"
	color = "#FFFFFF"
	injectable = 1
	taste_description = "sweetness"

/singleton/reagent/enzyme
	name = "Universal Enzyme"
	description = "A universal enzyme used in the preparation of certain chemicals and foods."
	reagent_state = LIQUID
	color = "#365E30"
	overdose = REAGENTS_OVERDOSE
	taste_description = "sweetness"
	taste_mult = 0.7
	fallback_specific_heat = 1
	condiment_name = "universal enzyme"
	condiment_icon_state = "enzyme"
	condiment_center_of_mass = list("x"=18, "y"=7)
	value = 0.2

/singleton/reagent/spacespice
	name = "Space Spice"
	description = "An exotic blend of spices for cooking. It must flow."
	reagent_state = SOLID
	color = "#e08702"
	taste_description = "spices"
	taste_mult = 1.5
	fallback_specific_heat = 2
	condiment_name = "bottle of space spice"
	condiment_icon_state = "spacespicebottle"
	condiment_center_of_mass = list("x"=16, "y"=10)

/singleton/reagent/nutriment/vanilla
	name = "Vanilla Extract"
	description = "The extract from vanilla beans..."
	color = "#e8efe5"
	taste_description = "vanilla"
	condiment_desc = "A cute little bottle holding great and intense powers within. The power of Vanilla extract."
	condiment_icon_state = "vanilla"

/singleton/reagent/spacespice/pumpkinspice
	name = "Pumpkin Spice"
	description = "A delicious seasonal flavoring."
	color = "#AE771C"
	taste_description = "autumn bliss"
	condiment_name = "Pumpkin Spice"
	condiment_desc = "Every teenager's favorite seasonal ingredient."
	condiment_icon_state = "pumpkinspice"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/browniemix
	name = "Brownie Mix"
	description = "A dry mix for making delicious brownies."
	reagent_state = SOLID
	color = "#441a03"
	taste_description = "chocolate"

/singleton/reagent/nutriment/gelatin
	name = "Gelatin"
	description = "A translucent, typically flavorless powder used in cooking."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#CBBCA9"
	taste_description = "jiggliness"
	condiment_name = "Gelatin Box"
	condiment_icon_state = "gello"
	condiment_desc = "An unassuming box of raw powdered gelatin. Let's get jiggly."
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/drink/ice
	name = "Ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494"
	taste_description = "ice"
	taste_mult = 1.5
	hydration = 8

	value = 0

	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

	default_temperature = T0C - 10

/singleton/reagent/drink/nothing
	name = "Nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	value = 0

	glass_icon_state = "nothing"
	glass_name = "glass of nothing"
	glass_desc = "Absolutely nothing."

/singleton/reagent/condiment/syrup_simple
	name = "Simple Syrup"
	description = "Thick, unflavored syrup used as a base for drinks or flavorings."
	taste_description = "molasses"
	color = "#ccccbb"
	glass_name = "simple syrup"
	glass_desc = "Thick, unflavored syrup used as a base for drinks or flavorings."
	condiment_desc = "Thick, flavorless, pointless, joyless syrup. Needs an extra something-something. Unless you're just trying to feed bees."
	condiment_icon_state = "syrup_simple"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/caramel
	name = "Caramel Sugar"
	reagent_state = SOLID
	description = "Caramelised sugar, used in various recipes."
	taste_description = "toasty sweetness"

/singleton/reagent/drink/caramel
	name = "Caramel Sauce"
	reagent_state = LIQUID
	description = "A caramel-based sauce. Now you're caramel dancin'."
	taste_description = "toasty sweet cream"
	taste_mult = 2

/singleton/reagent/drink/boba
	name = "Boba Pearls"
	description = "Tiny balls made of Tapioca, waiting to be added to a drink or flavored."
	reagent_state = SOLID
	nutrition = 13
	hydration = 0
	color = "#1c1727"
	taste_description = "tapioca"

//
// Syrup
//
/singleton/reagent/drink/mintsyrup
	name = "Mint Syrup"
	description = "A simple syrup that tastes strongly of mint."
	color = "#539830"
	taste_description = "mint"
	taste_mult = 5
	glass_icon_state = "mint_syrupglass"
	glass_name = "glass of mint syrup"
	glass_desc = "Pure mint syrup. Prepare your tastebuds."
	glass_center_of_mass = list("x"=17, "y"=6)

/singleton/reagent/drink/grenadine
	name = "Grenadine Syrup"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F"
	taste_description = "100% pure pomegranate"

	glass_icon_state = "grenadineglass"
	glass_name = "glass of grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	glass_center_of_mass = list("x"=17, "y"=6)

/singleton/reagent/condiment/syrup_chocolate
	name = "Chocolate Syrup"
	description = "Thick chocolate syrup used to flavor drinks."
	taste_description = "chocolate"
	color = "#542a0c"
	glass_name = "chocolate syrup"
	glass_desc = "Thick chocolate syrup used to flavor drinks."
	condiment_desc = "Must... resist... urge... to directly... pour... in mouth..."
	condiment_icon_state = "syrup_chocolate"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_caramel
	name = "Caramel Syrup"
	description = "Thick caramel syrup used to flavor drinks."
	taste_description = "caramel"
	color = "#85461e"
	glass_name = "caramel syrup"
	glass_desc = "Thick caramel syrup used to flavor drinks."
	condiment_desc = "There wasn't enough sugar in your sugar so we added sugar to it."
	condiment_icon_state = "syrup_caramel"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_vanilla
	name = "Vanilla Syrup"
	description = "Thick vanilla syrup used to flavor drinks."
	taste_description = "vanilla"
	color = "#f3e5ab"
	glass_name = "vanilla syrup"
	glass_desc = "Thick vanilla syrup used to flavor drinks."
	condiment_desc = "A bottle of vanilla flavored syrup. For pancakes, drinks and... whatever else!"
	condiment_icon_state = "syrup_vanilla"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_pumpkin
	name = "Pumpkin Spice Syrup"
	description = "Thick spiced pumpkin syrup used to flavor drinks."
	taste_description = "spiced pumpkin"
	color = "#d88b4c"
	glass_name = "pumpkin spice syrup"
	glass_desc = "Thick spiced pumpkin syrup used to flavor drinks."
	condiment_desc = "A concentrated, emergency ration of pumpkin spice to apply in case of cold weather."
	condiment_icon_state = "syrup_pumpkin"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_berry
	name = "Berry Syrup"
	description = "Thick berry syrup used to flavor drinks."
	taste_description = "berry"
	color = "#c00726"
	glass_name = "berry syrup"
	glass_desc = "Thick berry syrup used to flavor drinks."
	condiment_desc = "It's not just berry, it's VERY berry! Which berry? Don't worry about it!"
	condiment_icon_state = "syrup_berry"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_strawberry
	name = "Strawberry Syrup"
	description = "Thick strawberry syrup used to flavor drinks."
	taste_description = "strawberry"
	color = "#b40000"
	glass_name = "strawberry syrup"
	glass_desc = "Thick strawberry syrup used to flavor drinks."
	condiment_desc = "Made with real strawberries! Probably! Somewhere in there, I'm sure!"
	condiment_icon_state = "syrup_strawberry"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_blueberry
	name = "Blueberry Syrup"
	description = "Thick blueberry syrup used to flavor drinks."
	taste_description = "blueberry"
	color = "#0a0094"
	glass_name = "blueberry syrup"
	glass_desc = "Thick blueberry syrup used to flavor drinks."
	condiment_desc = "Da ba dee da be da."
	condiment_icon_state = "syrup_blueberry"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_raspberry
	name = "Raspberry Syrup"
	description = "Thick raspberry syrup used to flavor drinks."
	taste_description = "raspberry"
	color = "#ad0042"
	glass_name = "raspberry syrup"
	glass_desc = "Thick raspberry syrup used to flavor drinks."
	condiment_desc = "Ra ra raspberry concentrated flavoring!"
	condiment_icon_state = "syrup_raspberry"
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_blackraspberry
	name = "Black Raspberry Syrup"
	description = "Thick black raspberry syrup used to flavor drinks."
	taste_description = "black raspberry"
	color = "#1b1618"
	glass_name = "black raspberry syrup"
	glass_desc = "Thick black raspberry syrup used to flavor drinks."
	taste_mult = 5
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_blueraspberry
	name = "Blue Raspberry Syrup"
	description = "Thick blue raspberry syrup used to flavor drinks."
	taste_description = "blue raspberry"
	color = "#21154d"
	glass_name = "blue raspberry syrup"
	glass_desc = "Thick blue raspberry syrup used to flavor drinks."
	taste_mult = 5
	condiment_desc = "Now with extra GMOs!"
	condiment_icon_state = "syrup_blue_raspberry"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/syrup_glowberry
	name = "Glowberry Syrup"
	description = "Thick glowberry syrup used to flavor drinks."
	taste_description = "glowberry"
	color = "#f3e5ab"
	glass_name = "glowberry syrup"
	glass_desc = "Thick glowberry syrup used to flavor drinks."
	taste_mult = 5

/singleton/reagent/condiment/syrup_poisonberry
	name = "Poison Berry Syrup"
	description = "Thick poison berry syrup used to flavor drinks."
	taste_description = "something sweet"
	color = "#f3e5ab"
	glass_name = "poison berry syrup"
	glass_desc = "Thick poison berry syrup used to flavor drinks."
	taste_mult = 5

/singleton/reagent/condiment/syrup_deathberry
	name = "Death Berry Syrup"
	description = "Thick death berry syrup used to flavor drinks."
	taste_description = "something sweet"
	color = "#f3e5ab"
	glass_name = "death berry syrup"
	glass_desc = "Thick death berry syrup used to flavor drinks."
	taste_mult = 5

//
//Milk
//
/singleton/reagent/drink/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF"
	taste_description = "milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"

	condiment_name = "space milk"
	condiment_desc = "It's milk. White and nutritious goodness!"
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "milk"

	default_temperature = T0C + 5

/singleton/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/singleton/reagent/capsaicin, 10 * removed)

/singleton/reagent/drink/milk/steamed_milk
	name = "Steamed Milk"
	description = "A frothy opaque white liquid made by adding steam to milk."
	color = "#bebebb"
	taste_description =  "hot creamy milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of steamed milk"
	glass_desc = "Hot and creamy milk. Would go great with coffee!"
	default_temperature = T0C + 66

/singleton/reagent/drink/milk/cream
	name = "Cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF"
	taste_description = "creamy milk"

	value = 0.12

	glass_icon_state = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."

	condiment_name = "milk cream"
	condiment_desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "cream"

/singleton/reagent/drink/milk/soymilk
	name = "Soy Milk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7"
	taste_description = "soy milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of soy milk"
	glass_desc = "White and nutritious soy goodness!"

	condiment_name = "soy milk"
	condiment_desc = "It's soy milk. White and nutritious goodness!"
	condiment_icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	condiment_icon_state = "soymilk"

/singleton/reagent/drink/milk/chocolate
	name = "Chocolate Milk"
	description = "A mixture of perfectly healthy milk and delicious chocolate."
	color = "#74533b"
	taste_description = "chocolate milk"
	value = 0.11

	glass_icon_state = "glass_chocolate"
	glass_name = "glass of chocolate milk"
	glass_desc = "A mixture of perfectly healthy milk and delicious chocolate."

/singleton/reagent/drink/milk/strawberry
	name = "Strawberry Milk"
	description = "A mixture of perfectly healthy milk and delicious strawberry."
	color = "#fc5a8d"
	taste_description = "strawberry milk"

	glass_icon_state = "glass_strawberry"
	glass_name = "glass of strawberry milk"
	glass_desc = "A mixture of perfectly healthy milk and delicious strawberry."
