#define DRUG_MESSAGE_DELAY 90 SECONDS
/singleton/reagent/drugs
	name = null
	description = DESC_PARENT
	taste_description = "a bad investment"
	taste_mult = 1.2
	color = "#1a1414"

	reagent_state = LIQUID
	metabolism = REM * 0.5
	breathe_met = REM
	ingest_met = REM * 1.5
	overdose = REAGENTS_OVERDOSE

	var/effect_messages = TRUE
	var/list/initial_effect_message_list = list("You close your eyes, and when they open, everything appears so much more vibrant.", "You feel a wave of pleasure suddenly rush over you.", "This is already the best decision you've ever made.")
	var/list/sober_message_list = list("You feel like garbage now...", "Your head aches.")

	var/power = 0
	var/ignores_drug_resistance = FALSE

/singleton/reagent/drugs/initial_effect(mob/living/carbon/human/M, alien, datum/reagents/holder)
	if (effect_messages)
		var/msg = pick(initial_effect_message_list)
		to_chat(M, SPAN_GOOD("[msg]"))

/singleton/reagent/drugs/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return

	power = (M.chem_doses[type] + REAGENT_VOLUME(holder, type))/2 //Larger the dose and volume, the more affected you are by the chemical.
	if(HAS_TRAIT(M, TRAIT_ORIGIN_DRUG_RESISTANCE) && !ignores_drug_resistance)
		power = max(power - 2, 0)

/singleton/reagent/drugs/final_effect(mob/living/carbon/M, datum/reagents/holder)
	if (effect_messages)
		var/msg = pick(sober_message_list)
		to_chat(M, SPAN_WARNING("[msg]"))

/singleton/reagent/drugs/mms
	name = "Mercury Monolithium Sucrose"
	description = "Mercury Monolithium Sucrose, or MMS, is a synthetic relaxant. It's both abused and used as a chemical precursor. Lasts twice as long when inhaled."
	color = "#60A584"
	taste_description = "bitterness"
	taste_mult = 0.4
	value = 2.8

/singleton/reagent/drugs/mms/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()

	M.druggy = max(M.druggy, power)
	M.add_chemical_effect(CE_PAINKILLER, 5 + round(power,5))

	if(power < 10)
		M.drowsiness = min(20,max(M.drowsiness,power - 5))
		if(prob(5))
			to_chat(M, SPAN_GOOD(pick("Your anxieties fade away.","Just be yourself - stop caring about what others think.","Everything will be alright...","The world feels so much more vibrant!","You feel relaxed.")))

	if(power > 10)
		M.drowsiness = min(20,max(M.drowsiness,power - 5))
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("It's difficult to focus.","You feel... really... lethargic.","It's difficult to pay attention to what you're meant to be doing.", "Am I forgetting something?", "What was I doing again?")))

	if(power > 20)
		var/probmod = 5 + (power-20)
		if(prob(probmod) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
			step(M, pick(GLOB.cardinals))

	if(prob(7))
		M.emote(pick("smile","giggle","moan","yawn","laugh","drool","twitch"))

/singleton/reagent/drugs/mms/overdose(mob/living/carbon/M, alien, removed = 0, scale = 1, datum/reagents/holder)
	..()
	M.hallucination = max(M.hallucination, 30 * scale)

/singleton/reagent/drugs/serotrotium
	name = "Serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	reagent_state = LIQUID
	color = "#202040"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	taste_description = "bitterness"
	fallback_specific_heat = 1.2
	effect_messages = FALSE
	value = 2.5

/singleton/reagent/drugs/serotrotium/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()

	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "gasp"))
	return

