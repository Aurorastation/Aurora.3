//
// Kois
//
/singleton/reagent/kois
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
	value = 0.5

/singleton/reagent/kois/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!ishuman(M))
		return
	var/is_vaurcalike = (alien == IS_VAURCA)
	if(!is_vaurcalike)
		var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
		if(istype(P) && P.stage >= 3)
			is_vaurcalike = TRUE
	if(is_vaurcalike)
		M.heal_organ_damage(1.4 * removed, 1.6 * removed)
		M.adjustNutritionLoss(-nutriment_factor * removed)
	else
		infect(M, alien, removed)

/singleton/reagent/kois/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		infect(M, alien, removed)

/singleton/reagent/kois/affect_chem_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	var/is_vaurcalike = (alien == IS_VAURCA)
	if(!is_vaurcalike)
		var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
		if(istype(P) && P.stage >= 3)
			is_vaurcalike = TRUE
	if(is_vaurcalike)
		M.add_chemical_effect(CE_BLOODRESTORE, 6 * removed)

/singleton/reagent/kois/proc/infect(var/mob/living/carbon/human/H, var/alien, var/removed)
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

/singleton/reagent/kois/clean
	name = "Filtered K'ois"
	description = "A strange, ketchup-like substance, filled with K'ois nutrients."
	color = "#dce658"
	taste_description = "cabbage soup"
	kois_type = 0
	fallback_specific_heat = 1

	glass_icon_state = "glass_kois"
	glass_name = "glass of filtered k'ois"
	glass_desc = "A strange, ketchup-like substance, filled with K'ois nutrients."

/singleton/reagent/kois/black
	name = "Modified K'ois"
	description = "A thick goopy substance, rich in K'ois nutrients. This sample appears to be modified."
	color = "#31004A"
	taste_description = "tar"
	kois_type = 2
	fallback_specific_heat = 0.5

//
// Food
//
/singleton/reagent/nakarka
	name = "Nakarka Cheese"
	color = "#5bbd22"
	taste_description = "sharp tangy cheese"
	reagent_state = SOLID
	taste_mult = 3

/singleton/reagent/nakarka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(10) && !(alien in list(IS_VAURCA, IS_SKRELL, IS_DIONA, IS_UNATHI)))
			var/list/nemiik_messages = list(
				"Your stomache feels a bit unsettled...",
				"Your throat tingles slightly...",
				"You feel like you may need the restroom soon...",
				"Your stomach hurts a little bit...",
				"You feel the need to burp."
			)
			to_chat(H, SPAN_WARNING(pick(nemiik_messages)))

//
// Milk
//
/singleton/reagent/drink/milk/nemiik
	name = "Ne'miik"
	description = "A thick, pus-like substance extracted from the Sky'au creatures native to Sedantis. It is largely believed the louder and more horrifying the Sky'au's screams are as it is being milked, the tastier the ne'miik is. It is full of minerals! It's safe for Vaurcae and Skrell to drink, but generally causes some discomfort in other species."
	taste_description = "tangy sweet ooze"
	color = "#71fa21"
	glass_name = "glass of ne'miik"
	glass_desc = "A thick, pus-like substance extracted from the Sky'au creatures native to Sedantis. It is largely believed the louder and more horrifying the Sky'au's screams are as it is being milked, the tastier the ne'miik is. It is full of minerals! It's safe for Vaurcae and Skrell to drink, but generally causes some discomfort in other species."
	glass_icon_state = "nemiik"

/singleton/reagent/drink/milk/nemiik/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(10) && !(alien in list(IS_VAURCA, IS_SKRELL, IS_DIONA, IS_UNATHI)))
			var/list/nemiik_messages = list(
				"Your stomache feels a bit unsettled...",
				"Your throat tingles slightly...",
				"Your stomach hurts a little bit...",
				"You feel like you may need the restroom soon...",
				"You feel the need to burp."
			)
			to_chat(H, SPAN_WARNING(pick(nemiik_messages)))

