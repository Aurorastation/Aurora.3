/* General medicine */

/decl/reagent/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a cardiostimulant which stabilises myocardial contractility, working towards maintaining a steady pulse and blood pressure. Inaprovaline also acts as a weak analgesic."
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	metabolism_min = REM * 0.125
	breathe_mul = 0.5
	scannable = TRUE
	taste_description = "bitterness"

/decl/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M, 0.25))
		M.add_chemical_effect(CE_STABLE)
		M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/reagent/inaprovaline/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(2))
		to_chat(M, SPAN_WARNING(pick("Your chest feels tight.", "Your chest is aching a bit.", "You have a stabbing pain in your chest.")))
		M.adjustHalLoss(5)

/decl/reagent/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is a complex medication which specifically targets damaged tissues and damaged blood vessels by encouraging the rate at which the damaged tissues are regenerated. Overdosing bicaridine allows the drug to take effect on damaged muscular tissues of arteries."
	reagent_state = LIQUID
	color ="#BF0000"
	scannable = TRUE
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	taste_description = "bitterness"
	fallback_specific_heat = 1
	taste_mult = 3

/decl/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(5 * removed, 0)
	if(REAGENT_VOLUME(M.reagents, /decl/reagent/butazoline))
		M.add_chemical_effect(CE_ITCH, M.chem_doses[type] * 2)
		M.adjustHydrationLoss(2*removed)
		M.adjustCloneLoss(2.5*removed) // Cell regeneration spiralling out of control resulting in genetic damage.

/decl/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.dizziness = max(100, M.dizziness)
	M.make_dizzy(5)
	M.adjustHydrationLoss(5*removed)
	M.adjustNutritionLoss(5*removed)

	var/mob/living/carbon/human/H = M
	if(M.chem_doses[type] > 30) //Bicaridine treats arterial bleeding when dose is greater than 30u and when the drug is overdosing (chemical volume in blood greater than 20).
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(2))
				E.status &= ~ORGAN_ARTERY_CUT

/decl/reagent/butazoline
	name = "Butazoline"
	description = "Butazoline, a recent improvement upon Bicaridine, is specialised at treating the most traumatic of wounds, though less so for treating severe bleeding."
	reagent_state = LIQUID
	color = "#ff5555"
	overdose = 15
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "bitterness"
	taste_mult = 3

/decl/reagent/butazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(8 * removed, 0)
	M.add_chemical_effect(CE_ITCH, M.chem_doses[type])
	M.adjustHydrationLoss(1*removed)

/decl/reagent/kelotane
	name = "Kelotane"
	description = "Kelotane is a complex medication which specifically targets tissues which have been lost to severe burning by encouraging the rate at which these damaged tissues are regenerated."
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "bitterness"

/decl/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(0, 6 * removed)
	if(REAGENT_VOLUME(M.reagents, /decl/reagent/dermaline))
		M.add_chemical_effect(CE_ITCH, M.chem_doses[type] * 2)
		M.adjustHydrationLoss(2*removed)
		M.adjustCloneLoss(2.5*removed) //Cell regeneration spiralling out of control resulting in genetic damage.

/decl/reagent/kelotane/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	if(!(head.disfigured))
		if(prob(10))
			to_chat(M, SPAN_WARNING(pick("Blisters start forming on your face.", "Your face feels numb.", "Your face feels swollen.", "You face hurts to touch.")))
		if(prob(2))
			to_chat(M, SPAN_DANGER("Your face has swollen and blistered to such a degree that you are no longer recognisable!"))
			head.disfigured = TRUE

/decl/reagent/dermaline
	name = "Dermaline"
	description = "Dermaline is a recent improvement of kelotane, working in a similar way, though twice as effective. Dermaline is capable of recovering even the most dire of burnt tissues, being able to treat full-thickness burning."
	reagent_state = LIQUID
	color = "#FF8000"
	taste_description = "bitterness"
	fallback_specific_heat = 1
	scannable = TRUE
	metabolism = REM * 0.5
	overdose = 15
	taste_mult = 1.5

/decl/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(0, 12 * removed)
	M.add_chemical_effect(CE_ITCH, M.chem_doses[type])
	M.adjustHydrationLoss(1*removed)

/decl/reagent/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum over-the-counter antitoxin. It is used in response to a variety of poisoning cases, being able to neutralise and remove harmful toxins from the bloodstream."
	reagent_state = LIQUID
	color = "#00A000"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "a roll of gauze"

	var/remove_generic = TRUE
	var/list/remove_toxins = list(
		/decl/reagent/toxin/zombiepowder
	)

/decl/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		return

	if(remove_generic)
		M.drowsiness = max(0, M.drowsiness - 6 * removed)
		M.hallucination -= (2 * removed)
		if(check_min_dose(M, 0.5))
			M.add_up_to_chemical_effect(CE_ANTITOXIN, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/_R in ingested.reagent_volumes)
		if((remove_generic && ispath(_R, /decl/reagent/toxin)) || (_R in remove_toxins))
			ingested.remove_reagent(_R, removing)
			return
	for(var/_R in M.reagents.reagent_volumes)
		if((remove_generic && ispath(_R, /decl/reagent/toxin)) || (_R in remove_toxins))
			M.reagents.remove_reagent(_R, removing)
			return

/decl/reagent/dylovene/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(5 * removed)
	M.adjustHydrationLoss(5 * removed)

/decl/reagent/dexalin
	name = "Dexalin"
	description = "Dexalin is a complex oxygen therapeutic and is available OTC. The chemical utilises carbon nanostructures which cling to oxygen and, in pathological conditions where tissues are hypoxic, will oxygenate these regions. Dexalin is twice as efficient when inhaled."
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"
	metabolism = REM * 0.75
	breathe_met = REM * 0.5
	breathe_mul = 2
	var/strength = 6

/decl/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M, 0.5))
		M.add_chemical_effect(CE_OXYGENATED, strength/6) // 1 for dexalin, 2 for dexplus
	holder.remove_reagent(/decl/reagent/lexorin, strength/3 * removed)
	if(alien == IS_VAURCA) //Vaurca need a mixture of phoron and oxygen. Dexalin likely imbalances that.
		M.adjustToxLoss(removed * strength / 2)
		M.eye_blurry = max(M.eye_blurry, 5)

//Hyperoxia causes brain and eye damage
/decl/reagent/dexalin/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_NEUROTOXIC, removed*0.5)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			E.take_damage(removed * (strength / 12))

/decl/reagent/dexalin/plus
	name = "Dexalin Plus"
	fallback_specific_heat = 1
	description = "Dexalin Plus was a ground-breaking improvement of Dexalin, capable of transporting several times the amount of oxygen, allowing it to have more clinical uses in treating hypoxia. Dexalin Plus is twice as efficient when inhaled."
	color = "#0040FF"
	overdose = 15
	strength = 12

/decl/reagent/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is an old, though still useful, medication largely set aside following bicaridine and kelotane's development. The drug increases the rate at which tissues regenerate, though far slower than modern medications."
	reagent_state = LIQUID
	color = "#8040FF"
	overdose = 30
	scannable = TRUE
	fallback_specific_heat = 1
	taste_description = "bitterness"
	breathe_mul = 0
	metabolism = REM * 0.25

/decl/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/power = 1 + Clamp((holder.get_temperature() - (T0C + 20))*0.1,-0.5,0.5)
	//Heals 10% more brute and less burn for every 1 celcius above 20 celcius, up 50% more/less.
	//Heals 10% more burn and less brute for every 1 celcius below 20 celcius, up to 50% more/less.
	M.heal_organ_damage(3 * removed * power,3 * removed * power)

