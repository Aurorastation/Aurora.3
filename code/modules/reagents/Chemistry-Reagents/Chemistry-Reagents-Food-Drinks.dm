/* Food */
/decl/reagent/kois
	name = "K'ois"
	description = "A thick goopy substance, rich in K'ois nutrients."
	metabolism = REM * 4
	var/nutriment_factor = 10
	var/injectable = 0
	color = "#dcd9cd"
	taste_description = "boiled cabbage"
	unaffected_species = IS_MACHINE
	var/kois_type = 1
	fallback_specific_heat = 0.75

/decl/reagent/kois/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!ishuman(M))
		return
	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.heal_organ_damage(1.2 * removed, 1.2 * removed)
		M.adjustNutritionLoss(-nutriment_factor * removed)
		M.add_chemical_effect(CE_BLOODRESTORE, 6 * removed)

	else
		infect(M, alien, removed)

/decl/reagent/kois/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		infect(M, alien, removed)

/decl/reagent/kois/proc/infect(var/mob/living/carbon/human/H, var/alien, var/removed)
	var/obj/item/organ/internal/parasite/P = H.internal_organs_by_name["blackkois"]
	if((alien != IS_VAURCA) && !(istype(P) && P.stage >= 3))
		H.adjustToxLoss(1 * removed)
		switch(kois_type)
			if(1) //Normal
				if(!H.internal_organs_by_name["kois"] && prob(5*removed))
					var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
					var/obj/item/organ/internal/parasite/kois/infest = new()
					infest.replaced(H, affected)
			if(2) //Modified
				if(!H.internal_organs_by_name["blackkois"] && prob(10*removed))
					var/obj/item/organ/external/affected = H.get_organ(BP_HEAD)
					var/obj/item/organ/internal/parasite/blackkois/infest = new()
					infest.replaced(H, affected)

/decl/reagent/kois/clean
	name = "Filtered K'ois"
	description = "A strange, ketchup-like substance, filled with K'ois nutrients."
	color = "#ece9dd"
	taste_description = "cabbage soup"
	kois_type = 0
	fallback_specific_heat = 1

/decl/reagent/kois/black
	name = "Modified K'ois"
	description = "A thick goopy substance, rich in K'ois nutrients. This sample appears to be modified."
	color = "#31004A"
	taste_description = "tar"
	kois_type = 2
	fallback_specific_heat = 0.5

/* Food */
/decl/reagent/nutriment
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

/decl/reagent/nutriment/synthetic
	name = "Synthetic Nutriment"
	description = "A cheaper alternative to actual nutriment."
	taste_description = "cheap food"
	nutriment_factor = 6
	attrition_factor = (REM * 4)/BASE_MAX_NUTRITION // Increases attrition rate.

/decl/reagent/nutriment/mix_data(var/list/newdata, var/newamount, var/datum/reagents/holder)
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

/decl/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(injectable)
		affect_ingest(M, alien, removed, holder)

/decl/reagent/nutriment/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.adjustToxLoss(1.5 * removed)
	else if(alien != IS_UNATHI)
		digest(M,removed, holder = holder)

/decl/reagent/nutriment/proc/digest(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(regen_factor * removed, 0)
	M.adjustNutritionLoss(-nutriment_factor * removed)
	M.nutrition_attrition_rate = Clamp(M.nutrition_attrition_rate + attrition_factor, 1, 2)
	M.add_chemical_effect(CE_BLOODRESTORE, blood_factor * removed)
	M.intoxication -= min(M.intoxication,nutriment_factor*removed*0.05) //Nutrients can absorb alcohol.

/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.

	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/
/decl/reagent/nutriment/coating
	nutriment_factor = 4 //Less dense than the food itself, but coatings still add extra calories
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"
	taste_description = "some sort of frying coating"

/decl/reagent/nutriment/coating/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	to_chat(M, "Ugh, this raw [name] tastes disgusting.")

/decl/reagent/nutriment/coating/digest(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	var/nut_fact = holder.reagent_data[type]["cooked"] ? nutriment_factor : nutriment_factor / 2 // it's the nut fact
	M.heal_organ_damage(regen_factor * removed, 0)
	M.adjustNutritionLoss(-nut_fact * removed)
	M.nutrition_attrition_rate = Clamp(M.nutrition_attrition_rate + attrition_factor, 1, 2)
	M.add_chemical_effect(CE_BLOODRESTORE, blood_factor * removed)
	M.intoxication -= min(M.intoxication,nut_fact*removed*0.05) //Nutrients can absorb alcohol.

/decl/reagent/nutriment/coating/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if (!holder.reagent_data[type]["cooked"])
		//Raw coatings will sometimes cause vomiting
		if (ishuman(M) && prob(1))
			var/mob/living/carbon/human/H = M
			H.delayed_vomit()
	. = ..()

/decl/reagent/nutriment/coating/initialize_data(var/list/newdata, var/datum/reagents/holder) // Called when the reagent is created.
	var/list/data = ..()
	LAZYSET(data, "cooked", istype(holder?.my_atom,/obj/item/reagent_containers/food/snacks))
	if(data["cooked"])
		name = cooked_name
	return data

		//Batter which is part of objects at compiletime spawns in a cooked state

/decl/reagent/nutriment/coating/mix_data(var/list/newdata, var/newamount, var/datum/reagents/holder)
	var/list/data = ..()
	LAZYSET(data, "cooked", LAZYACCESS(newdata, "cooked"))
	return data

/decl/reagent/nutriment/coating/batter
	name = "Batter Mix"
	cooked_name = "batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"
	taste_description = "batter"

/decl/reagent/nutriment/coating/beerbatter
	name = "Beer Batter Mix"
	cooked_name = "beer batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"
	taste_description = "beer-batter"

/decl/reagent/nutriment/coating/beerbatter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.intoxication += removed*0.02 //Very slightly alcoholic

//==============================
/decl/reagent/nutriment/protein // Bad for Skrell!
	name = "Animal Protein"
	color = "#440000"
	blood_factor = 3
	taste_description = "meat"

/decl/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		digest(M,removed, holder = holder)
		return
	..()

/decl/reagent/nutriment/protein/tofu //Good for Skrell!
	name = "Tofu Protein"
	color = "#fdffa8"
	taste_description = "tofu"

/decl/reagent/nutriment/protein/seafood // Good for Skrell!
	name = "Seafood Protein"
	color = "#f5f4e9"
	taste_description = "fish"

/decl/reagent/nutriment/protein/seafood/mollusc
	name = "Mollusc Protein"
	taste_description = "cold, bitter slime"
	hydration_factor = 6

/decl/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "Egg Yolk"
	color = "#FFFFAA"
	taste_description = "egg"

/decl/reagent/nutriment/egg/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		digest(M, removed, holder = holder)
		return
	..()

/decl/reagent/nutriment/protein/cheese // Also bad for skrell.
	name = "Cheese"
	color = "#EDB91F"
	taste_description = "cheese"

//Fats
//=========================
/decl/reagent/nutriment/triglyceride
	name = "Triglyceride"
	description = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	reagent_state = SOLID
	nutriment_factor = 12
	color = "#CCCCCC"
	taste_description = "fat"

//Unathi can digest fats too
/decl/reagent/nutriment/triglyceride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		digest(M, removed, holder = holder)
		return
	..()

/decl/reagent/nutriment/triglyceride/oil
	//Having this base class in case we want to add more variants of oil
	name = "Oil"
	description = "Oils are liquid fats."
	reagent_state = LIQUID
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0
	taste_description = "some sort of oil"
	taste_mult = 0.1

/decl/reagent/nutriment/triglyceride/oil/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	if(amount >= 3)
		T.wet_floor(WET_TYPE_LUBE,amount)

//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/decl/reagent/nutriment/triglyceride/oil/proc/heatdamage(var/mob/living/carbon/M, var/datum/reagents/holder)
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

/decl/reagent/nutriment/triglyceride/oil/corn
	name = "Corn Oil"
	description = "An oil derived from various types of corn."
	taste_description = "corn oil"
	condiment_name = "corn oil"
	condiment_desc = "A delicious oil used in cooking. Made from corn."
	condiment_icon_state = "oliveoil"


/decl/reagent/nutriment/honey
	name = "Honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	nutriment_factor = 8
	color = "#FFFF00"
	taste_description = "honey"
	germ_adjust = 5

/decl/reagent/nutriment/flour
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

/decl/reagent/nutriment/flour/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T, /turf/space))
		if(locate(/obj/effect/decal/cleanable/flour) in T)
			return

		new /obj/effect/decal/cleanable/flour(T)

/decl/reagent/nutriment/flour/nfrihi
	name = "blizzard ear flour"
	taste_description = "chalky starch"
	color = "#DFDEA1"
	condiment_name = "Adhomian flour sack"

/decl/reagent/nutriment/coco
	name = "Coco Powder"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"
	taste_description = "bitterness"
	taste_mult = 1.3

/decl/reagent/nutriment/soysauce
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

/decl/reagent/nutriment/ketchup
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

/decl/reagent/nutriment/rice
	name = "Rice"
	description = "Enjoy the great taste of nothing."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	taste_description = "rice"
	taste_mult = 0.4
	condiment_name = "rice sack"
	condiment_icon_state = "rice"
	condiment_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801E28"
	taste_description = "cherry"
	taste_mult = 1.3

/decl/reagent/nutriment/virusfood
	name = "Virus Food"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#899613"
	taste_description = "vomit"
	taste_mult = 2

/decl/reagent/nutriment/sprinkles
	name = "Sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1
	color = "#FF00FF"
	taste_description = "sweetness"

/decl/reagent/nutriment/mint
	name = "Mint"
	description = "Also known as Mentha."
	reagent_state = LIQUID
	color = "#CF3600"
	taste_description = "mint"

/decl/reagent/nutriment/glucose
	name = "Glucose"
	color = "#FFFFFF"
	injectable = 1
	taste_description = "sweetness"

/decl/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE
	taste_description = "mothballs"

/decl/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(10*removed)
	M.overeatduration = 0

/decl/reagent/lipozine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(10*removed)
	if(prob(2))
		to_chat(M, SPAN_DANGER("You feel yourself wasting away."))
		M.adjustHalLoss(10)

/decl/reagent/nutriment/barbecue
	name = "Barbecue Sauce"
	description = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#4F330F"
	condiment_name = "barbecue sauce"
	condiment_icon_state = "barbecue"

/decl/reagent/nutriment/garlicsauce
	name = "Garlic Sauce"
	description = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	reagent_state = LIQUID
	nutriment_factor = 4
	color = "#d8c045"
	condiment_name = "garlic sauce"
	condiment_desc = "Perfect for repelling vampires and/or potential dates."

/* Non-food stuff like condiments */

/decl/reagent/sodiumchloride
	name = "Salt"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE
	taste_description = "salt"
	condiment_name = "salt shaker"
	condiment_desc = "Salt. From space oceans, presumably."
	condiment_icon_state = "saltshakersmall"
	condiment_center_of_mass = list("x"=17, "y"=11)

/decl/reagent/sodiumchloride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.intoxication -= min(M.intoxication,removed*2) //Salt absorbs alcohol
	M.adjustHydrationLoss(2*removed)

/decl/reagent/sodiumchloride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.intoxication -= min(M.intoxication,removed*20)
	M.adjustHydrationLoss(20*removed)
	M.adjustToxLoss(removed*2)

/decl/reagent/blackpepper
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

/decl/reagent/enzyme
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

/decl/reagent/frostoil
	name = "Frost Oil"
	description = "A special oil that chemically chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#005BCC"
	taste_description = "mint"
	taste_mult = 1.5

	fallback_specific_heat = 15
	default_temperature = T0C - 20
	condiment_name = "coldsauce"
	condiment_desc = "Leaves the tongue numb in its passage."
	condiment_icon_state = "coldsauce"

/decl/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent(/decl/reagent/capsaicin, 5)

/decl/reagent/capsaicin
	name = "Capsaicin Oil"
	description = "This is what makes chilis hot."
	reagent_state = LIQUID
	color = "#B31008"
	taste_description = "hot peppers"
	taste_mult = 1.5
	fallback_specific_heat = 2
	condiment_name = "hotsauce"
	condiment_desc = "You can almost TASTE the stomach ulcers now!"
	condiment_icon_state = "hotsauce"

	var/agony_dose = 5
	var/agony_amount = 1
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10


/decl/reagent/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.5 * removed)

/decl/reagent/capsaicin/initial_effect(var/mob/living/carbon/M, var/alien)
	to_chat(M, discomfort_message)