/singleton/reagent/drugs/serotrotium/overdose(mob/living/carbon/M, alien, removed = 0, scale = 1, datum/reagents/holder)
	..()
	M.bodytemperature = max(M.bodytemperature + 1 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	M.add_chemical_effect(CE_PULSE, 2)
	if(prob(5))
		to_chat(M, SPAN_WARNING(pick("You feel so hot...", "Why is it so hot!?")))
	M.make_jittery(10)
	M.dizziness = max(150, M.dizziness)
	M.make_dizzy(10)

/singleton/reagent/drugs/cryptobiolin
	name = "Cryptobiolin"
	description = "Cryptobiolin causes confusion and dizziness."
	reagent_state = LIQUID
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	taste_description = "sourness"
	effect_messages = FALSE
	value = 2

/singleton/reagent/drugs/cryptobiolin/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.dizziness = max(150, M.dizziness)//Setting dizziness directly works as long as the make_dizzy proc is called after to spawn the process
	M.make_dizzy(4)
	M.add_chemical_effect(CE_HALLUCINATE, power)
	M.confused = max(M.confused, power)

/singleton/reagent/drugs/snowflake
	name = "Snowflake"
	description = "A recreational stimulant refined from frost oil, found in certain plants."
	taste_description = "metallic and bitter"
	reagent_state = LIQUID
	color = "#bbd7eb"
	overdose = 15
	fallback_specific_heat = 15
	default_temperature = T0C - 40
	initial_effect_message_list = list("You feel euphoric!", "You feel unstoppable.")
	sober_message_list = list("You feel a bit more sluggish", "You feel terrible...", "You feel pretty dehydrated.")

/singleton/reagent/drugs/snowflake/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PAINKILLER, 3 * power)
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(12))
		M.emote(pick("shiver", "sniff"))
	if(prob(5))
		to_chat(M, SPAN_WARNING(pick("You just can't seem to stop sniffling...", "You feel impatient...", "Your eyes feel a bit dry.")))

/singleton/reagent/drugs/snowflake/overdose(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(prob(35))
		M.add_chemical_effect(CE_EMETIC, M.chem_doses[type])
		M.add_chemical_effect(CE_NEUROTOXIC, 1)
	..()

/singleton/reagent/drugs/impedrezene
	name = "Impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	taste_description = "numbness"
	effect_messages = FALSE
	value = 1.8

/singleton/reagent/drugs/impedrezene/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.jitteriness = max(M.jitteriness - 5, 0)
	M.confused = max(M.confused, power)
	M.add_chemical_effect(CE_NEUROTOXIC, 2*removed)
	if(prob(50))
		M.drowsiness = max(M.drowsiness, 3)
	if(prob(10) && ishuman(M))
		M.emote("drool")

/singleton/reagent/drugs/mindbreaker
	name = "Mindbreaker Toxin"
	description = "An incredibly potent hallucinogen designed to wreak havoc on the brain, resulting in disturbing hallucinations with long-term impacts on those given the drug - this drug is not pleasant, thus the name, and only hardcore addicts use the drug recreationally."
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	taste_description = "sourness"
	ignores_drug_resistance = TRUE
	value = 0.6

/singleton/reagent/drugs/mindbreaker/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.hallucination = max(M.hallucination, 100)
	M.add_chemical_effect(CE_HALLUCINATE, 2)
	M.add_chemical_effect(CE_NEUROTOXIC, 2*removed)

/singleton/reagent/drugs/mindbreaker/overdose(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_chemical_effect(CE_NEUROTOXIC, 4*removed)
	if(prob(5))
		M.adjustHalLoss(20)
		to_chat(M, SPAN_DANGER(pick("You feel the strongest of pains deeply rooted beneath your skull.", "Your head feels like it's going to burst!", "Your head stings!")))

/singleton/reagent/drugs/psilocybin
	name = "Psilocybin"
	description = "A strong psychotropic derived from certain species of mushroom."
	color = "#E700E7"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	taste_description = "mushroom"
	fallback_specific_heat = 1.2
	value = 0.7
	condiment_name = "Psilocybin"
	condiment_desc = "A small bottle full of a pink liquid. Whatever could it do?"
	condiment_icon_state = "psilocybin"
	condiment_center_of_mass = list("x"=16, "y"=8)

	initial_effect_message_list = list("You lean back and begin to fall... and fall... and fall.", "Your eyes open wide and you look upon this new world you now see.", "You close your eyes, and when they open, everything appears so much more vibrant.", "You feel a wave of pleasure suddenly rush over you.", "This is already the best decision you've ever made.")

/singleton/reagent/drugs/psilocybin/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.druggy = max(M.druggy, 30)
	M.add_chemical_effect(CE_HALLUCINATE, 1)
	var/dose = M.chem_doses[type]
	if(HAS_TRAIT(M, TRAIT_ORIGIN_DRUG_RESISTANCE))
		dose = max(dose - 2, 0)
	if(dose < 1)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(5))
			to_chat(M, SPAN_GOOD(pick("You feel giddy.", "You can't put your finger on it, but whatever it is, it's really funny.", "You feel full of energy.", "Your anxieties no longer cloud your mind.")))
	else if(dose < 2)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.dizziness = max(150, M.dizziness)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(5))
			to_chat(M, SPAN_GOOD(pick("Everything is so vibrant...", "Look at all those colours...", "Shapes dance across your vision.", "You feel like you're looking through a kaleidoscope.", "That's so funny!")))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.dizziness = max(150, M.dizziness)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(5))
			to_chat(M, SPAN_GOOD(pick("Everything is so vibrant...", "Look at all those colours...", "Shapes dance across your vision.", "You feel like you're looking through a kaleidoscope.", "That's so funny!")))
	if(ishuman(M) && prob(min(15, dose*5)))
		M.emote(pick("twitch", "giggle"))

