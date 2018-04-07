/* Food */
/datum/reagent/kois
	name = "K'ois"
	id = REAGENT_KOISPASTE
	description = "A thick goopy substance, rich in K'ois nutrients."
	metabolism = REM * 4
	var/nutriment_factor = 10
	var/injectable = 0
	color = "#dcd9cd"
	taste_description = "boiled cabbage"
	unaffected_species = IS_MACHINE
	var/kois_type = 1

/datum/reagent/kois/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VAURCA)
		M.heal_organ_damage(1.2 * removed, 1.2 * removed)
		M.adjustToxLoss(-1.2 * removed)
		M.nutrition += nutriment_factor * removed // For hunger and fatness
		M.add_chemical_effect(CE_BLOODRESTORE, 6 * removed)
	else
		M.adjustToxLoss(1 * removed)
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			switch(kois_type)
				if(1) //Normal
					if(!H.internal_organs_by_name["kois"] && prob(5*removed))
						var/obj/item/organ/external/affected = H.get_organ("chest")
						var/obj/item/organ/parasite/kois/infest = new()
						infest.replaced(H, affected)
				if(2) //Modified
					if(!H.internal_organs_by_name["blackkois"] && prob(10*removed))
						var/obj/item/organ/external/affected = H.get_organ("head")
						var/obj/item/organ/parasite/blackkois/infest = new()
						infest.replaced(H, affected)
	..()

/datum/reagent/kois/clean
	name = "Filtered K'ois"
	id = REAGENT_KOISPASTECLEAN
	description = "A strange, ketchup-like substance, filled with K'ois nutrients."
	color = "#ece9dd"
	taste_description = "cabbage soup"
	kois_type = 0

/datum/reagent/kois/black
	name = "Modified K'ois"
	id = REAGENT_BLACKKOIS
	description = "A thick goopy substance, rich in K'ois nutrients. This sample appears to be modified."
	color = "#31004A"
	taste_description = "tar"
	kois_type = 2

/* Food */
/datum/reagent/nutriment
	name = "Nutriment"
	id = REAGENT_NUTRIMENT
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 4
	var/nutriment_factor = -(REM * 4)/BASE_MAX_NUTRITION // Per removed in digest.
	var/blood_factor = 6
	var/regen_factor = 0.8
	var/injectable = 0
	var/attrition_factor = -0.1 // Decreases attrition rate.
	color = "#664330"
	unaffected_species = IS_MACHINE

/datum/reagent/nutriment/synthetic
	name = "Synthetic Nutriment"
	id = REAGENT_SYNNUTRIMENT
	description = "A cheaper alternative to actual nutriment."
	attrition_factor = (REM * 4)/BASE_MAX_NUTRITION // Increases attrition rate.

/datum/reagent/nutriment/mix_data(var/list/newdata, var/newamount)
	if(!islist(newdata) || !newdata.len)
		return
	for(var/i in 1 to newdata.len)
		if(!(newdata[i] in data))
			data.Add(newdata[i])
			data[newdata[i]] = 0
		data[newdata[i]] += newdata[newdata[i]]
	var/totalFlavor = 0
	for(var/i in 1 to data.len)
		totalFlavor += data[data[i]]

	if (!totalFlavor)
		return

	for(var/i in 1 to data.len) //cull the tasteless
		if(data[data[i]]/totalFlavor * 100 < 10)
			data[data[i]] = null
			data -= data[i]
			data -= null

/datum/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!injectable)
		M.adjustToxLoss(0.1 * removed)
		return
	affect_ingest(M, alien, removed)

/datum/reagent/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VAURCA)
		M.adjustToxLoss(1.5 * removed)
	else if(alien != IS_UNATHI)
		digest(M,removed)

/datum/reagent/nutriment/proc/digest(var/mob/living/carbon/M, var/removed)
	M.heal_organ_damage(regen_factor * removed, 0)
	M.nutrition += nutriment_factor * removed // For hunger and fatness
	M.nutrition_attrition_rate = Clamp(M.nutrition_attrition_rate + attrition_factor, 1, 2)
	M.add_chemical_effect(CE_BLOODRESTORE, blood_factor * removed)



/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.

	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/
/datum/reagent/nutriment/coating
	nutriment_factor = 6 //Less dense than the food itself, but coatings still add extra calories
	var/messaged = 0
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"
	taste_description = "some sort of frying coating"

/datum/reagent/nutriment/coating/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)

	//We'll assume that the batter isnt going to be regurgitated and eaten by someone else. Only show this once
	if (data["cooked"] != 1)
		if (!messaged)
			M << "Ugh, this raw [name] tastes disgusting."
			nutriment_factor *= 0.5
			messaged = 1

		//Raw coatings will sometimes cause vomiting
		if (ishuman(M) && prob(1))
			var/mob/living/carbon/human/H = M
			H.delayed_vomit()
	..()

/datum/reagent/nutriment/coating/initialize_data(var/newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list()
	else
		if (isnull(data["cooked"]))
			data["cooked"] = 0
		return
	data["cooked"] = 0
	if (holder && holder.my_atom && istype(holder.my_atom,/obj/item/weapon/reagent_containers/food/snacks))
		data["cooked"] = 1
		name = cooked_name

		//Batter which is part of objects at compiletime spawns in a cooked state


//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/coating/mix_data(var/newdata, var/newamount)
	if (!data)
		data = list()

	data["cooked"] = newdata["cooked"]


/datum/reagent/nutriment/coating/batter
	name = "batter mix"
	cooked_name = "batter"
	id = REAGENT_BATTER
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"
	taste_description = "batter"

/datum/reagent/nutriment/coating/beerbatter
	name = "beer batter mix"
	cooked_name = "beer batter"
	id = REAGENT_BEERBATTER
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"
	taste_description = "beer-batter"

/datum/reagent/nutriment/coating/beerbatter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.intoxication += removed*0.02 //Very slightly alcoholic

//==============================
/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "animal protein"
	id = REAGENT_PROTEIN
	color = "#440000"
	blood_factor = 12
	taste_description = "meat"

/datum/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(0.5 * removed)
		return
	if(alien && alien == IS_UNATHI)
		digest(M,removed)
		return
	..()

/datum/reagent/nutriment/protein/tofu //Good for Skrell!
	name = "tofu protein"
	id = REAGENT_TOFU
	color = "#fdffa8"
	taste_description = "tofu"

/datum/reagent/nutriment/protein/tofu/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		digest(M,removed) //Skrell are allowed to eat tofu, but not most animal proteins
		return
	..()

/datum/reagent/nutriment/protein/seafood // Good for Skrell!
	name = "seafood protein"
	id = REAGENT_SEAFOOD
	color = "#f5f4e9"
	taste_description = "fish"

/datum/reagent/nutriment/protein/seafood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		digest(M,removed)//Skrell are allowed to eat fish, but not other proteins
		return
	..()

/datum/reagent/nutriment/protein/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(2 * removed)
		return
	..()

/datum/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "egg yolk"
	id = REAGENT_EGG
	color = "#FFFFAA"
	taste_description = "egg"

/datum/reagent/nutriment/egg/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(0.5 * removed)
		return
	if(alien && alien == IS_UNATHI)
		digest(M,removed)
		return
	..()

/datum/reagent/nutriment/protein/cheese // Also bad for skrell.
	name = "cheese"
	id = REAGENT_CHEESE
	color = "#EDB91F"
	taste_description = "cheese"

//Fats
//=========================
/datum/reagent/nutriment/triglyceride
	name = "triglyceride"
	id = REAGENT_TRIGLYCERIDE
	description = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	reagent_state = SOLID
	nutriment_factor = 27//The caloric ratio of carb/protein/fat is 4:4:9
	color = "#CCCCCC"
	taste_description = "fat"

//Unathi can digest fats too
/datum/reagent/nutriment/triglyceride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_UNATHI)
		digest(M,removed)
		return
	..()

/datum/reagent/nutriment/triglyceride/oil
	//Having this base class incase we want to add more variants of oil
	name = "Oil"
	id = REAGENT_OIL
	description = "Oils are liquid fats"
	reagent_state = LIQUID
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0
	taste_description = "some short of oil"
	taste_mult = 0.1

/datum/reagent/nutriment/triglyceride/oil/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	/*
	//Why should oil put out fires? Pondering removing this

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
	*/

	if(volume >= 3)
		T.wet_floor(2)

