/* Toxins, poisons, venoms */

/datum/reagent/toxin
	name = "Toxin"
	description = "A toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolism = REM * 0.1 // 0.02 by default. They last a while and slowly kill you.
	taste_description = "bitterness"
	taste_mult = 1.2
	fallback_specific_heat = 0.75

	var/target_organ // needs to be null by default
	var/strength = 2 // How much damage it deals per unit

/datum/reagent/toxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(strength && alien != IS_DIONA)
		var/dam = (strength * removed)
		if(target_organ && ishuman(M))
			var/mob/living/carbon/human/H = M
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
		if(dam)
			M.adjustToxLoss(target_organ ? (dam * 0.5) : dam)

/datum/reagent/toxin/plasticide
	name = "Plasticide"
	description = "Liquid plastic, do not eat."
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 5
	taste_description = "plastic"

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = LIQUID
	color = "#792300"
	strength = 10
	taste_description = "mushroom"

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333"
	strength = 10
	taste_description = "fish"
	target_organ = BP_BRAIN

/datum/reagent/toxin/carpotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_UNATHI)
		return
	..()

/datum/reagent/toxin/panotoxin
	name = "Panotoxin"
	description = "A strange poison from the strange panocelium mushroom that causes intense pain when injected."
	reagent_state = LIQUID
	color = "#008844"
	strength = 0
	taste_description = "stinging needles"

/datum/reagent/toxin/panotoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustHalLoss(removed*15)

/datum/reagent/toxin/phoron
	name = "Phoron"
	description = "Phoron in its liquid form. Twice as potent when breathed in."
	reagent_state = LIQUID
	color = "#9D14DB"
	strength = 30
	touch_met = 5
	taste_mult = 1.5
	breathe_mul = 2
	fallback_specific_heat = 12 //Phoron is very dense and can hold a lot of energy.

/datum/reagent/toxin/phoron/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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
			var/obj/item/organ/vaurca/filtrationbit/F = H.internal_organs_by_name[BP_FILTRATION_BIT]
			if(isnull(F))
				..()
			else if(F.is_broken())
				..()
			else if(H.species.has_organ[BP_PHORON_RESERVE])
				var/obj/item/organ/vaurca/preserve/P = H.internal_organs_by_name[BP_PHORON_RESERVE]
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

/datum/reagent/toxin/phoron/touch_mob(var/mob/living/L, var/amount)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/toxin/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/parasite/P = H.internal_organs_by_name["blackkois"]
		if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
			return

	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(50))
		M.pl_effects()

/datum/reagent/toxin/phoron/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	T.assume_gas(GAS_PHORON, volume, T20C)
	remove_self(volume)

/datum/reagent/toxin/phoron_salt //Remember to exclude in RNG chems.
	name = "Phoron Salts"
	description = "A mysterious molten mixture with strange chemical properties. Incredibly deadly to all lifeforms, especially Vaurca."
	reagent_state = SOLID
	color = "#7C4876"
	strength = 30
	default_temperature = 130 //Kelvin

/datum/reagent/toxin/cardox
	name = "Cardox"
	description = "Cardox is a mildly toxic, expensive, NanoTrasen designed cleaner intended to eliminate liquid phoron stains from suits."
	reagent_state = LIQUID
	scannable = TRUE
	color = "#EEEEEE"
	metabolism = 0.3 // 100 seconds for 30 units to metabolise.
	taste_description = "cherry"
	conflicting_reagent = /datum/reagent/toxin/phoron
	strength = 1

/datum/reagent/toxin/cardox/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(!istype(M))
		return

	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.add_chemical_effect(CE_TOXIN, removed * strength * 2)
	else
		M.add_chemical_effect(CE_TOXIN, removed * strength)

/datum/reagent/toxin/cardox/affect_conflicting(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagent/conflicting)
	var/amount = min(removed, conflicting.volume)
	holder.remove_reagent(conflicting.type, amount)

/datum/reagent/toxin/cardox/touch_turf(var/turf/T, var/amount)
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

	var/datum/gas_mixture/environment = T.return_air()
	environment.adjust_gas(GAS_PHORON,-amount*10)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	description = "A highly toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 20
	metabolism = REM * 2
	taste_description = "bitter almonds"
	taste_mult = 1.5
	target_organ = BP_HEART

/datum/reagent/toxin/cyanide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.adjustOxyLoss(20 * removed)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 0
	overdose = 5
	od_minimum_dose = 20
	taste_description = "salt"

