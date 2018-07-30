/datum/reagent/acetone
	name = "Acetone"
	id = "acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	taste_description = "acid"

/datum/reagent/acetone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed * 3)

/datum/reagent/acetone/touch_obj(var/obj/O)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	if(istype(O, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution dissolves the ink on the paper."
		return
	if(istype(O, /obj/item/weapon/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/weapon/book/tome))
			usr << "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>"
			return
		var/obj/item/weapon/book/affectedbook = O
		affectedbook.dat = null
		usr << "<span class='notice'>The solution dissolves the ink on the book.</span>"
	return

/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8"
	taste_description = "metal"
	taste_mult = 1.1

/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners. Poisonous to most lifeforms, lingers for a while if inhaled."
	reagent_state = LIQUID
	color = "#404030"
	metabolism = REM * 0.5
	taste_description = "mordant"
	taste_mult = 2
	breathe_mul = 2
	breathe_met = REM * 0.25

/datum/reagent/ammonia/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustOxyLoss(-removed * 10)
	else
		M.adjustToxLoss(removed * 1.5)

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the builing block of life."
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5
	taste_description = "sour chalk"
	taste_mult = 1.5

/datum/reagent/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.ingested && M.ingested.reagent_list.len > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (M.ingested.reagent_list.len - 1)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(R == src)
				continue
			M.ingested.remove_reagent(R.id, removed * effect)

/datum/reagent/carbon/touch_turf(var/turf/T)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	color = "#6E3B08"
	taste_description = "copper"

/datum/reagent/alcohol //Parent class for all alcoholic reagents, though this one shouldn't be used anywhere.
	name = null	// This null name should prevent alcohol from being added to global lists.
	id = "alcohol"
	description = "An abstract type you shouldn't be able to see."
	reagent_state = LIQUID
	color = "#404030"

	var/nutriment_factor = 0.5
	var/strength = 100 // This is the Alcohol By Volume of the drink, value is in the range 0-100 unless you wanted to create some bizarre bluespace alcohol with <100

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0
	var/datum/modifier/caffeine_mod
	var/caffeine  = 0

	var/flammability_divisor = 10

	unaffected_species = IS_MACHINE

	taste_description = "mistakes"

	glass_icon_state = "glass_clear"
	glass_name = "glass of coder fuckups"
	glass_desc = "A glass of distilled maintainer tears."

/datum/reagent/alcohol/Destroy()
	if (caffeine_mod)
		QDEL_NULL(caffeine_mod)

	return ..()

/datum/reagent/alcohol/touch_mob(mob/living/L, amount)
	if (istype(L) && strength > 40)
		L.adjust_fire_stacks((amount / (flammability_divisor || 1)) * (strength / 100))

/datum/reagent/alcohol/affect_blood(mob/living/carbon/M, alien, removed)
	M.adjustToxLoss(removed * 2)

/datum/reagent/alcohol/affect_ingest(mob/living/carbon/M, alien, removed)

	M.intoxication += (strength / 100) * removed

	if (druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if (adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if (adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if (halluci)
		M.hallucination = max(M.hallucination, halluci)

	if (caffeine && !caffeine_mod)
		caffeine_mod = M.add_modifier(/datum/modifier/stimulant, MODIFIER_REAGENT, src, _strength = caffeine, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/alcohol/ethanol
	name = "Ethanol"
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	ingest_met = 0.5
	flammability_divisor = 10

	taste_description = "pure alcohol"

	glass_icon_state = "glass_clear"
	glass_name = "glass of ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/alcohol/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VAURCA)//Vaurca are damaged instead of getting nutrients, but they can still get drunk
		M.adjustToxLoss(1.5 * removed * (strength / 100))
	else
		M.nutrition += nutriment_factor * removed

	if(alien == IS_DIONA)
		return //Diona can gain nutrients, but don't get drunk or suffer other effects

	if (alien == IS_UNATHI)//unathi are poisoned by alcohol as well
		M.adjustToxLoss(1.5 * removed * (strength / 100))

	..()

/datum/reagent/alcohol/ethanol/touch_obj(var/obj/O)
	if(istype(O, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution dissolves the ink on the paper."
		return
	if(istype(O, /obj/item/weapon/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/weapon/book/tome))
			usr << "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>"
			return
		var/obj/item/weapon/book/affectedbook = O
		affectedbook.dat = null
		usr << "<span class='notice'>The solution dissolves the ink on the book.</span>"
	return


// Butanol is a common alcohol that is fairly ineffective for humans and most other species, but highly intoxicating to unathi.
// Most behavior is inherited from alcohol.
/datum/reagent/alcohol/butanol
	name = "Butanol"
	id = "butanol"
	description = "A fairly harmless alcohol that has intoxicating effects on certain species."
	reagent_state = LIQUID
	color = "#404030"
	ingest_met = 0.17 //Extremely slow metabolic rate means the liver will generally purge it faster than it can intoxicate you
	flammability_divisor = 7	//Butanol is a bit less flammable than ethanol

	taste_description = "alcohol"

	glass_icon_state = "glass_clear"
	glass_name = "glass of butanol"
	glass_desc = "A fairly harmless alcohol that has intoxicating effects on certain species."

/datum/reagent/alcohol/butanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (alien == IS_VAURCA)
		M.adjustToxLoss(removed * (strength / 100))
	else
		M.nutrition += nutriment_factor * removed

	if (alien == IS_UNATHI)
		ingest_met = initial(ingest_met)*3

	..()

/datum/reagent/hydrazine
	name = "Hydrazine"
	id = "hydrazine"
	description = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	taste_description = "sweet tasting metal"

/datum/reagent/hydrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(4 * removed)

/datum/reagent/hydrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // Hydrazine is both toxic and flammable.
	M.adjust_fire_stacks(removed / 12)
	M.adjustToxLoss(0.2 * removed)

/datum/reagent/hydrazine/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	color = "#353535"
	taste_description = "metal"

/datum/reagent/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	reagent_state = SOLID
	color = "#808080"
	taste_description = "metal"

/datum/reagent/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.canmove && !M.restrained() && !(istype(M.loc, /turf/space)))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	reagent_state = LIQUID
	color = "#484848"
	ingest_met = REM*0.2
	taste_mult = 0 //mercury apparently is tasteless

/datum/reagent/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.canmove && !M.restrained() && !(istype(M.loc, /turf/space)))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

	M.adjustBrainLoss(removed)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	reagent_state = SOLID
	color = "#832828"
	taste_description = "vinegar"

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0"
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#C7C7C7"
	taste_description = "the color blue, and regret"
	unaffected_species = IS_MACHINE

/datum/reagent/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_effect(10 * removed, IRRADIATE, blocked = 0) // Radium may increase your chances to cure a disease
	if(alien == IS_DIONA)
		M.adjustToxLoss(-20 * removed)
		return
	if(M.virus2.len)
		for(var/ID in M.virus2)
			var/datum/disease2/disease/V = M.virus2[ID]
			if(prob(5))
				M.antibodies |= V.antigen
				if(prob(50))
					M.apply_effect(50, IRRADIATE, blocked = 0) // curing it that way may kill you instead
					var/absorbed = 0
					var/obj/item/organ/diona/nutrients/rad_organ = locate() in M.internal_organs
					if(rad_organ && !rad_organ.is_broken())
						absorbed = 1
					if(!absorbed)
						M.adjustToxLoss(100)

/datum/reagent/radium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	reagent_state = LIQUID
	color = "#DB5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 4
	var/meltdose = 10 // How much is needed to melt
	taste_description = "acid"

/datum/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power)

/datum/reagent/acid/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed)
	. = ..()
	if(istype(H))
		var/obj/item/organ/L = H.internal_organs_by_name["lungs"]
		if(istype(L))
			L.take_damage(removed * power * 0.5)

/datum/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				H << "<span class='danger'>Your [H.head] protects you from the acid.</span>"
				remove_self(volume)
				return
			else if(removed > meltdose)
				H << "<span class='danger'>Your [H.head] melts away!</span>"
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				H << "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>"
				remove_self(volume)
				return
			else if(removed > meltdose)
				H << "<span class='danger'>Your [H.wear_mask] melts away!</span>"
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				H << "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>"
				removed /= 2
			else if(removed > meltdose)
				H << "<span class='danger'>Your [H.glasses] melt away!</span>"
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
		return
	if(!M.unacidable && removed > 0)
		if(istype(M, /mob/living/carbon/human) && volume >= meltdose)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/affecting = H.get_organ("head")
			if(affecting)
				if(affecting.take_damage(0, removed * power * 0.1))
					H.UpdateDamageIcon()
				if(prob(100 * removed / meltdose)) // Applies disfigurement
					if (!(H.species && (H.species.flags & NO_PAIN)))
						H.emote("scream")
					H.status_flags |= DISFIGURED
		else
			M.take_organ_damage(0, removed * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is not as dangerous, b) it's a one-use weapon, c) missing with it will splash it over the ground and d) clothes give some protection, so not everything will hit

/datum/reagent/acid/touch_obj(var/obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (volume > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			M << "<span class='warning'>\The [O] melts.</span>"
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	id = "hclacid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8
	taste_description = "stomach acid"

/datum/reagent/acid/polyacid //Not in dispensers, but it should be here
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	reagent_state = LIQUID
	color = "#8E18A9"
	power = 6
	meltdose = 4
	taste_description = "acid"

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8"
	taste_description = "metal"

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	reagent_state = SOLID
	color = "#808080"
	taste_description = "salty metal"

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF"
	taste_description = "sugar"
	taste_mult = 1.8

	glass_icon_state = "iceglass"
	glass_name = "glass of sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."

/datum/reagent/sugar/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition += removed * 3

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	reagent_state = SOLID
	color = "#BF8C00"
	taste_description = "old eggs"

/datum/reagent/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	reagent_state = SOLID
	color = "#DCDCDC"
	taste_mult = 0 //no taste