/decl/reagent/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] < agony_dose && prob(5))
		to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, PAIN, 0)
		if(prob(5))
			M.visible_message("<b>[M]</b> [pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent(/decl/reagent/frostoil, 5)

#define EYES_PROTECTED 1
#define EYES_MECH 2

/decl/reagent/capsaicin/condensed
	name = "Condensed Capsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly
	color = "#B31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15
	fallback_specific_heat = 4

/decl/reagent/capsaicin/condensed/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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
			if((I.body_parts_covered & FACE) && !(I.item_flags & FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name

	var/message = null
	if(eyes_covered)
		if (!mouth_covered && (eyes_covered & EYES_PROTECTED))
			message = "<span class='warning'>Your [eye_protection] protects your eyes from the pepperspray!</span>"
		else if (eyes_covered & EYES_MECH)
			message = "<span class='warning'>Your mechanical eyes are invulnurable to pepperspray!</span>"
	else
		message = "<span class='warning'>The pepperspray gets in your eyes!</span>"
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, 15)
			M.eye_blind = max(M.eye_blind, 5)
		else
			M.eye_blurry = max(M.eye_blurry, 25)
			M.eye_blind = max(M.eye_blind, 10)

	if(mouth_covered)
		if(!message)
			message = "<span class='warning'>Your [face_protection] protects you from the pepperspray!</span>"
	else if(!no_pain)
		message = "<span class='danger'>Your face and throat burn!</span>"
		if(prob(25))
			M.visible_message("<b>[M]</b> [pick("coughs!","coughs hysterically!","splutters!")]")
		M.apply_effect(30, PAIN)

/decl/reagent/capsaicin/condensed/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	M.apply_effect(10, PAIN)
	if(prob(5))
		M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>", "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent(/decl/reagent/frostoil, 5)

#undef EYES_PROTECTED
#undef EYES_MECH

/decl/reagent/spacespice
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

/decl/reagent/browniemix
	name = "Brownie Mix"
	description = "A dry mix for making delicious brownies."
	reagent_state = SOLID
	color = "#441a03"
	taste_description = "chocolate"

/* Drinks */

/decl/reagent/drink
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
	var/caffeine = 0 // strength of stimulant effect, since so many drinks use it
	unaffected_species = IS_MACHINE
	var/blood_to_ingest_scale = 2
	fallback_specific_heat = 1.75

/decl/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	digest(M,alien,removed * blood_to_ingest_scale, FALSE, holder)

/decl/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	digest(M, alien, removed, holder = holder)

/decl/reagent/drink/proc/digest(var/mob/living/carbon/M, var/alien, var/removed, var/add_nutrition = TRUE, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if (caffeine)
			M.add_up_to_chemical_effect(CE_SPEEDBOOST, caffeine)
		M.dizziness = max(0, M.dizziness + adj_dizzy)
		M.drowsyness = max(0, M.drowsyness + adj_drowsy)
		M.sleeping = max(0, M.sleeping + adj_sleepy)

	if(add_nutrition == TRUE)
		M.adjustHydrationLoss(-hydration * removed)
		M.adjustNutritionLoss(-nutrition * removed)

	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices
/decl/reagent/drink/banana
	name = "Banana Juice"
	description = "The raw essence of a banana."
	color = "#C3AF00"
	taste_description = "banana"

	glass_icon_state = "banana"
	glass_name = "glass of banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/decl/reagent/drink/berryjuice
	name = "Berry Juice"
	description = "A delicious blend of several different kinds of berries."
	color = "#990066"
	taste_description = "berries"

	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/decl/reagent/drink/carrotjuice
	name = "Carrot juice"
	description = "It is just like a carrot but without crunching."
	color = "#FF8C00" // rgb: 255, 140, 0
	taste_description = "carrots"

	glass_icon_state = "carrotjuice"
	glass_name = "glass of carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/decl/reagent/drink/carrotjuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	holder.add_reagent(/decl/reagent/oculine, removed * 0.2)

/decl/reagent/drink/grapejuice
	name = "Grape Juice"
	description = "It's grrrrrape!"
	color = "#863333"
	taste_description = "grapes"

	glass_icon_state = "grapejuice"
	glass_name = "glass of grape juice"
	glass_desc = "It's grrrrrape!"

/decl/reagent/drink/lemonjuice
	name = "Lemon Juice"
	description = "This juice is VERY sour."
	color = "#AFAF00"
	taste_description = "sourness"

	glass_icon_state = "lemonjuice"
	glass_name = "glass of lemon juice"
	glass_desc = "Sour..."

/decl/reagent/drink/limejuice
	name = "Lime Juice"
	description = "The sweet-sour juice of limes."
	color = "#365E30"
	taste_description = "tart citrus"
	taste_mult = 1.1

	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/decl/reagent/drink/orangejuice
	name = "Orange Juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108"
	taste_description = "oranges"

	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

/decl/reagent/drink/orangejuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/decl/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353"
	strength = 5
	taste_description = "berries"

	glass_icon_state = "poisonberryjuice"
	glass_name = "glass of poison berry juice"
	glass_desc = "A glass of deadly juice."

/decl/reagent/drink/potatojuice
	name = "Potato Juice"
	description = "Juice of the potato. Bleh."
	nutrition = 2
	color = "#302000"
	taste_description = "potato"

	glass_icon_state = "glass_brown"
	glass_name = "glass of potato juice"
	glass_desc = "Juice from a potato. Bleh."

/decl/reagent/drink/tomatojuice
	name = "Tomato Juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008"
	taste_description = "tomatoes"

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/decl/reagent/drink/tomatojuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 0.1 * removed)

/decl/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	description = "Delicious juice made from watermelon."
	color = "#B83333"
	taste_description = "watermelon"

	glass_icon_state = "glass_red"
	glass_name = "glass of watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

/decl/reagent/drink/pineapplejuice
	name = "Pineapple Juice"
	description = "From freshly canned pineapples."
	color = "#FFFF00"
	taste_description = "pineapple"

	glass_icon_state = "lemonjuice"
	glass_name = "glass of pineapple juice"
	glass_desc = "What the hell is this?"

/decl/reagent/drink/earthenrootjuice
	name = "Earthen-Root Juice"
	description = "Juice extracted from earthen-root, a plant native to Adhomai."
	color = "#4D8F53"
	taste_description = "sweetness"

	glass_icon_state = "bluelagoon"
	glass_name = "glass of earthen-root juice"
	glass_desc = "Juice extracted from earthen-root, a plant native to Adhomai."

/decl/reagent/drink/garlicjuice
	name = "Garlic Juice"
	description = "Who would even drink this?"
	taste_description = "garlic"
	nutrition = 1
	color = "#eeddcc"

	glass_name = "glass of garlic juice"
	glass_desc = "Who would even drink juice from garlic?"

	germ_adjust = 7.5 // has allicin, an antibiotic

/decl/reagent/drink/onionjuice
	name = "Onion Juice"
	description = "Juice from an onion, for when you need to cry."
	taste_description = "onion"
	nutrition = 1
	color = "#ffeedd"

	glass_name = "glass of onion juice"
	glass_desc = "Juice from an onion, for when you need to cry."

/decl/reagent/drink/applejuice
	name = "Apple Juice"
	description = "Juice from an apple. The most basic beverage you can imagine."
	taste_description = "apple juice"
	color = "#f2d779"

	glass_icon_state = "glass_apple"
	glass_name = "glass of apple juice"
	glass_desc = "Juice from an apple. The most basic beverage you can imagine."

/decl/reagent/drink/dynjuice
	name = "Dyn Juice"
	description = "Juice from a dyn leaf. Good for you, but normally not consumed undiluted."
	taste_description = "astringent menthol"
	color = "#00e0e0"

	glass_icon_state = "dynjuice"
	glass_name = "glass of dyn juice"
	glass_desc = "Juice from a dyn leaf. Good for you, but normally not consumed undiluted."

/decl/reagent/drink/dynjuice/hot
	name = "Dyn Tea"
	taste_description = "peppermint water"
	description = "An old-fashioned, but traditional Skrell drink with documented medicinal properties."

	glass_icon_state = "dynhot"
	glass_name = "cup of dyn tea"
	glass_desc = "An old-fashioned, but traditional Skrell drink with documented medicinal properties."

/decl/reagent/drink/dynjuice/cold
	name = "Dyn Ice Tea"
	taste_description = "fizzy mint tea"
	description = "A modern spin on an old formula, popular among Skrell youngsters. Good for you."

	glass_icon_state = "dyncold"
	glass_name = "glass of dyn ice tea"
	glass_desc = "A modern spin on an old formula, popular among Skrell youngsters. Good for you."

// Everything else

/decl/reagent/drink/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF"
	taste_description = "milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"

	default_temperature = T0C + 5

/decl/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/decl/reagent/capsaicin, 10 * removed)

/decl/reagent/drink/milk/cream
	name = "Cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF"
	taste_description = "creamy milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."

/decl/reagent/drink/milk/soymilk
	name = "Soy Milk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7"
	taste_description = "soy milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of soy milk"
	glass_desc = "White and nutritious soy goodness!"

/decl/reagent/drink/milk/adhomai
	name = "Fatshouters Milk"
	description = "An opaque white liquid produced by the mammary glands of native adhomian animal."
	taste_description = "fatty milk"

/decl/reagent/drink/milk/adhomai/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_TAJARA && prob(5))
			H.delayed_vomit()

/decl/reagent/drink/milk/adhomai/fermented
	name = "Fermented Fatshouters Milk"
	description = "A tajaran made fermented dairy product, traditionally consumed by nomadic population of Adhomai."
	taste_description = "sour milk"

	glass_name = "glass of fermented fatshouters milk"
	glass_desc = "A tajaran made fermented dairy product, traditionally consumed by nomadic population of Adhomai."

/decl/reagent/drink/milk/beetle
	name = "Hakhma Milk"
	description = "A milky substance extracted from the brood sac of the viviparous Hakhma, often consumed by Offworlders and Scarabs."
	nutrition = 4
	color = "#FFF8AD"
	taste_description = "alien milk"

	glass_name = "glass of hakhma milk"
	glass_desc = "A milky substance extracted from the brood sac of the viviparous Hakhma, often consumed by Offworlders and Scarabs."

/decl/reagent/drink/tea
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

/decl/reagent/drink/tea/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		if(last_taste_time + 800 < world.time) // Not to spam message
			to_chat(M, "<span class='danger'>Your body withers as you feel slight pain throughout.</span>")
			last_taste_time = world.time
		metabolism = REM * 0.33
		M.adjustToxLoss(1.5 * removed)

/decl/reagent/drink/icetea
	name = "Iced Tea"
	description = "No relation to a certain rap artist/ actor."
	color = "#984707"
	taste_description = "sweet tea"

	glass_icon_state = "icedteaglass"
	glass_name = "glass of iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_center_of_mass = list("x"=15, "y"=10)

//Hipster tea and cider drinks to go along with hipster coffee drinks

/decl/reagent/drink/tea/chaitea
	name = "Chai Tea"
	description = "A tea spiced with cinnamon and cloves."
	color = "#DBAD81"
	taste_description = "creamy cinnamon and spice"

	glass_icon_state = "chaitea"
	glass_name = "cup of chai tea"
	glass_desc = "A tea spiced with cinnamon and cloves."

/decl/reagent/drink/tea/coco_chaitea
	name = "Chocolate Chai"
	description = "A surprisingly pleasant mix of chocolate and spice."
	color = "#664300"
	taste_description = "creamy spiced cocoa"

	glass_icon_state = "coco_chaitea"
	glass_name = "cup of chocolate chai tea"
	glass_desc = "A surprisingly pleasant mix of chocolate and spice."

/decl/reagent/drink/tea/chaitealatte
	name = "Chai Latte"
	description = "A frothy spiced tea."
	color = "#DBAD81"
	taste_description = "spiced milk foam"

	glass_icon_state = "chailatte"
	glass_name = "cup of chai latte"
	glass_desc = "For when you need the energy to yell at the barista for making your drink wrong."

/decl/reagent/drink/tea/chaitealatte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) //milk effects
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/decl/reagent/capsaicin, 10 * removed)


/decl/reagent/drink/tea/coco_chailatte
	name = "Chocolate Chai Latte"
	description = "Sweet, liquid chocolate. Have a cup of this and maybe you'll calm down."
	color = "#664300"
	taste_description = "spiced milk chocolate"

	glass_icon_state = "coco_chailatte"
	glass_name = "cup of chocolate chai latte"
	glass_desc = "Sweet, liquid chocolate. Have a cup of this and maybe you'll calm down."

/decl/reagent/drink/tea/coco_chailatte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) //milk effects
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/decl/reagent/capsaicin, 10 * removed)

/decl/reagent/drink/tea/cofftea
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

/decl/reagent/drink/tea/bureacratea
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

/decl/reagent/drink/tea/desert_tea //not in butanol path since xuizi is strength 5 by itself so the alcohol content is negligible when mixed
	name = "Desert Blossom Tea"
	description = "A simple, semi-sweet tea from Moghes, that uses a little xuizi juice for flavor."
	color = "#A8F062"
	taste_description = "sweet cactus water"

	glass_icon_state = "deserttea"
	glass_name = "cup of desert blossom tea"
	glass_desc = "A simple, semi-sweet tea from Moghes, popular with guildsmen and peasants."

/decl/reagent/drink/tea/greentea
	name = "Green Tea"
	description = "Tasty green tea. It's good for you!"
	color = "#B7C49D"
	taste_description = "light, refreshing tea"

	glass_icon_state = "bigteacup"
	glass_name = "cup of green tea"
	glass_desc = "Tasty green tea. It's good for you!"

/decl/reagent/drink/tea/halfandhalf
	name = "Half and Half"
	description = "Tea and lemonade; not to be confused with the dairy creamer."
	color = "#997207"
	taste_description = "refreshing tea mixed with crisp lemonade"

	glass_icon_state = "halfandhalf"
	glass_name = "glass of half and half"
	glass_desc = "Tea and lemonade; not to be confused with the dairy creamer."

/decl/reagent/drink/tea/heretic_tea
	name = "Heretics' Tea"
	description = "A non-alcoholic take on a bloody brew."
	color = "#820000"
	taste_description = "fizzy, heretically sweet iron"
	carbonated = TRUE

	glass_icon_state = "heretictea"
	glass_name = "glass of Heretics' Tea"
	glass_desc = "A non-alcoholic take on a bloody brew."

/decl/reagent/drink/tea/kira_tea
	name = "Kira Tea"
	description = "A sweet take on a fizzy favorite."
	color = "#8A8A57"
	taste_description = "fizzy citrus tea"
	carbonated = TRUE

	glass_icon_state = "kiratea"
	glass_name = "glass of kira tea"
	glass_desc = "A sweet take on a fizzy favorite."

/decl/reagent/drink/tea/librarian_special
	name = "Librarian Special"
	description = "Shhhhhh!"
	color = "#101000"
	taste_description = "peace and quiet"

	glass_icon_state = "bureacratea"
	glass_name = "cup of Librarian Special"
	glass_desc = "Shhhhhh!"

/decl/reagent/drink/tea/librarian_special/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.silent += 3

/decl/reagent/drink/tea/mars_tea
	name = "Martian Tea"
	description = "A foul-smelling brew that you probably don't want to try."
	color = "#101000"
	taste_description = "bitter tea, pungent black pepper and just a hint of shaky politics"

	glass_icon_state = "bigteacup"
	glass_name = "cup of martian tea"
	glass_desc = "A foul-smelling brew that you probably don't want to try."

/decl/reagent/drink/tea/mendell_tea
	name = "Mendell Afternoon Tea"
	description = "A simple, minty tea."
	color = "#859466"
	taste_description = "minty tea with a hint of lemon"

	glass_icon_state = "mendelltea"
	glass_name = "cup of Mendell Afternoon Tea"
	glass_desc = "A simple, minty tea. A Biesel favorite."

/decl/reagent/drink/tea/berry_tea
	name = "Mixed Berry Tea"
	description = "Hot tea with a sweet, fruity taste!"
	color = "#2E0206"
	taste_description = "tart, fruity tea"

	glass_icon_state = "berrytea"
	glass_name = "cup of mixed berry tea"
	glass_desc = "Hot tea with a sweet, fruity taste!"

/decl/reagent/drink/tea/pomegranate_icetea
	name = "Pomegranate Iced Tea"
	description = "A refreshing, fruity tea. No fruit was harmed in the making of this drink."
	color = "#302109"
	taste_description = "sweet pomegranate"

	glass_icon_state = "pomegranatetea"
	glass_name = "glass of pomegranate iced tea"
	glass_desc = "A refreshing, fruity tea. No fruit was harmed in the making of this drink."

/decl/reagent/drink/tea/portsvilleminttea
	name = "Portsville Mint Tea"
	description = "A popular iced pick-me-up originating from a city in Eos, on Biesel."
	color = "#b6f442"
	taste_description = "cool minty tea"

	glass_icon_state = "portsvilleminttea"
	glass_name = "glass of Portsville Mint Tea"
	glass_desc = "A popular iced pick-me-up originating from a city in Eos, on Biesel."

/decl/reagent/drink/tea/potatea
	name = "Potatea"
	description = "Why would you ever drink this?"
	color = "#2B2710"
	nutrition = 0.2
	taste_description = "starchy regret"

	glass_icon_state = "bigteacup"
	glass_name = "cup of potatea"
	glass_desc = "Why would you ever drink this?"

/decl/reagent/drink/tea/securitea
	name = "Securitea"
	description = "The safest drink around."
	color = "#030B36"
	taste_description = "freshly polished boots"

	glass_icon_state = "securitea"
	glass_name = "cup of securitea"
	glass_desc = "Help, maint!!"