/decl/reagent/tricordrazine/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_ITCH, M.chem_doses[type])

/decl/reagent/cryoxadone
	name = "Cryoxadone"
	description = "Cryoxadone is a ground-breaking and complex medication that, when acting on bodies cooler than 170K, is capable of increasing the rate at which wounds regenerate, as well as treating genetic damage. Cryoxadone, alongside Clonexadone, are the backbones of the cloning industry."
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = TRUE
	taste_description = "sludge"

/decl/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustCloneLoss(-100 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)
		M.adjustToxLoss(-10 * removed)

/decl/reagent/clonexadone
	name = "Clonexadone"
	description = "Clonexadone is a ground-breaking, complex medication that improved upon Cryoxadone. When acting on bodies cooler than 170K, the drug is capable of increasing the rate at which wounds regenerate, as well as treating genetic damage. Clonexadone, alongside Cryoxadone, are the backbones of the cloning industry."
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	scannable = TRUE
	taste_description = "slime"

/decl/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustCloneLoss(-100 * removed)
		M.adjustOxyLoss(-30 * removed)
		M.heal_organ_damage(30 * removed, 30 * removed)
		M.adjustToxLoss(-30 * removed)

/* Painkillers */

/decl/reagent/perconol
	name = "Perconol"
	description = "Perconol is an advanced, analgesic medication which is highly effective at treating minor-mild pain, inflammation and high fevers. The drug is available over-the-counter for treating minor illnesses and mild pain. Perconol is not effective when inhaled."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	od_minimum_dose = 2
	scannable = TRUE
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM / 3 // Should be 0.06 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "sickness"
	metabolism_min = 0.005
	breathe_mul = 0

/decl/reagent/perconol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M))
		M.add_chemical_effect(CE_PAINKILLER, 35)
		M.add_up_to_chemical_effect(CE_NOFEVER, 5) //Good enough to handle fevers for a few light infections or one bad one.

/decl/reagent/perconol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M))
		M.add_chemical_effect(CE_PAINKILLER, 30)
		M.add_up_to_chemical_effect(CE_NOFEVER, 5) //Good enough to handle fevers for a few light infections or one bad one.

/decl/reagent/perconol/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	M.hallucination = max(M.hallucination, 25)

/decl/reagent/mortaphenyl
	name = "Mortaphenyl"
	description = "Mortaphenyl is an advanced, powerful analgesic medication which is highly effective at treating mild-severe pain as a result of severe, physical injury. Mortaphenyl is not effective when inhaled."
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = 15
	scannable = TRUE
	od_minimum_dose = 2
	metabolism = REM / 3.33 // 0.06ish units per tick
	ingest_met = REM / 2.3 // Should be 0.08 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "sourness"
	metabolism_min = 0.005
	breathe_mul = 0

/decl/reagent/mortaphenyl/initial_effect(var/mob/living/carbon/human/M, var/alien, var/holder)
	to_chat(M, SPAN_GOOD(pick("You lean back and begin to fall... and fall... and fall.", "A feeling of ecstasy builds within you.", "You're startled by just how amazing you suddenly feel.")))

/decl/reagent/mortaphenyl/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick("You feel soothed and at ease.", "You feel content and at peace.", "You feel a pleasant emptiness.", "You feel like sharing the wonderful memories and feelings you're experiencing.", "All your anxieties fade away.", "You feel like you're floating off the ground.", "You don't want this feeling to end.")))

	if(check_min_dose(M))
		M.add_chemical_effect(CE_PAINKILLER, 50)
		if(!M.chem_effects[CE_CLEARSIGHT])
			M.eye_blurry = max(M.eye_blurry, 5)
		if(!M.chem_effects[CE_STRAIGHTWALK])
			M.confused = max(M.confused, 10)

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/bac = H.get_blood_alcohol()
	if(bac >= 0.03)
		M.hallucination = max(M.hallucination, bac * 300)
		M.add_chemical_effect(CE_EMETIC, M.chem_doses[type]/6)
	if(bac >= 0.08)
		if(M.losebreath < 15)
			M.losebreath++

	if(REAGENT_VOLUME(M.reagents, /decl/reagent/oxycomorphine)) //Straight to overdose.
		overdose(M, alien, holder)

/decl/reagent/mortaphenyl/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	M.hallucination = max(M.hallucination, 40)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type]/6)
	if(M.losebreath < 15)
		M.losebreath++

/decl/reagent/mortaphenyl/aphrodite
	name = "Aphrodite"
	description = "Aphrodite is the name given to the chemical diona inject into organics soon after biting them. It serves a dual purpose of dulling the pain of the wound, and gathering deep-seated fragments of learned skills and memories, such as languages."
	color = "#a59153"
	overdose = 10
	scannable = TRUE
	fallback_specific_heat = 1
	taste_description = "euphoric acid"

/decl/reagent/mortaphenyl/aphrodite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 40)
	if(!M.chem_effects[CE_CLEARSIGHT])
		M.eye_blurry = max(M.eye_blurry, 3)
	if(!M.chem_effects[CE_STRAIGHTWALK])
		M.confused = max(M.confused, 6)

/decl/reagent/oxycomorphine
	name = "Oxycomorphine"
	description = "Oxycomorphine is a highly advanced, powerful analgesic medication which is extremely effective at treating severe-agonising pain as a result of injuries usually incompatible with life. The drug is highly addictive and sense-numbing. Oxycomorphine is not effective when inhaled."
	reagent_state = LIQUID
	color = "#800080"
	overdose = 10
	od_minimum_dose = 2
	scannable = TRUE
	metabolism = REM / 3.33 // 0.06ish units per tick
	ingest_met = REM / 1.5 // Should be 0.13 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "bitterness"
	metabolism_min = 0.005
	breathe_mul = 0

/decl/reagent/oxycomorphine/initial_effect(var/mob/living/carbon/human/M, var/alien, var/holder)
	to_chat(M, SPAN_GOOD(pick("You lean back and begin to fall... and fall... and fall.", "A feeling of ecstasy builds within you.", "You're startled by just how amazing you suddenly feel.")))

/decl/reagent/oxycomorphine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick("You feel soothed and at ease.", "You feel content and at peace.", "You feel a pleasant emptiness.", "You feel like sharing the wonderful memories and feelings you're experiencing.", "All your anxieties fade away.", "You feel like you're floating off the ground.", "You don't want this feeling to end.")))

	if(check_min_dose(M))
		M.add_chemical_effect(CE_PAINKILLER, 200)
		if(!M.chem_effects[CE_CLEARSIGHT])
			M.eye_blurry = max(M.eye_blurry, 5)
		if(!M.chem_effects[CE_STRAIGHTWALK])
			M.confused = max(M.confused, 20)

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/bac = H.get_blood_alcohol()
	if(bac >= 0.02)
		M.hallucination = max(M.hallucination, bac * 300)
		M.druggy = max(M.druggy, bac * 100)
		M.add_chemical_effect(CE_EMETIC, M.chem_doses[type]/6)
	if(bac >= 0.04)
		if(prob(3))
			to_chat(M, SPAN_WARNING(pick("You're having trouble breathing.", "You begin to feel a bit light headed.", "Your breathing is very shallow.", "")))
		if(M.losebreath < 15)
			M.losebreath++

/decl/reagent/oxycomorphine/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	M.druggy = max(M.druggy, 20)
	M.hallucination = max(M.hallucination, 60)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type]/6)
	if(M.losebreath < 15)
		M.losebreath++

