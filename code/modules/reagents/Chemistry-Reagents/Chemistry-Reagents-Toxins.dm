/* Toxins, poisons, venoms */

/singleton/reagent/toxin
	name = "Toxin"
	description = "A toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolism = REM * 0.1 // 0.02 by default. They last a while and slowly kill you.
	taste_description = "bitterness"
	taste_mult = 1.2
	fallback_specific_heat = 0.75
	overdose = 10

	var/target_organ // needs to be null by default
	var/strength = 2 // How much damage it deals per unit

/singleton/reagent/toxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(strength && alien != IS_DIONA)
		var/dam = (strength * removed)
		if(HAS_TRAIT(M, TRAIT_ORIGIN_TOX_RESISTANCE))
			dam = max(dam - 1, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(target_organ)
				var/obj/item/organ/internal/I = H.internal_organs_by_name[target_organ]
				if(I)
					var/can_damage = I.max_damage - I.damage
					if(can_damage > 0)
						if(dam > can_damage)
							I.take_internal_damage(can_damage, silent=TRUE)
							dam -= can_damage
						else
							I.take_internal_damage(dam, silent=TRUE)
							dam = 0
			for(var/organ in H.organs)
				var/obj/item/organ/external/O = organ
				var/obj/effect/spider/eggcluster/C = locate() in O
				if(C)
					C.take_damage(removed * 2)
		if(dam)
			M.adjustToxLoss(target_organ ? (dam * 0.5) : dam)
			M.add_chemical_effect(CE_TOXIN, removed * strength)

/singleton/reagent/toxin/plasticide
	name = "Plasticide"
	description = "Liquid plastic, do not eat."
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 5
	taste_description = "plastic"

/singleton/reagent/toxin/amatoxin
	name = "Amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = LIQUID
	color = "#792300"
	strength = 10
	taste_description = "mushroom"

/singleton/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333"
	strength = 10
	taste_description = "fish"
	target_organ = BP_BRAIN

/singleton/reagent/toxin/carpotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNATHI)
		return
	..()

/singleton/reagent/toxin/panotoxin
	name = "Panotoxin"
	description = "A strange poison from the strange panocelium mushroom that causes intense pain when injected."
	reagent_state = LIQUID
	color = "#008844"
	strength = 0
	taste_description = "stinging needles"

/singleton/reagent/toxin/panotoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustHalLoss(removed*15)

/singleton/reagent/toxin/phoron
	name = "Phoron"
	description = "Phoron in its liquid form. Twice as potent when breathed in."
	reagent_state = LIQUID
	color = "#9D14DB"
	strength = 30
	touch_met = 5
	taste_mult = 1.5
	breathe_mul = 2
	fallback_specific_heat = 12 //Phoron is very dense and can hold a lot of energy.

/singleton/reagent/toxin/phoron/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/obj/item/organ/internal/parasite/PA = H.internal_organs_by_name["blackkois"]
		if((istype(PA) && PA.stage >= 3))
			H.heal_organ_damage(2 * removed, 2 * removed)
			H.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)
			H.adjustToxLoss(-2 * removed)
			return

		if(alien == IS_VAURCA && H.species.has_organ[BP_FILTRATION_BIT])
			metabolism = REM * 20 //vaurcae metabolise phoron faster than other species - good for them if their filter isn't broken.
			var/obj/item/organ/internal/vaurca/filtrationbit/F = H.internal_organs_by_name[BP_FILTRATION_BIT]
			if(isnull(F))
				..()
			else if(F.is_broken())
				..()
			else if(H.species.has_organ[BP_PHORON_RESERVE])
				var/obj/item/organ/internal/vaurca/preserve/P = H.internal_organs_by_name[BP_PHORON_RESERVE]
				if(isnull(P))
					return
				else if(P.is_broken())
					return
				else
					P.air_contents.adjust_gas(GAS_PHORON, (0.5*removed))

		else
			..()
	else
		..()

/singleton/reagent/toxin/phoron/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/singleton/reagent/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/parasite/P = H.internal_organs_by_name["blackkois"]
		if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
			return

	M.take_organ_damage(0, removed * 0.3) //being splashed directly with phoron causes minor chemical burns
	if(prob(50))
		M.pl_effects()