/decl/reagent/drink/tea/sleepytime_tea
	name = "Sleepytime Tea"
	description = "The perfect drink to enjoy before falling asleep in your favorite chair."
	color = "#101000"
	adj_drowsy = 1
	adj_sleepy = 1
	taste_description = "liquid relaxation"

	glass_icon_state = "sleepytea"
	glass_name = "cup of sleepytime tea"
	glass_desc = "The perfect drink to enjoy before falling asleep in your favorite chair."

/decl/reagent/drink/tea/hakhma_tea
	name = "Spiced Hakhma Tea"
	description = "A tea often brewed by Offworlders and Scarabs during important meals."
	color = "#8F6742"
	nutrition = 1 //hakhma milk has nutrition 4
	taste_description = "creamy, cinnamon-spiced alien milk"

	glass_icon_state = "hakhmatea"
	glass_name = "cup of spiced hakhma tea"
	glass_desc = "A tea often brewed by Offworlders and Scarabs during important meals."

/decl/reagent/drink/tea/hakhma_tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) //milk effects
	..()
	if(alien != IS_DIONA)
		M.heal_organ_damage(0.1 * removed, 0)
		holder.remove_reagent(/decl/reagent/capsaicin, 10 * removed)

/decl/reagent/drink/tea/sweet_tea
	name = "Sweet Tea"
	description = "Hope you have a good dentist!"
	color = "#984707"
	taste_description = "sweet sugary comfort"

	glass_icon_state = "icedteaglass"
	glass_name = "glass of sweet tea"
	glass_desc = "Hope you have a good dentist!"

/decl/reagent/drink/dynjuice/thewake //dyn properties
	name = "The Wake"
	description = "The tea-based alternative to a Sromshine."
	color = "#00E0E0"
	adj_dizzy = -3
	adj_drowsy = -3
	adj_sleepy = -3
	taste_description = "orange juice mixed with minty toothpaste"

	glass_icon_state = "thewake"
	glass_name = "cup of The Wake"
	glass_desc = "Most young skrell get a kick out of letting humans try this."

/decl/reagent/drink/tea/tomatea
	name = "Tomatea"
	description = "Basically tomato soup in a mug."
	color = "#9F3400"
	taste_description = "sad tomato soup"

	glass_icon_state = "bigteacup"
	glass_name = "cup of tomatea"
	glass_desc = "Basically tomato soup in a mug."

/decl/reagent/drink/tea/tomatea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0, 0.1 * removed) //has tomato juice

/decl/reagent/drink/tea/tropical_icetea
	name = "Tropical Iced Tea"
	description = "For maximum enjoyment, drink while at the beach on a warm summer day."
	color = "#773404"
	taste_description = "sweet beachside fruit"

	glass_icon_state = "junglejuice"
	glass_name = "glass of tropical iced tea"
	glass_desc = "For maximum enjoyment, drink while at the beach on a warm summer day."


//Coffee
//==========

/decl/reagent/drink/coffee
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

/decl/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(adj_temp > 0)
		holder.remove_reagent(/decl/reagent/frostoil, 10 * removed)

	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsyness = max(0, M.drowsyness - 3)
		M.sleeping = max(0, M.sleeping - 2)
		M.intoxication = max(0, (M.intoxication - (removed*0.25)))

/decl/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.make_jittery(5)

/decl/reagent/drink/coffee/icecoffee
	name = "Frappe Coffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838"

	glass_icon_state = "frappe"
	glass_name = "glass of frappe coffee"
	glass_desc = "A drink to perk you up and refresh you!"

/decl/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	description = "A nice and tasty beverage to enjoy while reading your hippie books."
	color = "#664300"
	taste_description = "creamy coffee"

	glass_icon_state = "soy_latte_vended"
	glass_name = "glass of soy latte"
	glass_desc = "A nice and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.1 * removed, 0)

/decl/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	description = "A nice, strong and tasty beverage to enjoy while reading."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter cream"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of cafe latte"
	glass_desc = "A nice, strong and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.1 * removed, 0)

/decl/reagent/drink/coffee/espresso
	name = "Espresso"
	description = "A strong coffee made by passing nearly boiling water through coffee seeds at high pressure."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "shot of espresso"
	glass_desc = "A strong coffee made by passing nearly boiling water through coffee seeds at high pressure."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/freddo_espresso
	name = "Freddo Espresso"
	description = "Espresso with ice cubes poured over ice."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "cold and bitter coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of freddo espresso"
	glass_desc = "Espresso with ice cubes poured over ice."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/caffe_americano
	name = "Caffe Americano"
	description = "Espresso diluted with hot water."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "delicious coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of caffe Americano"
	glass_desc = "delicious coffee"
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/flat_white
	name = "Flat White Espresso"
	description = "Espresso with a bit of steamy hot milk."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter coffee and milk"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of flat white"
	glass_desc = "Espresso with a bit of steamy hot milk."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/latte
	name = "Latte"
	description = "A nice, strong, and refreshing beverage to enjoy while reading."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter cream"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of cafe latte"
	glass_desc = "A nice, strong, and refreshing beverage to enjoy while reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.heal_organ_damage(0.1 * removed, 0)

/decl/reagent/drink/coffee/latte/caramel
	name = "Caramel Latte"
	description = "A latte with caramel flavoring syrup added."
	taste_description = "bitter caramel cream"

	glass_icon_state = "caramel_latte"
	glass_name = "glass of caramel latte"
	glass_desc = "A latte with caramel syrup drizzled into it. Lovely!"
/decl/reagent/drink/coffee/latte/mocha
	name = "Mocha Latte"
	description = "A latte with chocolate flavoring syrup added."
	taste_description = "bitter chocolate cream"

	glass_icon_state = "mocha_latte"
	glass_name = "glass of chocolate latte"
	glass_desc = "A latte with chocolate syrup drizzled into it. Lovely!"
/decl/reagent/drink/coffee/latte/vanilla
	name = "Vanilla Latte"
	description = "A latte with vanilla flavoring syrup added."
	taste_description = "bitter vanilla cream"

	glass_icon_state = "caramel_latte"
	glass_name = "glass of vanilla latte"
	glass_desc = "A latte with vanilla syrup drizzled into it. Lovely!"

/decl/reagent/drink/coffee/cappuccino
	name = "Cappuccino"
	description = "Espresso with steamed milk foam."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of cappuccino"
	glass_desc = "Espresso with steamed milk foam."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/freddo_cappuccino
	name = "Freddo Cappuccino"
	description = "Espresso with steamed milk foam, on ice."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "cold and bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of freddo cappuccino"
	glass_desc = "Espresso with steamed milk foam, on ice."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/macchiato
	name = "Macchiato"
	description = "Espresso with milk foam."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of macchiato"
	glass_desc = "Espresso with milk foam."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/mocacchino
	name = "Mocacchino"
	description = "Espresso with hot milk and chocolate."
	color = "#664300" // rgb: 102, 67, 0
	taste_description = "sweet milk and bitter coffee"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of mocacchino"
	glass_desc = "Espresso with hot milk and chocolate."
	glass_center_of_mass = list("x"=15, "y"=9)

/decl/reagent/drink/coffee/icecoffee/psfrappe
	name = "Pumpkin Spice Frappe"
	description = "A seasonal treat popular around the autumn times."
	color = "#9C6B19"
	taste_description = "autumn bliss and coffee"

	glass_icon_state = "frappe_psl"
	glass_name = "glass of pumpkin spice frappe"
	glass_desc = "A seasonal treat popular around the autumn times."

/decl/reagent/drink/coffee/latte/pumpkinspice
	name = "Pumpkin Spice Latte"
	description = "A seasonal drink favored in autumn."
	color = "#9C6B19"
	taste_description = "hot creamy coffee and autumn bliss"

	glass_icon_state = "psl_cheap"
	glass_name = "cup of pumpkin spice latte"
	glass_desc = "A hot cup of pumpkin spiced coffee. Autumn really is the best season!"

/decl/reagent/drink/coffee/sadpslatte
	name = "Processed Pumpkin Latte"
	description = "A processed drink vaguely reminicent of autumn bliss."
	color = "#9C6B19"
	taste_description = "a disappointing approximation of autumn bliss"

	glass_icon_state = "psl_cheap"
	glass_name = "cup of cheap pumpkin latte"
	glass_desc = "Maybe you should just go ask the barista for something more authentic..."

/decl/reagent/drink/coffee/mars
	name = "Martian Special"
	description = "Black coffee, heavily peppered."
	taste_description = "bitter coffee, pungent black pepper and just a hint of shaky politics"

	glass_icon_state = "hot_coffee"
	glass_name = "cup of Martian Special"
	glass_desc = "Just by the pungent, sharp smell, you figure you probably don't want to drink that..."

/decl/reagent/drink/hot_coco
	name = "Hot Chocolate"
	description = "Made with love! And cocoa beans."
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	taste_description = "creamy chocolate"

	glass_icon_state = "chocolateglass"
	glass_name = "cup of hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/decl/reagent/drink/sodawater
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

/decl/reagent/drink/grapesoda
	name = "Grape Soda"
	description = "Grapes made into a fine drank."
	color = "#421C52"
	adj_drowsy = -3
	taste_description = "grape soda"
	carbonated = TRUE

	glass_icon_state = "gsodaglass"
	glass_name = "glass of grape soda"
	glass_desc = "Looks like a delicious drink!"

/decl/reagent/drink/tonic
	name = "Tonic Water"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#664300"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	taste_description = "tart and fresh"
	carbonated = TRUE

	glass_icon_state = "glass_clear"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/decl/reagent/drink/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	color = "#FFFF00"
	taste_description = "tartness"

	glass_icon_state = "lemonadeglass"
	glass_name = "glass of lemonade"
	glass_desc = "Oh the nostalgia..."

/decl/reagent/drink/lemonade/pink
	name = "Pink Lemonade"
	description = "A fruity pink citrus drink."
	color = "#FFC0CB"
	taste_description = "girly tartness"

	glass_icon_state = "pinklemonade"
	glass_name = "glass of pink lemonade"
	glass_desc = "You feel girlier just looking at this."

/decl/reagent/drink/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	color = "#CCCC99"
	taste_description = "fruity sweetness"
	carbonated = TRUE

	glass_icon_state = "kiraspecial"
	glass_name = "glass of Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/drink/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	color = "#9F3400"
	taste_description = "orange and cola soda"
	carbonated = TRUE

	glass_icon_state = "brownstar"
	glass_name = "glass of Brown Star"
	glass_desc = "It's not what it sounds like..."

/decl/reagent/drink/mintsyrup
	name = "Mint Syrup"
	description = "A simple syrup that tastes strongly of mint."
	color = "#539830"
	taste_description = "mint"

	glass_icon_state = "mint_syrupglass"
	glass_name = "glass of mint syrup"
	glass_desc = "Pure mint syrup. Prepare your tastebuds."
	glass_center_of_mass = list("x"=17, "y"=6)

/decl/reagent/drink/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	color = "#AEE5E4"
	taste_description = "creamy vanilla"

	glass_icon_state = "milkshake"
	glass_name = "glass of milkshake"
	glass_desc = "Glorious brainfreezing mixture."
	glass_center_of_mass = list("x"=16, "y"=7)

/decl/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	color = "#485000"
	caffeine = 0.4
	taste_description = "soda and coffee"
	carbonated = TRUE

	glass_icon_state = "rewriter"
	glass_name = "glass of Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(5)

/decl/reagent/drink/nuka_cola
	name = "Nuka Cola"
	description = "Cola, cola never changes."
	color = "#100800"
	adj_sleepy = -2
	caffeine = 1
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "nuka_colaglass"
	glass_name = "glass of Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_center_of_mass = list("x"=16, "y"=6)

/decl/reagent/drink/nuka_cola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_SPEEDBOOST, 1)
		M.make_jittery(20)
		M.druggy = max(M.druggy, 30)
		M.dizziness += 5
		M.drowsyness = 0

/decl/reagent/drink/grenadine
	name = "Grenadine Syrup"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F"
	taste_description = "100% pure pomegranate"

	glass_icon_state = "grenadineglass"
	glass_name = "glass of grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	glass_center_of_mass = list("x"=17, "y"=6)

/decl/reagent/drink/space_cola
	name = "Space Cola"
	description = "A refreshing beverage."
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state  = "glass_brown"
	glass_name = "glass of Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_center_of_mass = list("x"=17, "y"=6)

/decl/reagent/drink/spacemountainwind
	name = "Mountain Wind"
	description = "Blows right through you like a space wind."
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	taste_description = "sweet citrus soda"
	carbonated = TRUE

	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."

/decl/reagent/drink/dr_gibb
	name = "Dr. Gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#102000"
	adj_drowsy = -6
	taste_description = "cherry soda"
	carbonated = TRUE

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/decl/reagent/drink/root_beer
	name = "RnD Root Beer"
	description = "A classic Earth drink from the United Americas province."
	color = "#211100"
	adj_drowsy = -6
	taste_description = "sassafras and anise soda"
	carbonated = TRUE

	glass_icon_state = "root_beer_glass"
	glass_name = "glass of RnD Root Beer"
	glass_desc = "A glass of bubbly RnD Root Beer."

/decl/reagent/drink/spaceup
	name = "Space-Up"
	description = "Tastes like a hull breach in your mouth."
	color = "#202800"
	taste_description = "a hull breach"
	carbonated = TRUE

	glass_icon_state = "space-up_glass"
	glass_name = "glass of Space-up"
	glass_desc = "Space-up. It helps keep your cool."

/decl/reagent/drink/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	color = "#878F00"
	taste_description = "tangy lime and lemon soda"

	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"

/decl/reagent/drink/doctorsdelight
	name = "The Doctor's Delight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = LIQUID
	color = "#FF8CFF"
	nutrition = 1
	taste_description = "homely fruit"

	glass_icon_state = "doctorsdelightglass"
	glass_name = "glass of The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	glass_center_of_mass = list("x"=16, "y"=8)

	blood_to_ingest_scale = 1

/decl/reagent/drink/doctorsdelight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.adjustOxyLoss(-4 * removed)
		M.heal_organ_damage(2 * removed, 2 * removed)
		if(M.dizziness)
			M.dizziness = max(0, M.dizziness - 15)
		if(M.confused)
			M.confused = max(0, M.confused - 5)

/decl/reagent/drink/dry_ramen
	name = "Dry Ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutrition = 1
	hydration = 0
	color = "#302000"
	taste_description = "dry and cheap noodles"

/decl/reagent/drink/hot_ramen
	name = "Hot Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	hydration = 5
	adj_temp = 5
	taste_description = "wet and cheap noodles"

/decl/reagent/drink/hell_ramen
	name = "Hell Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	hydration = 5
	taste_description = "wet and cheap noodles on fire"
	adj_temp = 20

/decl/reagent/drink/ice
	name = "Ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494"
	taste_description = "ice"
	taste_mult = 1.5
	hydration = 8

	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

	default_temperature = T0C - 10

/decl/reagent/drink/nothing
	name = "Nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_icon_state = "nothing"
	glass_name = "glass of nothing"
	glass_desc = "Absolutely nothing."

/decl/reagent/drink/meatshake
	name = "Meatshake"
	color = "#874c20"
	description = "Blended meat and cream for those who want crippling heart failure down the road."
	taste_description = "liquified meat"

	glass_icon_state = "meatshake"
	glass_name = "Meatshake"
	glass_desc = "Blended meat and cream for those who want crippling health issues down the road. Has two straws for sharing! Perfect for dates!"