//
// Drinks
//
/singleton/reagent/drink/toothpaste
	name = "Toothpaste"
	description = "A paste commonly used in oral hygiene."
	reagent_state = LIQUID
	color = "#9ddaff"
	taste_description = "toothpaste"
	overdose = REAGENTS_OVERDOSE
	var/strength = 50

	glass_icon_state = "toothpaste"
	glass_name = "glass of toothpaste"
	glass_desc = "Dentists recommend drinking zero glasses a day, and instead brushing normally."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	if(alien == IS_VAURCA)
		M.intoxication += (strength / 100) * removed * 6

/singleton/reagent/drink/toothpaste/cold_gate
	name = "Cold Gate"
	description = "A C'thur Favorite, guaranteed to make even the bloodiest of warriors mandibles shimmer."
	strength = 25
	taste_description = "mint"

	glass_icon_state = "cold_gate"
	glass_name = "glass of Cold Gate"
	glass_desc = "A C'thur Favorite, guaranteed to make even the bloodiest of warriors mandibles shimmer."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/waterfresh
	name = "Waterfresh"
	description = "A concoction of toothpaste and water, for when you need to show your pearly whites."
	strength = 30
	taste_description = "bubble bath"

	glass_icon_state = "waterfresh"
	glass_name = "glass of Waterfresh"
	glass_desc = "A concoction of toothpaste and mouthwash, for when you need to show your pearly whites. Toothbrush Included."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/sedantian_firestorm
	name = "Sedantian Firestorm"
	description = "Florinated phoron, is the drink suppose to be on fire?"
	strength = 70
	taste_description = "melting asphalt"
	adj_temp = 25
	default_temperature = T0C + 60

	glass_icon_state = "sedantian_firestorm"
	glass_name = "glass of Sedantian Firestorm"
	glass_desc = "Florinated phoron, is the drink suppose to be on fire?"
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/kois_odyne
	name = "K'ois Odyne"
	description = "A favourite among the younger vaurca, born from an accident involving nanopaste and the repair of internal augments."
	strength = 40
	taste_description = "chalk"

	glass_icon_state = "kois_odyne"
	glass_name = "glass of Kois Odyne"
	glass_desc = "A favourite among the younger vaurca, born from an accident involving nanopaste and the repair of internal augments."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/teathpaste
	name = "Teathpaste"
	description = "A sad attempt to reduce the effects of sugary tea on your teeth."
	color = "#0099cc"
	strength = 20
	taste_description = "liquid dental work"

	glass_icon_state = "teathpaste"
	glass_name = "cup of teathpaste"
	glass_desc = "Recommended by 1 out of 5 dentists."

	var/last_taste_time = -100

/singleton/reagent/drink/toothpaste/teathpaste/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		if(last_taste_time + 800 < world.time) // Not to spam message
			to_chat(M, SPAN_DANGER("Your body withers as you feel slight pain throughout."))
			last_taste_time = world.time
		metabolism = REM * 0.33
		M.adjustToxLoss(1.5 * removed)

/singleton/reagent/drink/toothpaste/mouthwash
	name = "Mouthwash"
	description = "A fluid commonly used in oral hygiene."
	reagent_state = LIQUID
	color = "#9df8ff"
	taste_description = "mouthwash"
	overdose = REAGENTS_OVERDOSE
	strength = 75

	glass_icon_state = "mouthwash"
	glass_name = "glass of mouthwash"
	glass_desc = "A minty sip and you're buzzing."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/mouthwash/mouthgarita
	name = "Mouthgarita"
	description = "Very simple cocktail of mouthwash and lime juice."
	taste_description = "sour and minty"
	color = "#9dffd1"
	strength = 60

	glass_icon_state = "mouthgarita"
	glass_name = "glass of Mouthgarita"
	glass_desc = "Very simple cocktail of mouthwash and lime juice."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/mouthwash/caprician_sunrise
	name = "Caprician Sunrise"
	description = "Vaurcesian take on the classic screwdriver."
	taste_description = "spicy orange"
	color = "#9dffd6"
	strength = 60

	glass_icon_state = "caprician_sunrise"
	glass_name = "glass of Caprician Sunrise"
	glass_desc = "Vaurcesian take on the classic screwdriver."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/mouthwash/flagsdale_mule
	name = "Flagsdale Mule"
	description = "A hard-kicking cocktail, said to be invented in the better parts of Flagsdale."
	strength = 80
	taste_description = "refreshing, spicy lime, and bulwark's kick"
	color = "#9dfff2"

	glass_icon_state = "flagsdale_mule"
	glass_name = "glass of Flagsdale Mule"
	glass_desc = "A hard-kicking cocktail, said to be invented in the better parts of Flagsdale."
	glass_center_of_mass = list("x"=7, "y"=8)