/singleton/reagent/toxin/phoron/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/parasite/P = H.internal_organs_by_name["blackkois"]
		if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
			return

	M.take_organ_damage(0, removed * 0.6) //Breathing phoron? Oh hell no boy my boy.
	if(prob(50))
		M.pl_effects()

/singleton/reagent/toxin/phoron/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return
	T.assume_gas(GAS_PHORON, amount, T20C)
	remove_self(amount, holder)

/singleton/reagent/toxin/cardox
	name = "Cardox"
	description = "Cardox is a mildly toxic, expensive, NanoTrasen designed cleaner intended to eliminate liquid phoron stains from suits."
	reagent_state = LIQUID
	scannable = TRUE
	color = "#EEEEEE"
	metabolism = 0.3 // 100 seconds for 30 units to metabolise.
	taste_description = "cherry"
	conflicting_reagent = /singleton/reagent/toxin/phoron
	strength = 1
	touch_mul = 0.75

/singleton/reagent/toxin/cardox/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return

	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.add_chemical_effect(CE_TOXIN, removed * strength * 2)
	else
		M.add_chemical_effect(CE_TOXIN, removed * strength)

/singleton/reagent/toxin/cardox/affect_conflicting(var/mob/living/carbon/M, var/alien, var/removed, var/singleton/reagent/conflicting, var/datum/reagents/holder)
	var/amount = min(removed, REAGENT_VOLUME(holder, conflicting.type))
	holder.remove_reagent(conflicting.type, amount)

/singleton/reagent/toxin/cardox/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 1)
		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(amount*10)
	if(amount >= 10)
		for(var/obj/item/reagent_containers/food/snacks/grown/K in T)
			if((K.plantname == "koisspore" || K.plantname == "blackkois") || (K.name == "kois" || K.name == "black kois"))
				qdel(K)
		for(var/obj/machinery/portable_atmospherics/hydroponics/H in T)
			if(((H.name == "kois" || H.name == "black kois") || H.seed == /datum/seed/koisspore) && !(H.closed_system))
				H.health = 0 // kill this boi - geeves
				H.force_update = TRUE // and quick
				H.process()
				if(istype(H, /obj/machinery/portable_atmospherics/hydroponics/soil/invisible))
					qdel(H)

	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			environment.adjust_gas(GAS_PHORON,-amount*10)

/singleton/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	description = "A highly toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 20
	metabolism = REM * 2
	taste_description = "bitter almonds"
	taste_mult = 1.5
	target_organ = BP_HEART

/singleton/reagent/toxin/cyanide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.adjustOxyLoss(20 * removed)

/singleton/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 0
	overdose = 5
	od_minimum_dose = 20
	taste_description = "salt"

/singleton/reagent/toxin/potassium_chloride/overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	var/mob/living/carbon/human/H = M
	if(!istype(H) || (H.species.flags & NO_BLOOD))
		return
	M.add_chemical_effect(CE_NOPULSE, 1)
	if(H.stat != 1)
		if(H.losebreath >= 10)
			H.losebreath = max(10, H.losebreath - 10)
		H.adjustOxyLoss(2)
		H.Weaken(10)

/singleton/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	description = "Potassium Chlorophoride is an expensive, vastly improved variant of Potassium Chloride. Potassium Chlorophoride, unlike the original drug, acts immediately to block neuromuscular junctions, causing general paralysis."
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 10
	overdose = 5
	od_minimum_dose = 20
	taste_description = "salt"

/singleton/reagent/toxin/potassium_chlorophoride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	var/mob/living/carbon/human/H = M
	if(!istype(H) || (H.species.flags & NO_BLOOD))
		return
	M.add_chemical_effect(CE_NOPULSE, 1)
	if(H.stat != 1)
		if(H.losebreath >= 10)
			H.losebreath = max(10, M.losebreath-10)
		H.adjustOxyLoss(2)
		H.Weaken(10)

/singleton/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900"
	spectro_hidden = TRUE
	metabolism = REM
	strength = 3
	taste_description = "death"
	target_organ = BP_BRAIN

/singleton/reagent/toxin/zombiepowder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return
	M.add_chemical_effect(CE_NOPULSE, 1)
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(3 * removed)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	M.tod = worldtime2text()

