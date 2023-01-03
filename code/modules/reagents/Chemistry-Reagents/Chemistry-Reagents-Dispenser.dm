/decl/reagent/acetone
	name = "Acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	taste_description = "acid"
	fallback_specific_heat = 0.567

/decl/reagent/acetone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(removed * 3)

/decl/reagent/acetone/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(amount < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

/decl/reagent/aluminum
	name = "Aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8"
	taste_description = "metal"
	taste_mult = 1.1
	fallback_specific_heat = 0.811

/decl/reagent/ammonia
	name = "Ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners. Poisonous to most lifeforms, lingers for a while if inhaled."
	reagent_state = LIQUID
	color = "#404030"
	metabolism = REM * 0.5
	taste_description = "mordant"
	taste_mult = 2
	breathe_mul = 2
	breathe_met = REM * 0.25
	fallback_specific_heat = 1.048

/decl/reagent/ammonia/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_DIONA)
		M.adjustNutritionLoss(-removed*3)
	else
		if(prob(15))
			M.add_chemical_effect(CE_NEPHROTOXIC, 1)

/decl/reagent/ammonia/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
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

/decl/reagent/ammonia/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!(alien == IS_DIONA))
		M.adjustFireLoss(20)
		to_chat(M, SPAN_WARNING(pick("Your skin burns!", "The chemical is melting your skin!", "Wash it off, wash it off!")))
		remove_self(REAGENT_VOLUME(holder, type), holder)

/decl/reagent/carbon
	name = "Carbon"
	description = "A chemical element, the building block of life."
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5
	taste_description = "sour chalk"
	taste_mult = 1.5
	fallback_specific_heat = 0.018
	scannable = TRUE

/decl/reagent/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (ingested.reagent_volumes.len - 1)
		for(var/_R in ingested.reagent_volumes)
			if(_R == type)
				continue
			ingested.remove_reagent(_R, removed * effect)

/decl/reagent/carbon/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = amount * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + amount * 30, 255)

/decl/reagent/copper
	name = "Copper"
	description = "A highly ductile metal."
	color = "#6E3B08"
	taste_description = "copper"
	fallback_specific_heat = 1.148
	scannable = TRUE

/decl/reagent/copper/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if (alien & IS_SKRELL)
		M.add_chemical_effect(CE_BLOODRESTORE, 3 * removed)

/decl/reagent/alcohol //Parent class for all alcoholic reagents, though this one shouldn't be used anywhere.
	name = null	// This null name should prevent alcohol from being added to global lists.
	description = "An abstract type you shouldn't be able to see."
	reagent_state = LIQUID
	color = "#404030"
	ingest_met = REM * 5

	var/hydration_factor = 1 //How much hydration to add per unit.
	var/nutriment_factor = 0.5 //How much nutrition to add per unit.
	var/strength = 100 // This is the Alcohol By Volume of the drink, value is in the range 0-100 unless you wanted to create some bizarre bluespace alcohol with <100

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0
	var/caffeine  = 0

	var/flammability_divisor = 10

	var/distillation_point = T0C + 100
	germ_adjust = 20 // as good as sterilizine, but only if you have pure ethanol. or rubbing alcohol if we get that eventually

	unaffected_species = IS_MACHINE

	taste_description = "mistakes"

	glass_icon_state = "glass_clear"
	glass_name = "glass of coder fuckups"
	glass_desc = "A glass of distilled maintainer tears."

	var/blood_to_ingest_scale = 2

/decl/reagent/alcohol/touch_mob(mob/living/L, amount, var/datum/reagents/holder)
	. = ..()
	if (istype(L) && strength > 40)
		L.adjust_fire_stacks((amount / (flammability_divisor || 1)) * (strength / 100))

/decl/reagent/alcohol/affect_blood(mob/living/carbon/M, alien, removed, var/datum/reagents/holder)
	if(prob(10*(strength/100)))
		to_chat(M, SPAN_DANGER("Your insides are burning!")) // it would be quite painful to inject alcohol or otherwise get it in your bloodstream directly, without metabolising any
	M.adjustToxLoss(removed * blood_to_ingest_scale * (strength/100) )
	affect_ingest(M,alien,removed * blood_to_ingest_scale, holder)
	return