/decl/reagent/drink/ciderhot
	name = "Apple Cider"
	description = "A great drink to warm up a crisp autumn afternoon!"
	color = "#664300"
	taste_description = "fresh apples mixed with cinnamon"

	glass_icon_state = "ciderhot"
	glass_name = "cup of apple cider"
	glass_desc = "A great drink to warm up a crisp autumn afternoon!"

/decl/reagent/drink/cidercold
	name = "Apple Cider"
	description = "A refreshing mug of fresh apples and cinnamon."
	color = "#664300"
	taste_description = "fresh apples mixed with cinnamon"

	glass_icon_state = "meadglass"
	glass_name = "mug of apple cider"
	glass_desc = "A refreshing mug of fresh apples and cinnamon."

/decl/reagent/drink/cidercheap
	name = "Apple Cider Juice"
	description = "It's just spiced up apple juice. Ugh."
	color = "#664300"
	taste_description = "sad apple juice with cinnamon"

	glass_icon_state = "meadglass"
	glass_name = "mug of apple cider juice"
	glass_desc = "It's just spiced up apple juice. Sometimes the barista can't work miracles."

/decl/reagent/drink/toothpaste
	name = "Toothpaste"
	description = "A paste commonly used in oral hygiene."
	reagent_state = LIQUID
	color = "#b1eae8"
	taste_description = "toothpaste"
	overdose = REAGENTS_OVERDOSE
	var/strength = 50

	glass_icon_state = "toothpaste"
	glass_name = "glass of toothpaste"
	glass_desc = "Dentists recommend drinking zero glasses a day, and instead brushing normally."
	glass_center_of_mass = list("x"=7, "y"=8)

/decl/reagent/drink/toothpaste/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)

	if(!istype(M))
		return

	if(alien == IS_VAURCA)
		M.intoxication += (strength / 100) * removed * 3.5

/decl/reagent/drink/toothpaste/cold_gate
	name = "Cold Gate"
	description = "A C'thur Favorite, guaranteed to make even the bloodiest of warriors mandibles shimmer."
	strength = 25
	taste_description = "mint"

	glass_icon_state = "cold_gate"
	glass_name = "glass of Cold Gate"
	glass_desc = "A C'thur Favorite, guaranteed to make even the bloodiest of warriors mandibles shimmer."
	glass_center_of_mass = list("x"=7, "y"=8)

/decl/reagent/drink/toothpaste/waterfresh
	name = "Waterfresh"
	description = "A concoction of toothpaste and mouthwash, for when you need to show your pearly whites."
	strength = 40
	taste_description = "bubble bath"

	glass_icon_state = "waterfresh"
	glass_name = "glass of Waterfresh"
	glass_desc = "A concoction of toothpaste and mouthwash, for when you need to show your pearly whites. Toothbrush Included."
	glass_center_of_mass = list("x"=7, "y"=8)

/decl/reagent/drink/toothpaste/sedantian_firestorm
	name = "Sedantian Firestorm"
	description = "Florinated phoron, is the drink suppose to be on fire?"
	strength = 80
	taste_description = "melting asphalt"
	adj_temp = 25
	default_temperature = T0C + 60

	glass_icon_state = "sedantian_firestorm"
	glass_name = "glass of Sedantian Firestorm"
	glass_desc = "Florinated phoron, is the drink suppose to be on fire?"
	glass_center_of_mass = list("x"=7, "y"=8)

/decl/reagent/drink/toothpaste/kois_odyne
	name = "K'ois Odyne"
	description = "A favourite among the younger vaurca, born from an accident involving nanopaste and the repair of internal augments."
	strength = 60
	taste_description = "chalk"

	glass_icon_state = "kois_odyne"
	glass_name = "glass of Kois Odyne"
	glass_desc = "A favourite among the younger vaurca, born from an accident involving nanopaste and the repair of internal augments."
	glass_center_of_mass = list("x"=7, "y"=8)

/decl/reagent/drink/toothpaste/teathpaste
	name = "Teathpaste"
	description = "A sad attempt to reduce the effects of sugary tea on your teeth."
	color = "#45615A"
	strength = 20
	taste_description = "liquid dental work"

	glass_icon_state = "teathpaste"
	glass_name = "cup of teathpaste"
	glass_desc = "Recommended by 1 out of 5 dentists."


	var/last_taste_time = -100

/decl/reagent/drink/toothpaste/teathpaste/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		if(last_taste_time + 800 < world.time) // Not to spam message
			to_chat(M, "<span class='danger'>Your body withers as you feel slight pain throughout.</span>")
			last_taste_time = world.time
		metabolism = REM * 0.33
		M.adjustToxLoss(1.5 * removed)

/* Alcohol */

// Basic

/decl/reagent/alcohol/absinthe
	name = "Absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#33EE00"
	strength = 75
	taste_description = "licorice"

	glass_icon_state = "absintheglass"
	glass_name = "glass of absinthe"
	glass_desc = "Wormwood, anise, oh my."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/ale
	name = "Ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#664300"
	strength = 6
	taste_description = "hearty barley ale"
	carbonated = TRUE

	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A freezing pint of delicious ale"
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/beer
	name = "Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300"
	strength = 5
	nutriment_factor = 1
	taste_description = "beer"
	carbonated = TRUE

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.jitteriness = max(M.jitteriness - 3, 0)

/decl/reagent/alcohol/bitters
	name = "Aromatic Bitters"
	description = "A very, very concentrated and bitter herbal alcohol."
	color = "#223319"
	strength = 40
	taste_description = "bitter"

	glass_icon_state = "bittersglass"
	glass_name = "glass of bitters"
	glass_desc = "A pungent glass of bitters."
	glass_center_of_mass = list ("x"=17, "y"=8)

/decl/reagent/alcohol/bluecuracao
	name = "Blue Curacao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD"
	strength = 25
	taste_description = "oranges"

	glass_icon_state = "curacaoglass"
	glass_name = "glass of blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/champagne
	name = "Champagne"
	description = "A classy sparkling wine, usually found in meeting rooms and basements."
	color = "#EBECC0"
	strength = 15
	taste_description = "bubbly bitter-sweetness"
	carbonated = TRUE

	glass_icon_state = "champagneglass"
	glass_name = "glass of champagne"
	glass_desc = "Off-white and bubbly. So passe."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/cognac
	name = "Cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05"
	strength = 40
	taste_description = "rich and smooth alcohol"

	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	glass_center_of_mass = list("x"=16, "y"=6)

/decl/reagent/alcohol/deadrum
	name = "Deadrum"
	description = "Popular with the sailors. Not very popular with everyone else."
	color = "#664300"
	strength = 40
	taste_description = "salty sea water"

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/deadrum/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.dizziness +=5

/decl/reagent/alcohol/gin
	name = "Gin"
	description = "It's gin. In space. I say, good sir."
	color = "#664300"
	strength = 30
	taste_description = "an alcoholic christmas tree"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A crystal clear glass of Griffeater gin."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/victorygin
	name = "Victory Gin"
	description = "An oily Adhomai-based gin."
	color = "#664300"
	strength = 18
	taste_description = "oily gin"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "It has an oily smell and doesn't taste like typical gin."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/djinntea
	name = "Djinn Tea"
	description = "A mildly alcoholic spin on a popular Skrell drink."
	color = "#84C0C0"
	strength = 20
	taste_description = "fizzy mint tea"

	glass_icon_state = "djinnteaglass"
	glass_name = "glass of Djinn Tea"
	glass_desc = "A mildly alcoholic spin on a popular Skrell drink. Less good for you than the original."

//Base type for alchoholic drinks containing coffee
/decl/reagent/alcohol/coffee
	overdose = 45

/decl/reagent/alcohol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsyness = max(0, M.drowsyness - 3)
		M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/reagent/alcohol/coffee/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		M.make_jittery(5)

/decl/reagent/alcohol/coffee/kahlua
	name = "Kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#664300"
	strength = 20
	caffeine = 0.25
	taste_description = "spiked latte"

	glass_icon_state = "kahluaglass"
	glass_name = "glass of RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"
	glass_center_of_mass = list("x"=15, "y"=7)

/decl/reagent/alcohol/makgeolli
	name = "Makgeolli"
	description = "A mild Konyanger sparkling rice wine."
	color = "#664300"
	strength = 15
	taste_description = "creamy dry alcohol"

	glass_icon_state = "makgeolliglass"
	glass_name = "glass of makgeolli"
	glass_desc = "A clear alcohol similar to sparkling wine, brewed from rice."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/melonliquor
	name = "Melon Liquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	strength = 23
	taste_description = "fruity alcohol"

	glass_icon_state = "emeraldglass"
	glass_name = "glass of melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/rum
	name = "Rum"
	description = "Yohoho and all that."
	color = "#664300"
	strength = 40
	taste_description = "spiked butterscotch"

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/sake
	name = "Sake"
	description = "Anime's favorite drink."
	color = "#664300"
	strength = 20
	taste_description = "mildly dry alcohol with a subtle sweetness"

	glass_icon_state = "sakeglass"
	glass_name = "glass of sake"
	glass_desc = "A glass of sake."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/cloudyoran
	name = "Cloudy Oran"
	description = "Reminds Suits of home. Dregs, not so much."
	color = "#F6F6F6"
	strength = 15
	taste_description = "soy milk putting on airs"

	glass_icon_state = "cloudyoranglass"
	glass_name = "glass of Cloudy Oran"
	glass_desc = "A frothy white beverage. Reminds Suits of home. Dregs, not so much."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/soju
	name = "Soju"
	description = "A mild Konyanger spirit that is best described as rice vodka."
	color = "#664300"
	strength = 25
	taste_description = "slightly dry alcohol with a subtle burn"

	glass_icon_state = "sojuglass"
	glass_name = "glass of soju"
	glass_desc = "A clear alcohol similar to vodka, brewed from rice."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/tequila
	name = "Tequila"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	color = "#FFFF91"
	strength = 40
	taste_description = "paint stripper"

	glass_icon_state = "tequilaglass"
	glass_name = "glass of tequila"
	glass_desc = "Now all that's missing is the weird colored shades!"
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/thirteenloko
	name = "Thirteen Loko"
	description = "A potent mixture of caffeine and alcohol."
	color = "#102000"
	strength = 10
	nutriment_factor = 1
	caffeine = 0.5
	taste_description = "jitters and death"
	carbonated = TRUE

	glass_icon_state = "thirteen_loko_glass"
	glass_name = "glass of Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/decl/reagent/alcohol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 7)
	M.make_jittery(5)

	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))


/decl/reagent/alcohol/vermouth
	name = "Vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 17
	taste_description = "dry alcohol"
	taste_mult = 1.3

	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/vodka
	name = "Vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 50
	taste_description = "grain alcohol"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of vodka"
	glass_desc = "The glass contain wodka. Xynta."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/vodka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	M.apply_effect(max(M.total_radiation - 1 * removed, 0), IRRADIATE, blocked = 0)

/decl/reagent/alcohol/vodka/mushroom
	name = "Mushroom Vodka"
	description = "A strong drink distilled from mushrooms grown in caves. Tastes like dissatisfaction."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 55
	taste_description = "strong earthy alcohol"
	glass_icon_state = "mushroomvodkaglass"
	glass_name = "glass of mushroom vodka"
	glass_desc = "The glass contain wodka made from mushrooms. Blyat."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/whiskey
	name = "Whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#664300"
	strength = 40
	taste_description = "molasses"

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/wine
	name = "Wine"
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15
	taste_description = "bitter sweetness"

	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

// Cocktails

/decl/reagent/alcohol/acid_spit
	name = "Acid Spit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	reagent_state = LIQUID
	color = "#365000"
	strength = 25
	taste_description = "stomach acid"

	glass_icon_state = "acidspitglass"
	glass_name = "glass of Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."
	glass_center_of_mass = list("x"=16, "y"=7)

/decl/reagent/alcohol/alliescocktail
	name = "Allies Cocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	color = "#664300"
	strength = 25
	taste_description = "bitter yet free"

	glass_icon_state = "alliescocktail"
	glass_name = "glass of Allies cocktail"
	glass_desc = "A drink made from your allies."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/aloe
	name = "Aloe"
	description = "So very, very, very good."
	color = "#664300"
	strength = 15
	taste_description = "sweet 'n creamy"

	glass_icon_state = "aloe"
	glass_name = "glass of Aloe"
	glass_desc = "Very, very, very good."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/amasec
	name = "Amasec"
	description = "Official drink of the Gun Club!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 25
	taste_description = "dark and metallic"

	glass_icon_state = "amasecglass"
	glass_name = "glass of Amasec"
	glass_desc = "Always handy before COMBAT!!!"
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/andalusia
	name = "Andalusia"
	description = "A nice, strangely named drink."
	color = "#664300"
	strength = 35
	taste_description = "lemons"

	glass_icon_state = "andalusia"
	glass_name = "glass of Andalusia"
	glass_desc = "A nice, strange named drink."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/antifreeze
	name = "Anti-freeze"
	description = "Ultimate refreshment."
	color = "#664300"
	strength = 20
	adj_temp = 20
	targ_temp = 330
	taste_description = "cold cream"

	glass_icon_state = "antifreeze"
	glass_name = "glass of Anti-freeze"
	glass_desc = "The ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/atomicbomb
	name = "Atomic Bomb"
	description = "Nuclear proliferation never tasted so good."
	reagent_state = LIQUID
	color = "#666300"
	strength = 50
	druggy = 50
	taste_description = "da bomb"

	glass_icon_state = "atomicbombglass"
	glass_name = "glass of Atomic Bomb"
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."
	glass_center_of_mass = list("x"=15, "y"=7)

/decl/reagent/alcohol/coffee/b52
	name = "B-52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#664300"
	strength = 35
	taste_description = "angry and irish"

	glass_icon_state = "b52glass"
	glass_name = "glass of B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/decl/reagent/alcohol/bahama_mama
	name = "Bahama mama"
	description = "Tropical cocktail."
	color = "#FF7F3B"
	strength = 15
	taste_description = "lime and orange"

	glass_icon_state = "bahama_mama"
	glass_name = "glass of Bahama Mama"
	glass_desc = "Tropical cocktail"
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/diona_mama
	name = "Diona Mama"
	description = "Lightly irradiated."
	color = "#56A05D"
	strength = 25
	druggy = 25
	taste_description = "tangy, irradiated licorice"

	glass_icon_state = "dionamamaglass"
	glass_name = "glass of Diona Mama"
	glass_desc = "Lightly irradiated, just the way Dionae like it."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/jovian_storm
	name = "Jovian Storm"
	description = "Named after Jupiter's storm. It'll blow you away."
	color = "#AA856A"
	strength = 15
	taste_description = "stormy sweetness"

	glass_icon_state = "jovianstormglass"
	glass_name = "glass of Jovian Storm"
	glass_desc = "A classic Callistean drink named after Jupiter's storm. It'll blow you away."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/bananahonk
	name = "Banana Mama"
	description = "A drink from Clown Heaven."
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 15
	taste_description = "a bad joke"

	glass_icon_state = "bananahonkglass"
	glass_name = "glass of Banana Honk"
	glass_desc = "A drink from Banana Heaven."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/barefoot
	name = "Barefoot"
	description = "Barefoot and pregnant"
	color = "#664300"
	strength = 15
	taste_description = "creamy berries"

	glass_icon_state = "b&p"
	glass_name = "glass of Barefoot"
	glass_desc = "Barefoot and pregnant"
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/beepsky_smash
	name = "Beepsky Smash"
	description = "Deny drinking this and prepare for THE LAW."
	reagent_state = LIQUID
	color = "#664300"
	strength = 35
	taste_description = "JUSTICE"

	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
	glass_center_of_mass = list("x"=18, "y"=10)