/singleton/reagent/toxin/zombiepowder/final_effect(mob/living/carbon/M, datum/reagents/holder)
	if(istype(M))
		M.status_flags &= ~FAKEDEATH
	return ..()

/singleton/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	description = "A chemical mix good for growing plants with."
	reagent_state = LIQUID
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"
	taste_description = "plant food"
	taste_mult = 0.5
	touch_mul = 0
	unaffected_species = IS_MACHINE

/singleton/reagent/toxin/fertilizer/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		M.adjustNutritionLoss(-removed*3)
		//Fertilizer is good for plants
	else
		if(prob(15))
			M.add_chemical_effect(CE_NEPHROTOXIC, 1)

/singleton/reagent/toxin/fertilizer/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		M.adjustNutritionLoss(-removed*3)
	else if(REAGENT_VOLUME(holder, type) > 15)
		M.adjustOxyLoss(2 * removed)
		if(M.losebreath < 15)
			M.losebreath++
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat burns!", "Your insides are on fire!", "Your feel a burning pain in your chest!")))
	else
		if(prob(5))
			to_chat(M, SPAN_WARNING(pick("Your throat stings a bit.", "You can taste something really digusting.", "Your chest doesn't feel so great.")))

/singleton/reagent/toxin/fertilizer/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!(alien == IS_DIONA))
		M.adjustFireLoss(10)
		to_chat(M, SPAN_WARNING(pick("Your skin burns!", "The chemical is melting your skin!", "Wash it off, wash it off!")))
		remove_self(REAGENT_VOLUME(holder, type), holder)

/singleton/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	color = "#168042"

/singleton/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	color = "#2A1680"

/singleton/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	color = "#801616"

/singleton/reagent/toxin/fertilizer/monoammoniumphosphate
	name = "Monoammonium Phosphate"
	strength = 0.25
	description = "Commonly found in fire extinguishers, also works as a fertilizer."
	reagent_state = SOLID
	color = "#CCCCCC"
	taste_description = "salty dirt"
	touch_met = REM * 10
	breathe_mul = 0

/singleton/reagent/toxin/fertilizer/monoammoniumphosphate/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.return_air()
		lowertemp.temperature = max(lowertemp.temperature-2000, lowertemp.temperature / 2, T0C)
		lowertemp.react()
		qdel(hotspot)

	var/amount_to_remove = max(1,round(amount * 0.5))

	new /obj/effect/decal/cleanable/foam(T, amount_to_remove)
	remove_self(amount_to_remove, holder)
	return

/singleton/reagent/toxin/fertilizer/monoammoniumphosphate/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(L))
		var/needed = min(L.fire_stacks, amount)
		L.ExtinguishMob(3* needed) // Foam is 3 times more efficient at extinguishing
		remove_self(needed, holder)

/singleton/reagent/toxin/fertilizer/monoammoniumphosphate/affect_touch(var/mob/living/carbon/slime/S, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(S))
		S.adjustToxLoss( REAGENT_VOLUME(holder, type) * (removed/REM) * 0.23 )
		if(!S.client)
			if(S.target) // Like cats
				S.target = null
				++S.discipline
		if(S.chem_doses[type] == removed)
			S.visible_message(SPAN_WARNING("[S]'s flesh sizzles where the foam touches it!"), SPAN_DANGER("Your flesh burns in the foam!"))

/singleton/reagent/toxin/fertilizer/monoammoniumphosphate/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/structure/bonfire))
		var/obj/structure/bonfire/B = O
		B.fuel = max(0, B.fuel - (150 * amount))

/singleton/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	reagent_state = LIQUID
	color = "#49002E"
	strength = 4
	metabolism = REM*1.5
	taste_mult = 1
	unaffected_species = IS_MACHINE

/singleton/reagent/toxin/plantbgone/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message(SPAN_NOTICE("The fungi are completely dissolved by the solution!"))
	if(istype(T, /turf/simulated/floor/diona))
		T.visible_message(SPAN_WARNING("\The [T] squirms as it's hit by the solution, before dissolving."))
		var/turf/simulated/floor/F = T
		F.make_plating()
		playsound(F, 'sound/species/diona/gestalt_grow.ogg', 30, TRUE)