/singleton/reagent/drugs/psilocybin/overdose(mob/living/carbon/M, datum/reagents/holder)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type])
	to_chat(M, SPAN_WARNING(pick("You feel... disconnected from your body - is it your body?", "You are dying... but that's okay, right?", "You are at peace with the universe.", "The stars are beckoning you to them.")))
	if(prob(5))
		M.custom_pain("You feel a sharp pain in your stomach!", 10)

/singleton/reagent/drugs/raskara_dust
	name = "Raskara Dust"
	description = "A powdery narcotic found in the gang-ridden slums of Biesel and Sol. Known for it's relaxing poperties that cause trance-like states when inhaled. Casual users tend to snort or inhale, while hardcore users inject."
	reagent_state = SOLID
	color = "#AABBAA"
	overdose = 10
	taste_description = "baking soda"
	metabolism = REM * 0.1
	breathe_met = REM * 0.2
	ingest_met = REM * 0.3

	initial_effect_message_list = list("You gradually begin to slow down, and so does everything around you.", "You lean back and begin to fall... and fall... and fall.", "This is already the best decision you've ever made.")

	var/effect_message_list = list("You feel so relaxed...", "Nothing's really bothering you right now...", "You should lay down and just... take it easy.", "You deserve a break from all your hard work today.")

/singleton/reagent/drugs/raskara_dust/affect_ingest(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.drowsiness += 1 * removed
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick(effect_message_list)))

/singleton/reagent/drugs/raskara_dust/affect_breathe(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.drowsiness += 2 * removed
	if(prob(5) && ishuman(M))
		M.emote("cough")
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick(effect_message_list)))

/singleton/reagent/drugs/raskara_dust/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 30)
	M.drowsiness += 3 * removed
	if(prob(5))
		M.emote("twitch")
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick(effect_message_list)))

/singleton/reagent/drugs/raskara_dust/overdose(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(prob(3))
		to_chat(M, SPAN_WARNING(pick("You feel... disconnected from your body - is it your body?", "Are you ascending to another plane of existence... that's so cool?", "You are dying... but that's okay, right?", "You feel a tingly sensation in your body.", "You can smell something unusual.", "You can taste something unusual.")))
	if(prob(M.chem_doses[type] / 3))
		if(prob(85))
			M.emote(pick("twitch", "shiver"))
		else
			M.seizure(rand(2,3))

/singleton/reagent/drugs/colorspace
	name = "Colorspace"
	description = "A psychedelic drug that alters thought and perception."
	taste_description = "flavorless paste"
	color = "#a7a6a4"
	initial_effect_message_list = list("Your skin tickles.", "You seem to leave this world behind...")
	sober_message_list = list("The world grows still again.", "Colors seem duller.")

/singleton/reagent/drugs/colorspace/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()

	var/drug_strength = 20 * power

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	M.druggy = max(M.druggy, 15)
	M.hallucination = max(M.hallucination, drug_strength)

	if(prob(15))
		to_chat(SPAN_GOOD(pick("The floor is melting...", "Everything is so much brighter! Wow!", "Everything is shifting around you.")))


/singleton/reagent/drugs/night_juice
	name = "Nightlife"
	description = "A liquid narcotic commonly used by the more wealthy drug-abusing citizens of the Eridani Federation. Works as a potent stimulant that causes extreme awakefulness. Lethal in high doses."
	reagent_state = LIQUID
	color = "#FFFF44"
	taste_description = "salted sugar"
	overdose = 10
	metabolism = REM * 0.2
	breathe_met = REM * 0.1
	breathe_mul = 0.5
	ingest_mul = 0.125

	initial_effect_message_list = list("You feel a wave of pleasure smash into you and liven you up!", "You're startled by the sheer strength and speed of this drug!", "You already feel so damn good!", "This is the best decision you've ever made!")

/singleton/reagent/drugs/night_juice/initialize_data(newdata, datum/reagents/holder)
	. = ..()
	LAZYSET(., "special", 0)

/singleton/reagent/drugs/night_juice/affect_blood(mob/living/carbon/human/M, alien, removed, datum/reagents/holder)
	..()

	holder.reagent_data[type]["special"] += (REAGENT_VOLUME(holder, type)/10)*removed

	M.make_jittery(5 + holder.reagent_data[type]["special"])
	M.drowsiness = max(0,M.drowsiness - (1 + holder.reagent_data[type]["special"]*0.1))
	if(holder.reagent_data[type]["special"] > 5)
		M.apply_effect(1 + holder.reagent_data[type]["special"]*0.25, STUTTER)
		M.druggy = max(M.druggy, holder.reagent_data[type]["special"]*0.25)
		M.make_jittery(holder.reagent_data[type]["special"])
		if(prob(holder.reagent_data[type]["special"]))
			M.emote("twitch")
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("You begin to notice a rhythm to all the sounds around you.", "You feel euphoric!", "Your sense of hearing seems heightened.", "You can't sit still, you gotta move!", "You could start a party right now!", "Live in the moment!", "All your anxieties seem to fade away.")))
		var/obj/item/organ/H = M.internal_organs_by_name[BP_HEART]
		H.take_damage(holder.reagent_data[type]["special"] * removed * 0.025)