/datum/reagent/nutriment/triglyceride/oil/initialize_data(var/newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list("temperature" = T20C)

//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/triglyceride/oil/mix_data(var/newdata, var/newamount)

	if (!data)
		data = list()

	var/ouramount = volume - newamount
	if (ouramount <= 0 || !data["temperature"] || !volume)
		//If we get here, then this reagent has just been created, just copy the temperature exactly
		data["temperature"] = newdata["temperature"]

	else
		//Our temperature is set to the mean of the two mixtures, taking volume into account
		var/total = (data["temperature"] * ouramount) + (newdata["temperature"] * newamount)
		data["temperature"] = total / volume

	return ..()


//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/datum/reagent/nutriment/triglyceride/oil/proc/heatdamage(var/mob/living/carbon/M)
	var/threshold = 360//Human heatdamage threshold
	var/datum/species/S = M.get_species(1)
	if (S && istype(S))
		threshold = S.heat_level_1

	//If temperature is too low to burn, return a factor of 0. no damage
	if (data["temperature"] < threshold)
		return 0

	//Step = degrees above heat level 1 for 1.0 multiplier
	var/step = 60
	if (S && istype(S))
		step = (S.heat_level_2 - S.heat_level_1)*1.5

	. = data["temperature"] - threshold
	. /= step
	. = min(., 2.5)//Cap multiplier at 2.5

/datum/reagent/nutriment/triglyceride/oil/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/dfactor = heatdamage(M)
	if (dfactor)
		M.take_organ_damage(0, removed * 1.5 * dfactor)
		data["temperature"] -= (6 * removed) / (1 + volume*0.1)//Cools off as it burns you
		if (lastburnmessage+100 < world.time	)
			M << span("danger", "Searing hot oil burns you, wash it off quick!")
			lastburnmessage = world.time


/datum/reagent/nutriment/triglyceride/oil/corn
	name = "Corn Oil"
	id = REAGENT_CORNOIL
	description = "An oil derived from various types of corn."
	taste_description = "corn oil"

/datum/reagent/nutriment/honey
	name = "Honey"
	id = REAGENT_HONEY
	description = "A golden yellow syrup, loaded with sugary sweetness."
	nutriment_factor = 10
	color = "#FFFF00"
	taste_description = "honey"

/datum/reagent/nutriment/flour
	name = "flour"
	id = REAGENT_FLOUR
	description = "This is what you rub all over yourself to pretend to be a ghost."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	taste_description = "chalky wheat"

/datum/reagent/nutriment/flour/touch_turf(var/turf/simulated/T)
	if(!istype(T, /turf/space))
		if(locate(/obj/effect/decal/cleanable/flour) in T)
			return

		new /obj/effect/decal/cleanable/flour(T)

/datum/reagent/nutriment/coco
	name = "Coco Powder"
	id = REAGENT_COCO
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"
	taste_description = "bitterness"
	taste_mult = 1.3

/datum/reagent/nutriment/soysauce
	name = "Soysauce"
	id = REAGENT_SOYSAUCE
	description = "A salty sauce made from the soy plant."
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"
	taste_description = "umami"
	taste_mult = 1.1

/datum/reagent/nutriment/ketchup
	name = "Ketchup"
	id = REAGENT_KETCHUP
	description = "Ketchup, catsup, whatever. It's tomato paste."
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"
	taste_description = "ketchup"

/datum/reagent/nutriment/rice
	name = "Rice"
	id = REAGENT_RICE
	description = "Enjoy the great taste of nothing."
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	taste_description = "rice"
	taste_mult = 0.4

/datum/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	id = REAGENT_CHERRYJELLY
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801E28"
	taste_description = "cherry"
	taste_mult = 1.3

/datum/reagent/nutriment/virus_food
	name = "Virus Food"
	id = REAGENT_VIRUSFOOD
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#899613"
	taste_description = "vomit"
	taste_mult = 2

/datum/reagent/nutriment/sprinkles
	name = "Sprinkles"
	id = REAGENT_SPRINKLES
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1
	color = "#FF00FF"
	taste_description = "sweetness"

/datum/reagent/nutriment/mint
	name = "Mint"
	id = REAGENT_MINT
	description = "Also known as Mentha."
	reagent_state = LIQUID
	color = "#CF3600"
	taste_description = "mint"

/datum/reagent/nutriment/glucose
	name = "Glucose"
	id = REAGENT_GLUCOSE
	color = "#FFFFFF"
	injectable = 1
	taste_description = "sweetness"

/datum/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	id = REAGENT_LIPOZINE
	description = "A chemical compound that causes a powerful fat-burning reaction."
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE
	taste_description = "mothballs"

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 10 * removed, 0)
	M.overeatduration = 0
	if(M.nutrition < 0)
		M.nutrition = 0

/* Non-food stuff like condiments */

/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = REAGENT_SODIUMCHLORIDE
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE
	taste_description = "salt"

/datum/reagent/blackpepper
	name = "Black Pepper"
	id = REAGENT_BLACKPEPPER
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	color = "#000000"
	taste_description = "pepper"

/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = REAGENT_ENZYME
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	reagent_state = LIQUID
	color = "#365E30"
	overdose = REAGENTS_OVERDOSE
	taste_description = "sweetness"
	taste_mult = 0.7

/datum/reagent/frostoil
	name = "Frost Oil"
	id = REAGENT_FROSTOIL
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#B31008"
	taste_description = "mint"
	taste_mult = 1.5

/datum/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent(REAGENT_CAPSAICIN, 5)

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = REAGENT_CAPSAICIN
	description = "This is what makes chilis hot."
	reagent_state = LIQUID
	color = "#B31008"
	taste_description = "hot peppers"
	taste_mult = 1.5
	var/agony_dose = 5
	var/agony_amount = 1
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10

/datum/reagent/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(0.5 * removed)

/datum/reagent/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && (H.species.flags & (NO_PAIN)))
			return
	if(dose < agony_dose)
		if(prob(5) || dose == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			M << discomfort_message
	else
		M.apply_effect(agony_amount, AGONY, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			M << "<span class='danger'>You feel like your insides are burning!</span>"
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent(REAGENT_FROSTOIL, 5)

/datum/reagent/capsaicin/condensed
	name = "Condensed Capsaicin"
	id = REAGENT_CONDENSEDCAPSAICIN
	description = "A chemical agent used for self-defense and in police work."
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly
	color = "#B31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15

/datum/reagent/capsaicin/condensed/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
#define EYES_PROTECTED 1
#define EYES_MECH 2
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
		if(H.species && (H.species.flags & NO_PAIN))
			no_pain = 1 //TODO: living-level can_feel_pain() proc

		// Robo-eyes are immune to pepperspray now. Wee.
		var/obj/item/organ/eyes/E = H.get_eyes()
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
			message = "<span class='warning'>Your mechanical eyes are invulnurable pepperspray!</span>"
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
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
		M.Stun(5)
		M.Weaken(5)
#undef EYES_PROTECTED
#undef EYES_MECH

/datum/reagent/condensedcapsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && (H.species.flags & NO_PAIN))
			return
	if(dose == metabolism)
		M << "<span class='danger'>You feel like your insides are burning!</span>"
	else
		M.apply_effect(4, AGONY, 0)
		if(prob(5))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>", "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent(REAGENT_FROSTOIL, 5)

/datum/reagent/spacespice
	name = "Space Spice"
	id = REAGENT_SPACESPICE
	description = "An exotic blend of spices for cooking. It must flow."
	reagent_state = SOLID
	color = "#e08702"
	taste_description = "spices"
	taste_mult = 1.5

/datum/reagent/browniemix
	name = "Brownie Mix"
	id = REAGENT_BROWNIEMIX
	description = "A dry mix for making delicious brownies."
	reagent_state = SOLID
	color = "#441a03"
	taste_description = "chocolate"

/* Drinks */

/datum/reagent/drink
	name = "Drink"
	id = REAGENT_DRINK
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	color = "#E78108"
	var/nutrition = 0 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0
	var/caffeine = 0 // strength of stimulant effect, since so many drinks use it
	var/datum/modifier/modifier = null

/datum/reagent/drink/Destroy()
	if (modifier)
		QDEL_NULL(modifier)
	return ..()

/datum/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed) // Probably not a good idea; not very deadly though
	return

/datum/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (caffeine && !modifier)
		modifier = M.add_modifier(/datum/modifier/stimulant, MODIFIER_REAGENT, src, _strength = caffeine, override = MODIFIER_OVERRIDE_STRENGTHEN)

	M.nutrition += nutrition * removed
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.sleeping = max(0, M.sleeping + adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices

/datum/reagent/drink/banana
	name = "Banana Juice"
	id = REAGENT_BANANA
	description = "The raw essence of a banana."
	color = "#C3AF00"
	taste_description = "banana"

	glass_icon_state = "banana"
	glass_name = "glass of banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/datum/reagent/drink/berryjuice
	name = "Berry Juice"
	id = REAGENT_BERRYJUICE
	description = "A delicious blend of several different kinds of berries."
	color = "#990066"
	taste_description = "berries"

	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/drink/carrotjuice
	name = "Carrot juice"
	id = REAGENT_CARROTJUICE
	description = "It is just like a carrot but without crunching."
	color = "#FF8C00" // rgb: 255, 140, 0
	taste_description = "carrots"

	glass_icon_state = "carrotjuice"
	glass_name = "glass of carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/datum/reagent/drink/carrotjuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent(REAGENT_IMIDAZOLINE, removed * 0.2)

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	id = REAGENT_GRAPEJUICE
	description = "It's grrrrrape!"
	color = "#863333"
	taste_description = "grapes"

	glass_icon_state = "grapejuice"
	glass_name = "glass of grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/lemonjuice
	name = "Lemon Juice"
	id = REAGENT_LEMONJUICE
	description = "This juice is VERY sour."
	color = "#AFAF00"
	taste_description = "sourness"

	glass_icon_state = "lemonjuice"
	glass_name = "glass of lemon juice"
	glass_desc = "Sour..."

/datum/reagent/drink/limejuice
	name = "Lime Juice"
	id = REAGENT_LIMEJUICE
	description = "The sweet-sour juice of limes."
	color = "#365E30"
	taste_description = "tart citrus"
	taste_mult = 1.1

	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/datum/reagent/drink/limejuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	id = REAGENT_ORANGEJUICE
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108"
	taste_description = "oranges"

	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/orangejuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustOxyLoss(-2 * removed)

/datum/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	id = REAGENT_POISONBERRYJUICE
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353"
	strength = 5
	taste_description = "berries"

	glass_icon_state = "poisonberryjuice"
	glass_name = "glass of poison berry juice"
	glass_desc = "A glass of deadly juice."

/datum/reagent/drink/potato_juice
	name = "Potato Juice"
	id = REAGENT_POTATO
	description = "Juice of the potato. Bleh."
	nutrition = 2
	color = "#302000"
	taste_description = "potato"

	glass_icon_state = "glass_brown"
	glass_name = "glass of potato juice"
	glass_desc = "Juice from a potato. Bleh."

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	id = REAGENT_TOMATOJUICE
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008"
	taste_description = "tomatoes"

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/drink/tomatojuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0, 0.5 * removed)

/datum/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	id = REAGENT_WATERMELONJUICE
	description = "Delicious juice made from watermelon."
	color = "#B83333"
	taste_description = "watermelon"

	glass_icon_state = "glass_red"
	glass_name = "glass of watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

// Everything else

/datum/reagent/drink/milk
	name = "Milk"
	id = REAGENT_MILK
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF"
	taste_description = "milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent(REAGENT_CAPSAICIN, 10 * removed)

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = REAGENT_CREAM
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF"
	taste_description = "creamy milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = REAGENT_SOYMILK
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7"
	taste_description = "soy milk"

	glass_icon_state = "glass_white"
	glass_name = "glass of soy milk"
	glass_desc = "White and nutritious soy goodness!"

/datum/reagent/drink/tea
	name = "Tea"
	id = REAGENT_TEA
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20
	taste_description = "tart black tea"

	glass_icon_state = "bigteacup"
	glass_name = "cup of tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = REAGENT_ICETEA
	description = "No relation to a certain rap artist/ actor."
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = -5
	taste_description = "sweet tea"

	glass_icon_state = "icedteaglass"
	glass_name = "glass of iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_center_of_mass = list("x"=15, "y"=10)


/datum/reagent/drink/coffee
	name = "Coffee"
	id = REAGENT_COFFEE
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = 45
	caffeine = 0.3
	taste_description = "coffee"
	taste_mult = 1.3

	glass_icon_state = "hot_coffee"
	glass_name = "cup of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(adj_temp > 0)
		holder.remove_reagent(REAGENT_FROSTOIL, 10 * removed)

	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	M.intoxication = max(0, (M.intoxication - (removed*0.25)))
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien)
	M.make_jittery(5)