/decl/reagent/alcohol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.Stun(2)

/decl/reagent/alcohol/bilk
	name = "Bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C"
	strength = 4
	nutriment_factor = 2
	taste_description = "desperation and lactate"

	glass_icon_state = "glass_brown"
	glass_name = "glass of bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/decl/reagent/alcohol/blackrussian
	name = "Black Russian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000"
	strength = 20
	taste_description = "bitterness"

	glass_icon_state = "blackrussianglass"
	glass_name = "glass of Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/bloodymary
	name = "Bloody Mary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#664300"
	strength = 20
	taste_description = "tomatoes with a hint of lime"

	glass_icon_state = "bloodymaryglass"
	glass_name = "glass of Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/decl/reagent/alcohol/booger
	name = "Booger"
	description = "Ewww..."
	color = "#8CFF8C"
	strength = 20
	taste_description = "sweet 'n creamy"

	glass_icon_state = "booger"
	glass_name = "glass of Booger"
	glass_desc = "Ewww..."

/decl/reagent/alcohol/coffee/brave_bull
	name = "Brave Bull"
	description = "It's just as effective as Dutch-Courage!"
	color = "#664300"
	strength = 30
	caffeine = 0.2
	taste_description = "alcoholic bravery"

	glass_icon_state = "bravebullglass"
	glass_name = "glass of Brave Bull"
	glass_desc = "Tequila and coffee liquor, brought together in a mouthwatering mixture. Drink up."
	glass_center_of_mass = list("x"=15, "y"=8)

/decl/reagent/alcohol/cmojito
	name = "Champagne Mojito"
	description = "A fizzy, minty and sweet drink."
	color = "#5DBA40"
	strength = 15
	taste_description = "sweet mint alcohol"

	glass_icon_state = "cmojito"
	glass_name = "glass of champagne mojito"
	glass_desc = "Looks fun!"

/decl/reagent/alcohol/gibsonpunch
	name = "Gibson Punch"
	description = "An alcoholic fruit punch. It seems horribly sour at first, but a sweetly bitter aftertaste lingers in the mouth."
	color = "#5f712e"
	strength = 40
	taste_description = "sour and bitter fruit"

	glass_icon_state = "gibsonpunch"
	glass_name = "glass of Gibson Punch"
	glass_desc = "An alcoholic fruit punch."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/classic
	name = "The Classic"
	description = "The classic bitter lemon cocktail."
	color = "#9a8922"
	strength = 20
	taste_description = "sour and bitter"
	carbonated = TRUE

	glass_icon_state = "classic"
	glass_name = "glass of the classic"
	glass_desc = "Just classic. Wow."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/martini
	name = "Classic Martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300"
	strength = 25
	taste_description = "dry class"

	glass_icon_state = "martiniglass"
	glass_name = "glass of classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/corkpopper
	name = "Cork Popper"
	description = "A fancy cocktail with a hint of lemon."
	color = "#766818"
	strength = 30
	taste_description = "sour and smokey"

	glass_icon_state = "corkpopper"
	glass_name = "glass of cork popper"
	glass_desc = "The confusing scent only proves all the more alluring."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/cubalibre
	name = "Cuba Libre"
	description = "A rum and coke with lime. Viva la revolucion."
	color = "#3E1B00"
	strength = 10
	taste_description = "cola and a hint of lime"
	carbonated = TRUE

	glass_icon_state = "cubalibreglass"
	glass_name = "glass of Cuba Libre"
	glass_desc = "A classic mix of rum, cola, and lime."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/rumandcola
	name = "Rum and Cola"
	description = "A classic cocktail consisting of rum and cola."
	color = "#3E1B00"
	strength = 10
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "rumandcolaglass"
	glass_name = "glass of Rum and Cola"
	glass_desc = "A classic mix of rum and cola."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/demonsblood
	name = "Demons Blood"
	description = "AHHHH!!!!"
	color = "#820000"
	strength = 15
	taste_description = "sweet tasting iron"
	carbonated = TRUE

	glass_icon_state = "demonsblood"
	glass_name = "glass of Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."
	glass_center_of_mass = list("x"=16, "y"=2)

/decl/reagent/alcohol/devilskiss
	name = "Devils Kiss"
	description = "Creepy time!"
	color = "#A68310"
	strength = 15
	taste_description = "bitter iron"

	glass_icon_state = "devilskiss"
	glass_name = "glass of Devil's Kiss"
	glass_desc = "Creepy time!"
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/driestmartini
	name = "Driest Martini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1
	color = "#2E6671"
	strength = 20
	taste_description = "a beach"

	glass_icon_state = "driestmartiniglass"
	glass_name = "glass of Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/french75
	name = "French 75"
	description = "A sharp and classy cocktail."
	color = "#F4E68D"
	strength = 25
	taste_description = "sour and classy"
	carbonated = TRUE

	glass_icon_state = "french75"
	glass_name = "glass of french 75"
	glass_desc = "It looks like a lemon shaved into your cocktail."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/ginfizz
	name = "Gin Fizz"
	description = "Refreshingly lemony, deliciously dry."
	color = "#664300"
	strength = 20
	taste_description = "dry, tart lemons"
	carbonated = TRUE

	glass_icon_state = "ginfizzglass"
	glass_name = "glass of gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."
	glass_center_of_mass = list("x"=16, "y"=7)

/decl/reagent/alcohol/grog
	name = "Grog"
	description = "Watered-down rum, pirate approved!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 10
	taste_description = "a poor excuse for alcohol"

	glass_icon_state = "grogglass"
	glass_name = "glass of grog"
	glass_desc = "A fine and cepa drink for Space."

/decl/reagent/alcohol/erikasurprise
	name = "Erika Surprise"
	description = "The surprise is, it's green!"
	color = "#2E6671"
	strength = 15
	taste_description = "tartness and bananas"

	glass_icon_state = "erikasurprise"
	glass_name = "glass of Erika Surprise"
	glass_desc = "The surprise is, it's green!"
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/gargleblaster
	name = "Pan-Galactic Gargle Blaster"
	description = "Whoah, this stuff looks volatile!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 50
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"

	glass_icon_state = "gargleblasterglass"
	glass_name = "glass of Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
	glass_center_of_mass = list("x"=17, "y"=6)

/decl/reagent/alcohol/gintonic
	name = "Gin and Tonic"
	description = "An all time classic, mild cocktail."
	color = "#664300"
	strength = 12
	taste_description = "mild and tart"
	carbonated = TRUE

	glass_icon_state = "gintonicglass"
	glass_name = "glass of gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."
	glass_center_of_mass = list("x"=16, "y"=7)

/decl/reagent/alcohol/goldschlager
	name = "Goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#664300"
	strength = 50
	taste_description = "burning cinnamon"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."
	glass_center_of_mass = list("x"=16, "y"=12)

/decl/reagent/alcohol/hippiesdelight
	name = "Hippies' Delight"
	description = "You just don't get it maaaan."
	reagent_state = LIQUID
	color = "#664300"
	strength = 15
	druggy = 50
	taste_description = "giving peace a chance"

	glass_icon_state = "hippiesdelightglass"
	glass_name = "glass of Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/hooch
	name = "Hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	color = "#664300"
	strength = 65
	taste_description = "pure resignation"

	glass_icon_state = "glass_brown2"
	glass_name = "glass of Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/reagent/alcohol/iced_beer
	name = "Iced Beer"
	description = "A beer which is so cold the air around it freezes."
	color = "#664300"
	strength = 5
	targ_temp = 270
	taste_description = "refreshingly cold"
	carbonated = TRUE

	glass_icon_state = "iced_beerglass"
	glass_name = "glass of iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_center_of_mass = list("x"=16, "y"=7)

/decl/reagent/alcohol/irishcarbomb
	name = "Irish Car Bomb"
	description = "Mmm, tastes like chocolate cake..."
	color = "#2E6671"
	strength = 50
	taste_description = "delicious anger"
	carbonated = TRUE

	glass_icon_state = "irishcarbomb"
	glass_name = "glass of Irish Car Bomb"
	glass_desc = "An irish car bomb."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/fisfirebomb
	name = "Fisanduhian Firebomb"
	description = "Mmm, tastes like spicy chocolate..."
	color = "#320C00"
	strength = 50
	taste_description = "anti-dominian sentiment"
	carbonated = TRUE

	glass_icon_state = "fisfirebombglass"
	glass_name = "glass of Fisanduhian Firebomb"
	glass_desc = "The somewhat spicier cousin to the Irish Car Bomb."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/coffee/irishcoffee
	name = "Irish Coffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	color = "#664300"
	strength = 50
	caffeine = 0.3
	taste_description = "giving up on the day"

	glass_icon_state = "irishcoffeeglass"
	glass_name = "glass of Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
	glass_center_of_mass = list("x"=15, "y"=10)

/decl/reagent/alcohol/coffee/fiscoffee
	name = "Fisanduhian Coffee"
	description = "Coffee, and spicy alcohol. Popular among people who dislike Dominians."
	color = "#A9501C"
	strength = 50
	caffeine = 0.3
	taste_description = "giving up on peaceful coexistence"

	glass_icon_state = "fiscoffeeglass"
	glass_name = "glass of Fisanduhian coffee"
	glass_desc = "It's like an Irish coffee, but spicy and angry about Dominia."
	glass_center_of_mass = list("x"=15, "y"=10)

/decl/reagent/alcohol/irishcream
	name = "Irish Cream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	color = "#664300"
	strength = 25
	taste_description = "creamy alcohol"

	glass_icon_state = "irishcreamglass"
	glass_name = "glass of Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/fiscream
	name = "Fisanduhian Cream"
	description = "A sweet, slightly spicy alcoholic cream. Fisanduh is not yet lost."
	color = "#C8AC97"
	strength = 25
	taste_description = "creamy spiced alcohol"

	glass_icon_state = "irishcreamglass"
	glass_name = "glass of Fisanduhian cream"
	glass_desc = "A sweet, slightly spicy alcoholic cream. Fisanduh is not yet lost."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/longislandicedtea
	name = "Long Island Iced Tea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	color = "#664300"
	strength = 40
	taste_description = "a mixture of cola and alcohol"
	carbonated = TRUE

	glass_icon_state = "longislandicedteaglass"
	glass_name = "glass of Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/manhattan
	name = "Manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#664300"
	strength = 30
	taste_description = "mild dryness"

	glass_icon_state = "manhattanglass"
	glass_name = "glass of Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/manhattan_proj
	name = "Manhattan Project"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#664300"
	strength = 30
	druggy = 30
	taste_description = "death, the destroyer of worlds"

	glass_icon_state = "proj_manhattanglass"
	glass_name = "glass of Manhattan Project"
	glass_desc = "A scientist's drink of choice, for thinking how to blow up the station."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/manly_dorf
	name = "The Manly Dorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	color = "#664300"
	strength = 45
	taste_description = "hair on your chest and your chin"
	carbonated = TRUE

	glass_icon_state = "manlydorfglass"
	glass_name = "glass of The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/decl/reagent/alcohol/margarita
	name = "Margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#8CFF8C"
	strength = 30
	taste_description = "dry and salty"

	glass_icon_state = "margaritaglass"
	glass_name = "glass of margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/mead
	name = "Mead"
	description = "A Viking's drink, though a cheap one."
	reagent_state = LIQUID
	color = "#664300"
	strength = 25
	nutriment_factor = 1
	taste_description = "sweet yet alcoholic"

	glass_icon_state = "meadglass"
	glass_name = "glass of mead"
	glass_desc = "A Viking's beverage, though a cheap one."
	glass_center_of_mass = list("x"=17, "y"=10)

/decl/reagent/alcohol/moonshine
	name = "Moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#664300"
	strength = 65
	taste_description = "bitterness"

	glass_icon_state = "glass_clear"
	glass_name = "glass of moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/decl/reagent/alcohol/muscmule
	name = "Muscovite Mule"
	description = "A surprisingly gentle cocktail, with a hidden punch."
	color = "#8EEC5F"
	strength = 40
	taste_description = "mint and a mule's kick"

	glass_icon_state = "muscmule"
	glass_name = "glass of muscovite mule"
	glass_desc = "Such a pretty green, this couldn't possible go wrong!"
	glass_center_of_mass = list("x"=17, "y"=10)

/decl/reagent/alcohol/neurotoxin
	name = "Neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = LIQUID
	color = "#2E2E61"
	strength = 50
	taste_description = "a numbing sensation"

	glass_icon_state = "neurotoxinglass"
	glass_name = "glass of Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_center_of_mass = list("x"=16, "y"=8)

	blood_to_ingest_scale = 1
	metabolism = REM * 5

/decl/reagent/alcohol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		return
	M.Weaken(3)
	M.add_chemical_effect(CE_PULSE, -2)

/decl/reagent/alcohol/omimosa
	name = "Orange Mimosa"
	description = "Wonderful start to any day."
	color = "#F4A121"
	strength = 15
	taste_description = "fizzy orange"
	carbonated = TRUE

	glass_icon_state = "omimosa"
	glass_name = "glass of orange mimosa"
	glass_desc = "Smells like a fresh start."

/decl/reagent/alcohol/patron
	name = "Patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#585840"
	strength = 20
	taste_description = "metallic and expensive"

	glass_icon_state = "patronglass"
	glass_name = "glass of Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	glass_center_of_mass = list("x"=7, "y"=8)

/decl/reagent/alcohol/pinkgin
	name = "Pink Gin"
	description = "Bitters and Gin."
	color = "#DB80B2"
	strength = 25
	taste_description = "bitter christmas tree"

	glass_icon_state = "pinkgin"
	glass_name = "glass of pink gin"
	glass_desc = "What an eccentric cocktail."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/pinkgintonic
	name = "Pink Gin and Tonic."
	description = "Bitterer gin and tonic."
	color = "#F4BDDB"
	strength = 25
	taste_description = "very bitter christmas tree"
	carbonated = TRUE

	glass_icon_state = "pinkgintonic"
	glass_name = "glass of pink gin and tonic"
	glass_desc = "You made gin and tonic more bitter... you madman!"

/decl/reagent/alcohol/piratepunch
	name = "Pirate's Punch"
	description = "Nautical punch!"
	color = "#ECE1A0"
	strength = 25
	taste_description = "spiced fruit cocktail"

	glass_icon_state = "piratepunch"
	glass_name = "glass of pirate's punch"
	glass_desc = "Yarr harr fiddly dee, drink whatcha want 'cause a pirate is ye!"
	glass_center_of_mass = list("x"=17, "y"=10)