/decl/reagent/alcohol/affect_ingest(mob/living/carbon/M, alien, removed, var/datum/reagents/holder)

	if(alien != IS_DIONA)
		M.intoxication += (strength / 100) * removed * 3.5

		if (druggy != 0)
			M.druggy = max(M.druggy, druggy)

		if (halluci)
			M.hallucination = max(M.hallucination, halluci)

		if(caffeine)
			M.add_chemical_effect(CE_PULSE, caffeine*2)
			M.add_up_to_chemical_effect(CE_SPEEDBOOST, 1)

	if (adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if (adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

/decl/reagent/alcohol
	name = "Ethanol"
	description = "A well-known alcohol with a variety of applications."
	flammability_divisor = 10

	taste_description = "pure alcohol"

	glass_icon_state = "glass_clear"
	glass_name = "glass of ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

	fallback_specific_heat = 0.605

	distillation_point = T0C + 78.37

/decl/reagent/alcohol/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))//Vaurca are damaged instead of getting nutrients, but they can still get drunk
		M.adjustToxLoss(1.5 * removed * (strength / 100))
	else
		M.adjustNutritionLoss(-nutriment_factor * removed)
		M.adjustHydrationLoss(-hydration_factor * removed)

	if (alien == IS_UNATHI)//unathi are poisoned by alcohol as well
		M.adjustToxLoss(1.5 * removed * (strength / 100))

	..()

/decl/reagent/alcohol/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(amount < 5)
			return
		if(istype(O, /obj/item/book/tome))
			to_chat(usr, "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>")
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat = null
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return


// Butanol is a common alcohol that is fairly ineffective for humans and most other species, but highly intoxicating to unathi.
// Most behavior is inherited from alcohol.
/decl/reagent/alcohol/butanol
	name = "Butanol"
	description = "A fairly harmless alcohol that has intoxicating effects on certain species."
	reagent_state = LIQUID
	color = "#404030"
	ingest_met = REM * 0.5 //Extremely slow metabolic rate means the liver will generally purge it faster than it can intoxicate you
	flammability_divisor = 7	//Butanol is a bit less flammable than ethanol

	taste_description = "alcohol"

	glass_icon_state = "glass_clear"
	glass_name = "glass of butanol"
	glass_desc = "A fairly harmless alcohol that has intoxicating effects on certain species."

	fallback_specific_heat = 0.549

	distillation_point = T0C + 117.7

/decl/reagent/alcohol/butanol/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
	if((alien == IS_VAURCA) || (istype(P) && P.stage >= 3))
		M.adjustToxLoss(removed * (strength / 100))
	else
		M.adjustNutritionLoss(-nutriment_factor * removed)
		M.adjustHydrationLoss(-hydration_factor * removed)

	if (alien == IS_UNATHI)
		ingest_met = initial(ingest_met)*3

	..()

/decl/reagent/hydrazine
	name = "Hydrazine"
	description = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	taste_description = "sweet tasting metal"

	fallback_specific_heat = 0.549 //Unknown

/decl/reagent/hydrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(4 * removed)

/decl/reagent/hydrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) // Hydrazine is both toxic and flammable.
	M.adjust_fire_stacks(removed / 12)
	M.adjustToxLoss(0.2 * removed)

/decl/reagent/hydrazine/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	new /obj/effect/decal/cleanable/liquid_fuel(T, amount)
	remove_self(amount, holder)
	return

/decl/reagent/hydrazine/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	H.add_chemical_effect(CE_PNEUMOTOXIC, removed * 0.5)

/decl/reagent/iron
	name = "Iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	color = "#353535"
	taste_description = "metal"
	scannable = TRUE

	fallback_specific_heat = 1.181

/decl/reagent/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if (!(alien & (IS_SKRELL | IS_VAURCA)))
		M.add_chemical_effect(CE_BLOODRESTORE, 3 * removed)

/decl/reagent/lithium
	name = "Lithium"
	description = "A chemical element, used as an antidepressant."
	reagent_state = SOLID
	color = "#808080"
	taste_description = "metal"

	fallback_specific_heat = 0.633

/decl/reagent/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(M.canmove && !M.restrained() && !(istype(M.loc, /turf/space)))
		step(M, pick(cardinal))
	if(prob(5) && ishuman(M))
		M.emote(pick("twitch", "drool", "moan"))

/decl/reagent/mercury
	name = "Mercury"
	description = "A poisonous chemical element, one of two that is a liquid at human room temperature and pressure."
	reagent_state = LIQUID
	color = "#484848"
	ingest_met = REM*0.1
	breathe_met = REM*0.4
	breathe_mul = 2 //mercury vapours and skin absorption more dangerous than eating mercury.
	touch_met = REM*0.1
	touch_mul = 1.25
	taste_mult = 0 //mercury apparently is tasteless
	scannable = TRUE

	fallback_specific_heat = 0.631