/singleton/reagent/drugs/night_juice/overdose(mob/living/carbon/human/M, alien, removed, datum/reagents/holder)
	M.bodytemperature = max(M.bodytemperature + 1 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(2))
		M.emote("shiver")
		to_chat(M, SPAN_WARNING(pick("You feel so hot...", "Why is it so hot!?")))
	if(prob(25))
		M.add_chemical_effect(CE_NEPHROTOXIC, 1)


/singleton/reagent/drugs/guwan_painkillers
	name = "Tremble"
	description = "An ancient tribal Unathi narcotic based on the outer gel layer of the seeds of a poisonous flower. The chemical itself acts as a very potent omni-healer when consumed, however as the chemical metabolizes, it causes immense and crippling pain."
	reagent_state = LIQUID
	color = "#FFFF44"
	taste_description = "sunflower seeds"
	metabolism = REM * 0.25
	overdose = 10
	fallback_specific_heat = 1
	ignores_drug_resistance = TRUE
	effect_messages = FALSE

/singleton/reagent/drugs/guwan_painkillers/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	affect_ingest(M, alien, removed*0.5, holder)

/singleton/reagent/drugs/guwan_painkillers/affect_ingest(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	var/dose = M.chem_doses[type]
	if(dose > 5 && REAGENT_VOLUME(holder, type) <= 3)
		M.adjustHalLoss(removed*300) //So oxycomorphine can't be used with it.
	else
		if(dose > 5)
			M.add_chemical_effect(CE_PAINKILLER, 30)
			M.heal_organ_damage(5 * removed,5 * removed)
		else
			M.add_chemical_effect(CE_PAINKILLER, 5)
			M.heal_organ_damage(2 * removed,2 * removed)

/singleton/reagent/toxin/stimm	//Homemade Hyperzine, ported from Polaris
	name = "Stimm"
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a"
	metabolism = REM * 3
	overdose = 10
	strength = 3

/singleton/reagent/toxin/stimm/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	M.add_movespeed_modifier(/datum/movespeed_modifier/reagent/stimm)

/singleton/reagent/toxin/stimm/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("twitch", "blink_r", "shiver"))
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick("You feel pumped!", "Energy, energy, energy - so much energy!", "You could run a marathon!", "You can't sit still!", "It's difficult to focus right now... but that's not important!")))
	if(prob(5)) // average of 6 brute every 20 seconds.
		M.visible_message("[M] shudders violently.", "You shudder uncontrollably, it hurts.")
		M.take_organ_damage(6 * removed, 0)

/singleton/reagent/toxin/stimm/final_effect(mob/living/carbon/M, datum/reagents/holder)
	M.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/stimm)
	. = ..()

/singleton/reagent/toxin/krok
	name = "Krok Juice"
	description = "An advanced Eridanian variant of ancient krokodil, known for causing prosthetic malfunctions."
	strength = 3
	metabolism = REM
	overdose = 15

/singleton/reagent/toxin/krok/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/robo = FALSE
	for (var/obj/item/organ/external/E in H.organs)
		if(!E || !(E.status & ORGAN_ROBOT))
			continue
		robo = TRUE
		if(prob(80)) // 20% chance of making robot limbs malfuction
			continue
		switch(E.body_part)
			if(HAND_LEFT, ARM_LEFT)
				H.drop_l_hand()
			if(HAND_RIGHT, ARM_RIGHT)
				H.drop_r_hand()
	if(robo)
		H.add_chemical_effect(CE_PAINKILLER, 30)
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("You feel a pleasant tingling sensation in your cybernetics.", "You feel a jolt of pain in your cybernetic limb, but it feels oddly nice.", "The sensations in your cybernetics feel heightened.", "Your cybernetics feel magnitudes better than your organic body parts.")))
	else
		H.add_chemical_effect(CE_PAINKILLER, 10)
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("You feel a little bit more comfortable.", "You feel alright.", "Your joints feel warm and tingly.", "You feel soothed and at ease.")))

	var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[H.species.vision_organ || BP_EYES]
	if(eyes.status & ORGAN_ROBOT)
		M.hallucination = max(M.hallucination, 40)