/* Other medicine */

/decl/reagent/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is an advanced synaptic stimulant and nootropic which improves synaptic transmission and keeps one alert, giving it many clinical uses in the treatment of paralysis, weakness, narcolepsy and hallucinations. Synaptizine is difficult to metabolise and is hard on the liver."
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = 10
	od_minimum_dose = 1
	scannable = TRUE
	taste_description = "bitterness"
	metabolism_min = REM * 0.0125

/decl/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.drowsiness = max(M.drowsiness - 5, 0)
	if(REAGENT_VOLUME(holder, type) < 10) // Will prevent synaptizine interrupting a seizure caused by its own overdose.
		M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent(/decl/reagent/mindbreaker, 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.confused = max(M.confused - 10, 0)

/decl/reagent/synaptizine/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	if(.)
		M.add_chemical_effect(CE_CLEARSIGHT)
		M.add_chemical_effect(CE_STRAIGHTWALK)
		M.add_chemical_effect(CE_PAINKILLER, 30)
		M.add_chemical_effect(CE_HALLUCINATE, -1)
		M.add_up_to_chemical_effect(CE_ADRENALINE, 1)

/decl/reagent/synaptizine/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	if(prob(M.chem_doses[type] / 2))
		to_chat(M, SPAN_WARNING(pick("You feel a tingly sensation in your body.", "You can smell something unusual.", "You can taste something unusual.")))
	if(prob(M.chem_doses[type] / 3))
		if(prob(75))
			M.emote(pick("twitch", "shiver"))
		else
			M.seizure()

/decl/reagent/alkysine
	name = "Alkysine"
	description = "Alkysine is a complex drug which increases cerebral circulation, ensuring the brain does not become hypoxic and increasing the rate at which neurological function returns after a catastrophic injury."
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM //0.2u/tick
	overdose = 10
	scannable = TRUE
	taste_description = "bitterness"
	metabolism_min = REM * 0.075

/decl/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M, 2)) //Increased effectiveness & no side-effects if given via IV drip with low transfer rate.
		if(prob(M.chem_doses[type]))
			to_chat(M, SPAN_WARNING(pick("Everything is spinning!", "The room won't stop moving...", "You lose track of your thoughts.")))
		M.dizziness = max(125, M.dizziness)
		M.make_dizzy(5)
		if(!(REAGENT_VOLUME(holder, type) > 10)) //Prevents doubling up with overdose
			M.confused = max(M.confused, 10)
			M.slurring = max(M.slurring, 50)

/decl/reagent/alkysine/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(.)
		M.add_chemical_effect(CE_STRAIGHTWALK)
		if(REAGENT_VOLUME(holder, type) < 2) //Increased effectiveness & no side-effects if given via IV drip with low transfer rate.
			M.add_chemical_effect(CE_BRAIN_REGEN, 40) //1 unit of Alkysine fed via drip at a low transfer rate will raise activity by 10%.
		else
			M.add_chemical_effect(CE_BRAIN_REGEN, 30) //1 unit of Alkysine will raise brain activity by 7.5%.
			M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/reagent/alkysine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.hallucination = max(M.hallucination, 50)
	M.add_chemical_effect(CE_UNDEXTROUS)
	if(prob(M.chem_doses[type]))
		to_chat(M, SPAN_WARNING(pick("You lose motor control for a moment!", "Your body seizes up!")))
		M.paralysis = max(M.paralysis, 3 SECONDS)
	..()

/decl/reagent/oculine
	name = "Oculine"
	description = "Oculine is a complex organ-regenerative medication which increases the rate at which cells can differentiate into those required to recover damage to ocular tissues."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_mult = 0.33 //Specifically to cut the dull toxin taste out of foods using carrot
	taste_description = "dull toxin"

/decl/reagent/oculine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.eye_blurry = max(M.eye_blurry - 5 * removed, 0)
	M.eye_blind = max(M.eye_blind - 5 * removed, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)
		if(isvaurca(H))
			if(E.damage < E.min_broken_damage && H.sdisabilities & BLIND)
				H.sdisabilities -= BLIND

/decl/reagent/oculine/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(.)
		if(check_min_dose(M))
			M.add_chemical_effect(CE_CLEARSIGHT)

/decl/reagent/oculine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.hallucination = max(M.hallucination, 15)
	..()

/decl/reagent/peridaxon
	name = "Peridaxon"
	description = "Peridaxon is complex, broad-spectrum organ-regenerative medication which increases the rate at which cells can differentiate into organ cells to recover damaged organ tissues. The drug is hard on the body, leading to confusion and drowsiness."
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 10
	scannable = TRUE
	taste_description = "bitterness"

/decl/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.add_chemical_effect(CE_CLUMSY, 1)
		for(var/obj/item/organ/internal/I in H.internal_organs)
			if(I.organ_tag == BP_BRAIN)
				if(I.damage >= I.min_bruised_damage)
					continue
			if((I.damage > 0) && (I.robotic != 2)) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)

/decl/reagent/peridaxon/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.dizziness = max(150, M.dizziness)
	M.make_dizzy(5)
	if(prob(M.chem_doses[type] / 2))
		to_chat(M, SPAN_DANGER("You feel your insides twisting and burning."))
		M.adjustHalLoss(5)

/decl/reagent/ryetalyn
	name = "Ryetalyn"
	description = "Ryetalyn is a novel, highly advanced, broad-spectrum medication, developed by Dominian scientists, which has varying clinical uses in treating genetic abnormalities including certain cancers, autoimmune conditions, and Hulk Syndrome."
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE
	taste_description = "acid"
	metabolism = 1
	metabolism_min = 0.25

/decl/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

/decl/reagent/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a complex cardio-synaptic stimulant drug designed to increase the performance of the body. Downsides include violent muscle spasms and tremors."
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = 15
	var/datum/modifier = null
	taste_description = "acid"
	metabolism_min = REM * 0.025
	breathe_met = REM * 0.15 * 0.5

/decl/reagent/hyperzine/get_overdose(mob/living/carbon/M, location, datum/reagents/holder)
	if(REAGENT_VOLUME(M.reagents, /decl/reagent/adrenaline) > 5)
		return 10 //Volume of hyperzine required to OD reduced from 15u to 10u.
	. = ..()

/decl/reagent/hyperzine/get_od_min_dose(mob/living/carbon/M, location, datum/reagents/holder)
	if(REAGENT_VOLUME(M.reagents, /decl/reagent/adrenaline) > 5)
		return 0 // Takes effect instantly.
	. = od_minimum_dose

/decl/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
		to_chat(M, SPAN_GOOD(pick("You feel pumped!", "Energy, energy, energy - so much energy!", "You could run a marathon!", "You can't sit still!", "It's difficult to focus right now... but that's not important!")))
	if(check_min_dose(M, 0.5))
		M.add_chemical_effect(CE_SPEEDBOOST, 1)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/reagent/hyperzine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(5*removed)
	M.add_chemical_effect(CE_PULSE, 2)
	if(prob(5))
		to_chat(M, SPAN_DANGER(pick("Your heart is beating rapidly!", "Your chest hurts!", "You've totally over-exerted yourself!")))
	if(prob(M.chem_doses[type] / 3))
		M.visible_message("<b>[M]</b> twitches violently, grimacing.", "You twitch violently and feel yourself sprain a joint.")
		M.take_organ_damage(5 * removed, 0)
		M.adjustHalLoss(15)

/decl/reagent/hyperzine/Destroy()
	QDEL_NULL(modifier)
	return ..()