/singleton/reagent/drink/toothpaste/skyemok
	name = "Skye'mok mead"
	description = "A traditional mead produced by V'krexi fermentation of the Skye'mok fungus."
	strength = 25
	taste_description = "fresh, tangy, and lingering taste"
	color = "#8ae5bf"
	glass_icon_state = "skyemok_glass"
	glass_name = "glass of Skye'mok"
	glass_desc = "A plastic recipient meant to look like a V'krexi head full of a gooey fungus."
	glass_center_of_mass = list("x"=14, "y"=8)

//
// Zo'ra Soda
//
/singleton/reagent/drink/zorasoda
	name = "Zo'ra Soda"
	description = "Zo'ra Soda. You aren't supposed to see this."
	color = "#000000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	overdose = 45
	caffeine = 0.4
	taste_description = "zo'ra soda"
	carbonated = TRUE

/singleton/reagent/drink/zorasoda/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien != IS_DIONA)
		if(prob(2))
			to_chat(M, SPAN_GOOD(pick("You feel great!", "You feel full of energy!", "You feel alert and focused!")))

/singleton/reagent/drink/zorasoda/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(!(alien in list(IS_DIONA, IS_VAURCA)))
		M.make_jittery(5)

/singleton/reagent/drink/zorasoda/cherry
	name = "Zo'ra Cherry"
	description = "Zo'ra Soda, cherry edition. All good energy drinks come in cherry."
	color = "#102000"
	taste_description = "bitter cherry"

/singleton/reagent/drink/zorasoda/phoron
	name = "Zo'ra Phoron Passion"
	description = "Tastes nothing like phoron, but everything like grapes."
	color = "#863333"
	taste_description = "fruity grape"

/singleton/reagent/drink/zorasoda/klax
	name = "K'lax Energy Crush"
	description = "An orange zest cream soda with a delicious smooth taste."
	color = "#E78108"
	taste_description = "fizzy and creamy orange zest"

/singleton/reagent/drink/zorasoda/xuizi
	name = "K'lax Xuizi Xplosion"
	description = "A fizzy soda, made with genuine xuizi juice."
	color = "#91de47"
	taste_description = "sparkling cactus water"
	species_taste_description = list(
		SPECIES_UNATHI = "an electric kick of strawberry and watermelon"
	)

/singleton/reagent/drink/zorasoda/cthur
	name = "C'thur Rockin' Raspberry"
	description = "A raspberry concoction you're pretty sure is already on recall."
	color = "#0000CD"
	taste_description = "sweet flowery raspberry"

/singleton/reagent/drink/zorasoda/dyn
	name = "C'thur Dyn-A-Mite"
	description = "Tastes like dyn, if it punched you in the mouth."
	color = "#00e0e0"
	taste_description = "an explosion of menthol"

/singleton/reagent/drink/zorasoda/venomgrass
	name = "Zo'ra Sour Venom Grass"
	description = "The milder version of High Energy Zorane Might. Still tastes like a cloud of angry stinging acidic bees, though."
	color = "#100800"
	taste_description = "fizzy acidic nettles"