/singleton/reagent/toxin/plantbgone/touch_obj(var/obj/O, var/volume, var/datum/reagents/holder)
	if(istype(O, /obj/effect/plant))
		qdel(O)

/singleton/reagent/toxin/plantbgone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(alien == IS_DIONA)
		M.adjustToxLoss(30 * removed)

//Affect touch automatically transfers to affect_blood, so we'll apply the damage there, after accounting for permeability
/singleton/reagent/toxin/plantbgone/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	removed *= M.reagent_permeability()
	affect_blood(M, alien, removed*0.5, holder)

/singleton/reagent/lexorin
	name = "Lexorin"
	description = "Lexorin is a complex toxin that attempts to induce general hypoxia by weakening the diaphragm to prevent respiration and also by binding to haemoglobins to prevent oxygen molecules from doing the same."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	taste_description = "acid"

/singleton/reagent/lexorin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.adjustOxyLoss(2 * removed)
	if(M.losebreath < 15)
		M.losebreath++

/singleton/reagent/mutagen
	name = "Unstable Mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	reagent_state = LIQUID
	color = "#13BC5E"
	taste_description = "slime"
	taste_mult = 0.9

/singleton/reagent/mutagen/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(33))
		affect_blood(M, alien, removed, holder)

/singleton/reagent/mutagen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(prob(67))
		affect_blood(M, alien, removed, holder)

/singleton/reagent/mutagen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(isslime(M)) // destabilize slime mutation by adding unstable mutagen
		var/mob/living/carbon/slime/slime = M
		slime.mutation_chance = min(slime.mutation_chance + removed, 100)
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return
	if(M.dna)
		if(prob(removed * 10)) // Approx. one mutation per 10 injected/20 ingested/30 touching units
			to_chat(M, "Something feels different about you...")
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
	M.apply_damage(10 * removed, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/singleton/reagent/slimejelly
	name = "Slime Jelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	reagent_state = LIQUID
	color = "#801E28"
	taste_description = "slime"
	taste_mult = 1.3

/singleton/reagent/slimejelly/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(isslime(M)) // stabilize slime mutation by reintroducing slime jelly into the slime
		var/mob/living/carbon/slime/slime = M
		slime.mutation_chance = max(slime.mutation_chance - removed, 0)
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return

	if(check_min_dose(M, 0.5))
		M.adjustCloneLoss(10*removed)
		M.add_chemical_effect(CE_OXYGENATED, 2) //strength of dexalin plus
		M.heal_organ_damage(8 * removed, 8 * removed) //strength of butazoline/dermaline

/singleton/reagent/soporific
	name = "Soporific"
	description = "Soporific is highly diluted polysomnine which results in slower and more gradual sedation. This makes the drug ideal at treating insomnia and anxiety disorders, however is generally not reliable for sedation in preparation for surgery except in high doses."
	reagent_state = LIQUID
	scannable = TRUE
	color = "#009CA8"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	taste_description = "bitterness"
	breathe_met = REM * 0.5 * 0.33
	var/total_strength = 0

/singleton/reagent/soporific/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if((istype(H) && (H.species.flags & NO_BLOOD)) || alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PULSE, -2)
	var/dose = M.chem_doses[type]
	if(dose < 2)
		if(ishuman(M) && (dose == metabolism * 2 || prob(5)))
			M.emote("yawn")
	else if(dose < 3.5)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(dose < 7)
		if(prob(50))
			M.Weaken(2)
		M.drowsiness = max(M.drowsiness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsiness = max(M.drowsiness, 60)

/singleton/reagent/polysomnine
	name = "Polysomnine"
	description = "Polysomnine is a complex drug which rapidly induces sedation in preparation for surgery. Polysomnine's sedative effect is fast acting, and sedated individuals wake up with zero amnesia regarding the events leading up to their sedation, however the only downside is how hard the drug is on the liver."
	reagent_state = SOLID
	scannable = TRUE
	color = "#000067"
	metabolism = REM * 0.5
	overdose = 15
	taste_description = "bitterness"
	breathe_met = REM * 0.5 * 0.5

/singleton/reagent/polysomnine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	var/dose = M.chem_doses[type]
	if(dose == metabolism)
		M.confused += 2
		M.drowsiness += 2
	else if(dose < 2)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		M.sleeping = max(M.sleeping, 30)
		M.eye_blurry = max(M.eye_blurry, 30)

	if(dose > 1)
		M.add_chemical_effect(CE_TOXIN, removed)

/singleton/reagent/polysomnine/beer2 //disguised as normal beer for use by emagged brobots
	name = "Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300"
	taste_description = "beer"

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer."
	glass_center_of_mass = list("x"=16, "y"=8)

	fallback_specific_heat = 1.2

/* Transformations */

/singleton/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	description = "A transformative toxin isolated from jelly extract from black slimes. The chemical is fundamentally the same as regular Mutation Toxin, however its effect is magnitudes faster, degenerating a body into a grey slime immediately."
	reagent_state = LIQUID
	color = "#13BC5E"
	taste_description = "sludge"

/singleton/reagent/aslimetoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) // TODO: check if there's similar code anywhere else
	if(M.transforming)
		return
	to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
	M.transforming = 1
	M.canmove = 0
	M.icon = null
	M.cut_overlays()
	M.set_invisibility(101)
	for(var/obj/item/W in M)
		if(istype(W, /obj/item/implant)) //TODO: Carn. give implants a dropped() or something
			qdel(W)
			continue
		W.layer = initial(W.layer)
		W.forceMove(M.loc)
		W.dropped(M)
	var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
	new_mob.set_intent(I_HURT)
	new_mob.universal_speak = 1
	if(M.mind)
		M.mind.transfer_to(new_mob)
	else
		new_mob.key = M.key
	qdel(M)

/singleton/reagent/toxin/nanites
	name = "Nanomachines"
	description = "Microscopic construction robots."
	reagent_state = LIQUID
	color = "#535E66"
	taste_description = "slimey metal"
	fallback_specific_heat = 3

/singleton/reagent/toxin/undead
	name = "Undead Ichor"
	description = "A wicked liquid with unknown origins and uses."
	color = "#b2beb5"
	strength = 25
	taste_description = "ashes"

/singleton/reagent/toxin/undead/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien && alien == IS_UNDEAD)
		M.heal_organ_damage(10 * removed, 15 * removed)
		return
	..()