#define ETHYL_INTOX_COST	3 //The cost of power to remove one unit of intoxication from the patient
#define ETHYL_REAGENT_POWER	20 //The amount of power in one unit of ethyl

//Ethylredoxrazine will remove a number of units of alcoholic substances from the patient's blood and stomach, equal to its pow
//Once all alcohol in the body is neutralised, it will then cure intoxication and sober the patient up
/decl/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	description = "Ethylredoxrazine is a powerful medication which oxidises ethanol in the bloodstream, reducing the burden on the liver to complete this task. Ethylredoxrazine also blocks the reuptake of neurotransmitters responsible for symptoms of alcohol intoxication."
	reagent_state = SOLID
	color = "#605048"
	metabolism = REM * 0.3
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"

/decl/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/P = removed * ETHYL_REAGENT_POWER
	var/DP = M.chem_doses[type] * ETHYL_REAGENT_POWER//tiny optimisation

	//These status effects will now take a little while for the dose to build up and remove them
	M.dizziness = max(0, M.dizziness - DP)
	M.drowsiness = max(0, M.drowsiness - DP)
	M.stuttering = max(0, M.stuttering - DP)
	M.confused = max(0, M.confused - DP)

	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		for(var/_R in ingested.reagent_volumes)
			if(ispath(_R, /decl/reagent/alcohol))
				var/amount = min(P, REAGENT_VOLUME(ingested, _R))
				ingested.remove_reagent(_R, amount)
				P -= amount
				if (P <= 0)
					return

	//Even though alcohol is not supposed to be injected, ethyl removes it from the blood too,
	//as a treatment option if someone was dumb enough to do this
	if(M.bloodstr)
		for(var/_R in M.bloodstr.reagent_volumes)
			if(ispath(_R, /decl/reagent/alcohol))
				var/amount = min(P, REAGENT_VOLUME(M.bloodstr, _R))
				M.bloodstr.remove_reagent(_R, amount)
				P -= amount
				if (P <= 0)
					return

	if (M.intoxication && P > 0)
		var/amount = min(M.intoxication * ETHYL_INTOX_COST, P)
		M.intoxication = max(0, (M.intoxication - (amount / ETHYL_INTOX_COST)))
		P -= amount

/decl/reagent/ethylredoxrazine/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(.)
		if(check_min_dose(M))
			M.add_chemical_effect(CE_STRAIGHTWALK)

/decl/reagent/hyronalin
	name = "Hyronalin"
	description = "Hyronalin is a complex anti-radiation medication which specifically targets ionised cells, reducing their cell division rate to prevent their growth before gradually destroying these afflicted cells."
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"
	unaffected_species = IS_MACHINE
	var/last_taste_time = -10000

/decl/reagent/hyronalin/initialize_data(newdata)
	LAZYSET(newdata, "last_taste_time", 0)
	return newdata

/decl/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.is_diona())
		if(holder.reagent_data[type]["last_taste_time"] + 950 < world.time) // Not to spam message
			to_chat(M, SPAN_DANGER("Your body withers as you feel a searing pain throughout."))
			holder.reagent_data[type]["last_taste_time"] = world.time
		//metabolism = REM * 0.22
		M.adjustToxLoss(45 * removed * (0.22/0.25)) // Multiplier is to replace the above line
	else
		M.apply_radiation(-30 * removed)

/decl/reagent/hyronalin/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0) //Hyronaline OD deals brute damage to the same degree as Arithrazine

/decl/reagent/arithrazine
	name = "Arithrazine"
	description = "Arithrazine is a recent improvement of Hyronalin, rapidly destroying any ionised cells, though this often leads to collateral cell damage, resulting in contusions across affected parts of the body."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"
	unaffected_species = IS_MACHINE

/decl/reagent/arithrazine/initialize_data(newdata)
	var/list/data = newdata
	LAZYSET(data, "last_taste_time", 0)
	return data

/decl/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.is_diona())
		if(holder.reagent_data[type]["last_taste_time"] + 950 < world.time) // Not to spam message
			to_chat(M, SPAN_DANGER("Your body withers as you feel a searing pain throughout."))
			holder.reagent_data[type]["last_taste_time"] = world.time
		//metabolism = REM * 0.195
		M.adjustToxLoss(115 * removed * (0.195/0.25)) // Multiplier is to replace the above line
	else
		M.apply_radiation(-70 * removed)
		M.add_chemical_effect(CE_ITCH, M.chem_doses[type]/2)
		if(prob(60))
			M.take_organ_damage(4 * removed, 0)

/decl/reagent/arithrazine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(50))
		M.take_organ_damage(6 * removed, 0) //Even more collateral damage dealt by arithrazine when overdosed.

/decl/reagent/thetamycin
	name = "Thetamycin"
	description = "Thetamycin is a complex, broad-spectrum antibiotic developed to treat wound infections, organ infections, and septicaemia, even those caused by superbugs with high anti-bacterial resistances."
	reagent_state = LIQUID
	color = "#41C141"
	od_minimum_dose = 1
	metabolism = 0.03
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitter gauze soaked in rubbing alcohol"
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/decl/reagent/thetamycin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_ANTIBIOTIC, M.chem_doses[type]) // strength of antibiotics; amount absorbed, need >5u dose to begin to be effective which'll take ~5 minutes to metabolise. need >10u dose if administered orally.

/decl/reagent/thetamycin/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type]/8) // chance per 2 second tick to cause vomiting
	M.dizziness = max(150, M.dizziness)
	M.make_dizzy(5)

/decl/reagent/steramycin
	name = "Steramycin"
	description = "A preventative antibiotic that will stop small infections from growing, but only if administered early. Has no effect on internal organs, wounds, or if the infection has grown beyond its early stages."
	reagent_state = LIQUID
	color = "#81b38b"
	od_minimum_dose = 1
	overdose = 15
	scannable = TRUE
	taste_description = "bleach"
	fallback_specific_heat = 0.605

/decl/reagent/steramycin/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M, 1))
		for(var/obj/item/organ/external/E in M.organs)
			if(E.germ_level >= INFECTION_LEVEL_ONE || !E.germ_level) //No effect if it's not infected or the infection has progressed.
				continue
			E.germ_level = max(E.germ_level - 4, 0)

/decl/reagent/steramycin/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.dizziness = max(150, M.dizziness)
	M.make_dizzy(5)
	M.adjustToxLoss(1) //Antibodies start fighting your body

/decl/reagent/asinodryl
	name = "Asinodryl"
	description = "Asinodryl is an anti-emetic medication which acts by preventing the two regions in the brain responsible for vomiting from controlling the act of emesis."
	color = "#f5f2d0"
	taste_description = "bitterness"
	scannable = TRUE
	metabolism = REM * 0.25
	fallback_specific_heat = 1

/decl/reagent/asinodryl/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_ANTIEMETIC, M.chem_doses[type]/4) // 1u should suppress 2u thetamycin

/decl/reagent/coughsyrup
	name = "Cough Syrup"
	description = "A complex antitussive medication available OTC which is very effective at suppressing cough reflexes. The medication also acts as a very weak analgesic medication, leading to it being a very cheap recreational drug or precursor to other recreational drugs."
	scannable = TRUE
	reagent_state = LIQUID
	taste_description = "bitterness"
	color = "#402060"
	fallback_specific_heat = 0.605 // assuming it's ethanol-based
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow

	glass_name = "glass of cough syrup"
	glass_desc = "You'd better not."

/decl/reagent/coughsyrup/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(M))
		M.add_chemical_effect(CE_PAINKILLER, 5) // very slight painkiller effect at low doses