/decl/reagent/alcohol/planterpunch
	name = "Planter's Punch"
	description = "A popular beach cocktail."
	color = "#FFA700"
	strength = 25
	taste_description = "jamaica"

	glass_icon_state = "planterpunch"
	glass_name = "glass of planter's punch"
	glass_desc = "This takes you back, back to those endless white beaches of yore."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/pwine
	name = "Poison Wine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000"
	strength = 15
	druggy = 50
	halluci = 10
	taste_description = "purified alcoholic death"

	glass_icon_state = "pwineglass"
	glass_name = "glass of ???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/reagent/alcohol/red_mead
	name = "Red Mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	color = "#C73C00"
	strength = 21
	taste_description = "sweet and salty alcohol"

	glass_icon_state = "red_meadglass"
	glass_name = "glass of red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."
	glass_center_of_mass = list("x"=17, "y"=10)

/decl/reagent/alcohol/sbiten
	name = "Sbiten"
	description = "A spicy mix of mead and spices! Might be a little hot for the little guys!"
	color = "#664300"
	strength = 40
	adj_temp = 50
	targ_temp = 360
	taste_description = "hot and spice"

	glass_icon_state = "sbitenglass"
	glass_name = "glass of Sbiten"
	glass_desc = "A spicy mix of Mead and Spices. Very hot."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/screwdrivercocktail
	name = "Screwdriver"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#A68310"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
	glass_center_of_mass = list("x"=15, "y"=10)

/decl/reagent/alcohol/silencer
	name = "Silencer"
	description = "A drink from Mime Heaven."
	nutriment_factor = 1
	color = "#664300"
	strength = 50
	taste_description = "a pencil eraser"

	glass_icon_state = "silencerglass"
	glass_name = "glass of Silencer"
	glass_desc = "A drink from mime Heaven."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/singulo
	name = "Singulo"
	description = "A blue-space beverage!"
	color = "#2E6671"
	strength = 50
	taste_description = "concentrated matter"

	glass_icon_state = "singulo"
	glass_name = "glass of Singulo"
	glass_desc = "A blue-space beverage."
	glass_center_of_mass = list("x"=17, "y"=4)

/decl/reagent/alcohol/snowwhite
	name = "Snow White"
	description = "A cold refreshment"
	color = "#FFFFFF"
	strength = 7
	taste_description = "refreshing cold"
	carbonated = TRUE

	glass_icon_state = "snowwhite"
	glass_name = "glass of Snow White"
	glass_desc = "A cold refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/ssroyale
	name = "Southside Royale"
	description = "Classy cocktail containing citrus."
	color = "#66F446"
	strength = 20
	taste_description = "lime christmas tree"

	glass_icon_state = "ssroyale"
	glass_name = "glass of southside royale"
	glass_desc = "This cocktail is better than you. Maybe it's the crossed arms that give it away. Or the rich parents."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/suidream
	name = "Sui Dream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	color = "#00A86B"
	strength = 5
	taste_description = "fruit"
	carbonated = TRUE

	glass_icon_state = "sdreamglass"
	glass_name = "glass of Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/gibsonhooch
	name = "Gibson Hooch"
	description = "A disgusting concoction of cheap alcohol and soda - just what you need after a busy day at the factories."
	color = "#5f641d"
	strength = 65
	taste_description = "cheap labor"
	carbonated = TRUE

	glass_icon_state = "gibsonhooch"
	glass_name = "glass of Gibson Hooch"
	glass_desc = "A factory worker's favorite... Because they can't afford much else."
	glass_center_of_mass = list("x"=16, "y"=10)

/decl/reagent/alcohol/tequila_sunrise
	name = "Tequila Sunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	color = "#FFE48C"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "tequilasunriseglass"
	glass_name = "glass of Tequila Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/decl/reagent/alcohol/threemileisland
	name = "Three Mile Island Iced Tea"
	description = "Made for a woman, strong enough for a man."
	color = "#666340"
	strength = 60
	druggy = 50
	taste_description = "dry"
	carbonated = TRUE

	glass_icon_state = "threemileislandglass"
	glass_name = "glass of Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."
	glass_center_of_mass = list("x"=16, "y"=2)

/decl/reagent/alcohol/toxins_special
	name = "Toxins Special"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 40
	adj_temp = 15
	targ_temp = 330
	taste_description = "spicy toxins"

	glass_icon_state = "toxinsspecialglass"
	glass_name = "glass of Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"

/decl/reagent/alcohol/vodkamartini
	name = "Vodka Martini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300"
	strength = 32
	taste_description = "shaken, not stirred"

	glass_icon_state = "martiniglass"
	glass_name = "glass of vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/vodkatonic
	name = "Vodka and Tonic"
	description = "For when a gin and tonic isn't russian enough."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 35
	taste_description = "tart bitterness"

	glass_icon_state = "vodkatonicglass"
	glass_name = "glass of vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."
	glass_center_of_mass = list("x"=16, "y"=7)

/decl/reagent/alcohol/white_russian
	name = "White Russian"
	description = "That's just, like, your opinion, man..."
	color = "#A68340"
	strength = 30
	taste_description = "bitter cream"

	glass_icon_state = "whiterussianglass"
	glass_name = "glass of White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/solarian_white
	name = "Solarian White"
	description = "Despite the name, this is not a security officer."
	color = "#C3D1D4"
	strength = 30
	taste_description = "creamy vodka and lime"

	glass_icon_state = "solarianwhiteglass"
	glass_name = "glass of Solarian White"
	glass_desc = "A classic Solarian cocktail. Despite the name, this is not a security officer."

	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/solarian_marine
	name = "Solarian Marine"
	description = "Drink too many of these, and you'll wake up invading Tau Ceti."
	reagent_state = LIQUID
	color = "#33567A"
	strength = 35
	taste_description = "polished boots and nationalism"

	glass_icon_state = "solarianmarineglass"
	glass_name = "Solarian Marine"
	glass_desc = "Drink too many of these, and you'll wake up invading Tau Ceti."

	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/permanent_revolution
	name = "Permanent Revolution"
	description = "You have nothing to lose but your sobriety."
	color = "#A7AA60"
	strength = 65
	taste_description = "strong, earthy licorice"

	glass_icon_state = "permanentrevolutionglass"
	glass_name = "glass of Permanent Revolution"
	glass_desc = "A Himean cocktail, so named for its tendency to make the room spin.  You have nothing to lose but your sobriety."

	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/internationale
	name = "Solarian White"
	description = "The subversive's choice."
	color = "#D9CCAA"
	strength = 28
	taste_description = "earthy, oily unity"

	glass_icon_state = "internationaleglass"
	glass_name = "glass of Internationale"
	glass_desc = "The nearest thing the Orion Spur has to left unity. The subversive's choice."

	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/whiskeycola
	name = "Whiskey Cola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/whiskeysoda
	name = "Whiskey Soda"
	description = "For the more refined griffon."
	color = "#664300"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "whiskeysodaglass2"
	glass_name = "glass of whiskey soda"
	glass_desc = "Ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/specialwhiskey // I have no idea what this is and where it comes from
	name = "Special Blend Whiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	color = "#664300"
	strength = 45
	taste_description = "silky, amber goodness"

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	glass_center_of_mass = list("x"=16, "y"=12)

// Snowflake drinks
/decl/reagent/drink/dr_gibb_diet
	name = "Diet Dr. Gibb"
	description = "A delicious blend of 42 different flavours, one of which is water."
	color = "#102000"
	taste_description = "watered down liquid sunshine"
	carbonated = TRUE

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Diet Dr. Gibb"
	glass_desc = "Regular Dr.Gibb is probably healthier than this cocktail of artificial flavors."

/decl/reagent/alcohol/drdaniels
	name = "Dr. Daniels"
	description = "A limited edition tallboy of Dr. Gibb's Infusions."
	color = "#8e6227"
	caffeine = 0.2
	overdose = 80
	strength = 20
	nutriment_factor = 2
	taste_description = "smooth, honeyed carbonation"
	carbonated = TRUE

	glass_icon_state = "drdaniels"
	glass_name = "glass of Dr. Daniels"
	glass_desc = "A tall glass of honey, whiskey, and diet Dr. Gibb. The perfect blend of throat-soothing liquid."

//aurora unique drinks

/decl/reagent/alcohol/daiquiri
	name = "Daiquiri"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#664300"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "daiquiri"
	glass_name = "glass of Daiquiri"
	glass_desc = "A splendid looking cocktail."

/decl/reagent/alcohol/icepick
	name = "Ice Pick"
	description = "Big. And red. Hmm...."
	color = "#664300"
	strength = 10
	taste_description = "vodka and lemon"

	glass_icon_state = "icepick"
	glass_name = "glass of Ice Pick"
	glass_desc = "Big. And red. Hmm..."

/decl/reagent/alcohol/poussecafe
	name = "Pousse-Cafe"
	description = "Smells of French and liquore."
	color = "#664300"
	strength = 15
	taste_description = "layers of liquors"

	glass_icon_state = "pousseecafe"
	glass_name = "glass of Pousse-Cafe"
	glass_desc = "Smells of French and liquore."

/decl/reagent/alcohol/mintjulep
	name = "Mint Julep"
	description = "As old as time itself, but how does it taste?"
	color = "#664300"
	strength = 25
	taste_description = "old as time"

	glass_icon_state = "mintjulep"
	glass_name = "glass of Mint Julep"
	glass_desc = "As old as time itself, but how does it taste?"

/decl/reagent/alcohol/johncollins
	name = "John Collins"
	description = "Crystal clear, yellow, and smells of whiskey. How could this go wrong?"
	color = "#664300"
	strength = 25
	taste_description = "whiskey"
	carbonated = TRUE

	glass_icon_state = "johnscollins"
	glass_name = "glass of John Collins"
	glass_desc = "Named after a man, perhaps?"

/decl/reagent/alcohol/gimlet
	name = "Gimlet"
	description = "Small, elegant, and kicks."
	color = "#664300"
	strength = 20
	taste_description = "gin and class"
	carbonated = TRUE

	glass_icon_state = "gimlet"
	glass_name = "glass of Gimlet"
	glass_desc = "Small, elegant, and packs a punch."

/decl/reagent/alcohol/starsandstripes
	name = "Stars and Stripes"
	description = "Someone, somewhere, is saluting."
	color = "#664300"
	strength = 10
	taste_description = "freedom"

	glass_icon_state = "starsandstripes"
	glass_name = "glass of Stars and Stripes"
	glass_desc = "Someone, somewhere, is saluting."

/decl/reagent/alcohol/metropolitan
	name = "Metropolitan"
	description = "What more could you ask for?"
	color = "#664300"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "metropolitan"
	glass_name = "glass of Metropolitan"
	glass_desc = "What more could you ask for?"

/decl/reagent/alcohol/primeminister
	name = "Prime Minister"
	description = "All the fun of power, none of the assassination risk!"
	color = "#FF3C00"
	strength = 30
	taste_description = "political power"

	glass_icon_state = "primeministerglass"
	glass_name = "glass of Prime Minister"
	glass_desc = "All the fun of power, none of the assassination risk!"

/decl/reagent/alcohol/peacetreaty
	name = "Peace Treaty"
	description = "A diplomatic overture in a glass."
	color = "#DFDF93"
	strength = 21
	taste_description = "tart, oily honey"

	glass_icon_state = "peacetreatyglass"
	glass_name = "glass of Peace Treaty"
	glass_desc = "A diplomatic overture in a glass"

/decl/reagent/alcohol/caruso
	name = "Caruso"
	description = "Green, almost alien."
	color = "#664300"
	strength = 25
	taste_description = "dryness"

	glass_icon_state = "caruso"
	glass_name = "glass of Caruso"
	glass_desc = "Green, almost alien."

/decl/reagent/alcohol/aprilshower
	name = "April Shower"
	description = "Smells of brandy."
	color = "#664300"
	strength = 25
	taste_description = "brandy and oranges"

	glass_icon_state = "aprilshower"
	glass_name = "glass of April Shower"
	glass_desc = "Smells of brandy."

/decl/reagent/alcohol/carthusiansazerac
	name = "Carthusian Sazerac"
	description = "Whiskey and... Syrup?"
	color = "#664300"
	strength = 15
	taste_description = "sweetness"

	glass_icon_state = "carthusiansazerac"
	glass_name = "glass of Carthusian Sazerac"
	glass_desc = "Whiskey and... Syrup?"

/decl/reagent/alcohol/deweycocktail
	name = "Dewey Cocktail"
	description = "Colours, look at all the colours!"
	color = "#664300"
	strength = 25
	taste_description = "dry gin"

	glass_icon_state = "deweycocktail"
	glass_name = "glass of Dewey Cocktail"
	glass_desc = "Colours, look at all the colours!"

/decl/reagent/alcohol/chartreusegreen
	name = "Green Chartreuse"
	description = "A green, strong liqueur."
	color = "#664300"
	strength = 40
	taste_description = "a mixture of herbs"

	glass_icon_state = "greenchartreuseglass"
	glass_name = "glass of Green Chartreuse"
	glass_desc = "A green, strong liqueur."

/decl/reagent/alcohol/chartreuseyellow
	name = "Yellow Chartreuse"
	description = "A yellow, strong liqueur."
	color = "#664300"
	strength = 40
	taste_description = "a sweet mixture of herbs"

	glass_icon_state = "chartreuseyellowglass"
	glass_name = "glass of Yellow Chartreuse"
	glass_desc = "A yellow, strong liqueur."

/decl/reagent/alcohol/cremewhite
	name = "White Creme de Menthe"
	description = "Mint-flavoured alcohol, in a bottle."
	color = "#664300"
	strength = 20
	taste_description = "mint"

	glass_icon_state = "whitecremeglass"
	glass_name = "glass of White Creme de Menthe"
	glass_desc = "Mint-flavoured alcohol."

/decl/reagent/alcohol/cremeyvette
	name = "Creme de Yvette"
	description = "Berry-flavoured alcohol, in a bottle."
	color = "#664300"
	strength = 20
	taste_description = "berries"

	glass_icon_state = "cremedeyvetteglass"
	glass_name = "glass of Creme de Yvette"
	glass_desc = "Berry-flavoured alcohol."

/decl/reagent/alcohol/brandy
	name = "Brandy"
	description = "Cheap knock off for cognac."
	color = "#664300"
	strength = 40
	taste_description = "cheap cognac"

	glass_icon_state = "brandyglass"
	glass_name = "glass of Brandy"
	glass_desc = "Cheap knock off for cognac."

/decl/reagent/alcohol/guinness
	name = "Guinness"
	description = "Special Guinnes drink."
	color = "#2E6671"
	strength = 8
	taste_description = "dryness"
	carbonated = TRUE

	glass_icon_state = "guinnessglass"
	glass_name = "glass of Guinness"
	glass_desc = "A glass of Guinness."

/decl/reagent/alcohol/drambuie
	name = "Drambuie"
	description = "A drink that smells like whiskey but tastes different."
	color = "#2E6671"
	strength = 40
	taste_description = "sweet whisky"

	glass_icon_state = "drambuieglass"
	glass_name = "glass of Drambuie"
	glass_desc = "A drink that smells like whiskey but tastes different."

/decl/reagent/alcohol/oldfashioned
	name = "Old Fashioned"
	description = "That looks like it's from the sixties."
	color = "#2E6671"
	strength = 30
	taste_description = "bitterness"

	glass_icon_state = "oldfashioned"
	glass_name = "glass of Old Fashioned"
	glass_desc = "That looks like it's from the sixties."