/datum/reagent/toxin/potassium_chloride/overdose(var/mob/living/carbon/M, var/alien)
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

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	description = "Potassium Chlorophoride is an expensive, vastly improved variant of Potassium Chloride. Potassium Chlorophoride, unlike the original drug, acts immediately to block neuromuscular junctions, causing general paralysis."
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 10
	overdose = 5
	od_minimum_dose = 20
	taste_description = "salt"

/datum/reagent/toxin/potassium_chlorophoride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900"
	metabolism = REM
	strength = 3
	taste_description = "death"
	target_organ = BP_BRAIN

/datum/reagent/toxin/zombiepowder/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	return ..()

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	description = "A chemical mix good for growing plants with."
	reagent_state = LIQUID
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"
	taste_description = "plant food"
	taste_mult = 0.5
	unaffected_species = IS_MACHINE

/datum/reagent/toxin/fertilizer/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		M.adjustNutritionLoss(-removed*3)
		//Fertilizer is good for plants
	else
		..()

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"

/datum/reagent/toxin/fertilizer/monoammoniumphosphate
	name = "Monoammonium Phosphate"
	strength = 0.25
	description = "Commonly found in fire extinguishers, also works as a fertilizer."
	reagent_state = SOLID
	color = "#CCCCCC"
	taste_description = "salty dirt"
	touch_met = REM * 10
	breathe_mul = 0

/datum/reagent/toxin/fertilizer/monoammoniumphosphate/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.return_air()
		lowertemp.temperature = max(lowertemp.temperature-2000, lowertemp.temperature / 2, T0C)
		lowertemp.react()
		qdel(hotspot)

	var/amount_to_remove = max(1,round(volume * 0.5))

	new /obj/effect/decal/cleanable/foam(T, amount_to_remove)
	remove_self(amount_to_remove)
	return

/datum/reagent/toxin/fertilizer/monoammoniumphosphate/touch_mob(var/mob/living/L, var/amount)
	. = ..()
	if(istype(L))
		var/needed = min(L.fire_stacks, amount)
		L.ExtinguishMob(3* needed) // Foam is 3 times more efficient at extinguishing
		remove_self(needed)

/datum/reagent/toxin/fertilizer/monoammoniumphosphate/affect_touch(var/mob/living/carbon/slime/S, var/alien, var/removed)
	if(istype(S))
		S.adjustToxLoss( volume * (removed/REM) * 0.23 )
		if(!S.client)
			if(S.target) // Like cats
				S.target = null
				++S.discipline
		if(dose == removed)
			S.visible_message(SPAN_WARNING("[S]'s flesh sizzles where the foam touches it!"), SPAN_DANGER("Your flesh burns in the foam!"))

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	reagent_state = LIQUID
	color = "#49002E"
	strength = 4
	metabolism = REM*1.5
	taste_mult = 1
	unaffected_species = IS_MACHINE

/datum/reagent/toxin/plantbgone/touch_turf(var/turf/T)
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

/datum/reagent/toxin/plantbgone/touch_obj(var/obj/O, var/volume)
	if(istype(O, /obj/effect/plant))
		qdel(O)

/datum/reagent/toxin/plantbgone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		M.adjustToxLoss(30 * removed)

//Affect touch automatically transfers to affect_blood, so we'll apply the damage there, after accounting for permeability
/datum/reagent/toxin/plantbgone/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	removed *= M.reagent_permeability()
	affect_blood(M, alien, removed*0.5)

/datum/reagent/lexorin
	name = "Lexorin"
	description = "Lexorin is a complex toxin that attempts to induce general hypoxia by weakening the diaphragm to prevent respiration and also by binding to haemoglobins to prevent oxygen molecules from doing the same."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	taste_description = "acid"

/datum/reagent/lexorin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.adjustOxyLoss(2 * removed)
	if(M.losebreath < 15)
		M.losebreath++

/datum/reagent/mutagen
	name = "Unstable Mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	reagent_state = LIQUID
	color = "#13BC5E"
	taste_description = "slime"
	taste_mult = 0.9

/datum/reagent/mutagen/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(33))
		affect_blood(M, alien, removed)

/datum/reagent/mutagen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(67))
		affect_blood(M, alien, removed)

/datum/reagent/mutagen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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
	M.apply_effect(10 * removed, IRRADIATE, blocked = 0)

/datum/reagent/slimejelly
	name = "Slime Jelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	reagent_state = LIQUID
	color = "#801E28"
	taste_description = "slime"
	taste_mult = 1.3

/datum/reagent/slimejelly/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	if(prob(10))
		to_chat(M, SPAN_DANGER("Your insides are burning!"))
		M.add_chemical_effect(CE_TOXIN, rand(100, 300) * removed)
	else if(prob(40))
		M.heal_organ_damage(25 * removed, 0)