/decl/reagent/coughsyrup/overdose(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder) // effects based loosely on DXM
	M.hallucination = max(M.hallucination, 40)
	M.add_chemical_effect(CE_PAINKILLER, 20) // stronger at higher doses
	if(prob(M.chem_doses[type]))
		M.vomit()
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	if(prob(7))
		M.add_chemical_effect(CE_NEUROTOXIC, 5)
	if(prob(50))
		M.drowsiness = max(M.drowsiness, 3)

/decl/reagent/cetahydramine
	name = "Cetahydramine"
	description = "Cetahydramine is a complex antihistamine medication available OTC which blocks the release of histamine, thus making it effective at suppressing allergies and sneezing. Cetahydramine can cause drowsiness in larger doses, making it an effective sleep aid."
	scannable = TRUE
	reagent_state = LIQUID
	taste_description = "bitterness"
	metabolism = REM * 0.05 // only performs its effects while in blood
	ingest_met = REM // .2 units per tick
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	ingest_mul = 1
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/decl/reagent/cetahydramine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_NOITCH, M.chem_doses[type] * 2) // 5 units of cetahydramine will counter 10 units of dermaline/butazoline itching.
	if(prob(M.chem_doses[type]/2))
		M.drowsiness += 2

/decl/reagent/sterilizine
	name = "Sterilizine"
	description = "Sterilizine is a chemical product composed of bleach and anti-toxins which can thoroughly disinfect wound sites and any biohazardous waste."
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5
	taste_description = "burning bleach"
	germ_adjust = 20

/decl/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/obj/item/organ/external/E in H.organs)//For each external bodypart
			for (var/datum/wound/W in E.wounds)//We check each wound on that bodypart
				W.germ_level -= min(removed*germ_adjust, W.germ_level)//Clean the wound a bit. Note we only clean wounds on the part, not the part itself.
				if (W.germ_level <= 0)
					W.disinfected = 1//The wound becomes disinfected if fully cleaned

/decl/reagent/sterilizine/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	O.germ_level -= min(amount*20, O.germ_level)
	O.was_bloodied = null

/decl/reagent/sterilizine/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	T.germ_level -= min(amount*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/decl/reagent/sterilizine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "All you can taste is blood!", "Your insides are on fire!", "Your feel a burning pain in your gut!")))
	else
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat stings a bit.", "You can taste something chemical.")))

/decl/reagent/sterilizine/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "All you can taste is blood!", "Your insides are on fire!", "Your feel a burning pain in your gut!")))
	else
		if(prob(5))
			to_chat(M, SPAN_NOTICE(pick("You get a strong whiff of sterilizine fumes - careful.")))

/decl/reagent/sterilizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 15)
		M.add_chemical_effect(CE_EMETIC, 5)
		if(prob(25))
			M.add_chemical_effect(CE_NEPHROTOXIC, 1)

/decl/reagent/leporazine
	name = "Leporazine"
	description = "Leporazine is a complex medication which improves thermal homeostasis, stabilising and regulating the body's core temperature. Leporazine often results in hyperventilation which should be monitored."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"

/decl/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!check_min_dose(M))
		return
	M.add_up_to_chemical_effect(CE_NOFEVER, 5) //Also handles the effects of fevers
	if(!(REAGENT_VOLUME(holder, type) > 20))
		if(M.bodytemperature > 310)
			M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
		else if(M.bodytemperature < 311)
			M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/reagent/leporazine/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.bodytemperature = max(M.bodytemperature - 2 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(2))
		M.emote("shiver")
	if(prob(2))
		to_chat(M, SPAN_WARNING("You feel very cold..."))

/decl/reagent/inacusiate
	name = "Inacusiate"
	description = ""
	reagent_state = LIQUID
	color = "#D2B48C"
	overdose = 10
	scannable = TRUE
	metabolism = REM * 1
	taste_description = "a roll of gauze"

/decl/reagent/inacusiate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustEarDamage(-0.6, -0.6, FALSE)

/decl/reagent/inacusiate/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/obj/item/organ/external/E = M.organs_by_name[BP_HEAD]
	M.custom_pain("Your head hurts a ton!", 70, FALSE, E, 1)

/* mental */

#define MEDICATION_MESSAGE_DELAY 10 MINUTES

/decl/reagent/mental
	name = null //Just like alcohol
	description = "Some nameless, experimental antidepressant that you should obviously not have your hands on."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolism = 0.001 * REM
	metabolism_min = 0
	scannable = TRUE
	overdose = REAGENTS_OVERDOSE
	od_minimum_dose = 0.02
	taste_description = "bugs"
	ingest_mul = 1
	var/alchohol_affected = 1
	var/messagedelay = MEDICATION_MESSAGE_DELAY
	var/list/goodmessage = list() //Fluff messages

	fallback_specific_heat = 1.5

/decl/reagent/mental/initialize_data(newdata, datum/reagents/holder)
	var/data = newdata
	LAZYSET(data, "last_tick_time", world.time + (messagedelay / 2)) //Small startup delay
	return data

/decl/reagent/mental/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(H) || world.time < holder.reagent_data[type]["last_tick_time"] || messagedelay == -1)
		return

	var/bac = H.get_blood_alcohol()
	if(alchohol_affected && bac > 0.03)
		H.hallucination = max(H.hallucination, bac * 400)

	if(H.chem_doses[type] < overdose && H.shock_stage < 5) //Don't want feel-good messages when we're suffering an OD or particularly hurt/injured
		to_chat(H, SPAN_GOOD("[pick(goodmessage)]"))

	LAZYINITLIST(holder.reagent_data)
	LAZYSET(holder.reagent_data[type], "last_tick_time", world.time + (messagedelay))

/decl/reagent/mental/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type] / 6)

/decl/reagent/mental/nicotine
	name = "Nicotine"
	description = "Nicotine is an ancient stimulant and relaxant commonly found in tobacco products. It is very poisonous, unless at very low doses."
	reagent_state = LIQUID
	color = "#333333"
	metabolism = 0.0016 * REM
	overdose = 15
	od_minimum_dose = 3
	taste_description = "bitterness"
	messagedelay = MEDICATION_MESSAGE_DELAY * 0.75
	goodmessage = list("You feel good.","You feel relaxed.","You feel alert and focused.")

/decl/reagent/mental/nicotine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/scale, var/datum/reagents/holder)
	. = ..()
	M.adjustOxyLoss(10 * removed * scale)
	M.add_chemical_effect(CE_PULSE, 0.5)

/decl/reagent/mental/corophenidate
	name = "Corophenidate"
	description = "Corophenidate is a new generation, psychoactive stimulant used in the treatment of ADHD and ADD. It has far fewer side effects than previous generations of CNS stimulants. Withdrawal symptoms include hallucinations and disruption of focus."
	reagent_state = LIQUID
	color = "#8888AA"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	taste_description = "paper"
	goodmessage = list("You feel focused.","You feel like you have no distractions.","You feel willing to work.")

/decl/reagent/mental/corophenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_HALLUCINATE, -1)
	..()

/decl/reagent/mental/neurostabin
	name = "Neurostabin"
	description = "Neurostabin is a new generation, psychoactive drug used in the treatment of psychoses, and also has clinical significance in treating muscle weakness. It has far fewer side effects than previous generations of psychoactive drugs. Withdrawal symptoms include hallucinations and the development of phobias."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	taste_description = "bitterness"
	goodmessage = list("You do not feel the need to worry about simple things.","You feel calm and level-headed.","You feel fine.")