/decl/reagent/alcohol/blindrussian
	name = "Blind Russian"
	description = "You can't see?"
	color = "#2E6671"
	strength = 40
	taste_description = "bitterness blindness"

	glass_icon_state = "blindrussian"
	glass_name = "glass of Blind Russian"
	glass_desc = "You can't see?"

/decl/reagent/alcohol/rustynail
	name = "Rusty Nail"
	description = "Smells like lemon."
	color = "#2E6671"
	strength = 25
	taste_description = "lemons"

	glass_icon_state = "rustynail"
	glass_name = "glass of Rusty Nail"
	glass_desc = "Smells like lemon."

/decl/reagent/alcohol/tallrussian
	name = "Tall Black Russian"
	description = "Just like black russian but taller."
	color = "#2E6671"
	strength = 25
	taste_description = "tall bitterness"
	carbonated = TRUE

	glass_icon_state = "tallblackrussian"
	glass_name = "glass of Tall Black Russian"
	glass_desc = "Just like black russian but taller."

//Synnono Meme Drinks
//=====================================
// Organized here because why not.

/decl/reagent/alcohol/badtouch
	name = "Bad Touch"
	description = "We're nothing but mammals, after all."
	color = "#42f456"
	strength = 50
	taste_description = "naughtiness"

	glass_icon_state = "badtouch"
	glass_name = "glass of Bad Touch"
	glass_desc = "We're nothing but mammals, after all."

/decl/reagent/alcohol/bluelagoon
	name = "Blue Lagoon"
	description = "Because lagoons shouldn't come in other colors."
	color = "#51b8ef"
	strength = 25
	taste_description = "electric lemonade"

	glass_icon_state = "bluelagoon"
	glass_name = "glass of Blue Lagoon"
	glass_desc = "Because lagoons shouldn't come in other colors."

/decl/reagent/alcohol/boukha
	name = "Boukha"
	description = "A distillation of figs, popular in the Serene Republic of Elyra."
	color = "#efd0d0"
	strength = 40
	taste_description = "spiced figs"

	glass_icon_state = "boukhaglass"
	glass_name = "glass of boukha"
	glass_desc = "A distillation of figs, popular in the Serene Republic of Elyra."

/decl/reagent/alcohol/fireball
	name = "Fireball"
	description = "Whiskey that's been infused with cinnamon and hot pepper. Meant for mixing."
	color = "#773404"
	strength = 35
	taste_description = "cinnamon whiskey"

	glass_icon_state = "fireballglass"
	glass_name = "glass of fireball"
	glass_desc = "Whiskey that's been infused with cinnamon and hot pepper. Is this safe to drink?"
	taste_mult = 1.2
	var/agony_dose = 5
	var/agony_amount = 1
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 3

/decl/reagent/alcohol/fireball/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(0.1 * removed)

/decl/reagent/alcohol/fireball/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	to_chat(M, discomfort_message)

/decl/reagent/alcohol/fireball/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.can_feel_pain())
				return
		if(M.chem_doses[type] < agony_dose)
			if(prob(5))
				to_chat(M, discomfort_message)
		else
			M.apply_effect(agony_amount, PAIN, 0)
			if(prob(5))
				M.visible_message("<b>[M]</b> [pick("dry heaves!","coughs!","splutters!")]")
				to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
		if(istype(M, /mob/living/carbon/slime))
			M.bodytemperature += rand(0, 15) + slime_temp_adj
		holder.remove_reagent(/decl/reagent/frostoil, 2)

/decl/reagent/alcohol/cherrytreefireball
	name = "Cherry Tree Fireball"
	description = "An iced fruit cocktail shaken with cinnamon whiskey. Hot, cold and sweet all at once."
	color = "#e87727"
	strength = 15
	taste_description = "sweet spiced cherries"

	glass_icon_state = "cherrytreefireball"
	glass_name = "glass of Cherry Tree Fireball"
	glass_desc = "An iced fruit cocktail shaken with cinnamon whiskey. Hot, cold and sweet all at once."

/decl/reagent/alcohol/cobaltvelvet
	name = "Cobalt Velvet"
	description = "An electric blue champagne cocktail that's popular on the club scene."
	color = "#a3ecf7"
	strength = 25
	taste_description = "neon champagne"
	carbonated = TRUE

	glass_icon_state = "cobaltvelvet"
	glass_name = "glass of Cobalt Velvet"
	glass_desc = "An electric blue champagne cocktail that's popular on the club scene."

/decl/reagent/alcohol/fringeweaver
	name = "Fringe Weaver"
	description = "Effectively pure alcohol with a dose of sugar. It's as simple as it is strong."
	color = "#f78888"
	strength = 65
	taste_description = "liquid regret"

	glass_icon_state = "fringeweaver"
	glass_name = "glass of Fringe Weaver"
	glass_desc = "Effectively pure alcohol with a dose of sugar. It's as simple as it is strong."

/decl/reagent/alcohol/junglejuice
	name = "Jungle Juice"
	description = "You're in the jungle now, baby."
	color = "#773404"
	strength = 35
	taste_description = "a fraternity house party"

	glass_icon_state = "junglejuice"
	glass_name = "glass of Jungle Juice"
	glass_desc = "You're in the jungle now, baby."

/decl/reagent/alcohol/marsarita
	name = "Marsarita"
	description = "The margarita with a Martian twist. They call it something less embarrassing there."
	color = "#3eb7c9"
	strength = 30
	taste_description = "spicy, salty lime"

	glass_icon_state = "marsarita"
	glass_name = "glass of Marsarita"
	glass_desc = "The margarita with a Martian twist. They call it something less embarrassing there."

/decl/reagent/drink/meloncooler
	name = "Melon Cooler"
	description = "Summertime on the beach, in liquid form."
	color = "#d8457b"
	taste_description = "minty melon"

	glass_icon_state = "meloncooler"
	glass_name = "glass of Melon Cooler"
	glass_desc = "Summertime on the beach, in liquid form."

/decl/reagent/alcohol/midnightkiss
	name = "Midnight Kiss"
	description = "A champagne cocktail, quietly bubbling in a slender glass."
	color = "#13144c"
	strength = 25
	taste_description = "a late-night promise"
	carbonated = TRUE

	glass_icon_state = "midnightkiss"
	glass_name = "glass of Midnight Kiss"
	glass_desc = "A champagne cocktail, quietly bubbling in a slender glass."

/decl/reagent/drink/millionairesour
	name = "Millionaire Sour"
	description = "It's a good mix, a great mix. The best mix in known space. It's terrific, you're gonna love it."
	color = "#13144c"
	taste_description = "tart fruit"

	glass_icon_state = "millionairesour"
	glass_name = "glass of Millionaire Sour"
	glass_desc = "It's a good mix, a great mix. Best mix in the galaxy. It's terrific, you're gonna love it."

/decl/reagent/alcohol/olympusmons
	name = "Olympus Mons"
	description = "Another, stronger version of the Black Russian. It's popular in some Martian arcologies."
	color = "#020407"
	strength = 30
	taste_description = "bittersweet independence"

	glass_icon_state = "olympusmons"
	glass_name = "glass of Olympus Mons"
	glass_desc = "Another, stronger version of the Black Russian. It's popular in some Martian arcologies."

/decl/reagent/alcohol/europanail
	name = "Europa Nail"
	description = "Named for Jupiter's moon. It looks about as crusty."
	color = "#785327"
	strength = 30
	taste_description = "a coffee-flavored moon"

	glass_icon_state = "europanail"
	glass_name = "glass of Europa Nail"
	glass_desc = "Named for Jupiter's moon. It looks about as crusty."

/decl/reagent/drink/shirleytemple
	name = "Shirley Temple"
	description = "Straight from the good ship Lollipop."
	color = "#ce2727"
	taste_description = "innocence"

	glass_icon_state = "shirleytemple"
	glass_name = "glass of Shirley Temple"
	glass_desc = "Straight from the good ship Lollipop."

/decl/reagent/alcohol/sugarrush
	name = "Sugar Rush"
	description = "Sweet, light and fruity. As girly as it gets."
	color = "#d51d5d"
	strength = 15
	taste_description = "sweet soda"
	carbonated = TRUE

	glass_icon_state = "sugarrush"
	glass_name = "glass of Sugar Rush"
	glass_desc = "Sweet, light and fruity. As girly as it gets."

/decl/reagent/alcohol/sangria
	name = "Sangria"
	description = "Red wine, splashed with brandy and infused with fruit."
	color = "#960707"
	strength = 30
	taste_description = "sweet wine"

	glass_icon_state = "sangria"
	glass_name = "glass of Sangria"
	glass_desc = "Red wine, splashed with brandy and infused with fruit."

/decl/reagent/alcohol/bassline
	name = "Bassline"
	description = "A vodka cocktail from Vega De Rosa, Mendell City's entertainment district. Purple and deep."
	color = "#6807b2"
	strength = 25
	taste_description = "the groove"

	glass_icon_state = "bassline"
	glass_name = "glass of Bassline"
	glass_desc = "A vodka cocktail from Vega De Rosa, Mendell City's entertainment district. Purple and deep."

/decl/reagent/alcohol/bluebird
	name = "Bluebird"
	description = "A gin drink popularized by a spy thriller in 2452."
	color = "#4286f4"
	strength = 30
	taste_description = "a blue christmas tree"

	glass_icon_state = "bluebird"
	glass_name = "glass of Bluebird"
	glass_desc = "A gin drink popularized by a spy thriller in 2452."

/decl/reagent/alcohol/whitewine
	name = "White Wine"
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#e5d272"
	strength = 15
	taste_description = "dry sweetness"

	glass_icon_state = "whitewineglass"
	glass_name = "glass of white wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

/decl/reagent/alcohol/messa_mead
	name = "Messa's Mead"
	description = "A sweet alcoholic adhomian drink. Produced with Messa's tears and earthen-root."
	color = "#664300"
	strength = 25
	taste_description = "honey"

	glass_icon_state = "messa_mead_glass"
	glass_name = "glass of Messa's Mead"
	glass_desc = "A sweet alcoholic adhomian drink. Produced with Messa's tears."

/decl/reagent/alcohol/winter_offensive
	name = "Winter Offensive"
	description = "An alcoholic tajaran cocktail, named after the famous military campaign."
	color = "#664300"
	strength = 15
	taste_description = "oily gin"
	targ_temp = 270

	glass_icon_state = "winter_offensive"
	glass_name = "glass of Winter Offensive"
	glass_desc = "An alcoholic tajaran cocktail, named after the famous military campaign."

/decl/reagent/alcohol/mountain_marauder
	name = "Mountain Marauder"
	description = "An adhomian beverage made from fermented fatshouters milk and victory gin."
	color = "#DFDFDF"
	strength = 15
	taste_description = "alcoholic sour milk"

	glass_icon_state = "mountain_marauder"
	glass_name = "glass of Mountain Marauder"
	glass_desc = "An adhomian beverage made from fermented fatshouters milk and victory gin."

/decl/reagent/alcohol/mountain_marauder/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien != IS_TAJARA && prob(5))
			H.delayed_vomit()

/decl/reagent/alcohol/cinnamonapplewhiskey
	name = "Cinnamon Apple Whiskey"
	description = "Cider with cinnamon whiskey. It's like drinking a hot apple pie!"
	color = "#664300"
	strength = 20
	taste_description = "sweet spiced apples"

	glass_icon_state = "manlydorfglass"
	glass_name = "mug of cinnamon apple whiskey"
	glass_desc = "Cider with cinnamon whiskey. It's like drinking a hot apple pie!"

// Skrellian drinks
//====================
// Some are alocholic, some are not

/decl/reagent/alcohol/thirdincident
	name = "The Third Incident"
	color = "#1936a0"
	strength = 10
	description = "A controversial drink popular with the punk youth of the Jargon Federation. Represents blood, eggs, and tears."
	taste_description = "genophage sadness"

	glass_icon_state = "thirdincident"
	glass_name = "glass of the Third Incident"
	glass_desc = "A controversial drink popular with the punk youth of the Jargon Federation. Represents blood, eggs, and tears."

/decl/reagent/drink/upsidedowncup
	name = "Upside-Down Cup"
	color = "#B2110A"
	description = "An age-old part of Skrell culture. Even children know of the humor."
	taste_description = "esoteric humor"

	glass_icon_state = "upsidedowncup"
	glass_name = "glass of Upside-Down Cup"
	glass_desc = "An age-old part of Skrell culture. Even children know of the humor. It's not actually upside down."

/decl/reagent/drink/smokinglizard
	name = "Cigarette Lizard"
	color = "#80C274"
	description = "The amusement of Cigarette Lizard, now in a cup!"
	taste_description = "minty sass"

	glass_icon_state = "cigarettelizard"
	glass_name = "glass of Cigarette Lizard"
	glass_desc = "The amusement of Cigarette Lizard, now in a cup!"

/decl/reagent/drink/coffee/sromshine
	name = "Sromshine"
	color = "#A14702"
	description = "The best part of waking up."
	taste_description = "bitter citrus"

	glass_icon_state = "sromshine"
	glass_name = "cup of Sromshine"
	glass_desc = "The best part of waking up."

/decl/reagent/alcohol/cbsc
	name = "Complex Bluespace Calculation"
	color = "#000000"
	strength = 25
	description = "A loud bang. No, really, that's the joke. Skrell get a kick out of it."
	taste_description = "fizzling spatiotemporal instability"

	glass_icon_state = "cbsc"
	glass_name = "glass of Complex Bluespace Calculation"
	glass_desc = "A loud bang. No, really, that's the joke. Skrell get a kick out of it."

/decl/reagent/alcohol/cbsc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(10)

/decl/reagent/drink/algaesuprise
	name = "Pl'iuop Algae Surprise"
	color = "#FFFF80"
	description = "This bubbling drink gives off a faint moldy aroma."
	taste_description = "swamp fungus"

	glass_icon_state = "algae_surprise"
	glass_name = "glass of Pl'iuop Algae Surprise"
	glass_desc = "This bubbling drink gives off a faint moldy aroma."

/decl/reagent/drink/xrim
	name = "Xrim Garden"
	color = "#F6668E"
	description = "A colorful drink that smells a lot like rotten fruit."
	taste_description = "sweet, fruity slime"

	glass_icon_state = "xrim"
	glass_name = "glass of Xrim Garden"
	glass_desc = "A colorful drink that smells a lot like rotten fruit."

/decl/reagent/alcohol/rixulin_sundae
	name = "Rixulin Sundae"
	color = "#83E2C6"
	description = "A fizzing drink that looks like a really great time."
	taste_description = "spacetime and warbling music"

	strength = 15
	druggy = 30

	glass_icon_state = "rixulin_sundae"
	glass_name = "glass of Rixulin Sundae"
	glass_desc = "A fizzing drink that looks like a really great time."

// Butanol-based alcoholic drinks
//=====================================
//These are mainly for unathi, and have very little (but still some) effect on other species

/decl/reagent/alcohol/butanol/xuizijuice
	name = "Xuizi Juice"
	description = "Blended flower buds from a Moghean Xuizi cactus. Has a mild butanol content and is a staple recreational beverage in Unathi culture."
	color = "#91de47"
	strength = 5
	taste_description = "water"

	glass_icon_state = "xuiziglass"
	glass_name = "glass of Xuizi Juice"
	glass_desc = "The clear green liquid smells like vanilla, tastes like water. Unathi swear it has a rich taste and texture."