/datum/reagent/soporific
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

/datum/reagent/soporific/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/mob/living/carbon/human/H = M
	if((istype(H) && (H.species.flags & NO_BLOOD)) || alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PULSE, -2)
	if(dose < 1)
		if(dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(dose < 1.5)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(dose < 5)
		if(prob(50))
			M.Weaken(2)
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/polysomnine
	name = "Polysomnine"
	description = "Polysomnine is a complex drug which rapidly induces sedation in preparation for surgery. Polysomnine's sedative effect is fast acting, and sedated individuals wake up with zero amnesia regarding the events leading up to their sedation, however the only downside is how hard the drug is on the liver."
	reagent_state = SOLID
	scannable = TRUE
	color = "#000067"
	metabolism = REM * 0.5
	overdose = 15
	taste_description = "bitterness"
	breathe_met = REM * 0.5 * 0.5

/datum/reagent/polysomnine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	if(dose == metabolism)
		M.confused += 2
		M.drowsyness += 2
	else if(dose < 2)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		M.sleeping = max(M.sleeping, 30)

	if(dose > 1)
		M.add_chemical_effect(CE_TOXIN, removed)

/datum/reagent/polysomnine/beer2 //disguised as normal beer for use by emagged brobots
	name = "Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300"
	taste_description = "beer"

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

	fallback_specific_heat = 1.2

/* Transformations */

/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	description = "A transformative toxin isolated from jelly extract from black slimes. The chemical is fundamentally the same as regular Mutation Toxin, however its effect is magnitudes faster, degenerating a body into a grey slime immediately."
	reagent_state = LIQUID
	color = "#13BC5E"
	taste_description = "sludge"

/datum/reagent/aslimetoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) // TODO: check if there's similar code anywhere else
	if(M.transforming)
		return
	to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
	M.transforming = 1
	M.canmove = 0
	M.icon = null
	M.cut_overlays()
	M.invisibility = 101
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

/datum/reagent/toxin/nanites
	name = "Nanomachines"
	description = "Microscopic construction robots."
	reagent_state = LIQUID
	color = "#535E66"
	taste_description = "slimey metal"
	fallback_specific_heat = 3

/datum/reagent/toxin/undead
	name = "Undead Ichor"
	description = "A wicked liquid with unknown origins and uses."
	color = "#b2beb5"
	strength = 25
	taste_description = "ashes"

/datum/reagent/toxin/undead/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_UNDEAD)
		M.heal_organ_damage(10 * removed, 15 * removed)
		return
	..()

/datum/reagent/toxin/tobacco
	name = "Space Tobacco"
	description = "Low-grade space tobacco."
	reagent_state = SOLID
	color = "#333300"
	data = 0
	taste_description = "cheap tobacco"
	strength = 0.004
	taste_mult = 10
	var/nicotine = 0.2

/datum/reagent/toxin/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.reagents.add_reagent(/datum/reagent/mental/nicotine, removed * nicotine)

/datum/reagent/toxin/tobacco/rich
	name = "Earth Tobacco"
	description = "Nicknamed 'Earth Tobacco', this plant is much higher quality than its spacefaring counterpart."
	taste_description = "luxury tobacco"
	strength = 0.002
	nicotine = 0.5

/datum/reagent/toxin/tobacco/fake
	name = "Cheap Tobacco"
	description = "This actually appears to be mostly ground up leaves masquerading as tobacco. There's maybe some nicotine in there somewhere..."
	taste_description = "acrid smoke"
	strength = 0.008
	nicotine = 0.1

/datum/reagent/toxin/berserk
	name = "Red Nightshade"
	description = "An illegal combat performance enhancer originating from the criminal syndicates of Mars. The drug stimulates regions of the brain responsible for violence and rage, inducing a feral, berserk state in users."
	reagent_state = LIQUID
	color = "#AF111C"
	strength = 5
	taste_description = "bitterness"
	metabolism = REM * 2
	unaffected_species = IS_DIONA | IS_MACHINE
	var/datum/modifier/modifier

/datum/reagent/toxin/berserk/affect_blood(var/mob/living/carbon/M, var/removed)
	..()
	if(!modifier)
		modifier = M.add_modifier(/datum/modifier/berserk, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)
	M.make_jittery(20)
	M.add_chemical_effect(CE_BERSERK, 1)
	if(M.a_intent != I_HURT)
		M.a_intent_change(I_HURT)
	if(prob(10))
		M.add_chemical_effect(CE_NEUROTOXIC, 5*removed)

/datum/reagent/toxin/berserk/Destroy()
	QDEL_NULL(modifier)
	return ..()