/singleton/reagent/toxin/tobacco
	name = "Space Tobacco"
	description = "Low-grade space tobacco."
	reagent_state = SOLID
	color = "#333300"
	taste_description = "cheap tobacco"
	strength = 0
	taste_mult = 10
	var/nicotine = 0.2

/singleton/reagent/toxin/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	holder.add_reagent(/singleton/reagent/mental/nicotine, removed * nicotine)

/singleton/reagent/toxin/tobacco/rich
	name = "Earth Tobacco"
	description = "Nicknamed 'Earth Tobacco', this plant is much higher quality than its spacefaring counterpart."
	taste_description = "luxury tobacco"
	nicotine = 0.5

/singleton/reagent/toxin/tobacco/fake
	name = "Cheap Tobacco"
	description = "This actually appears to be mostly ground up leaves masquerading as tobacco. There's maybe some nicotine in there somewhere..."
	taste_description = "acrid smoke"
	nicotine = 0.1

/singleton/reagent/toxin/tobacco/sweet
	name = "Sweet Tobacco"
	description = "This tobacco is much sweeter than the strains usually found in human space."
	taste_description = "sweet tobacco"
	nicotine = 0.3

/singleton/reagent/toxin/tobacco/liquid
	name = "Nicotine Solution"
	description = "A diluted nicotine solution."
	reagent_state = LIQUID
	nicotine = REM * 0.1
	taste_mult = 2

/mob/living/carbon/human/proc/berserk_start()
	to_chat(src, SPAN_DANGER("An uncontrollable rage courses through your body and overtakes your thoughts - your blood begins to boil with fury!"))
	add_client_color(/datum/client_color/berserk)
	shock_stage = 0
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)
	setHalLoss(0)
	lying = 0
	update_canmove()

/mob/living/carbon/human/proc/berserk_process()
	drowsiness = max(drowsiness - 5, 0)
	AdjustParalysis(-1)
	AdjustStunned(-1)
	AdjustWeakened(-1)
	adjustHalLoss(-1)

/mob/living/carbon/human/proc/berserk_stop()
	to_chat(src, SPAN_DANGER("Your rage fades away and the boiling sensation subsides, your thoughts are clear once more."))
	remove_client_color(/datum/client_color/berserk)