/singleton/reagent/wulumunusha
	name = "Wulumunusha Extract"
	description = "The extract of the wulumunusha fruit, it can cause hallucinations and muteness."
	color = "#61E2EC"
	taste_description = "earthiness"
	fallback_specific_heat = 1
	overdose = 10
	condiment_name = "Wulumunusha Extract Bottle"
	condiment_desc = "A small dropper bottle full of a stoner's paradise. A warning label warns of muteness as a side effect."
	condiment_icon_state = "wuluextract"

/singleton/reagent/wulumunusha/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.druggy = max(M.druggy, 100)
	M.silent = max(M.silent, 5)
	if(prob(3) && !isskrell(M))
		to_chat(M, SPAN_GOOD(pick("You can almost see the currents of air as they dance around you.", "You see the colours around you beginning to bleed together.", "You feel safe and comfortable.")))
	if(prob(3) && isskrell(M))
		to_chat(M, SPAN_ALIEN(pick("You can see the thoughts of those around you dancing in the air.", "You feel as if your mind has opened even further, your thought-field expanding.", "It's difficult to contain your thoughts - but why hide them anyway?", "You feel safe and comfortable.")))

/singleton/reagent/wulumunusha/overdose(mob/living/carbon/M, alien, removed = 0, scale = 1, datum/reagents/holder)
	if(isskrell(M))
		M.hallucination = max(M.hallucination, 10 * scale)	//light hallucinations that afflict skrell

/singleton/reagent/drugs/ambrosia_extract
	name = "Ambrosia Extract"
	description = "Ambrosia Extract is a fairly strong relaxant commonly found in Ambrosia plants. It's one of the most widely available drugs in human space."
	reagent_state = LIQUID
	color = "#60A584"
	metabolism = REM / 3.33
	overdose = 30
	taste_description = "spicy earth"
	taste_mult = 0.4
	fallback_specific_heat = 1.6
	value = 2.8
	effect_messages = FALSE
	condiment_name = "Ambrosia Extract Bottle"
	condiment_desc = "A small dropper bottle full of a stoner's paradise."
	condiment_icon_state = "ambrosiaextract"
	condiment_center_of_mass = list("x"=16, "y"=8)


/singleton/reagent/drugs/ambrosia_extract/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PULSE, -1)

	M.add_chemical_effect(CE_PAINKILLER, 5 + round(power,5))

	if(power < 15)
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("Your anxieties fade away.","Just be yourself - stop caring about what others think.","Everything will be alright...","The world feels so much more vibrant!","You feel relaxed.")))

	if(power > 15)
		M.drowsiness = min(20,max(M.drowsiness,power - 5))
		var/nutrition_percent = M.nutrition/M.max_nutrition
		M.adjustNutritionLoss(power*removed*nutrition_percent)
		var/hunger_strength = 1 - nutrition_percent
		if(prob( round(hunger_strength*removed) ))
			to_chat(M, SPAN_NOTICE(pick("You could really go for some munchies.","You feel the need to eat more.","You crave chips for some reason.","You kind of really want pizza.","Some cosmic brownies would be nice.")))
		if(prob(3))
			to_chat(M, SPAN_WARNING(pick("It's a little bit difficult to focus.","You feel a bit lethargic."," It's kinda hard to pay attention to what you're doing.", "Am I forgetting something?", "What was I doing again?")))

/singleton/reagent/drugs/ambrosia_extract/overdose(mob/living/carbon/M, alien, removed = 0, scale = 1, datum/reagents/holder)
	..()
	M.hallucination = max(M.hallucination, 30 * scale)

/singleton/reagent/drugs/joy
	name = "Joy"
	description = "An expensive and illegal drug often abused by those who find no other means to numb their physical and mental pains. A Joy addict is a truly sad sight."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolism = REM*0.1
	overdose = 5
	od_minimum_dose = 2
	taste_description = "tranquility"

	initial_effect_message_list = list("You feel a numbing sensation spread from within you.", "A numbing sensation builds within you.", "Everything will be okay... just relax.")
	sober_message_list = list("You feel grounded in the real world again... for better or worse.")