/decl/reagent/mental/parvosil
	name = "Parvosil"
	description = "Parvosil is a new generation, psychoactive drug used in the treatment of anxiety disorders such as phobias and social anxiety. It has far fewer side effects than previous generations of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#88AA88"
	metabolism = 0.02 * REM
	od_minimum_dose = 0.4
	taste_description = "paper"
	goodmessage = list("You feel fine.","You feel rational.","You feel secure.")

/decl/reagent/mental/minaphobin
	name = "Minaphobin"
	description = "Minaphobin is a new generation, psychoactive drug used in the treatment of anxiety disorders such as phobias and social anxiety. It has far fewer side effects than previous generations of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#FF8888"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	taste_description = "duct tape"
	goodmessage = list("You feel relaxed.","You feel at ease.","You feel carefree.")

/decl/reagent/mental/emoxanyl
	name = "Emoxanyl"
	description = "Emoxanyl is a novel, psychoactive medication which increases cerebral circulation and is used to treat anxiety, depression, concussion, and epilepsy. It has fewer side effects than many other forms of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#88FFFF"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	taste_description = "scotch tape"
	goodmessage = list("You feel at ease.","Your mind feels great.", "You feel centered.")
	messagedelay = MEDICATION_MESSAGE_DELAY * 0.75

/decl/reagent/mental/orastabin
	name = "Orastabin"
	description = "Orastabin is a new generation, complex psychoactive medication used in the treatment of anxiety disorders and speech impediments. It has fewer side effects than many other forms of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#FF88FF"
	metabolism = 0.005 * REM
	od_minimum_dose = 0.2
	taste_description = "glue"
	goodmessage = list("You feel at ease.","You feel like you can speak with confidence.","You feel unafraid to speak.")
	messagedelay = MEDICATION_MESSAGE_DELAY * 0.75

/decl/reagent/mental/orastabin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_NOSTUTTER, 2)
	..()

/decl/reagent/mental/neurapan
	name = "Neurapan"
	description = "Neurapan is a groundbreaking, expensive antipsychotic medication capable of treating a whole spectrum of mental illnesses, including psychoses, anxiety disorders, Tourette Syndrome and depression, and can alleviate symptoms of stress. Neurapan can be addictive due to its tranquilising effects, and withdrawal symptoms are dangerous."
	reagent_state = LIQUID
	color = "#FF4444"
	overdose = 10
	metabolism = 0.02 * REM
	od_minimum_dose = 0.4
	taste_description = "tranquility"
	goodmessage = list("Your mind feels as one.","You feel incredibly comfortable.","Your body feels good.","Your thoughts are clear.", "You feel stress free.", "Nothing is bothering you anymore.")
	messagedelay = MEDICATION_MESSAGE_DELAY * 0.5

/decl/reagent/mental/neurapan/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_HALLUCINATE, -2)
	M.add_chemical_effect(CE_NOSTUTTER, 1)
	..()

/decl/reagent/mental/neurapan/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PACIFIED, 1)
	M.eye_blurry = max(M.eye_blurry, 30)
	if(prob(3))
		to_chat(M, SPAN_GOOD(pick("Stress was an inconvenience that you are now free of.", "You feel somewhat dettached from reality.", "You can feel time passing by and it no longer bothers you.")))

/decl/reagent/mental/nerospectan
	name = "Nerospectan"
	description = "Nerospectan is an expensive, new generation anti-psychotic medication capable of treating a whole spectrum of mental illnesses, including psychoses, anxiety disorders, Tourette Syndrome and depression, and can alleviate symptoms of stress. Nerospectan can be addictive due to its tranquilising effects, and withdrawal symptoms are dangerous."
	reagent_state = LIQUID
	color = "#FF8844"
	metabolism = 0.02 * REM
	od_minimum_dose = 0.4
	taste_description = "paint"
	goodmessage = list("Your mind feels as one.","You feel comfortable speaking.","Your body feels good.","Your thoughts are pure.","Your body feels responsive.","You can handle being alone.")
	messagedelay = MEDICATION_MESSAGE_DELAY * 0.5

/decl/reagent/mental/nerospectan/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_HALLUCINATE, -2)
	M.add_chemical_effect(CE_NOSTUTTER, 1)
	..()

/decl/reagent/mental/nerospectan/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type] / 6)

/decl/reagent/mental/truthserum
	name = "Truth Serum"
	description = "Truth Serum is an expensive and very unethical psychoactive drug capable of inhibiting defensive measures and reasoning in regards to communication, resulting in those under the effects of the drug to be very open to telling the truth."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.05 * REM
	od_minimum_dose = 1
	taste_description = "something"
	goodmessage = list("You feel like you have nothing to hide.","You feel compelled to spill your secrets.","You feel like you can trust those around you.")
	messagedelay = 30
	ingest_mul = 1

/decl/reagent/mental/truthserum/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PACIFIED, 1)

/decl/reagent/mental/kokoreed
	name = "Koko Reed Juice"
	description = "Juice from the Koko reed plant. Causes unique mental effects in Unathi."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = 0.0016 * REM
	overdose = 5
	od_minimum_dose = 3
	taste_description = "sugar"
	goodmessage = list("You feel pleasantly warm.","You feel like you've been basking in the sun.","You feel focused and warm...")

/decl/reagent/mental/kokoreed/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/reagent/mental/kokoreed/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/scale, var/datum/reagents/holder)
	. = ..()
	if(isunathi(M))
		M.add_up_to_chemical_effect(CE_SPEEDBOOST, 1)

/decl/reagent/cataleptinol
	name = "Cataleptinol"
	description = "Cataleptinol is a highly advanced, expensive medication capable of regenerating the most damaged of brain tissues. Cataleptinol is used in the treatment of dumbness, cerebral blindness, cerebral paralysis and aphasia. The drug is more effective when the patient's core temperature is below 170K."
	reagent_state = LIQUID
	color = "#FFFF00"
	metabolism = REM //0.2u/tick
	overdose = 15
	scannable = TRUE
	taste_description = "bitterness"
	metabolism_min = REM * 0.25


/decl/reagent/cataleptinol/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.dizziness = max(100, M.dizziness)
	M.make_dizzy(5)
	var/chance = M.chem_doses[type]*removed
	if(M.bodytemperature < 170)
		chance = (chance*4) + 5
		M.add_chemical_effect(CE_BRAIN_REGEN, 30) //1 unit of cryo-tube Cataleptinol will raise brain activity by 10%.
	else
		M.add_chemical_effect(CE_BRAIN_REGEN, 20) //1 unit of Cataleptinol will raise brain activity by 5%.


/decl/reagent/cataleptinol/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.hallucination = max(M.hallucination, 15)
	if(prob(5))
		to_chat(M, SPAN_WARNING(pick("You have a painful headache!", "You feel a throbbing pain behind your eyes!")))
	..()


/decl/reagent/fluvectionem
	name = "Fluvectionem"
	description = "Fluvectionem is a complex anti-toxin medication that is capable of purging the bloodstream of toxic reagents. The drug is capable of neutralising the most difficult of compounds and acts very fast, however it is inefficient and results in benign waste products that can be damaging to the liver."
	color = "#222244"
	metabolism = 0.5 * REM
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "thick salt"
	reagent_state = SOLID