/datum/reagent/drink/coffee/icecoffee
	name = "Frappe Coffee"
	id = REAGENT_ICECOFFEE
	description = "Coffee and ice, refreshing and cool."
	color = "#102838"
	adj_temp = -5

	glass_icon_state = "icedcoffeeglass"
	glass_name = "glass of frappe coffee"
	glass_desc = "A drink to perk you up and refresh you!"

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = REAGENT_SOY_LATTE
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#664300"
	adj_temp = 5
	taste_description = "creamy coffee"

	glass_icon_state = "soy_latte"
	glass_name = "glass of soy latte"
	glass_desc = "A nice and refrshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = REAGENT_CAFE_LATTE
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "bitter cream"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/espresso
	name = "Espresso"
	id = REAGENT_ESPRESSO
	description = "A strong coffee made by passing nearly boiling water through coffee seeds at high pressure."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "bitter coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "shot of espresso"
	glass_desc = "A strong coffee made by passing nearly boiling water through coffee seeds at high pressure."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/freddo_espresso
	name = "Freddo espresso"
	id = REAGENT_FREDDO_ESPRESSO
	description = "Espresso with ice cubes poured over ice."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "cold and bitter coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of freddo espresso"
	glass_desc = "Espresso with ice cubes poured over ice."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/caffe_americano
	name = "Caffe Americano"
	id = REAGENT_CAFFE_AMERICANO
	description = "Espresso diluted with hot water."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "delicious coffee"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of caffe Americano"
	glass_desc = "delicious coffee"
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/flat_white
	name = "Flat White Espresso"
	id = REAGENT_FLAT_WHITE
	description = "Espresso with a bit of steamy hot milk."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "bitter coffee and milk"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of flat white"
	glass_desc = "Espresso with a bit of steamy hot milk."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/latte
	name = "Latte"
	id = REAGENT_LATTE
	description = "A nice, strong and refreshing beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "bitter cream"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/cappuccino
	name = "Cappuccino"
	id = REAGENT_CAPPUCCINO
	description = "Espresso with steamed milk foam."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of cappuccino"
	glass_desc = "Espresso with steamed milk foam."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/freddo_cappuccino
	name = "Freddo Cappuccino"
	id = REAGENT_FREDDO_CAPPUCCINO
	description = "Espresso with steamed milk foam, on ice."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "cold and bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of freddo cappuccino"
	glass_desc = "Espresso with steamed milk foam, on ice."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/macchiato
	name = "Macchiato"
	id = REAGENT_MACCHIATO
	description = "Espresso with milk foam."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "bitter milk foam"

	glass_icon_state = "hot_coffee"
	glass_name = "glass of macchiato"
	glass_desc = "Espresso with milk foam."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/mocacchino
	name = "Mocacchino"
	id = REAGENT_MOCACCHINO
	description = "Espresso with hot milk and chocolate."
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_description = "sweet milk and bitter coffee"

	glass_icon_state = "cafe_latte"
	glass_name = "glass of mocacchino"
	glass_desc = "Espresso with hot milk and chocolate."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = REAGENT_HOT_COCO
	description = "Made with love! And cocoa beans."
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5
	taste_description = "creamy chocolate"

	glass_icon_state = "chocolateglass"
	glass_name = "glass of hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/datum/reagent/drink/sodawater
	name = "Soda Water"
	id = REAGENT_SODAWATER
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5
	taste_description = "carbonated water"

	glass_icon_state = "glass_clear"
	glass_name = "glass of soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"

/datum/reagent/drink/grapesoda
	name = "Grape Soda"
	id = REAGENT_GRAPESODA
	description = "Grapes made into a fine drank."
	color = "#421C52"
	adj_drowsy = -3
	taste_description = "grape soda"

	glass_icon_state = "gsodaglass"
	glass_name = "glass of grape soda"
	glass_desc = "Looks like a delicious drink!"

/datum/reagent/drink/tonic
	name = "Tonic Water"
	id = REAGENT_TONIC
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#664300"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5
	taste_description = "tart and fresh"

	glass_icon_state = "glass_clear"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	id = REAGENT_LEMONADE
	color = "#FFFF00"
	adj_temp = -5
	taste_description = "tartness"

	glass_icon_state = "lemonadeglass"
	glass_name = "glass of lemonade"
	glass_desc = "Oh the nostalgia..."

/datum/reagent/drink/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	id = REAGENT_KIRASPECIAL
	color = "#CCCC99"
	adj_temp = -5
	taste_description = "fruity sweetness"

	glass_icon_state = "kiraspecial"
	glass_name = "glass of Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/drink/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	id = REAGENT_BROWNSTAR
	color = "#9F3400"
	adj_temp = -2
	taste_description = "orange and cola soda"

	glass_icon_state = "brownstar"
	glass_name = "glass of Brown Star"
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/mintsyrup
	name = "Mint Syrup"
	description = "A simple syrup that tastes strongly of mint."
	id = REAGENT_MINTSYRUP
	color = "#539830"
	taste_description = "mint"

	glass_icon_state = "mint_syrupglass"
	glass_name = "glass of mint syrup"
	glass_desc = "Pure mint syrup. Prepare your tastebuds."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	id = REAGENT_MILKSHAKE
	color = "#AEE5E4"
	adj_temp = -9
	taste_description = "creamy vanilla"

	glass_icon_state = "milkshake"
	glass_name = "glass of milkshake"
	glass_desc = "Glorious brainfreezing mixture."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	id = REAGENT_REWRITER
	color = "#485000"
	adj_temp = -5
	caffeine = 0.4
	taste_description = "soda and coffee"

	glass_icon_state = "rewriter"
	glass_name = "glass of Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.make_jittery(5)


/datum/reagent/drink/nuka_cola
	name = "Nuka Cola"
	id = REAGENT_NUKA_COLA
	description = "Cola, cola never changes."
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2
	caffeine = 1
	taste_description = "cola"

	glass_icon_state = "nuka_colaglass"
	glass_name = "glass of Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/drink/nuka_cola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness += 5
	M.drowsyness = 0

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = REAGENT_GRENADINE
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F"
	taste_description = "100% pure pomegranate"

	glass_icon_state = "grenadineglass"
	glass_name = "glass of grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/space_cola
	name = "Space Cola"
	id = REAGENT_COLA
	description = "A refreshing beverage."
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5
	taste_description = "cola"

	glass_icon_state  = "glass_brown"
	glass_name = "glass of Space Cola"
	glass_desc = "A glass of refreshing Space Cola"

/datum/reagent/drink/spacemountainwind
	name = "Mountain Wind"
	id = REAGENT_SPACEMOUNTAINWIND
	description = "Blows right through you like a space wind."
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5
	taste_description = "sweet citrus soda"

	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."

/datum/reagent/drink/dr_gibb
	name = "Dr. Gibb"
	id = REAGENT_DR_GIBB
	description = "A delicious blend of 42 different flavours"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5
	taste_description = "cherry soda"

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/root_beer
	name = "R&D Root Beer"
	id = REAGENT_ROOT_BEER
	description = "A classic Earth drink from the United Americas province."
	color = "#211100"
	adj_drowsy = -6
	adj_temp = -5
	taste_description = "sassafras and anise soda"

	glass_icon_state = "root_beer_glass"
	glass_name = "glass of R&D Root Beer"
	glass_desc = "A glass of bubbly R&D Root Beer."

/datum/reagent/drink/space_up
	name = "Space-Up"
	id = REAGENT_SPACE_UP
	description = "Tastes like a hull breach in your mouth."
	color = "#202800"
	adj_temp = -8
	taste_description = "a hull breach"

	glass_icon_state = "space-up_glass"
	glass_name = "glass of Space-up"
	glass_desc = "Space-up. It helps keep your cool."

/datum/reagent/drink/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	id = REAGENT_LEMON_LIME
	color = "#878F00"
	adj_temp = -8
	taste_description = "tangy lime and lemon soda"

	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	id = REAGENT_DOCTORSDELIGHT
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = LIQUID
	color = "#FF8CFF"
	nutrition = 1
	taste_description = "homely fruit"

	glass_icon_state = "doctorsdelightglass"
	glass_name = "glass of The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/doctor_delight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)
	if(M.dizziness)
		M.dizziness = max(0, M.dizziness - 15)
	if(M.confused)
		M.confused = max(0, M.confused - 5)

/datum/reagent/drink/dry_ramen
	name = "Dry Ramen"
	id = REAGENT_DRY_RAMEN
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"
	taste_description = "dry and cheap noodles"

/datum/reagent/drink/hot_ramen
	name = "Hot Ramen"
	id = REAGENT_HOT_RAMEN
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5
	taste_description = "wet and cheap noodles"

/datum/reagent/drink/hell_ramen
	name = "Hell Ramen"
	id = REAGENT_HELL_RAMEN
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	taste_description = "wet and cheap noodles on fire"

/datum/reagent/drink/hell_ramen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/drink/ice
	name = "Ice"
	id = REAGENT_ICE
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5
	taste_description = "ice"
	taste_mult = 1.5

	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

/datum/reagent/drink/nothing
	name = "Nothing"
	id = REAGENT_NOTHING
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_icon_state = "nothing"
	glass_name = "glass of nothing"
	glass_desc = "Absolutely nothing."

/datum/reagent/drink/meatshake
	name = "Meatshake"
	id = REAGENT_MEATSHAKE
	color = "#874c20"
	description = "Blended meat and cream for those who want crippling heart failure down the road."
	taste_description = "liquified meat"

	glass_icon_state = "meatshake"
	glass_name = "Meatshake"
	glass_desc = "Blended meat and cream for those who want crippling health issues down the road. Has two straws for sharing! Perfect for dates!"

/* Alcohol */

// Basic