/singleton/reagent/drugs/joy/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 100)
	M.add_chemical_effect(CE_NEUROTOXIC, 4*removed)
	M.adjustCloneLoss(6*removed)
	M.add_chemical_effect(CE_PACIFIED, 1)
	M.eye_blurry = max(M.eye_blurry, 30)
	M.drowsiness = max(M.drowsiness, 10)
	M.make_dizzy(15)
	if(M.chem_doses[type] < 1)
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("Stress was an inconvenience that you are now free of.", "You feel somewhat detached from reality.", "You can feel time passing by and it no longer bothers you.", "You feel so incredibly relaxed.", "You haven't felt this care-free since you were a child...", "Why can't it always be like this?", "You're watching yourself from afar - detached from your physical body.")))
	if(M.chem_doses[type] >= 1)
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("Stress was an inconvenience that you are now free of.", "You lose all sense of connection to the real world.", "Everything is so tranquil.", "You feel totaly detached from reality.", "Your feel disconnected from your body.", "You are aware of nothing but your conscious thoughts.", "You keep falling... and falling... and falling - never stopping.", "Is this what it feels like to be dead?", "Your memories are hazy... all you have ever known is this feeling.", "You're watching yourself from afar - detached from your physical body.")))

/singleton/reagent/drugs/joy/overdose(mob/living/carbon/M, alien, removed, scale, datum/reagents/holder)
	M.ear_deaf = 20
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type])
	M.adjustOxyLoss(2 * removed)
	if(M.losebreath < 15)
		M.losebreath++
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick("You're dying... but you don't care.", "The numbing sensation continues to build and build.", "One more hit... and maybe even death will cease to exist.")))

/singleton/reagent/drugs/xuxigas
	name = "Xu'Xi Gas"
	description = "A recreational drug hailing from Qerr'Malic that must be inhaled. It produces a mild high similar to Wulumunusha and is known to make users susceptible to persuasion. Most forms of Xu'Xi Gas found outside of the Nralakk Federation are cheap, synthetic substitutes. Only works when inhaled."
	color = "#58D373"
	taste_description = "algae"
	reagent_state = GAS
	overdose = REAGENTS_OVERDOSE
	breathe_met = REM*0.2

/singleton/reagent/drugs/xuxigas/affect_breathe(mob/living/carbon/human/M, alien, removed, datum/reagents/holder)
	M.druggy = max(M.druggy, M.chem_doses[type]/2)
	M.add_chemical_effect(CE_PULSE, -1)
	var/message_list = list("You feel soothed and at ease.", "You feel like sharing the wonderful memories and feelings you're experiencing.", "You feel like you're floating off the ground.", "You don't want this feeling to end.", "You wish to please all those around you.", "You feel particularly susceptible to persuasion.", "Everyone is so trustworthy nowadays.")
	var/message_type = "good"
	if(isskrell(M))
		message_list += list("You can see the thoughts of those around you dancing in the air.", "You feel as if your mind has opened even further, your thought-field expanding.", "It's difficult to contain your thoughts - but why hide them anyway?")
		message_type = "alium"
	else
		message_list += list("You can almost see the currents of air as they dance around you.", "You see the colours around you beginning to bleed together.", "You feel safe and comfortable.")

	if(prob(5))
		to_chat(M, span(message_type, pick(message_list)))


/singleton/reagent/drugs/xuxigas/overdose(mob/living/carbon/human/M, alien, removed, scale, datum/reagents/holder)
	if(prob(3))
		to_chat(M, SPAN_WARNING(pick("You feel particularly vulnerable to being swayed by those around you...", "You have an urge to please those around you.", "This high cannot end... where can you get more?", "You don't want this feeling to end.")))

/singleton/reagent/drugs/skrell_nootropic
	name = "Co'qnixq Wuxi"
	description = "Co'qnixq Wuxi, or Co'qnixq Nootropic, has existed since before Glorsh, and was developed as a cognitive enhancer for Skrell with on-set dementia. When taken, one's consciousness is heightened greatly alongside receiving mild energy boost. Frequently used as a 'smart drug' by students and scientists."
	color = "#E3B0E5"
	taste_description = "concentration"
	reagent_state = LIQUID
	overdose = 10
	od_minimum_dose = 2
	metabolism = REM*0.05
	var/psi_boosted = FALSE
	var/initial_stamina

