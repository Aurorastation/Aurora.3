// Food
/singleton/reagent/nutriment
	name = "Nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 2
	var/nutriment_factor = 8 // Per removed in digest.
	var/hydration_factor = 0 // Per removed in digest.
	var/blood_factor = 2
	var/regen_factor = 0.8
	var/injectable = 0
	var/attrition_factor = -(REM * 4)/BASE_MAX_NUTRITION // Decreases attrition rate.
	color = "#664330"
	unaffected_species = IS_MACHINE
	taste_description = "food"
	fallback_specific_heat = 1.25
	value = 0.1

/singleton/reagent/nutriment/mix_data(var/list/newdata, var/newamount, var/datum/reagents/holder)
	if(isemptylist(newdata))
		return

	//add the new taste data
	var/list/data = ..()
	for(var/taste in newdata)
		if(taste in data)
			data[taste] += newdata[taste]
		else
			data[taste] = newdata[taste]

	//cull all tastes below 10% of total
	var/totalFlavor = 0
	for(var/taste in data)
		totalFlavor += data[taste]
	if(totalFlavor)
		for(var/taste in data) //cull the tasteless
			if(data[taste] && data[taste]/totalFlavor < 0.1)
				data -= taste
	. = data

/singleton/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(injectable)
		affect_ingest(M, alien, removed, holder)

/singleton/reagent/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.adjustToxLoss(1.5 * removed)
	else if(alien != IS_UNATHI)
		digest(M,removed, holder = holder)