/decl/reagent/fluvectionem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/is_overdosed = is_overdosing(M, holder = holder)
	if(is_overdosed)
		removed *= 2

	var/amount_to_purge = removed*4 //Every unit removes 4 units of other chemicals
	var/amount_purged = 0

	for(var/_selected in M.reagents.reagent_volumes)
		var/decl/reagent/selected = decls_repository.get_decl(_selected)
		if(_selected == type)
			continue
		if(_selected == /decl/reagent/blood && !is_overdosed)
			continue
		var/local_amount = min(amount_to_purge, REAGENT_VOLUME(M.reagents, _selected))
		M.reagents.remove_reagent(selected.type, local_amount)
		amount_to_purge -= local_amount
		amount_purged += local_amount
		if(amount_to_purge <= 0)
			break

	M.adjustToxLoss(removed + amount_purged*0.5) //15u has the potential to do 15 + 30 toxin damage in 30 seconds

	. = ..()

/decl/reagent/pulmodeiectionem
	name = "Pulmodeiectionem"
	description = "Pulmodeiectionem is a complex anti-toxin medication that is capable of purging the lungs of toxic reagents by damaging the mucous lining of the bronchi and trachea, allowing particulate to be coughed out of the lungs. Pulmodeiectionem works only when inhaled and can cause long-term damage to the lungs."
	color = "#550055"
	metabolism = 2 * REM
	overdose = 10
	scannable = TRUE
	taste_description = "coarse dust"
	reagent_state = SOLID

/decl/reagent/pulmodeiectionem/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(H))
		var/obj/item/organ/L = H.internal_organs_by_name[BP_LUNGS]
		if(istype(L) && !L.robotic && !L.is_broken())
			var/amount_to_purge = removed*5 //Every unit removes 5 units of other chemicals.
			for(var/_selected in H.breathing.reagent_volumes)
				var/decl/reagent/selected = decls_repository.get_decl(_selected)
				if(selected == src)
					continue
				var/local_amount = min(amount_to_purge, REAGENT_VOLUME(H.breathing, _selected))
				H.breathing.remove_reagent(_selected, local_amount)
				amount_to_purge -= local_amount
				if(amount_to_purge <= 0)
					break

			H.adjustOxyLoss(2*removed) //Every unit deals 2 oxy damage
			if(prob(50)) //Cough uncontrolably.
				H.emote("cough")
				H.add_chemical_effect(CE_PNEUMOTOXIC, 0.2*removed)
	. = ..()

/decl/reagent/pulmodeiectionem/affect_ingest(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(H, 5))
		if(prob(50))
			H.visible_message("<b>[H]</b> splutters, coughing up a cloud of purple dust.", "You cough up a cloud of purple dust.")
			remove_self(10, holder)
		else
			H.adjustOxyLoss(2)
			H.add_chemical_effect(CE_PNEUMOTOXIC, 0.1)

/decl/reagent/pulmodeiectionem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(2 * removed)
	M.add_chemical_effect(CE_ITCH, M.chem_doses[type])

/decl/reagent/pneumalin
	name = "Pneumalin"
	description = "Pneumalin is a powerful, organ-regenerative medication that increases the rate at which lung tissues are regenerated. Pneumalin only works when inhaled, and overdosing can lead to severe bradycardia."
	color = "#8154b4"
	overdose = 15
	scannable = TRUE
	taste_description = "fine dust"
	reagent_state = SOLID

/decl/reagent/pneumalin/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	H.adjustOxyLoss(removed) //Every unit heals 1 oxy damage
	H.add_chemical_effect(CE_PNEUMOTOXIC, -removed * 1.5)
	H.add_chemical_effect(CE_PULSE, -1)

	var/obj/item/organ/internal/lungs/L = H.internal_organs_by_name[BP_LUNGS]
	if(istype(L) && !BP_IS_ROBOTIC(L))
		L.rescued = FALSE
		L.damage = max(L.damage - (removed * 1.5), 0)

	. = ..()

/decl/reagent/pneumalin/overdose(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	H.add_chemical_effect(CE_PULSE, -H.chem_doses[type] * 0.33)

/decl/reagent/rezadone
	name = "Rezadone"
	description = "Rezadone is an extremely expensive, ground-breaking miracle drug. The compound is capable of treating all kinds of physical damage, disfiguration, as well as genetic damage. Excessive consumption of rezadone can lead to severe disorientation."
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "sickness"

/decl/reagent/rezadone/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(.)
		M.add_chemical_effect(CE_ORGANREPAIR, 1)
		M.add_chemical_effect(CE_BLOODRESTORE, 15)

/decl/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-1 * removed)
	if(M.is_asystole() && prob(20))
		M.resuscitate()
	if(M.chem_doses[type] > 3)
		M.status_flags &= ~DISFIGURED
	if(M.chem_doses[type] > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/decl/reagent/sanasomnum
	name = "Sanasomnum"
	description = "Not strictly a drug, Sanasomnum is actually a cocktail of biomechanical stem cells, which induce a regenerative state of unconsciousness capable healing almost any injury in minutes - however, usage nearly guarantees long-term and irreversible complications, and it is banned from medical use throughout the spur."
	reagent_state = SOLID
	color = "#b2db5e"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "blood"
	specific_heat = 1

/decl/reagent/sanasomnum/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	if(.)
		M.add_chemical_effect(CE_ORGANREPAIR, 20)
		M.add_chemical_effect(CE_BLOODRESTORE, 15)
		M.add_chemical_effect(CE_BLOODCLOT, 15)
		M.add_chemical_effect(CE_BRAIN_REGEN, 20)
		M.add_chemical_effect(CE_OXYGENATED, 15)
		M.add_chemical_effect(CE_ANTITOXIN, 15)
		M.add_chemical_effect(CE_ANTIBIOTIC, 15)
		M.add_chemical_effect(CE_STABLE, 15)
		M.add_chemical_effect(CE_UNDEXTROUS, 30)
		M.add_chemical_effect(CE_CLUMSY, 30)

/decl/reagent/sanasomnum/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	if(M.is_asystole() && prob(20))
		M.resuscitate()
	if(M.chem_doses[type] > 3)
		M.status_flags &= ~DISFIGURED
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return
	if (!(CE_UNDEXTROUS in M.chem_effects))
		to_chat(M, SPAN_WARNING("Your limbs start to feel numb and weak, and your legs wobble as it becomes hard to stand..."))
		M.confused = max(M.confused, 250)
		M.eye_blurry = max(M.eye_blurry, 250)
	if(M.chem_doses[type] > 0.2)
		M.Weaken(10)
	if(M.chem_doses[type] > 5)
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(10))
				E.status &= ~ORGAN_ARTERY_CUT
	if(M.chem_doses[type] > 5)
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_BROKEN && prob(10))
				E.status &= ~ORGAN_BROKEN
	if(M.chem_doses[type] > 5)
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & TENDON_CUT && prob(10))
				E.status &= ~TENDON_CUT

/decl/reagent/verunol
	name = "Verunol Syrup"
	description = "A complex emetic medication that causes the patient to vomit due to gastric irritation and the stimulating of the vomit centres of the brain."
	reagent_state = LIQUID
	color = "#280f0b"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "sweet syrup"

/decl/reagent/verunol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if (prob(10+M.chem_doses[type]))
		to_chat(M, pick("You feel nauseous!", "Your stomach churns uncomfortably.", "You feel like you're about to throw up.", "You feel queasy.", "You feel bile in your throat."))

	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type])

/decl/reagent/verunol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(2 * removed) //If you inject it you're doing it wrong

/decl/reagent/azoth
	name = "Azoth"
	description = "Azoth is a miraculous medicine, capable of healing internal injuries."
	reagent_state = LIQUID
	color = "#BF0000"
	taste_description = "bitter metal"
	overdose = 5
	fallback_specific_heat = 1.2