/datum/reagent/alcohol/ethanol/absinthe
	name = "Absinthe"
	id = REAGENT_ABSINTHE
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#33EE00"
	strength = 75
	taste_description = "licorice"

	glass_icon_state = "absintheglass"
	glass_name = "glass of absinthe"
	glass_desc = "Wormwood, anise, oh my."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/ale
	name = "Ale"
	id = REAGENT_ALE
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#664300"
	strength = 6
	taste_description = "hearty barley ale"

	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A freezing pint of delicious ale"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/beer
	name = "Beer"
	id = REAGENT_BEER
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300"
	strength = 5
	nutriment_factor = 1
	taste_description = "beer"

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/alcohol/ethanol/bitters
	name = "Aromatic Bitters"
	id = REAGENT_BITTERS
	description = "A very, very concentrated and bitter herbal alcohol."
	color = "#223319"
	strength = 40
	taste_description = "bitter"

	glass_icon_state = "bittersglass"
	glass_name = "glass of bitters"
	glass_desc = "A pungent glass of bitters."
	glass_center_of_mass = list ("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/bluecuracao
	name = "Blue Curacao"
	id = REAGENT_BLUECURACAO
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD"
	strength = 25
	taste_description = "oranges"

	glass_icon_state = "curacaoglass"
	glass_name = "glass of blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/champagne
	name = "Champagne"
	id = REAGENT_CHAMPAGNE
	description = "A classy sparkling wine, usually found in meeting rooms and basements."
	color = "#EBECC0"
	strength = 15
	taste_description = "bubbly bitter-sweetness"

	glass_icon_state = "champagneglass"
	glass_name = "glass of champagne"
	glass_desc = "Off-white and bubbly. So passe."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/cognac
	name = "Cognac"
	id = REAGENT_COGNAC
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05"
	strength = 40
	taste_description = "rich and smooth alcohol"

	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/alcohol/ethanol/deadrum
	name = "Deadrum"
	id = REAGENT_DEADRUM
	description = "Popular with the sailors. Not very popular with everyone else."
	color = "#664300"
	strength = 40
	taste_description = "salty sea water"

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/deadrum/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.dizziness +=5

/datum/reagent/alcohol/ethanol/gin
	name = "Gin"
	id = REAGENT_GIN
	description = "It's gin. In space. I say, good sir."
	color = "#664300"
	strength = 20
	taste_description = "an alcoholic christmas tree"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A crystal clear glass of Griffeater gin."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/victorygin
	name = "Victory Gin"
	id = REAGENT_VICTORYGIN
	description = "An oily Adhomai-based gin."
	color = "#664300"
	strength = 18
	taste_description = "oily gin"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "It has an oily smell and doesn't taste like typical gin."
	glass_center_of_mass = list("x"=16, "y"=12)

//Base type for alchoholic drinks containing coffee
/datum/reagent/alcohol/ethanol/coffee
	overdose = 45

/datum/reagent/alcohol/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/alcohol/ethanol/coffee/overdose(var/mob/living/carbon/M, var/alien)
	M.make_jittery(5)

/datum/reagent/alcohol/ethanol/coffee/kahlua
	name = "Kahlua"
	id = REAGENT_KAHLUA
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#664300"
	strength = 20
	caffeine = 0.25
	taste_description = "spiked latte"

	glass_icon_state = "kahluaglass"
	glass_name = "glass of RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/alcohol/ethanol/melonliquor
	name = "Melon Liquor"
	id = REAGENT_MELONLIQUOR
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	strength = 23
	taste_description = "fruity alcohol"

	glass_icon_state = "emeraldglass"
	glass_name = "glass of melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/rum
	name = "Rum"
	id = REAGENT_RUM
	description = "Yohoho and all that."
	color = "#664300"
	strength = 40
	taste_description = "spiked butterscotch"

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/sake
	name = "Sake"
	id = REAGENT_SAKE
	description = "Anime's favorite drink."
	color = "#664300"
	strength = 20
	taste_description = "dry alcohol"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of sake"
	glass_desc = "A glass of sake."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/tequilla
	name = "Tequila"
	id = REAGENT_TEQUILLA
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	color = "#FFFF91"
	strength = 40
	taste_description = "paint stripper"

	glass_icon_state = "tequillaglass"
	glass_name = "glass of Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = REAGENT_THIRTEENLOKO
	description = "A potent mixture of caffeine and alcohol."
	color = "#102000"
	strength = 10
	nutriment_factor = 1
	caffeine = 0.5
	taste_description = "jitters and death"

	glass_icon_state = "thirteen_loko_glass"
	glass_name = "glass of Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/datum/reagent/alcohol/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.drowsyness = max(0, M.drowsyness - 7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)

/datum/reagent/alcohol/ethanol/vermouth
	name = "Vermouth"
	id = REAGENT_VERMOUTH
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 17
	taste_description = "dry alcohol"
	taste_mult = 1.3

	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/vodka
	name = "Vodka"
	id = REAGENT_VODKA
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 50
	taste_description = "grain alcohol"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of vodka"
	glass_desc = "The glass contain wodka. Xynta."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/vodka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.apply_effect(max(M.total_radiation - 1 * removed, 0), IRRADIATE, blocked = 0)

/datum/reagent/alcohol/ethanol/whiskey
	name = "Whiskey"
	id = REAGENT_WHISKEY
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#664300"
	strength = 40
	taste_description = "molasses"

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/wine
	name = "Wine"
	id = REAGENT_WINE
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15
	taste_description = "bitter sweetness"

	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

// Cocktails

/datum/reagent/alcohol/ethanol/acid_spit
	name = "Acid Spit"
	id = REAGENT_ACIDSPIT
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	reagent_state = LIQUID
	color = "#365000"
	strength = 25
	taste_description = "stomach acid"

	glass_icon_state = "acidspitglass"
	glass_name = "glass of Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/alcohol/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = REAGENT_ALLIESCOCKTAIL
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	color = "#664300"
	strength = 25
	taste_description = "bitter yet free"

	glass_icon_state = "alliescocktail"
	glass_name = "glass of Allies cocktail"
	glass_desc = "A drink made from your allies."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/aloe
	name = "Aloe"
	id = REAGENT_ALOE
	description = "So very, very, very good."
	color = "#664300"
	strength = 15
	taste_description = "sweet 'n creamy"

	glass_icon_state = "aloe"
	glass_name = "glass of Aloe"
	glass_desc = "Very, very, very good."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/amasec
	name = "Amasec"
	id = REAGENT_AMASEC
	description = "Official drink of the Gun Club!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 25
	taste_description = "dark and metallic"

	glass_icon_state = "amasecglass"
	glass_name = "glass of Amasec"
	glass_desc = "Always handy before COMBAT!!!"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/andalusia
	name = "Andalusia"
	id = REAGENT_ANDALUSIA
	description = "A nice, strangely named drink."
	color = "#664300"
	strength = 35
	taste_description = "lemons"

	glass_icon_state = "andalusia"
	glass_name = "glass of Andalusia"
	glass_desc = "A nice, strange named drink."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/antifreeze
	name = "Anti-freeze"
	id = REAGENT_ANTIFREEZE
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

/datum/reagent/alcohol/ethanol/atomicbomb
	name = "Atomic Bomb"
	id = REAGENT_ATOMICBOMB
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

/datum/reagent/alcohol/ethanol/coffee/b52
	name = "B-52"
	id = "b52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#664300"
	strength = 35
	taste_description = "angry and irish"

	glass_icon_state = "b52glass"
	glass_name = "glass of B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/datum/reagent/alcohol/ethanol/bahama_mama
	name = "Bahama mama"
	id = REAGENT_BAHAMA_MAMA
	description = "Tropical cocktail."
	color = "#FF7F3B"
	strength = 15
	taste_description = "lime and orange"

	glass_icon_state = "bahama_mama"
	glass_name = "glass of Bahama Mama"
	glass_desc = "Tropical cocktail"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/bananahonk
	name = "Banana Mama"
	id = REAGENT_BANANAHONK
	description = "A drink from Clown Heaven."
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 15
	taste_description = "a bad joke"

	glass_icon_state = "bananahonkglass"
	glass_name = "glass of Banana Honk"
	glass_desc = "A drink from Banana Heaven."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/barefoot
	name = "Barefoot"
	id = REAGENT_BAREFOOT
	description = "Barefoot and pregnant"
	color = "#664300"
	strength = 15
	taste_description = "creamy berries"

	glass_icon_state = "b&p"
	glass_name = "glass of Barefoot"
	glass_desc = "Barefoot and pregnant"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = REAGENT_BEEPSKYSMASH
	description = "Deny drinking this and prepare for THE LAW."
	reagent_state = LIQUID
	color = "#664300"
	strength = 35
	taste_description = "JUSTICE"

	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
	glass_center_of_mass = list("x"=18, "y"=10)

/datum/reagent/alcohol/ethanol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Stun(2)

/datum/reagent/alcohol/ethanol/bilk
	name = "Bilk"
	id = REAGENT_BILK
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C"
	strength = 4
	nutriment_factor = 2
	taste_description = "desperation and lactate"

	glass_icon_state = "glass_brown"
	glass_name = "glass of bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/datum/reagent/alcohol/ethanol/black_russian
	name = "Black Russian"
	id = REAGENT_BLACKRUSSIAN
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000"
	strength = 20
	taste_description = "bitterness"

	glass_icon_state = "blackrussianglass"
	glass_name = "glass of Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/bloody_mary
	name = "Bloody Mary"
	id = REAGENT_BLOODYMARY
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#664300"
	strength = 20
	taste_description = "tomatoes with a hint of lime"

	glass_icon_state = "bloodymaryglass"
	glass_name = "glass of Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/datum/reagent/alcohol/ethanol/booger
	name = "Booger"
	id = REAGENT_BOOGER
	description = "Ewww..."
	color = "#8CFF8C"
	strength = 20
	taste_description = "sweet 'n creamy"

	glass_icon_state = "booger"
	glass_name = "glass of Booger"
	glass_desc = "Ewww..."

/datum/reagent/alcohol/ethanol/coffee/brave_bull
	name = "Brave Bull"
	id = REAGENT_BRAVEBULL
	description = "It's just as effective as Dutch-Courage!"
	color = "#664300"
	strength = 30
	caffeine = 0.2
	taste_description = "alcoholic bravery"

	glass_icon_state = "bravebullglass"
	glass_name = "glass of Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."
	glass_center_of_mass = list("x"=15, "y"=8)

/datum/reagent/alcohol/ethanol/cmojito
	name = "Champagne Mojito"
	id = REAGENT_CMOJITO
	description = "A fizzy, minty and sweet drink."
	color = "#5DBA40"
	strength = 15
	taste_description = "sweet mint alcohol"

	glass_icon_state = "cmojito"
	glass_name = "glass of champagne mojito"
	glass_desc = "Looks fun!"

/datum/reagent/alcohol/ethanol/changelingsting
	name = "Changeling Sting"
	id = REAGENT_CHANGELINGSTING
	description = "You take a tiny sip and feel a burning sensation..."
	color = "#2E6671"
	strength = 40
	taste_description = "your brain coming out your nose"

	glass_icon_state = "changelingsting"
	glass_name = "glass of Changeling Sting"
	glass_desc = "A stingy drink."

/datum/reagent/alcohol/ethanol/classic
	name = "The Classic"
	id = REAGENT_CLASSIC
	description = "The classic bitter lemon cocktail."
	color = "#9a8922"
	strength = 20
	taste_description = "sour and bitter"

	glass_icon_state = "classic"
	glass_name = "glass of the classic"
	glass_desc = "Just classic. Wow."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/martini
	name = "Classic Martini"
	id = REAGENT_MARTINI
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300"
	strength = 25
	taste_description = "dry class"

	glass_icon_state = "martiniglass"
	glass_name = "glass of classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/corkpopper
	name = "Cork Popper"
	id = REAGENT_CORKPOPPER
	description = "A fancy cocktail with a hint of lemon."
	color = "#766818"
	strength = "30"
	taste_description = "sour and smokey"

	glass_icon_state = "corkpopper"
	glass_name = "glass of cork popper"
	glass_desc = "The confusing scent only proves all the more alluring."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/cuba_libre
	name = "Cuba Libre"
	id = REAGENT_CUBALIBRE
	description = "Rum, mixed with cola. Viva la revolucion."
	color = "#3E1B00"
	strength = 10
	taste_description = "cola"

	glass_icon_state = "cubalibreglass"
	glass_name = "glass of Cuba Libre"
	glass_desc = "A classic mix of rum and cola."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/demonsblood
	name = "Demons Blood"
	id = REAGENT_DEMONSBLOOD
	description = "AHHHH!!!!"
	color = "#820000"
	strength = 15
	taste_description = "sweet tasting iron"

	glass_icon_state = "demonsblood"
	glass_name = "glass of Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/alcohol/ethanol/devilskiss
	name = "Devils Kiss"
	id = REAGENT_DEVILSKISS
	description = "Creepy time!"
	color = "#A68310"
	strength = 15
	taste_description = "bitter iron"

	glass_icon_state = "devilskiss"
	glass_name = "glass of Devil's Kiss"
	glass_desc = "Creepy time!"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/driestmartini
	name = "Driest Martini"
	id = REAGENT_DRIESTMARTINI
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1
	color = "#2E6671"
	strength = 20
	taste_description = "a beach"

	glass_icon_state = "driestmartiniglass"
	glass_name = "glass of Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/french75
	name = "French 75"
	id = "french75"
	description = "A sharp and classy cocktail."
	color = "#F4E68D"
	strength = 25
	taste_description = "sour and classy"

	glass_icon_state = "french75"
	glass_name = "glass of french 75"
	glass_desc = "It looks like a lemon shaved into your cocktail."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/ginfizz
	name = "Gin Fizz"
	id = REAGENT_GINFIZZ
	description = "Refreshingly lemony, deliciously dry."
	color = "#664300"
	strength = 20
	taste_description = "dry, tart lemons"

	glass_icon_state = "ginfizzglass"
	glass_name = "glass of gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/alcohol/ethanol/grog
	name = "Grog"
	id = REAGENT_GROG
	description = "Watered-down rum, pirate approved!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 10
	taste_description = "a poor excuse for alcohol"

	glass_icon_state = "grogglass"
	glass_name = "glass of grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/alcohol/ethanol/erikasurprise
	name = "Erika Surprise"
	id = REAGENT_ERIKASURPRISE
	description = "The surprise is, it's green!"
	color = "#2E6671"
	strength = 15
	taste_description = "tartness and bananas"

	glass_icon_state = "erikasurprise"
	glass_name = "glass of Erika Surprise"
	glass_desc = "The surprise is, it's green!"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = REAGENT_GARGLEBLASTER
	description = "Whoah, this stuff looks volatile!"
	reagent_state = LIQUID
	color = "#664300"
	strength = 50
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"

	glass_icon_state = "gargleblasterglass"
	glass_name = "glass of Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/alcohol/ethanol/gintonic
	name = "Gin and Tonic"
	id = REAGENT_GINTONIC
	description = "An all time classic, mild cocktail."
	color = "#664300"
	strength = 12
	taste_description = "mild and tart"

	glass_icon_state = "gintonicglass"
	glass_name = "glass of gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/alcohol/ethanol/goldschlager
	name = "Goldschlager"
	id = REAGENT_GOLDSCHLAGER
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#664300"
	strength = 50
	taste_description = "burning cinnamon"

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/alcohol/ethanol/hippies_delight
	name = "Hippies' Delight"
	id = REAGENT_HIPPIESDELIGHT
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

/datum/reagent/alcohol/ethanol/hooch
	name = "Hooch"
	id = REAGENT_HOOCH
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	color = "#664300"
	strength = 65
	taste_description = "pure resignation"

	glass_icon_state = "glass_brown2"
	glass_name = "glass of Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/alcohol/ethanol/iced_beer
	name = "Iced Beer"
	id = REAGENT_ICED_BEER
	description = "A beer which is so cold the air around it freezes."
	color = "#664300"
	strength = 5
	adj_temp = -20
	targ_temp = 270
	taste_description = "refreshingly cold"

	glass_icon_state = "iced_beerglass"
	glass_name = "glass of iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/alcohol/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = REAGENT_IRISHCARBOMB
	description = "Mmm, tastes like chocolate cake..."
	color = "#2E6671"
	strength = 50
	taste_description = "delicious anger"

	glass_icon_state = "irishcarbomb"
	glass_name = "glass of Irish Car Bomb"
	glass_desc = "An irish car bomb."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/coffee/irishcoffee
	name = "Irish Coffee"
	id = REAGENT_IRISHCOFFEE
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	color = "#664300"
	strength = 50
	caffeine = 0.3
	taste_description = "giving up on the day"

	glass_icon_state = "irishcoffeeglass"
	glass_name = "glass of Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/alcohol/ethanol/irish_cream
	name = "Irish Cream"
	id = REAGENT_IRISHCREAM
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	color = "#664300"
	strength = 25
	taste_description = "creamy alcohol"

	glass_icon_state = "irishcreamglass"
	glass_name = "glass of Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = REAGENT_LONGISLANDICEDTEA
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	color = "#664300"
	strength = 40
	taste_description = "a mixture of cola and alcohol"

	glass_icon_state = "longislandicedteaglass"
	glass_name = "glass of Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/manhattan
	name = "Manhattan"
	id = REAGENT_MANHATTAN
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#664300"
	strength = 30
	taste_description = "mild dryness"

	glass_icon_state = "manhattanglass"
	glass_name = "glass of Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = REAGENT_MANHATTAN_PROJ
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#664300"
	strength = 30
	druggy = 30
	taste_description = "death, the destroyer of worlds"

	glass_icon_state = "proj_manhattanglass"
	glass_name = "glass of Manhattan Project"
	glass_desc = "A scientist's drink of choice, for thinking how to blow up the station."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = REAGENT_MANLYDORF
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	color = "#664300"
	strength = 45
	taste_description = "hair on your chest and your chin"

	glass_icon_state = "manlydorfglass"
	glass_name = "glass of The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/datum/reagent/alcohol/ethanol/margarita
	name = "Margarita"
	id = REAGENT_MARGARITA
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#8CFF8C"
	strength = 30
	taste_description = "dry and salty"

	glass_icon_state = "margaritaglass"
	glass_name = "glass of margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/mead
	name = "Mead"
	id = REAGENT_MEAD
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

/datum/reagent/alcohol/ethanol/moonshine
	name = "Moonshine"
	id = REAGENT_MOONSHINE
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#664300"
	strength = 65
	taste_description = "bitterness"

	glass_icon_state = "glass_clear"
	glass_name = "glass of moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/alcohol/ethanol/muscmule
	name = "Muscovite Mule"
	id = REAGENT_MUSCMULE
	description = "A surprisingly gentle cocktail, with a hidden punch."
	color = "#8EEC5F"
	strength = 40
	taste_description = "mint and a mule's kick"

	glass_icon_state = "muscmule"
	glass_name = "glass of muscovite mule"
	glass_desc = "Such a pretty green, this couldn't possible go wrong!"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/alcohol/ethanol/neurotoxin
	name = "Neurotoxin"
	id = REAGENT_NEUROTOXIN
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = LIQUID
	color = "#2E2E61"
	strength = 50
	taste_description = "a numbing sensation"

	glass_icon_state = "neurotoxinglass"
	glass_name = "glass of Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Weaken(3)

/datum/reagent/alcohol/ethanol/omimosa
	name = "Orange Mimosa"
	id = REAGENT_OMIMOSA
	description = "Wonderful start to any day."
	color = "#F4A121"
	strength = 15
	taste_description = "fizzy orange"

	glass_icon_state = "omimosa"
	glass_name = "glass of orange mimosa"
	glass_desc = "Smells like a fresh start."

/datum/reagent/alcohol/ethanol/patron
	name = "Patron"
	id = REAGENT_PATRON
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#585840"
	strength = 20
	taste_description = "metallic and expensive"

	glass_icon_state = "patronglass"
	glass_name = "glass of Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	glass_center_of_mass = list("x"=7, "y"=8)

/datum/reagent/alcohol/ethanol/pinkgin
	name = "Pink Gin"
	id = REAGENT_PINKGIN
	description = "Bitters and Gin."
	color = "#DB80B2"
	strength = 25
	taste_description = "bitter christmas tree"

	glass_icon_state = "pinkgin"
	glass_name = "glass of pink gin"
	glass_desc = "What an eccentric cocktail."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/pinkgintonic
	name = "Pink Gin and Tonic."
	id = REAGENT_PINKGINTONIC
	description = "Bitterer gin and tonic."
	color = "#F4BDDB"
	strength = 25
	taste_description = "very bitter christmas tree"

	glass_icon_state = "pinkgintonic"
	glass_name = "glass of pink gin and tonic"
	glass_desc = "You made gin and tonic more bitter... you madman!"

/datum/reagent/alcohol/ethanol/piratepunch
	name = "Pirate's Punch"
	id = REAGENT_PIRATEPUNCH
	description = "Nautical punch!"
	color = "#ECE1A0"
	strength = 25
	taste_description = "spiced fruit cocktail"

	glass_icon_state = "piratepunch"
	glass_name = "glass of pirate's punch"
	glass_desc = "Yarr harr fiddly dee, drink whatcha want 'cause a pirate is ye!"
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/alcohol/ethanol/planterpunch
	name = "Planter's Punch"
	id = REAGENT_PLANTERPUNCH
	description = "A popular beach cocktail."
	color = "#FFA700"
	strength = 25
	taste_description = "jamaica"

	glass_icon_state = "planterpunch"
	glass_name = "glass of planter's punch"
	glass_desc = "This takes you back, back to those endless white beaches of yore."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/pwine
	name = "Poison Wine"
	id = REAGENT_PWINE
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

/datum/reagent/alcohol/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(dose > 30)
		M.adjustToxLoss(2 * removed)
	if(dose > 60 && ishuman(M) && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/heart/L = H.internal_organs_by_name["heart"]
		if (L && istype(L))
			if(dose < 120)
				L.take_damage(10 * removed, 0)
			else
				L.take_damage(100, 0)

/datum/reagent/alcohol/ethanol/red_mead
	name = "Red Mead"
	id = REAGENT_RED_MEAD
	description = "The true Viking's drink! Even though it has a strange red color."
	color = "#C73C00"
	strength = 21
	taste_description = "sweet and salty alcohol"

	glass_icon_state = "red_meadglass"
	glass_name = "glass of red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/alcohol/ethanol/sbiten
	name = "Sbiten"
	id = REAGENT_SBITEN
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

/datum/reagent/alcohol/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = REAGENT_SCREWDRIVERCOCKTAIL
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#A68310"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/alcohol/ethanol/silencer
	name = "Silencer"
	id = REAGENT_SILENCER
	description = "A drink from Mime Heaven."
	nutriment_factor = 1
	color = "#664300"
	strength = 50
	taste_description = "a pencil eraser"

	glass_icon_state = "silencerglass"
	glass_name = "glass of Silencer"
	glass_desc = "A drink from mime Heaven."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/singulo
	name = "Singulo"
	id = REAGENT_SINGULO
	description = "A blue-space beverage!"
	color = "#2E6671"
	strength = 50
	taste_description = "concentrated matter"

	glass_icon_state = "singulo"
	glass_name = "glass of Singulo"
	glass_desc = "A blue-space beverage."
	glass_center_of_mass = list("x"=17, "y"=4)

/datum/reagent/alcohol/ethanol/snowwhite
	name = "Snow White"
	id = REAGENT_SNOWWHITE
	description = "A cold refreshment"
	color = "#FFFFFF"
	strength = 7
	taste_description = "refreshing cold"

	glass_icon_state = "snowwhite"
	glass_name = "glass of Snow White"
	glass_desc = "A cold refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/ethanol/ssroyale
	name = "Southside Royale"
	id = REAGENT_SSROYALE
	description = "Classy cocktail containing citrus."
	color = "#66F446"
	strength = 20
	taste_description = "lime christmas tree"

	glass_icon_state = "ssroyale"
	glass_name = "glass of southside royale"
	glass_desc = "This cocktail is better than you. Maybe it's the crossed arms that give it away. Or the rich parents."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/suidream
	name = "Sui Dream"
	id = REAGENT_SUIDREAM
	description = "Comprised of: White soda, blue curacao, melon liquor."
	color = "#00A86B"
	strength = 5
	taste_description = "fruit"

	glass_icon_state = "sdreamglass"
	glass_name = "glass of Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = REAGENT_SYNDICATEBOMB
	description = "Tastes like terrorism!"
	color = "#2E6671"
	strength = 65
	taste_description = "purified antagonism"

	glass_icon_state = "syndicatebomb"
	glass_name = "glass of Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/alcohol/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	id = REAGENT_TEQUILLASUNRISE
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	color = "#FFE48C"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "tequillasunriseglass"
	glass_name = "glass of Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/datum/reagent/alcohol/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = REAGENT_THREEMILEISLAND
	description = "Made for a woman, strong enough for a man."
	color = "#666340"
	strength = 60
	druggy = 50
	taste_description = "dry"

	glass_icon_state = "threemileislandglass"
	glass_name = "glass of Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/alcohol/ethanol/toxins_special
	name = "Toxins Special"
	id = REAGENT_PHORONSPECIAL
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

/datum/reagent/alcohol/ethanol/vodkamartini
	name = "Vodka Martini"
	id = REAGENT_VODKAMARTINI
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300"
	strength = 32
	taste_description = "shaken, not stirred"

	glass_icon_state = "martiniglass"
	glass_name = "glass of vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = REAGENT_VODKATONIC
	description = "For when a gin and tonic isn't russian enough."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 35
	taste_description = "tart bitterness"

	glass_icon_state = "vodkatonicglass"
	glass_name = "glass of vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/alcohol/ethanol/white_russian
	name = "White Russian"
	id = REAGENT_WHITERUSSIAN
	description = "That's just, like, your opinion, man..."
	color = "#A68340"
	strength = 30
	taste_description = "bitter cream"

	glass_icon_state = "whiterussianglass"
	glass_name = "glass of White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = REAGENT_WHISKEYCOLA
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00"
	strength = 15
	taste_description = "cola"

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = REAGENT_WHISKEYSODA
	description = "For the more refined griffon."
	color = "#664300"
	strength = 15
	taste_description = "cola"

	glass_icon_state = "whiskeysodaglass2"
	glass_name = "glass of whiskey soda"
	glass_desc = "Ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/ethanol/specialwhiskey // I have no idea what this is and where it comes from
	name = "Special Blend Whiskey"
	id = REAGENT_SPECIALWHISKEY
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	color = "#664300"
	strength = 45
	taste_description = "silky, amber goodness"

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	glass_center_of_mass = list("x"=16, "y"=12)


// Snowflake drinks
/datum/reagent/drink/dr_gibb_diet
	name = "Diet Dr. Gibb"
	id = REAGENT_DR_GIBB_DIET
	description = "A delicious blend of 42 different flavours, one of which is water."
	color = "#102000"

	adj_temp = -5
	taste_description = "watered down liquid sunshine"

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Diet Dr. Gibb"
	glass_desc = "Regular Dr.Gibb is probably healthier than this cocktail of artificial flavors."

/datum/reagent/alcohol/ethanol/drdaniels
	name = "Dr. Daniels"
	id = REAGENT_DR_DANIELS
	description = "A limited edition tallboy of Dr. Gibb's Infusions."
	color = "#8e6227"
	adj_temp = -5
	caffeine = 0.2
	overdose = 80
	strength = 20
	nutriment_factor = 2
	taste_description = "smooth, honeyed carbonation"

	glass_icon_state = "drdaniels"
	glass_name = "glass of Dr. Daniels"
	glass_desc = "A tall glass of honey, whiskey, and diet Dr. Gibb. The perfect blend of throat-soothing liquid."

//aurora unique drinks

/datum/reagent/alcohol/ethanol/daiquiri
	name = "Daiquiri"
	id = REAGENT_DAIQUIRI
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#664300"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "daiquiri"
	glass_name = "glass of Daiquiri"
	glass_desc = "A splendid looking cocktail."

/datum/reagent/alcohol/ethanol/icepick
	name = "Ice Pick"
	id = REAGENT_ICEPICK
	description = "Big. And red. Hmm...."
	color = "#664300"
	strength = 10
	taste_description = "vodka and lemon"

	glass_icon_state = "icepick"
	glass_name = "glass of Ice Pick"
	glass_desc = "Big. And red. Hmm..."

/datum/reagent/alcohol/ethanol/poussecafe
	name = "Pousse-Cafe"
	id = REAGENT_POUSSECAFE
	description = "Smells of French and liquore."
	color = "#664300"
	strength = 15
	taste_description = "layers of liquors"

	glass_icon_state = "pousseecafe"
	glass_name = "glass of Pousse-Cafe"
	glass_desc = "Smells of French and liquore."

/datum/reagent/alcohol/ethanol/mintjulep
	name = "Mint Julep"
	id = REAGENT_MINTJULEP
	description = "As old as time itself, but how does it taste?"
	color = "#664300"
	strength = 25
	taste_description = "old as time"

	glass_icon_state = "mintjulep"
	glass_name = "glass of Mint Julep"
	glass_desc = "As old as time itself, but how does it taste?"

/datum/reagent/alcohol/ethanol/johncollins
	name = "John Collins"
	id = REAGENT_JOHNCOLLINS
	description = "Crystal clear, yellow, and smells of whiskey. How could this go wrong?"
	color = "#664300"
	strength = 25
	taste_description = "whiskey"

	glass_icon_state = "johnscollins"
	glass_name = "glass of John Collins"
	glass_desc = "Named after a man, perhaps?"

/datum/reagent/alcohol/ethanol/gimlet
	name = "Gimlet"
	id = REAGENT_GIMLET
	description = "Small, elegant, and kicks."
	color = "#664300"
	strength = 20
	taste_description = "gin and class"

	glass_icon_state = "gimlet"
	glass_name = "glass of Gimlet"
	glass_desc = "Small, elegant, and packs a punch."

/datum/reagent/alcohol/ethanol/starsandstripes
	name = "Stars and Stripes"
	id = REAGENT_STARSANDSTRIPES
	description = "Someone, somewhere, is saluting."
	color = "#664300"
	strength = 10
	taste_description = "freedom"

	glass_icon_state = "starsandstripes"
	glass_name = "glass of Stars and Stripes"
	glass_desc = "Someone, somewhere, is saluting."

/datum/reagent/alcohol/ethanol/metropolitan
	name = "Metropolitan"
	id = REAGENT_METROPOLITAN
	description = "What more could you ask for?"
	color = "#664300"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "metropolitan"
	glass_name = "glass of Metropolitan"
	glass_desc = "What more could you ask for?"

/datum/reagent/alcohol/ethanol/caruso
	name = "Caruso"
	id = REAGENT_CARUSO
	description = "Green, almost alien."
	color = "#664300"
	strength = 25
	taste_description = "dryness"

	glass_icon_state = "caruso"
	glass_name = "glass of Caruso"
	glass_desc = "Green, almost alien."

/datum/reagent/alcohol/ethanol/aprilshower
	name = "April Shower"
	id = REAGENT_APRILSHOWER
	description = "Smells of brandy."
	color = "#664300"
	strength = 25
	taste_description = "brandy and oranges"

	glass_icon_state = "aprilshower"
	glass_name = "glass of April Shower"
	glass_desc = "Smells of brandy."

/datum/reagent/alcohol/ethanol/carthusiansazerac
	name = "Carthusian Sazerac"
	id = REAGENT_CARTHUSIANSAZERAC
	description = "Whiskey and... Syrup?"
	color = "#664300"
	strength = 15
	taste_description = "sweetness"

	glass_icon_state = "carthusiansazerac"
	glass_name = "glass of Carthusian Sazerac"
	glass_desc = "Whiskey and... Syrup?"

/datum/reagent/alcohol/ethanol/deweycocktail
	name = "Dewey Cocktail"
	id = REAGENT_DEWEYCOCKTAIL
	description = "Colours, look at all the colours!"
	color = "#664300"
	strength = 25
	taste_description = "dry gin"

	glass_icon_state = "deweycocktail"
	glass_name = "glass of Dewey Cocktail"
	glass_desc = "Colours, look at all the colours!"

/datum/reagent/alcohol/ethanol/chartreusegreen
	name = "Green Chartreuse"
	id = REAGENT_CHARTREUSEGREEN
	description = "A green, strong liqueur."
	color = "#664300"
	strength = 40
	taste_description = "a mixture of herbs"

	glass_icon_state = "greenchartreuseglass"
	glass_name = "glass of Green Chartreuse"
	glass_desc = "A green, strong liqueur."

/datum/reagent/alcohol/ethanol/chartreuseyellow
	name = "Yellow Chartreuse"
	id = REAGENT_CHARTREUSEYELLOW
	description = "A yellow, strong liqueur."
	color = "#664300"
	strength = 40
	taste_description = "a sweet mixture of herbs"

	glass_icon_state = "chartreuseyellowglass"
	glass_name = "glass of Yellow Chartreuse"
	glass_desc = "A yellow, strong liqueur."

/datum/reagent/alcohol/ethanol/cremewhite
	name = "White Creme de Menthe"
	id = REAGENT_CREMEWHITE
	description = "Mint-flavoured alcohol, in a bottle."
	color = "#664300"
	strength = 20
	taste_description = "mint"

	glass_icon_state = "whitecremeglass"
	glass_name = "glass of White Creme de Menthe"
	glass_desc = "Mint-flavoured alcohol."

/datum/reagent/alcohol/ethanol/cremeyvette
	name = "Creme de Yvette"
	id = REAGENT_CREMEYVETTE
	description = "Berry-flavoured alcohol, in a bottle."
	color = "#664300"
	strength = 20
	taste_description = "berries"

	glass_icon_state = "cremedeyvetteglass"
	glass_name = "glass of Creme de Yvette"
	glass_desc = "Berry-flavoured alcohol."

/datum/reagent/alcohol/ethanol/brandy
	name = "Brandy"
	id = REAGENT_BRANDY
	description = "Cheap knock off for cognac."
	color = "#664300"
	strength = 40
	taste_description = "cheap cognac"

	glass_icon_state = "brandyglass"
	glass_name = "glass of Brandy"
	glass_desc = "Cheap knock off for cognac."

/datum/reagent/alcohol/ethanol/guinnes
	name = "Guinness"
	id = REAGENT_GUINNES
	description = "Special Guinnes drink."
	color = "#2E6671"
	strength = 8
	taste_description = "dryness"

	glass_icon_state = "guinnes_glass"
	glass_name = "glass of Guinness"
	glass_desc = "A glass of Guinness."

/datum/reagent/alcohol/ethanol/drambuie
	name = "Drambuie"
	id = REAGENT_DRAMBUIE
	description = "A drink that smells like whiskey but tastes different."
	color = "#2E6671"
	strength = 40
	taste_description = "sweet whisky"

	glass_icon_state = "drambuieglass"
	glass_name = "glass of Drambuie"
	glass_desc = "A drink that smells like whiskey but tastes different."

/datum/reagent/alcohol/ethanol/oldfashioned
	name = "Old Fashioned"
	id = REAGENT_OLDFASHIONED
	description = "That looks like it's from the sixties."
	color = "#2E6671"
	strength = 30
	taste_description = "bitterness"

	glass_icon_state = "oldfashioned"
	glass_name = "glass of Old Fashioned"
	glass_desc = "That looks like it's from the sixties."

/datum/reagent/alcohol/ethanol/blindrussian
	name = "Blind Russian"
	id = REAGENT_BLINDRUSSIAN
	description = "You can't see?"
	color = "#2E6671"
	strength = 40
	taste_description = "bitterness blindness"

	glass_icon_state = "blindrussian"
	glass_name = "glass of Blind Russian"
	glass_desc = "You can't see?"

/datum/reagent/alcohol/ethanol/rustynail
	name = "Rusty Nail"
	id = REAGENT_RUSTYNAIL
	description = "Smells like lemon."
	color = "#2E6671"
	strength = 25
	taste_description = "lemons"

	glass_icon_state = "rustynail"
	glass_name = "glass of Rusty Nail"
	glass_desc = "Smells like lemon."

/datum/reagent/alcohol/ethanol/tallrussian
	name = "Tall Black Russian"
	id = REAGENT_TALLRUSSIAN
	description = "Just like black russian but taller."
	color = "#2E6671"
	strength = 25
	taste_description = "tall bitterness"

	glass_icon_state = "tallblackrussian"
	glass_name = "glass of Tall Black Russian"
	glass_desc = "Just like black russian but taller."

//Synnono Meme Drinks
//=====================================
// Organized here because why not.

/datum/reagent/alcohol/ethanol/badtouch
	name = "Bad Touch"
	id = REAGENT_BADTOUCH
	description = "We're nothing but mammals, after all."
	color = "#42f456"
	strength = 50
	taste_description = "naughtiness"

	glass_icon_state = "badtouch"
	glass_name = "glass of Bad Touch"
	glass_desc = "We're nothing but mammals, after all."

/datum/reagent/alcohol/ethanol/bluelagoon
	name = "Blue Lagoon"
	id = REAGENT_BLUELAGOON
	description = "Because lagoons shouldn't come in other colors."
	color = "#51b8ef"
	strength = 25
	taste_description = "electric lemonade"

	glass_icon_state = "bluelagoon"
	glass_name = "glass of Blue Lagoon"
	glass_desc = "Because lagoons shouldn't come in other colors."

/datum/reagent/alcohol/ethanol/boukha
	name = "Boukha"
	id = REAGENT_BOUKHA
	description = "A distillation of figs, popular in the Serene Republic of Elyra."
	color = "#efd0d0"
	strength = 40
	taste_description = "spiced figs"

	glass_icon_state = "boukhaglass"
	glass_name = "glass of boukha"
	glass_desc = "A distillation of figs, popular in the Serene Republic of Elyra."

/datum/reagent/alcohol/ethanol/fireball
	name = "Fireball"
	id = REAGENT_FIREBALL
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

/datum/reagent/alcohol/ethanol/fireball/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(0.1 * removed)

/datum/reagent/alcohol/ethanol/fireball/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && (H.species.flags & (NO_PAIN)))
			return
	if(dose < agony_dose)
		if(prob(5) || dose == metabolism)
			M << discomfort_message
	else
		M.apply_effect(agony_amount, AGONY, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			M << "<span class='danger'>You feel like your insides are burning!</span>"
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent(REAGENT_FROSTOIL, 2)

/datum/reagent/alcohol/ethanol/cherrytreefireball
	name = "Cherry Tree Fireball"
	id = REAGENT_CHERRYTREEFIREBALL
	description = "An iced fruit cocktail shaken with cinnamon whiskey. Hot, cold and sweet all at once."
	color = "#e87727"
	strength = 15
	taste_description = "sweet spiced cherries"

	glass_icon_state = "cherrytreefireball"
	glass_name = "glass of Cherry Tree Fireball"
	glass_desc = "An iced fruit cocktail shaken with cinnamon whiskey. Hot, cold and sweet all at once."

/datum/reagent/alcohol/ethanol/cobaltvelvet
	name = "Cobalt Velvet"
	id = REAGENT_COBALTVELVET
	description = "An electric blue champagne cocktail that's popular on the club scene."
	color = "#a3ecf7"
	strength = 25
	taste_description = "neon champagne"

	glass_icon_state = "cobaltvelvet"
	glass_name = "glass of Cobalt Velvet"
	glass_desc = "An electric blue champagne cocktail that's popular on the club scene."

/datum/reagent/alcohol/ethanol/fringeweaver
	name = "Fringe Weaver"
	id = REAGENT_FRINGEWEAVER
	description = "Effectively pure alcohol with a dose of sugar. It's as simple as it is strong."
	color = "#f78888"
	strength = 65
	taste_description = "liquid regret"

	glass_icon_state = "fringeweaver"
	glass_name = "glass of Fringe Weaver"
	glass_desc = "Effectively pure alcohol with a dose of sugar. It's as simple as it is strong."

/datum/reagent/alcohol/ethanol/junglejuice
	name = "Jungle Juice"
	id = REAGENT_JUNGLEJUICE
	description = "You're in the jungle now, baby."
	color = "#773404"
	strength = 35
	taste_description = "a fraternity house party"

	glass_icon_state = "junglejuice"
	glass_name = "glass of Jungle Juice"
	glass_desc = "You're in the jungle now, baby."

/datum/reagent/alcohol/ethanol/marsarita
	name = "Marsarita"
	id = REAGENT_MARSARITA
	description = "The margarita with a Martian twist. They call it something less embarrassing there."
	color = "#3eb7c9"
	strength = 30
	taste_description = "spicy, salty lime"

	glass_icon_state = "marsarita"
	glass_name = "glass of Marsarita"
	glass_desc = "The margarita with a Martian twist. They call it something less embarrassing there."

/datum/reagent/drink/meloncooler
	name = "Melon Cooler"
	id = REAGENT_MELONCOOLER
	description = "Summertime on the beach, in liquid form."
	color = "#d8457b"
	taste_description = "minty melon"

	glass_icon_state = "meloncooler"
	glass_name = "glass of Melon Cooler"
	glass_desc = "Summertime on the beach, in liquid form."

/datum/reagent/alcohol/ethanol/midnightkiss
	name = "Midnight Kiss"
	id = REAGENT_MIDNIGHTKISS
	description = "A champagne cocktail, quietly bubbling in a slender glass."
	color = "#13144c"
	strength = 25
	taste_description = "a late-night promise"

	glass_icon_state = "midnightkiss"
	glass_name = "glass of Midnight Kiss"
	glass_desc = "A champagne cocktail, quietly bubbling in a slender glass."

/datum/reagent/drink/millionairesour
	name = "Millionaire Sour"
	id = REAGENT_MILLIONAIRESOUR
	description = "It's a good mix, a great mix. The best mix in known space. It's terrific, you're gonna love it."
	color = "#13144c"
	taste_description = "tart fruit"

	glass_icon_state = "millionairesour"
	glass_name = "glass of Millionaire Sour"
	glass_desc = "It's a good mix, a great mix. Best mix in the galaxy. It's terrific, you're gonna love it."

/datum/reagent/alcohol/ethanol/olympusmons
	name = "Olympus Mons"
	id = REAGENT_OLYMPUSMONS
	description = "Another, stronger version of the Black Russian. It's popular in some Martian arcologies."
	color = "#020407"
	strength = 30
	taste_description = "bittersweet independence"

	glass_icon_state = "olympusmons"
	glass_name = "glass of Olympus Mons"
	glass_desc = "Another, stronger version of the Black Russian. It's popular in some Martian arcologies."

/datum/reagent/alcohol/ethanol/europanail
	name = "Europa Nail"
	id = REAGENT_EUROPANAIL
	description = "Named for Jupiter's moon. It looks about as crusty."
	color = "#785327"
	strength = 30
	taste_description = "a coffee-flavored moon"

	glass_icon_state = "europanail"
	glass_name = "glass of Europa Nail"
	glass_desc = "Named for Jupiter's moon. It looks about as crusty."

/datum/reagent/drink/portsvilleminttea
	name = "Portsville Mint Tea"
	id = REAGENT_PORTSVILLEMINTTEA
	description = "A popular iced pick-me-up originating from a city in Eos, on Biesel."
	color = "#b6f442"
	taste_description = "cool minty tea"

	glass_icon_state = "portsvilleminttea"
	glass_name = "glass of Portsville Mint Tea"
	glass_desc = "A popular iced pick-me-up originating from a city in Eos, on Biesel."

/datum/reagent/drink/shirleytemple
	name = "Shirley Temple"
	id = REAGENT_SHIRLEYTEMPLE
	description = "Straight from the good ship Lollipop."
	color = "#ce2727"
	taste_description = "innocence"

	glass_icon_state = "shirleytemple"
	glass_name = "glass of Shirley Temple"
	glass_desc = "Straight from the good ship Lollipop."

/datum/reagent/alcohol/ethanol/sugarrush
	name = "Sugar Rush"
	id = REAGENT_SUGARRUSH
	description = "Sweet, light and fruity. As girly as it gets."
	color = "#d51d5d"
	strength = 15
	taste_description = "sweet soda"

	glass_icon_state = "sugarrush"
	glass_name = "glass of Sugar Rush"
	glass_desc = "Sweet, light and fruity. As girly as it gets."

/datum/reagent/alcohol/ethanol/sangria
	name = "Sangria"
	id = REAGENT_SANGRIA
	description = "Red wine, splashed with brandy and infused with fruit."
	color = "#960707"
	strength = 30
	taste_description = "sweet wine"

	glass_icon_state = "sangria"
	glass_name = "glass of Sangria"
	glass_desc = "Red wine, splashed with brandy and infused with fruit."

/datum/reagent/alcohol/ethanol/bassline
	name = "Bassline"
	id = REAGENT_BASSLINE
	description = "A vodka cocktail from Vega De Rosa, Mendell City's entertainment district. Purple and deep."
	color = "#6807b2"
	strength = 25
	taste_description = "the groove"

	glass_icon_state = "bassline"
	glass_name = "glass of Bassline"
	glass_desc = "A vodka cocktail from Vega De Rosa, Mendell City's entertainment district. Purple and deep."

/datum/reagent/alcohol/ethanol/bluebird
	name = "Bluebird"
	id = REAGENT_BLUEBIRD
	description = "A gin drink popularized by a spy thriller in 2452."
	color = "#4286f4"
	strength = 30
	taste_description = "a blue christmas tree"

	glass_icon_state = "bluebird"
	glass_name = "glass of Bluebird"
	glass_desc = "A gin drink popularized by a spy thriller in 2452."

/datum/reagent/alcohol/ethanol/whitewine
	name = "White Wine"
	id = REAGENT_WHITEWINE
	description = "A premium alchoholic beverage made from distilled grape juice."
	color = "#e5d272"
	strength = 15
	taste_description = "dry sweetness"

	glass_icon_state = "whitewineglass"
	glass_name = "glass of white wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

// Butanol-based alcoholic drinks
//=====================================
//These are mainly for unathi, and have very little (but still some) effect on other species

/datum/reagent/alcohol/butanol/xuizijuice
	name = "Xuizi Juice"
	id = REAGENT_XUIZIJUICE
	description = "Blended flower buds from a Moghean Xuizi cactus. Has a mild butanol content and is a staple recreational beverage in Unathi culture."
	color = "#91de47"
	strength = 5
	taste_description = "water"

	glass_icon_state = "xuiziglass"
	glass_name = "glass of Xuizi Juice"
	glass_desc = "The clear green liquid smells like vanilla, tastes like water. Unathi swear it has a rich taste and texture."

/datum/reagent/alcohol/butanol/sarezhiwine
	name = "Sarezhi Wine"
	id = REAGENT_SAREZHIWINE
	description = "An alcoholic beverage made from lightly fermented Sareszhi berries, considered an upper class delicacy on Moghes. Significant butanol content indicates intoxicating effects on Unathi."
	color = "#bf8fbc"
	strength = 20
	taste_description = "berry juice"

	glass_icon_state = "sarezhiglass"
	glass_name = "glass of Sarezhi Wine"
	glass_desc = "It tastes like plain berry juice. Is this supposed to be alcoholic?"

//Kaed's Unathi Cocktails
//=======
//What an exciting time we live in, that lizards may drink fruity girl drinks.
/datum/reagent/alcohol/butanol/moghesmargarita
	name = "Moghes Margarita"
	id = REAGENT_MOGHESMARGARITA
	description = "A classic human cocktail, now ruined with cactus juice instead of tequila."
	color = "#8CFF8C"
	strength = 30
	taste_description = "lime juice"

	glass_icon_state = "cactusmargarita"
	glass_name = "glass of Moghes Margarita"
	glass_desc = "A classic human cocktail, now ruined with cactus juice instead of tequila."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/alcohol/butanol/cactuscreme
	name = "Cactus Creme"
	id = REAGENT_CACTUSCREME
	description = "A tasty mix of berries and cream with xuizi juice, for the discerning unathi."
	color = "#664300"
	strength = 15
	taste_description = "creamy berries"

	glass_icon_state = "cactuscreme"
	glass_name = "glass of Cactus Creme"
	glass_desc = "A tasty mix of berries and cream with xuizi juice, for the discerning unathi."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/alcohol/butanol/bahamalizard
	name = "Bahama Lizard"
	id = REAGENT_BAHAMALIZARD
	description = "A tropical cocktail containing cactus juice from Moghes, but no actual alcohol."
	color = "#FF7F3B"
	strength = 15
	taste_description = "lime and orange"

	glass_icon_state = "bahamalizard"
	glass_name = "glass of Bahama Lizard"
	glass_desc = "A tropical cocktail containing cactus juice from Moghes, but no actual alcohol."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/alcohol/butanol/lizardphlegm
	name = "Lizard Phlegm"
	id = REAGENT_LIZARDPHLEGM
	description = "Looks gross, but smells fruity."
	color = "#8CFF8C"
	strength = 20
	taste_description = "creamy fruit"

	glass_icon_state = "lizardphlegm"
	glass_name = "glass of Lizard Phlegm"
	glass_desc = "Looks gross, but smells fruity."

/datum/reagent/alcohol/butanol/cactustea
	name = "Cactus Tea"
	id = REAGENT_CACTUSTEA
	description = "Tea flavored with xuizi juice."
	color = "#664300"
	strength = 10
	taste_description = "tea"

	glass_icon_state = "icepick"
	glass_name = "glass of Cactus Tea"
	glass_desc = "Tea flavored with xuizi juice."

/datum/reagent/alcohol/butanol/moghespolitan
	name = "Moghespolitan"
	id = REAGENT_MOGHESPOLITAN
	description = "Pomegranate syrup and cactus juice, with a splash of Sarezhi Wine. Delicious!"
	color = "#664300"
	strength = 27
	taste_description = "fruity sweetness"

	glass_icon_state = "moghespolitan"
	glass_name = "glass of Moghespolitan"
	glass_desc = "Pomegranate syrup and cactus juice, with a splash of Sarezhi Wine. Delicious!"

/datum/reagent/alcohol/butanol/wastelandheat
	name = "Wasteland Heat"
	id = REAGENT_WASTELANDHEAT
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

/datum/reagent/alcohol/butanol/Sandgria
	name = "Sandgria"
	id = REAGENT_SANDGRIA
	description = "Sarezhi wine, blended with citrus and a splash of cactus juice."
	color = "#960707"
	strength = 30
	taste_description = "tart berries"

	glass_icon_state = "sangria"
	glass_name = "glass of Sandgria"
	glass_desc = "Sarezhi wine, blended with citrus and a splash of cactus juice."

/datum/reagent/alcohol/butanol/contactwine
	name = "Contact Wine"
	id = REAGENT_CONTACTWINE
	description = "A perfectly good glass of Sarezhi wine, ruined by adding radioactive material. It reminds you of something..."
	color = "#2E6671"
	strength = 50
	taste_description = "berries and regret"

	glass_icon_state = "contactwine"
	glass_name = "glass of Contact Wine"
	glass_desc = "A perfectly good glass of Sarezhi wine, ruined by adding radioactive material. It reminds you of something..."
	glass_center_of_mass = list("x"=17, "y"=4)

/datum/reagent/alcohol/butanol/hereticblood
	name = "Heretics Blood"
	id = REAGENT_HERETICBLOOD
	description = "A fizzy cocktail made with cactus juice and heresy."
	color = "#820000"
	strength = 15
	taste_description = "heretically sweet iron"

	glass_icon_state = "demonsblood"
	glass_name = "glass of Heretics' Blood"
	glass_desc = "A fizzy cocktail made with cactus juice and heresy."
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/alcohol/butanol/sandpit
	name = "Sandpit"
	id = REAGENT_SANDPIT
	description = "An unusual mix of cactus and orange juice, mostly favored by unathi."
	color = "#A68310"
	strength = 15
	taste_description = "oranges"

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Sandpit"
	glass_desc = "An unusual mix of cactus and orange juice, mostly favored by unathi."
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/alcohol/butanol/cactuscola
	name = "Cactus Cola"
	id = REAGENT_CACTUSCOLA
	description = "Cactus juice splashed with cola, on ice. Simple and delicious."
	color = "#3E1B00"
	strength = 15
	taste_description = "cola"

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of Cactus Cola"
	glass_desc = "Cactus juice splashed with cola, on ice. Simple and delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/alcohol/butanol/bloodwine
	name = "Bloodwine"
	id = REAGENT_BLOODWINE
	description = "A traditional unathi drink said to strengthen one before a battle."
	color = "#C73C00"
	strength = 21
	taste_description = "strong berries"

	glass_icon_state = "bloodwine"
	glass_name = "glass of Bloodwine"
	glass_desc = "A traditional unathi drink said to strengthen one before a battle."
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/alcohol/butanol/crocodile_booze
	name = "Crocodile Guwan"
	id = REAGENT_CROCODILE_BOOZE
	description = "A highly alcoholic butanol based beverage typically fermented using the venom of a zerl'ock and cheaply made Sarezhi Wine. A popular drink among Unathi troublemakers, conviently housed in a 2L plastic bottle."
	color = "#b0f442"
	strength = 50
	taste_description = "sour body sweat"

	glass_icon_state = "crocodile_glass"
	glass_name = "glass of Crocodile Guwan"
	glass_desc = "The smell says no, but the pretty colors say yes."