/decl/reagent/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_NEUROTOXIC, 1*removed)
	var/dose = M.chem_doses[type]
	if(dose > 1)
		if(prob(dose/2))
			to_chat(M, SPAN_WARNING(pick("You feel a tingly sensation in your body.", "You can smell something unusual.", "You can taste something unusual.", "You hear a faint white-noise that's gradually getting louder.")))
		M.confused = max(M.confused, 10)
	if(dose > 4)
		M.add_chemical_effect(CE_CLUMSY, 1)
		if(prob(dose/4) && ishuman(M))
			M.emote(pick("twitch", "shiver", "drool"))
		if(prob(dose/4))
			M.visible_message("<b>[M]</b> chuckles spontaneously.", "You chuckle spontaneously.")
	if(dose > 8)
		if(prob(2))
			to_chat(M, SPAN_WARNING("You can't feel any sensation in your extremities."))
		M.add_chemical_effect(CE_UNDEXTROUS, 1) //A budget dextrotoxin that's a tad more dangerous and slower to take effect.
		M.Weaken(10)

/decl/reagent/phosphorus
	name = "Phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	reagent_state = SOLID
	color = "#832828"
	taste_description = "vinegar"

	fallback_specific_heat = 0.569

/decl/reagent/potassium
	name = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0"
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.

	fallback_specific_heat = 0.214

/decl/reagent/potassium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(REAGENT_VOLUME(holder, type) > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/reagent/radium
	name = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#C7C7C7"
	taste_description = "the color blue, and regret"
	unaffected_species = IS_MACHINE

	fallback_specific_heat = 0.220
	var/message_shown = FALSE

/decl/reagent/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.apply_effect(10 * removed, IRRADIATE, blocked = 0) // Radium may increase your chances to cure a disease

/decl/reagent/radium/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(amount >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/decl/reagent/acid
	name = "Sulphuric Acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	reagent_state = LIQUID
	color = "#DB5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 4
	var/meltdose = 10 // How much is needed to melt
	taste_description = "acid"

	fallback_specific_heat = 0.815

/decl/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.take_organ_damage(0, removed * power)

/decl/reagent/acid/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed, var/datum/reagents/holder)
	. = ..()
	H.add_chemical_effect(CE_PNEUMOTOXIC, removed * power * 0.5)

/decl/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				remove_self(REAGENT_VOLUME(holder, type))
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				remove_self(REAGENT_VOLUME(holder, type))
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(REAGENT_VOLUME(holder, type) < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && removed > 0)
		if(ishuman(M) && REAGENT_VOLUME(holder, type) >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				if(affecting.take_damage(0, removed * power * 0.1))
					H.UpdateDamageIcon()
				if(prob(100 * removed / meltdose)) // Applies disfigurement
					H.emote("scream")
					H.status_flags |= DISFIGURED
		else
			M.take_organ_damage(0, removed * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

/decl/reagent/acid/touch_obj(var/obj/O,  var/amount, var/datum/reagents/holder)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (amount > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(get_turf(O))
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(get_turf(O), 5))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		remove_self(meltdose, holder) // 10 units of acid will not melt EVERYTHING on the tile

/decl/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8
	taste_description = "stomach acid"
	fallback_specific_heat = 1.710

/decl/reagent/acid/polyacid //Not in dispensers, but it should be here
	name = "Polytrinic Acid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	reagent_state = LIQUID
	color = "#8E18A9"
	power = 6
	meltdose = 4
	taste_description = "acid"

/decl/reagent/acid/stomach
	name = "Stomach Acid"
	taste_description = "coppery foulness"
	power = 2
	color = "#d8ff00"

/decl/reagent/silicon
	name = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8"
	taste_description = "metal"
	fallback_specific_heat = 2.650

/decl/reagent/sodium
	name = "Sodium"
	description = "A chemical element, readily reacts with water."
	reagent_state = SOLID
	color = "#808080"
	taste_description = "salty metal"
	fallback_specific_heat = 0.483

/decl/reagent/sugar
	name = "Sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "sugar"
	taste_mult = 1.8

	glass_icon_state = "iceglass"
	glass_name = "glass of sugar"
	glass_desc = "You can feel your blood sugar rising just looking at this."

	fallback_specific_heat = 0.332
	condiment_name = "sugar sack"
	condiment_desc = "Tasty space sugar!"
	condiment_icon_state = "sugar"

/decl/reagent/sugar/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustNutritionLoss(-removed*3)

/decl/reagent/sulfur
	name = "Sulfur"
	description = "A chemical element with a pungent smell."
	reagent_state = SOLID
	color = "#BF8C00"
	taste_description = "rotten eggs"
	scannable = TRUE

	fallback_specific_heat = 0.503

/decl/reagent/sulfur/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if (alien & IS_VAURCA)
		M.add_chemical_effect(CE_BLOODRESTORE, 3 * removed)

/decl/reagent/tungsten
	name = "Tungsten"
	description = "A chemical element, and a strong oxidising agent."
	reagent_state = SOLID
	color = "#DCDCDC"
	taste_mult = 0 //no taste
	fallback_specific_heat = 18

	fallback_specific_heat = 0.859