/decl/reagent/azoth/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/A in H.organs)
			var/obj/item/organ/external/E = A
			if((E.tendon_status() & TENDON_CUT) && E.tendon.can_recover())
				E.tendon.rejuvenate()
				return 1

			if(E.status & ORGAN_ARTERY_CUT)
				E.status &= ~ORGAN_ARTERY_CUT
				return 1

			if(E.status & ORGAN_BROKEN)
				E.status &= ~ORGAN_BROKEN
				E.stage = 0
				return 1

/decl/reagent/azoth/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.adjustBruteLoss(5)

/decl/reagent/adipemcina
	name = "Adipemcina"
	description = "Adipemcina is a complex, organ-regenerative medication that increases the rate at which cells differentiate into myocardial cells. Adipemcina overdoses result in severe liver damage and vomiting."
	reagent_state = LIQUID
	color = "#008000"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"

/decl/reagent/adipemcina/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_CARDIOTOXIC, -removed*2)
	var/obj/item/organ/internal/heart/H = M.internal_organs_by_name[BP_HEART]
	if(istype(H) && !BP_IS_ROBOTIC(H))
		H.damage = max(H.damage - (removed * 2), 0)
	..()

/decl/reagent/adipemcina/overdose(var/mob/living/carbon/human/M, var/alien, var/datum/reagents/holder)
	M.add_chemical_effect(CE_EMETIC, M.chem_doses[type] / 6)
	if(istype(M))
		if(prob(25))
			M.add_chemical_effect(CE_HEPATOTOXIC, 1)

/decl/reagent/saline
	name = "Saline Plus"
	description = "Saline Plus is an expensive improvement upon the various saline solutions of old. Saline Plus has wide clinical applications in the treatment of dehydration and hypovolaemia, with no more debates as to whether it is effective or not."
	reagent_state = LIQUID
	scannable = TRUE
	metabolism = 1.5
	overdose = 5 // Low overdose and fast metabolism to necessitate IV drip usage
	od_minimum_dose = 10
	color = "#0064C877"
	taste_description = "premium salty water"
	unaffected_species = IS_MACHINE
	ingest_mul = 0
	breathe_mul = 0

/decl/reagent/saline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if((M.hydration > M.max_hydration) > CREW_HYDRATION_OVERHYDRATED)
		M.adjustHydrationLoss(-removed*2)
	else
		M.adjustHydrationLoss(-removed*5)
	if(REAGENT_VOLUME(holder, type) < 3)
		M.add_chemical_effect(CE_BLOODRESTORE, 2 * removed)

/decl/reagent/saline/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	M.confused = max(M.confused, 20)
	M.make_jittery(5)
	if(prob(2))
		M.emote("twitch")
	if(prob(2))
		to_chat(M, SPAN_WARNING(pick("You're beginning to lose your appetite.","Your mouth is so incredibly dry.","You feel really confused.","What was I just thinking of?","Where am I?","Your muscles are tingling.")))

/decl/reagent/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	fallback_specific_heat = 1
	reagent_state = LIQUID
	color = "#c8a5dc"
	scannable = TRUE
	overdose = 20
	metabolism = 0.1
	value = 2
	breathe_mul = 0
	ingest_mul = 0

/decl/reagent/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		return
	if(M.chem_doses[type] < 0.2)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(15*REAGENT_VOLUME(holder, type), 35))
		M.add_chemical_effect(CE_PULSE, 1)
	else if(M.chem_doses[type] < 1)
		M.add_chemical_effect(CE_PAINKILLER, min(10*REAGENT_VOLUME(holder, type), 15))
		M.add_chemical_effect(CE_PULSE, 2)
	if(M.chem_doses[type] > 10)
		M.make_jittery(5)
	if(REAGENT_VOLUME(holder, type) >= 5 && M.is_asystole())
		remove_self(5, holder)
		if(M.resuscitate())
			var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
			M.add_chemical_effect(CE_CARDIOTOXIC, heart.max_damage * 0.05)

//Secret Chems
/decl/reagent/elixir
	name = "Elixir of Life"
	description = "A mythical substance, the cure for the ultimate illness."
	color = "#ffd700"
	affects_dead = 1
	taste_description = "eternal blissfulness"
	fallback_specific_heat = 2

/decl/reagent/elixir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		if(M && M.stat == DEAD)
			M.adjustOxyLoss(-rand(15,20))
			M.visible_message(SPAN_DANGER("\The [M] shudders violently!"))
			M.stat = 0

/decl/reagent/pacifier
	name = "Paxazide"
	description = "Paxazide is an expensive and unethical, psychoactive drug used to pacify people, suppressing regions of the brain responsible for anger and violence. Paxazide can be addictive due to its tranquilising effects, though withdrawal symptoms are scarce."
	reagent_state = LIQUID
	color = "#1ca9c9"
	overdose = REAGENTS_OVERDOSE
	taste_description = "numbness"

/decl/reagent/pacifier/affect_blood(var/mob/living/carbon/H, var/alien, var/removed, var/datum/reagents/holder)
	if(check_min_dose(H))
		H.add_chemical_effect(CE_PACIFIED, 1)

/decl/reagent/pacifier/overdose(var/mob/living/carbon/H, var/alien, var/datum/reagents/holder)
	H.add_chemical_effect(CE_EMETIC, H.chem_doses[type] / 6)

/decl/reagent/rmt
	name = "Regenerative-Muscular Tissue Supplements"
	description = "RMT Supplement is a bioengineered, fast-acting growth factor that specifically helps recover bone and muscle mass caused by prolonged zero-gravity adaptations. It can also be used to treat chronic muscle weakness."
	reagent_state = LIQUID
	scannable = TRUE
	color = "#AA8866"
	overdose = 30
	metabolism = 0.1 * REM
	taste_description = "sourness"
	fallback_specific_heat = 1

/decl/reagent/rmt/overdose(var/mob/living/carbon/H, var/alien, var/datum/reagents/holder)
	if(prob(2))
		to_chat(H, SPAN_WARNING(pick("Your muscles are stinging a bit.", "Your muscles ache.")))

/decl/reagent/coagzolug
	name = "Coagzolug"
	description = "A medicine that was stumbled upon by accident, coagzolug encourages blood to clot and slow down bleeding. An overdose causes dangerous blood clots capable of harming the heart."
	reagent_state = LIQUID
	scannable = TRUE
	color = "#bd5eb5"
	overdose = 10
	metabolism = REM / 3.33
	taste_description = "throat-clenching sourness"
	fallback_specific_heat = 1

/decl/reagent/coagzolug/affect_blood(mob/living/carbon/M, alien, removed)
	. = ..()
	if(check_min_dose(M, 0.5))
		M.add_chemical_effect(CE_BLOODCLOT)
		M.make_dizzy(5)

/decl/reagent/coagzolug/overdose(var/mob/living/carbon/H, var/alien)
	if(prob(2))
		to_chat(H, SPAN_WARNING(pick("You feel a clot shoot through your heart!", "Your veins feel like they're being shredded!")))
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		heart.take_internal_damage(1, TRUE)

/decl/reagent/mental/vkrexi
	name = "V'krexi taffy"
	description = "V'krexi meat, processed to become a chewy, sticky candy."
	reagent_state = SOLID
	scannable = TRUE
	color = "#d6ec57"
	metabolism = 0.4 * REM
	taste_description = "bittersweetness, insect meat and regret"
	metabolism_min = 0.5
	breathe_mul = 0
	goodmessage = list("You feel strange, in a good way.")