/datum/reagent/toxin/spectrocybin
	name = "Spectrocybin"
	description = "Spectrocybin is a hallucinogenic chemical found in a unique strain of fungi. Little research has been conducted into the hallucinogenic properties of spectrocybin, though many spiritual creeds utilise the drug in rituals and claim it allows people to act as mediums between the living and dead."
	reagent_state = LIQUID
	color = "#800080"
	strength = 5
	overdose = 5  //5 units per ghostmushroom.
	od_minimum_dose = 1
	taste_description = "acid"
	metabolism = REM * 0.5
	unaffected_species = IS_DIONA | IS_MACHINE
	var/datum/modifier/modifier

/datum/reagent/toxin/spectrocybin/affect_blood(var/mob/living/carbon/M, var/removed)
	..()
	if(!(volume > 5))
		M.hallucination = max(M.hallucination, 20)
		if(prob(20))
			M.see_invisible = SEE_INVISIBLE_CULT
		if(dose < 5)
			if(prob(10))
				M.emote("shiver")
				to_chat(M, SPAN_GOOD(pick("You hear the clinking of dinner plates and laughter.", "You hear a distant voice of someone you know talking to you.", "Fond memories of a departed loved one flocks to your mind.", "You feel the reassuring presence of a departed loved one.", "You feel a hand squeezing yours.")))

/datum/reagent/toxin/spectrocybin/overdose(var/mob/living/carbon/M)
	M.see_invisible = SEE_INVISIBLE_CULT
	M.make_jittery(5)
	if(dose < 5)
		if(prob(5))
			M.visible_message("<b>[M]</b> trembles uncontrollably.", "<span class='warning'>You tremble uncontrollably.</span>")
			to_chat(M, SPAN_CULT(pick("You feel fingers tracing up your back.", "You hear the distant wailing and sobbing of a departed loved one.", "You feel like you are being closely watched.", "You hear the hysterical laughter of a departed loved one.", "You no longer feel the reassuring presence of a departed loved one.", "You feel a hand taking hold of yours, digging its nails into you as it clings on.")))
	else
		if(!modifier)
			modifier = M.add_modifier(/datum/modifier/berserk, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)
		M.hallucination = 0 //Brings down hallucination quickly to prevent message spam from being switched between harm and help by hallucinoatory pacification and berserk.
		M.add_chemical_effect(CE_BERSERK, 1)
		if(M.a_intent != I_HURT)
			M.a_intent_change(I_HURT)
		if(prob(10))
			M.emote(pick("shiver", "twitch"))
			to_chat(M, SPAN_CULT(pick("You feel a cold and threatening air wrapping around you.", "Whispering shadows, ceaseless in their demands, twist your thoughts...", "The whispering, anything to make them stop!", "Your head spins amid the cacophony of screaming, wailing and maniacal laughter of distant loved ones.", "You feel vestiges of decaying souls cling to you, trying to re-enter the world of the living.")))

/datum/reagent/toxin/spectrocybin/Destroy()
	QDEL_NULL(modifier)
	return ..()

/datum/reagent/toxin/trioxin
	name = "Trioxin"
	description = "A synthetic compound of unknown origins, designated originally as a performance enhancing substance."
	reagent_state = LIQUID
	color = "#E7E146"
	strength = 1
	taste_description = "old eggs"
	metabolism = REM
	unaffected_species = IS_DIONA | IS_MACHINE | IS_UNDEAD
	affects_dead = TRUE

/datum/reagent/toxin/trioxin/affect_blood(var/mob/living/carbon/M, var/removed)
	..()
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		if(H.reagents.has_reagent(/datum/reagent/thetamycin, 15))
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



/datum/reagent/toxin/dextrotoxin
	name = "Dextrotoxin"
	description = "A complicated to make and highly illegal drug that cause paralysis mostly focused on the limbs."
	reagent_state = LIQUID
	color = "#002067"
	metabolism = REM * 0.2
	strength = 0
	taste_description = "danger"

/datum/reagent/toxin/dextrotoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_SCAN))
		return
	if (!(CE_UNDEXTROUS in M.chem_effects))
		to_chat(M, SPAN_WARNING("Your limbs start to feel numb and weak, and your legs wobble as it becomes hard to stand..."))
		M.confused = max(M.confused, 250)
	M.add_chemical_effect(CE_UNDEXTROUS, 1)
	if(dose > 0.2)
		M.Weaken(10)

/datum/reagent/toxin/dextrotoxin/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		to_chat(M, SPAN_WARNING("You can feel sensation creeping back into your limbs..."))
	return ..()