/singleton/reagent/drugs/skrell_nootropic/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(M.psi && !psi_boosted)
		initial_stamina = M.psi.max_stamina
		M.psi.max_stamina = M.psi.max_stamina*1.25
		psi_boosted = TRUE
	if(prob(2))
		to_chat(M, SPAN_GOOD(pick("You have a renewed sense of focus.", "You feel more determined to get things done.", "You feel more confident in your own abilities.", "Your head-space feels tidy and organised - now's the time to get to work.", "You could climb a mountain right now!")))

/singleton/reagent/drugs/skrell_nootropic/overdose(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_movespeed_modifier(/datum/movespeed_modifier/reagent/skrell_nootropic)
	if(prob(25))
		M.add_chemical_effect(CE_NEPHROTOXIC, 0.5)
	if(prob(2))
		to_chat(M, SPAN_WARNING(pick("You can't allow anyone to get between you and your tasks.", "You feel like screaming at the next person who interrupts you.", "No one can stop you!", "You can power through this...")))

/singleton/reagent/drugs/skrell_nootropic/final_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/skrell_nootropic)
	if(M.psi && psi_boosted)
		M.psi.max_stamina = initial_stamina
		psi_boosted = FALSE
	. = ..()

/singleton/reagent/drugs/cocaine
	name = "Cocaine"
	description = "A recreational drug known for its sharp, but short, energy boost. Very commonly used by cytherians on Venus."
	taste_description = "numbing powder"
	color = "#FFFFFF"

	initial_effect_message_list = list("You feel... happy...", "A numbing sensation comes over you...", "Reality feels... distant now...")
	sober_message_list = list("You feel like garbage now...", "Your head aches.")

	overdose = 10
	ingest_met = REM * 0.25 // Stomach acid slows rate of absorption

	var/painkiller_mul = 1

/singleton/reagent/drugs/cocaine/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_PAINKILLER, painkiller_mul * power * 40)
	if(prob(7))
		M.emote(pick("shiver", "sniff"))

/singleton/reagent/drugs/cocaine/overdose(mob/living/carbon/M, alien, removed, scale, datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_HALLUCINATE, power)
	M.apply_effect(1, STUTTER)
	M.make_jittery(power - 6)
	M.add_chemical_effect(CE_NEUROTOXIC, removed / 3)
	M.add_chemical_effect(CE_CARDIOTOXIC, removed / 2) //Tolerable damage, unless your heart can't regenerate...
	if(prob(7))
		var/obj/item/organ/internal/heart/H = M.internal_organs_by_name[BP_HEART]
		if(istype(H) && !BP_IS_ROBOTIC(H)) //But at least a robot heart can keep working at all!
			to_chat(M, SPAN_WARNING(pick("You feel a cramp in your chest!", "Something tingles inside your chest.", "You feel lightheaded.", "Your vision tunnels.", "You can't feel your fingers.", "Maybe you should slow down?")))
			if(prob(20))
				M.add_chemical_effect(CE_NOPULSE, power)

/singleton/reagent/drugs/cocaine/contemplus
	name = "Contemplus"
	description = "A designer varient of cocaine originating from Venus. This is designed to enhance the brain activity to provide enhanced thinking abilities."
	color = "#fff200"

	sober_message_list = list("You don't feel quite so knowledgable anymore...")

	painkiller_mul = 0.8 // Not as good a painkiller

/singleton/reagent/drugs/cocaine/contemplus/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	if(prob(7))
		to_chat(M, SPAN_GOOD(pick("You've got an idea for something.", "You figured out that problem you were having trouble with.", "You think you know what to do now.")))


/singleton/reagent/drugs/cocaine/spotlight
	name = "Spotlight"
	description = "A designer varient of cocaine originating from Venus. Commonly used by the acting scene, this is designed to increase the user's confidence."
	color = "#8dff64"

	sober_message_list = list("Your newfound confidence is gone...", "You don't feel so sure about yourself anymore...")

	painkiller_mul = 1.2 // Actors that do their own stunts will want this

/singleton/reagent/drugs/cocaine/sparkle
	name = "Sparkle"
	description = "A designer variant of cocaine originating from Venus. Primarily present in the nightlife scene, this is designed to decrease a user's inhibitions and increase pleasure."
	color = "#f704d6"

	painkiller_mul = 1.5

/singleton/reagent/drugs/cocaine/sparkle/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	if(prob(7))
		to_chat(M, SPAN_GOOD(pick("You begin to notice a rhythm to all the sounds around you.", "You feel euphoric!", "You could start a party right now!", "Live in the moment!", "All your anxieties seem to fade away.")))

	M.druggy = max(M.druggy, power)
	if(prob(15))
		M.emote(pick("laugh", "chuckle", "giggle"))