/singleton/reagent/drink/zorasoda/hozm // "Contraband"
	name = "Zo'ra High Octane Zorane Might"
	description = "It feels like someone is driving a freezing cold spear through the bottom of your mouth."
	color = "#365000"
	overdose = 20
	caffeine = 0.6
	taste_description = "biting into an acidic lemon mixed with strong mint"

/singleton/reagent/drink/zorasoda/hozm/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(!(alien in list(IS_DIONA, IS_VAURCA)))
		M.make_jittery(10)

/singleton/reagent/drink/zorasoda/kois
	name = "Zo'ra K'ois Twist"
	description = "Tastes exactly like how a kitchen smells after boiling brussel sprouts."
	color = "#DCD9CD"
	taste_description = "sugary cabbage"

/singleton/reagent/drink/zorasoda/mixedberry
	name = "Zo'ra Caprician Craze"
	description = "A mixed berry soda. Which berries are those? You can't tell!"
	color = "#F9190F"
	taste_description = "energizing berries"

/singleton/reagent/drink/zorasoda/lemonlime
	name = "Zo'ra Seismic Slammer"
	description = "A potently effervescent lemon-lime energy drink."
	color = "#E3E3E3"
	taste_description = "electric zestiness"

/singleton/reagent/drink/zorasoda/buzz
	name = "Buzzin' Cola"
	description = "A remarkably bubbly cola flavoured energy drink."
	color = "#3C090B"
	taste_description = "a fizzing swarm of cola"

/singleton/reagent/drink/zorasoda/drone
	name = "Vaurca Drone Fuel"
	description = "It's as thick as syrup and smells of gasoline. Why."
	color = "#31004A"
	taste_description = "viscous stale cola mixed with gasoline"
	carbonated = TRUE

/singleton/reagent/drink/zorasoda/drone/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return

	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.add_movespeed_modifier(/datum/movespeed_modifier/reagent/zorasoda/drone)
		M.add_chemical_effect(CE_BLOODRESTORE, 2 * removed)
		M.make_jittery(5)
	else if(alien != IS_DIONA)
		if (prob(M.chem_doses[type]))
			to_chat(M, pick(SPAN_WARNING("You feel nauseous!"), SPAN_WARNING("Ugh... You're going to be sick!"), SPAN_WARNING("Your stomach churns uncomfortably!"), SPAN_WARNING("You feel like you're about to throw up!"), SPAN_WARNING("You feel queasy!")))
			M.vomit()

/singleton/reagent/drink/zorasoda/drone/final_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/zorasoda/drone)

	. = ..()


/singleton/reagent/drink/zorasoda/jelly
	name = "Royal Vaurca Jelly"
	description = "It looks like mucus, but tastes like heaven. Royal jelly is a nutritious concentrated substance commonly created by Caretaker Vaurca in order to feed larvae. It is known to have a stimulating effect in most, if not all, species."
	color = "#FFFF00"
	caffeine = 0.3
	taste_description = "sweet flowers and nectar mixed with aromatic spices"

/singleton/reagent/drink/zorasoda/jelly/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien != IS_DIONA)
		M.druggy = max(M.druggy, 30)

/singleton/reagent/drink/toothpaste/caprician_coffee
	name = "Caprician Coffee"
	description = "A Vaurcesian take on liqueur coffee, quickly becoming a favorite of the Zo'ra Hive."
	color = "#C00000"
	taste_description = "minty coffee"
	strength = 15

	glass_icon_state = "caprician_coffee"
	glass_name = "glass of caprician coffee"
	glass_desc = "A Vaurcesian take on liqueur coffee, quickly becoming a favorite of the Zo'ra Hive."

/singleton/reagent/drink/toothpaste/ichor
	name = "Xsain Ichor"
	description = "A slushy beverage popular in Tret, often used as an example of K'laxan pride."
	color = "#584721"
	taste_description = "minty cactus water"

	glass_icon_state = "ichor"
	glass_name = "glass of xsain ichor"
	glass_desc = "A slushy beverage popular in Tret, often used as an example of K'laxan pride."