/decl/reagent/alcohol/butanol/sarezhiwine
	name = "Sarezhi Wine"
	description = "An alcoholic beverage made from lightly fermented Sareszhi berries, considered an upper class delicacy on Moghes. Significant butanol content indicates intoxicating effects on Unathi."
	color = "#bf8fbc"
	strength = 20
	taste_description = "berry juice"

	glass_icon_state = "sarezhiglass"
	glass_name = "glass of Sarezhi Wine"
	glass_desc = "It tastes like plain berry juice. Is this supposed to be alcoholic?"

/decl/reagent/alcohol/butanol/threetownscider
	name = "Three Towns Cider"
	description = "A cider made on the west coast of the Moghresian Sea, this is simply one of many brands made in a region known for its craft local butanol, shipped throughout the Wasteland."
	color = "#b8f77e"
	strength = 20
	taste_description = "bittersweet root juice"

//Kaed's Unathi Cocktails
//=======
//What an exciting time we live in, that lizards may drink fruity girl drinks.
/decl/reagent/alcohol/butanol/moghesmargarita
	name = "Moghes Margarita"
	description = "A classic human cocktail, now ruined with cactus juice instead of tequila."
	color = "#8CFF8C"
	strength = 30
	taste_description = "lime juice"

	glass_icon_state = "cactusmargarita"
	glass_name = "glass of Moghes Margarita"
	glass_desc = "A classic human cocktail, now ruined with cactus juice instead of tequila."
	glass_center_of_mass = list("x"=16, "y"=8)

/decl/reagent/alcohol/butanol/cactuscreme
	name = "Cactus Creme"
	description = "A tasty mix of berries and cream with xuizi juice, for the discerning unathi."
	color = "#664300"
	strength = 15
	taste_description = "creamy berries"

	glass_icon_state = "cactuscreme"
	glass_name = "glass of Cactus Creme"
	glass_desc = "A tasty mix of berries and cream with xuizi juice, for the discerning unathi."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/butanol/bahamalizard
	name = "Bahama Lizard"
	description = "A tropical cocktail containing cactus juice from Moghes, but no actual alcohol."
	color = "#FF7F3B"
	strength = 15
	taste_description = "sweet lemons"

	glass_icon_state = "bahamalizard"
	glass_name = "glass of Bahama Lizard"
	glass_desc = "A tropical cocktail containing cactus juice from Moghes, but no actual alcohol."
	glass_center_of_mass = list("x"=16, "y"=5)

/decl/reagent/alcohol/butanol/lizardphlegm
	name = "Lizard Phlegm"
	description = "Looks gross, but smells fruity."
	color = "#8CFF8C"
	strength = 20
	taste_description = "creamy fruit"

	glass_icon_state = "lizardphlegm"
	glass_name = "glass of Lizard Phlegm"
	glass_desc = "Looks gross, but smells fruity."

/decl/reagent/alcohol/butanol/cactustea
	name = "Cactus Tea"
	description = "Tea flavored with xuizi juice."
	color = "#664300"
	strength = 10
	taste_description = "tea"

	glass_icon_state = "icepick"
	glass_name = "glass of Cactus Tea"
	glass_desc = "Tea flavored with xuizi juice."

/decl/reagent/alcohol/butanol/moghespolitan
	name = "Moghespolitan"
	description = "Pomegranate syrup and cactus juice, with a splash of Sarezhi Wine. Delicious!"
	color = "#664300"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "moghespolitan"
	glass_name = "glass of Moghespolitan"
	glass_desc = "Pomegranate syrup and cactus juice, with a splash of Sarezhi Wine. Delicious!"

/decl/reagent/alcohol/butanol/wastelandheat
	name = "Wasteland Heat"
	description = "A mix of spicy cactus juice to warm you up."
	color = "#664300"
	strength = 40
	adj_temp = 60
	targ_temp = 390
	taste_description = "burning heat"

	glass_icon_state = "moghesheat"
	glass_name = "glass of Wasteland Heat"
	glass_desc = "A mix of spicy cactus juice to warm you up. Maybe a little too warm for non-unathi, though."
	glass_center_of_mass = list("x"=17, "y"=8)

/decl/reagent/alcohol/butanol/sandgria
	name = "Sandgria"
	description = "Sarezhi wine, blended with citrus and a splash of cactus juice."
	color = "#960707"
	strength = 30
	taste_description = "tart berries"

	glass_icon_state = "sangria"
	glass_name = "glass of Sandgria"
	glass_desc = "Sarezhi wine, blended with citrus and a splash of cactus juice."

/decl/reagent/alcohol/butanol/contactwine
	name = "Contact Wine"
	description = "A perfectly good glass of Sarezhi wine, ruined by adding radioactive material. It reminds you of something..."
	color = "#2E6671"
	strength = 50
	taste_description = "berries and regret"

	glass_icon_state = "contactwine"
	glass_name = "glass of Contact Wine"
	glass_desc = "A perfectly good glass of Sarezhi wine, ruined by adding radioactive material. It reminds you of something..."
	glass_center_of_mass = list("x"=17, "y"=4)

/decl/reagent/alcohol/butanol/hereticblood
	name = "Heretics Blood"
	description = "A fizzy cocktail made with cactus juice and heresy."
	color = "#820000"
	strength = 15
	taste_description = "heretically sweet iron"

	glass_icon_state = "demonsblood"
	glass_name = "glass of Heretics' Blood"
	glass_desc = "A fizzy cocktail made with cactus juice and heresy."
	glass_center_of_mass = list("x"=16, "y"=2)

/decl/reagent/alcohol/butanol/sandpit
	name = "Sandpit"
	description = "An unusual mix of cactus and orange juice, mostly favored by unathi."
	color = "#A68310"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Sandpit"
	glass_desc = "An unusual mix of cactus and orange juice, mostly favored by unathi."
	glass_center_of_mass = list("x"=15, "y"=10)

/decl/reagent/alcohol/butanol/cactuscola
	name = "Cactus Cola"
	description = "Cactus juice splashed with cola, on ice. Simple and delicious."
	color = "#3E1B00"
	strength = 15
	taste_description = "cola"
	carbonated = TRUE

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of Cactus Cola"
	glass_desc = "Cactus juice splashed with cola, on ice. Simple and delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/decl/reagent/alcohol/butanol/bloodwine
	name = "Bloodwine"
	description = "A traditional unathi drink said to strengthen one before a battle."
	color = "#C73C00"
	strength = 21
	taste_description = "strong berries"

	glass_icon_state = "bloodwine"
	glass_name = "glass of Bloodwine"
	glass_desc = "A traditional unathi drink said to strengthen one before a battle."
	glass_center_of_mass = list("x"=15, "y"=7)

/decl/reagent/alcohol/butanol/crocodile_booze
	name = "Crocodile Guwan"
	description = "A highly alcoholic butanol based beverage typically fermented using the venom of a zerl'ock and cheaply made Sarezhi Wine. A popular drink among Unathi troublemakers, conviently housed in a 2L plastic bottle."
	color = "#b0f442"
	strength = 50
	taste_description = "sour body sweat"

	glass_icon_state = "crocodile_glass"
	glass_name = "glass of Crocodile Guwan"
	glass_desc = "The smell says no, but the pretty colors say yes."

/decl/reagent/alcohol/butanol/trizkizki_tea
	name = "Trizkizki Tea"
	description = "A popular drink from Ouerea that smells of crisp sea air."
	color = "#876185"
	strength = 5
	taste_description = "light, sweet wine, with a hint of sea breeze"

	glass_icon_state = "trizkizkitea"
	glass_name = "cup of Trizkizki tea"
	glass_desc = "A popular drink from Ouerea that smells of crisp sea air."


	var/last_taste_time = -100

/decl/reagent/alcohol/butanol/trizkizki_tea/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		if(last_taste_time + 800 < world.time) // Not to spam message
			to_chat(M, "<span class='danger'>Your body withers as you feel slight pain throughout.</span>")
			last_taste_time = world.time
		metabolism = REM * 0.33
		M.adjustToxLoss(1.5 * removed)

//ZZZZOOOODDDDAAAAA

/decl/reagent/drink/zorasoda
	name = "Zo'ra Soda Cherry"
	description = "Zo'ra Soda, cherry edition. All good drinks come in cherry."
	color = "#102000"
	adj_sleepy = -2
	caffeine = 0.4
	taste_description = "electric cherry"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/phoron
	name = "Zo'ra Soda Phoron Passion"
	description = "Reported to taste nothing like phoron, but everything like grapes."
	color = "#863333"
	adj_sleepy = -2
	caffeine = 0.4
	taste_description = "electric grape"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/kois
	name = "Zo'ra Soda K'ois Twist"
	description = "Whoever approved this in marketing needs to be drawn and quartered."
	color = "#dcd9cd"
	adj_sleepy = -2
	caffeine = 0.4
	taste_description = "sugary cabbage"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/kois/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(5)

/decl/reagent/drink/zorasoda/hozm
	name = "Zo'ra Soda High Octane Zorane Might"
	description = "It feels like someone is just driving a freezing cold spear through the bottom of your mouth."
	color = "#365000"
	adj_sleepy = -3
	caffeine = 0.6
	taste_description = "a full-body bite into an acidic lemon"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/hozm/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(20)
		M.dizziness += 5
		M.drowsyness = 0

/decl/reagent/drink/zorasoda/venomgrass
	name = "Zo'ra Soda Sour Venom Grass"
	description = "The 'diet' version of High Energy Zorane Might, still tastes like a cloud of stinging polytrinic bees."
	color = "#100800"
	adj_sleepy = -3
	caffeine = 0.4
	taste_description = "fizzy nettles"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/venomgrass/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(5)

/decl/reagent/drink/zorasoda/klax
	name = "Klaxan Energy Crush"
	description = "An orange, cream soda. It's a wonder it got here."
	color = "#E78108"
	adj_sleepy = -3
	caffeine = 0.4
	unaffected_species = IS_MACHINE
	taste_description = "orange cream"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/klax/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(5)

/decl/reagent/drink/zorasoda/cthur
	name = "C'thur Rockin' Raspberry"
	description = "A raspberry concoction you're pretty sure is already on recall."
	color = "#0000CD"
	adj_sleepy = -3
	caffeine = 0.4
	taste_description = "flat raspberry"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/cthur/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.make_jittery(15)

/decl/reagent/drink/zorasoda/drone
	name = "Drone Fuel"
	description = "It's thick as syrup and smells of gas. Why."
	color = "#31004A"
	adj_sleepy = -3
	taste_description = "viscous cola"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/drone/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return

	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.add_chemical_effect(CE_SPEEDBOOST, 1)
		M.add_chemical_effect(CE_BLOODRESTORE, 2 * removed)
		M.make_jittery(5)
	else if(alien != IS_DIONA)
		if (prob(10+M.chem_doses[type]))
			to_chat(M, pick("You feel nauseous!", "Ugh...", "Your stomach churns uncomfortably!", "You feel like you're about to throw up!", "You feel queasy!","You feel pressure in your abdomen!"))

		if (prob(M.chem_doses[type]))
			M.vomit()

/decl/reagent/drink/zorasoda/jelly
	name = "Royal Jelly"
	description = "It looks of mucus, but tastes like Heaven."
	color = "#FFFF00"
	adj_sleepy = -3
	caffeine = 0.3
	taste_description = "a reassuring spectrum of color"
	carbonated = TRUE

/decl/reagent/drink/zorasoda/jelly/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.druggy = max(M.druggy, 30)
		M.dizziness += 5
		M.drowsyness = 0

/decl/reagent/drink/hrozamal_soda
	name = "Hro'zamal Soda"
	description = "A cabornated version of the herbal tea made with Hro'zamal Ras'Nifs powder."
	color = "#F0C56C"
	adj_sleepy = -1
	caffeine = 0.2
	taste_description = "carbonated fruit sweetness"
	carbonated = TRUE

	glass_icon_state = "hrozamal_soda_glass"
	glass_name = "glass of Hro'zamal Soda"
	glass_desc = "A cabornated version of the herbal tea made with Hro'zamal Ras'Nifs powder."

/decl/reagent/nutriment/pumpkinpulp
	name = "Pumpkin Pulp"
	description = "The gooey insides of a slain pumpkin. This day is the greatest..."
	color = "#f9ab28"
	taste_description = "gooey pumpkin"

/decl/reagent/spacespice/pumpkinspice
	name = "Pumpkin Spice"
	description = "A delicious seasonal flavoring."
	color = "#AE771C"
	taste_description = "autumn bliss"

/decl/reagent/drink/syrup_chocolate
	name = "Chocolate Syrup"
	description = "Thick chocolate syrup used to flavor drinks."
	taste_description = "chocolate"
	color = "#542a0c"

	glass_name = "chocolate syrup"
	glass_desc = "Thick chocolate syrup used to flavor drinks."

/decl/reagent/drink/syrup_caramel
	name = "Caramel Syrup"
	description = "Thick caramel syrup used to flavor drinks."
	taste_description = "caramel"
	color = "#85461e"

	glass_name = "caramel syrup"
	glass_desc = "Thick caramel syrup used to flavor drinks."

/decl/reagent/drink/syrup_vanilla
	name = "Vanilla Syrup"
	description = "Thick vanilla syrup used to flavor drinks."
	taste_description = "vanilla"
	color = "#f3e5ab"

	glass_name = "vanilla syrup"
	glass_desc = "Thick vanilla syrup used to flavor drinks."

/decl/reagent/drink/syrup_pumpkin
	name = "Pumpkin Spice Syrup"
	description = "Thick spiced pumpkin syrup used to flavor drinks."
	taste_description = "spiced pumpkin"
	color = "#d88b4c"

	glass_name = "pumpkin spice syrup"
	glass_desc = "Thick spiced pumpkin syrup used to flavor drinks."

/decl/reagent/drink/syrup_simple
	name = "Simple Syrup"
	description = "Thick, unflavored syrup used as a base for drinks or flavorings."
	taste_description = "molasses"
	color = "#ccccbb"
	glass_name = "simple syrup"
	glass_desc = "Thick, unflavored syrup used as a base for drinks or flavorings."

/decl/reagent/nutriment/caramel
	name = "Caramel Sugar"
	reagent_state = SOLID
	description = "Caramelised sugar, used in various recipes."
	taste_description = "toasty sweetness"

/decl/reagent/drink/caramel
	name = "Caramel Sauce"
	reagent_state = LIQUID
	description = "A caramel-based sauce. Now you're caramel dancin'."
	taste_description = "toasty sweet cream"

/decl/reagent/diona_powder
	name = "Dionae Powder"
	description = "Powdered Dionae ambergris."
	reagent_state = SOLID
	color = "#e08702"
	taste_description = "diona delicacy"
	fallback_specific_heat = 2
	condiment_name = "bottle of dionae powder"
	condiment_desc = "A vegetarian friendly way to add a little extra pizazz to any dish."
	condiment_icon_state = "dionaepowder"
	condiment_center_of_mass = list("x"=16, "y"=10)