/singleton/reagent/nutriment/proc/digest(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(regen_factor * removed, 0)
	M.adjustNutritionLoss(-nutriment_factor * removed)
	M.nutrition_attrition_rate = clamp(M.nutrition_attrition_rate + attrition_factor, 1, 2)
	M.add_chemical_effect(CE_BLOODRESTORE, blood_factor * removed)
	M.intoxication -= min(M.intoxication,nutriment_factor*removed*0.05) //Nutrients can absorb alcohol.

//
//Lipozine?
//
/singleton/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE
	taste_description = "mothballs"
	value = 0.11

/singleton/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(10*removed)
	M.overeatduration = 0

/singleton/reagent/lipozine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(10*removed)
	if(prob(2))
		to_chat(M, SPAN_DANGER("You feel yourself wasting away."))
		M.adjustHalLoss(10)

//
// Protein
//
/singleton/reagent/nutriment/protein // Bad for Skrell!
	name = "Animal Protein"
	color = "#440000"
	blood_factor = 3
	taste_description = "some sort of protein"
	var/vegan = FALSE

/singleton/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		digest(M,removed, holder = holder)
		return
	if(HAS_TRAIT(M, TRAIT_ORIGIN_NO_ANIMAL_PROTEIN) && !vegan)
		if(prob(2))
			var/list/uncomfortable_messages = list(
				"You shouldn't have eaten that...",
				"Your stomach cramps!",
				"Your stomach hurts a bit...",
				"You feel a bit sick..."
			)
			to_chat(M, SPAN_WARNING(uncomfortable_messages))
	..()

/singleton/reagent/nutriment/protein/tofu //Good for Skrell!
	name = "Tofu Protein"
	color = "#fdffa8"
	taste_description = "tofu"
	vegan = TRUE

/singleton/reagent/nutriment/protein/seafood // Good for Skrell!
	name = "Seafood Protein"
	color = "#f5f4e9"
	taste_description = "fish"
	vegan = TRUE

/singleton/reagent/nutriment/protein/seafood/mollusc
	name = "Mollusc Protein"
	taste_description = "cold, bitter slime"
	hydration_factor = 6
	vegan = TRUE

/singleton/reagent/nutriment/protein/seafood/cosmozoan
	name = "Cosmozoan Protein"
	taste_description = "cold, bitter slime"
	hydration_factor = 8
	vegan = TRUE

/singleton/reagent/nutriment/protein/seafood/cosmozoan/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/singleton/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "Egg Yolk"
	color = "#FFFFAA"
	taste_description = "egg"
	condiment_name = "Egg Yolk Carton"
	condiment_desc = "A carton full of Egg Yolk."
	condiment_icon_state = "eggyolkcarton"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/nutriment/egg/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		digest(M, removed, holder = holder)
		return
	..()

/singleton/reagent/nutriment/protein/cheese // Also bad for skrell.
	name = "Cheese"
	color = "#EDB91F"
	taste_description = "cheese"

//
//Fats
//
/singleton/reagent/nutriment/triglyceride
	name = "Triglyceride"
	description = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	reagent_state = SOLID
	nutriment_factor = 12
	color = "#ffdfb0"
	taste_description = "fat"
	condiment_name = "Triglyceride"
	condiment_desc = "A bottle full of Triglyceride. Feel the burn."
	condiment_icon_state = "triglyceridebottle"
	condiment_center_of_mass = list("x"=16, "y"=8)

//Unathi can digest fats too
/singleton/reagent/nutriment/triglyceride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		digest(M, removed, holder = holder)
		return
	..()

/singleton/reagent/nutriment/triglyceride/oil
	//Having this base class in case we want to add more variants of oil
	name = "Oil"
	description = "Oils are liquid fats."
	reagent_state = LIQUID
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0
	taste_description = "some sort of oil"
	taste_mult = 0.1

/singleton/reagent/nutriment/triglyceride/oil/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	if(amount >= 3)
		T.wet_floor(WET_TYPE_LUBE,amount)

//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/singleton/reagent/nutriment/triglyceride/oil/proc/heatdamage(var/mob/living/carbon/M, var/datum/reagents/holder)
	var/threshold = 360//Human heatdamage threshold
	var/datum/species/S = M.get_species(1)
	if (S && istype(S))
		threshold = S.heat_level_1

	//If temperature is too low to burn, return a factor of 0. no damage
	if (holder.get_temperature() < threshold)
		return 0

	//Step = degrees above heat level 1 for 1.0 multiplier
	var/step = 60
	if (S && istype(S))
		step = (S.heat_level_2 - S.heat_level_1)*1.5

	return min((holder.get_temperature() - threshold)/step, 2.5)

/singleton/reagent/nutriment/triglyceride/oil/corn
	name = "Corn Oil"
	description = "An oil derived from various types of corn."
	taste_description = "corn oil"
	condiment_name = "corn oil"
	condiment_desc = "A delicious oil used in cooking. Made from corn."
	condiment_icon_state = "cooking_oil"

/singleton/reagent/nutriment/triglyceride/oil/peanut
	name = "Peanut Oil"
	description = "A flavourful oil derived from roasted peanuts."
	color = "#ba8002"
	taste_description = "smoky peanut oil"
	taste_mult = 1
	condiment_name = "peanut oil"
	condiment_desc = "Tasteful and rich peanut oil used in cooking. Made from roasted peanuts."
	condiment_icon_state = "peanut_oil"

/singleton/reagent/nutriment/pumpkinpulp
	name = "Pumpkin Pulp"
	description = "The gooey insides of a slain pumpkin. This day is the greatest..."
	color = "#f9ab28"
	taste_description = "gooey pumpkin"
	condiment_name = "Pumpkin Pulp Jar"
	condiment_desc = "An orange jar with a picture of a pumpkin on its label. Spooky."
	condiment_icon_state = "pumpkinpulp"
	condiment_center_of_mass = list("x"=16, "y"=8)

/singleton/reagent/condiment/gravy
	name = "Gravy"
	description = "A thick sauce made from the juice of meat that occurs naturally during cooking."
	taste_description = "gravy"
	color = "#a36a35"
	condiment_desc = "A thick meaty sauce for your dishes."
	taste_mult = 3

//
// Chemistry things people probably shouldnt eat.
//
/singleton/reagent/nutriment/virusfood
	name = "Virus Food"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#899613"
	taste_description = "vomit"
	taste_mult = 2
	value = 0.15

//
// Ramen
//
/singleton/reagent/drink/dry_ramen
	name = "Dry Ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutrition = 1
	hydration = 0
	color = "#d44557"
	taste_description = "dry and cheap noodles"

/singleton/reagent/drink/hot_ramen
	name = "Hot Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#d44557"
	nutrition = 5
	hydration = 5
	adj_temp = 5
	taste_description = "wet and cheap noodles"

/singleton/reagent/drink/hell_ramen
	name = "Hell Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#a82323"
	nutrition = 5
	hydration = 5
	taste_description = "wet and cheap noodles on fire"
	adj_temp = 20