/singleton/reagent/drugs/heroin
	name = "Heroin"
	description = "An extremely potent but dangerous and addictive opiate refined from morphine, its use is nearly-universally banned across the Orion Spur. The possession and usage of heroin is illegal in the Republic of Biesel."
	reagent_state = SOLID
	color = "#ffffff"
	metabolism_min = 0.5
	overdose = 5
	od_minimum_dose = 2

/singleton/reagent/drugs/heroin/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	if(prob(7))
		to_chat(M, SPAN_GOOD(pick("You feel soothed and at ease.", "You feel content and at peace.", "You feel a pleasant emptiness.", "You feel like sharing the wonderful memories and feelings you're experiencing.", "All your anxieties fade away.", "You feel like you're floating off the ground.", "You don't want this feeling to end.")))

	if(check_min_dose(M))
		M.add_chemical_effect(CE_PAINKILLER, 180)
		if(!M.chem_effects[CE_CLEARSIGHT])
			M.eye_blurry = max(M.eye_blurry, 10)
		if(!M.chem_effects[CE_STRAIGHTWALK])
			M.confused = max(M.confused, 20)

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/bac = H.get_blood_alcohol()
	if(bac >= 0.01)
		overdose(M, alien, removed, holder) // Straight to overdose

/singleton/reagent/drugs/heroin/overdose(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	M.druggy = max(M.druggy, 20)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type])
	if(M.losebreath < 15)
		M.losebreath++

/singleton/reagent/drugs/dionae_stimulant
	name = "Diesel"
	description = "Fondly dubbed Diesel by the dionae of the Narrows where it is served in the ship's cafeteria, this viscous sludge is the byproduct of refining radioactive materials and provides an invigorating kick to a dionae's workday."
	color = "#465044"
	taste_description = "gritty corium"
	reagent_state = SOLID
	metabolism = REM*0.04
	overdose = 10
	unaffected_species = IS_MACHINE

	initial_effect_message_list = list("A heat builds within you.", )
	sober_message_list = list("The heat within you begins to dull...")

/singleton/reagent/drugs/dionae_stimulant/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	. = ..()
	if(alien == IS_DIONA)
		M.add_movespeed_modifier(/datum/movespeed_modifier/reagent/dionae_stimulant)

/singleton/reagent/drugs/dionae_stimulant/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.apply_damage(10, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	if(alien == IS_DIONA)
		if(prob(5))
			to_chat(M, SPAN_GOOD(pick("A bubbling sensation is felt by your nymphs.", "A nymph comments that this is the most energetic it has ever been!", "A warm energy builds within your central structure.", "Your nymphs can't stay still!")))
			M.emote(pick("chirp", "twitch", "shiver"))
	else
		M.apply_damage(10, DAMAGE_TOXIN, damage_flags = DAMAGE_FLAG_DISPERSED)

/singleton/reagent/drugs/dionae_stimulant/overdose(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		if(prob(5))
			to_chat(M, SPAN_DANGER(pick("Your nymphs keep interrupting one another - decisions can't be made!", "A nymph is too many steps ahead of the majority, we can't keep up!", "None of your nymphs have time to deliberate!", "What do we do? Where do we go? What do we say?")))
		if(prob(5))
			M.Weaken(10)
			M.Stun(10)

/singleton/reagent/drugs/dionae_stimulant/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 2)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/singleton/reagent/drugs/dionae_stimulant/final_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(alien == IS_DIONA)
		M.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/dionae_stimulant)
	. = ..()

/singleton/reagent/drugs/dionae_stimulant/diet
	name = "diet Diesel"
	description = "Diesel produced straight from the Narrows that has been made \"diet\" or decontaminated of radiation, making it safe for distribution around the Orion Spur."

/singleton/reagent/drugs/dionae_stimulant/diet/initial_effect(mob/living/carbon/M, alien, datum/reagents/holder)
	return

/singleton/reagent/drugs/dionae_stimulant/diet/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	if(alien == IS_DIONA)
		if(prob(5))
			to_chat(M, SPAN_GOOD(pick("A bubbling sensation is felt by your nymphs.", "A nymph comments that this is the most energetic it has ever been!", "A warm energy builds within your central structure.", "Your nymphs can't stay still!")))
			M.emote(pick("chirp", "twitch", "shiver"))
	else
		M.apply_damage(5, DAMAGE_TOXIN, damage_flags = DAMAGE_FLAG_DISPERSED) //Less toxic than regular Diesel due to the lack of radioactivity, but still toxic

/singleton/reagent/drugs/dionae_stimulant/diet/final_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	return

#undef DRUG_MESSAGE_DELAY