/singleton/reagent/toxin/berserk
	name = "Red Nightshade"
	description = "An illegal combat performance enhancer originating from the criminal syndicates of Mars. The drug stimulates regions of the brain responsible for violence and rage, inducing a feral, berserk state in users. It is incredibly hard on the liver."
	reagent_state = LIQUID
	color = "#AF111C"
	strength = 3
	overdose = 10
	taste_description = "popping candy"
	metabolism = REM*0.3 //10u = ~5 minutes of being berserk.
	unaffected_species = IS_DIONA | IS_MACHINE

/singleton/reagent/toxin/berserk/initial_effect(var/mob/living/carbon/human/H, var/alien, var/holder)
	. = ..()
	if(istype(H))
		H.berserk_start()

/singleton/reagent/toxin/berserk/final_effect(var/mob/living/carbon/human/H, var/alien, var/holder)
	. = ..()
	if(istype(H))
		H.berserk_stop()

/singleton/reagent/toxin/berserk/affect_blood(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.berserk_process()
	M.make_jittery(20)
	M.add_chemical_effect(CE_BERSERK, 1)
	if(M.a_intent != I_HURT)
		M.a_intent_change(I_HURT)
	if(prob(3))
		to_chat(M, SPAN_WARNING(pick("Your blood boils with rage!", "A monster stirs within you - let it out.", "You feel an overwhelming sense of rage!", "You cannot contain your anger!", "You struggle to relax - a fury stirs within you.", "You feel an electric sensation course through your body!")))
	if(prob(5))
		M.emote(pick("twitch_v", "grunt"))

/singleton/reagent/toxin/berserk/overdose(var/mob/living/carbon/M, var/datum/reagents/holder)
	if(prob(25))
		M.add_chemical_effect(CE_CARDIOTOXIC, 1)

/singleton/reagent/toxin/spectrocybin
	name = "Spectrocybin"
	description = "Spectrocybin is a hallucinogenic chemical found in a unique strain of fungi. Little research has been conducted into the hallucinogenic properties of spectrocybin, though many spiritual creeds utilise the drug in rituals and claim it allows people to act as mediums between the living and dead."
	reagent_state = LIQUID
	color = "#800080"
	strength = 5
	overdose = 5  //5 units per ghostmushroom.
	od_minimum_dose = 11
	taste_description = "acid"
	metabolism = REM * 0.5
	unaffected_species = IS_DIONA | IS_MACHINE
	var/berserked = FALSE

/singleton/reagent/toxin/spectrocybin/affect_blood(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_HAUNTED, M.chem_doses[type])

/singleton/reagent/toxin/spectrocybin/overdose(var/mob/living/carbon/M, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(ishuman(M) && !berserked)
		H.berserk_start()
		berserked = TRUE
	else if(ishuman(M) && berserked)
		H.berserk_process()
	M.add_chemical_effect(CE_BERSERK, 1)
	if(M.a_intent != I_HURT)
		M.a_intent_change(I_HURT)

/singleton/reagent/toxin/spectrocybin/final_effect(mob/living/carbon/human/H, datum/reagents/holder)
	. = ..()
	if(istype(H) && H.chem_doses[type] >= get_overdose(H, holder = holder))
		H.berserk_stop()
		berserked = FALSE

/singleton/reagent/toxin/trioxin
	name = "Trioxin"
	description = "A synthetic compound of unknown origins, designated originally as a performance enhancing substance."
	reagent_state = LIQUID
	color = "#E7E146"
	strength = 1
	taste_description = "old eggs"
	metabolism = REM
	unaffected_species = IS_DIONA | IS_MACHINE | IS_UNDEAD
	affects_dead = TRUE

/singleton/reagent/toxin/trioxin/affect_blood(var/mob/living/carbon/M, var/removed, var/datum/reagents/holder)
	..()
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		if(H.reagents.has_reagent(/singleton/reagent/thetamycin, 15))
			return

		if(!H.internal_organs_by_name[BP_ZOMBIE_PARASITE] && prob(15))
			var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
			var/obj/item/organ/internal/parasite/zombie/infest = new()
			infest.replaced(H, affected)

		if(H.species.zombie_type)
			if(!H.internal_organs_by_name[BP_BRAIN])	//destroying the brain stops trioxin from bringing the dead back to life
				return

			if(H && H.stat != DEAD)
				return

			for(var/datum/language/L in H.languages)
				H.remove_language(L.name)

			var/r = H.r_skin
			var/g = H.g_skin
			var/b = H.b_skin

			H.set_species(H.species.zombie_type, 0, 0, 0)
			H.revive()
			H.change_skin_color(r, g, b)
			playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
			to_chat(H,"<font size='3'><span class='cult'>You return back to life as the undead, all that is left is the hunger to consume the living and the will to spread the infection.</font></span>")

/singleton/reagent/toxin/dextrotoxin
	name = "Dextrotoxin"
	description = "A complicated to make and highly illegal drug that cause paralysis mostly focused on the limbs."
	reagent_state = LIQUID
	color = "#002067"
	spectro_hidden = TRUE
	metabolism = REM/3
	strength = 0
	taste_description = "danger"

/singleton/reagent/toxin/dextrotoxin/initial_effect(mob/living/carbon/M)
	to_chat(M, SPAN_WARNING("Your limbs start to feel <b>numb</b> and <b>weak</b>, and your legs wobble as it becomes hard to stand!"))

/singleton/reagent/toxin/dextrotoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return
	M.add_chemical_effect(CE_UNDEXTROUS, 1)
	if(M.chem_doses[type] > 0.2)
		M.Weaken(10)

/singleton/reagent/toxin/dextrotoxin/final_effect(mob/living/carbon/M)
	to_chat(M, SPAN_GOOD("You can feel sensation creeping back into your limbs!"))

/singleton/reagent/toxin/coagulated_blood
	name = "Hemoglobin"
	description = "A protein that works to carry oxygen. If freely floating in the bloodstream, however, it is toxic to the kidneys."
	reagent_state = SOLID
	color = "#C80000"
	metabolism = REM * 0.5 // 0.05/second by default, so it isn't outhealed.
	taste_description = "iron"
	taste_mult = 1.3
	fallback_specific_heat = 3.617
	target_organ = BP_KIDNEYS

/singleton/reagent/toxin/coagulated_blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	return // denatured blood isn't absorbed when eaten

/singleton/reagent/toxin/coagulated_blood/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	M.add_chemical_effect(CE_NEPHROTOXIC, 0) // deal no damage, but prevent regeneration
	..()

/singleton/reagent/toxin/nerveworm_eggs
	name = "Nerve Fluke Eggs"
	description = "The eggs of a parasitic worm. These ones grow to infest the nervous system, working their way up from the peripheral to the central nervous system. The infection is gradual: lethargy, issues with motor coordination, then eventually seizures."
	reagent_state = SOLID
	color = "#b9b9d9"
	metabolism = REM*2
	ingest_met = REM*2
	touch_met = REM*5
	taste_description = "something tingly"
	taste_mult = 0.25
	strength = 0

/singleton/reagent/toxin/nerveworm_eggs/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		if(H.chem_effects[CE_ANTIPARASITE])
			return

		if(!H.internal_organs_by_name[BP_WORM_NERVE])
			var/obj/item/organ/external/affected = H.get_organ(BP_L_ARM)
			var/obj/item/organ/internal/parasite/nerveworm/infest = new()
			infest.replaced(H, affected)

/singleton/reagent/toxin/heartworm_eggs
	name = "Heart Fluke Eggs"
	description = "The eggs of a parasitic worm. These ones grow to infest the cardiac tissue of the heart. The infection is gradual: coughing first, then eventually heart failure."
	reagent_state = SOLID
	color = "#caaaaa"
	metabolism = REM/2 //Slow metabolisation so medical can potentially screen it early, given it's danger.
	ingest_met = REM/2
	touch_met = REM*5
	taste_description = "something quite sour"
	taste_mult = 0.75
	strength = 0

/singleton/reagent/toxin/heartworm_eggs/affect_blood(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	..()
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		if(H.chem_effects[CE_ANTIPARASITE])
			return

		if(!H.internal_organs_by_name[BP_WORM_HEART])
			var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
			var/obj/item/organ/internal/parasite/heartworm/infest = new()
			infest.replaced(H, affected)
