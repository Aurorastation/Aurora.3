/datum/reagent/blood
	data = list(
		"donor" = null,
		"viruses" = null,
		"species" = "Human",
		"blood_DNA" = null,
		"blood_type" = null,
		"blood_colour" = "#A10808",
		"resistances" = null,
		"trace_chem" = null,
		"antibodies" = list()
	)
	name = "Blood"
	id = "blood"
	reagent_state = LIQUID
	metabolism = REM * 5
	color = "#C80000"
	taste_description = "iron"
	taste_mult = 1.3

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

	fallback_specific_heat = 3.617

/datum/reagent/blood/initialize_data(var/newdata)
	..()
	if(data && data["blood_colour"])
		color = data["blood_colour"]
	return

/datum/reagent/blood/get_data() // Just in case you have a reagent that handles data differently.
	var/t = data.Copy()
	if(t["virus2"])
		var/list/v = t["virus2"]
		t["virus2"] = v.Copy()
	return t

/datum/reagent/blood/mix_data(var/newdata, var/newamount) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	if(data["viruses"] || newdata["viruses"])
		var/list/mix1 = data["viruses"]
		var/list/mix2 = newdata["viruses"]
		var/list/to_mix = list() // Stop issues with the list changing during mixing.
		for(var/datum/disease/advance/AD in mix1)
			to_mix += AD
		for(var/datum/disease/advance/AD in mix2)
			to_mix += AD
		var/datum/disease/advance/AD = Advance_Mix(to_mix)
		if(AD)
			var/list/preserve = list(AD)
			for(var/D in data["viruses"])
				if(!istype(D, /datum/disease/advance))
					preserve += D
			data["viruses"] = preserve

/datum/reagent/blood/touch_turf(var/turf/simulated/T)

	if(!istype(T) || volume < 3)
		return

	var/datum/weakref/W = data["donor"]
	if (!W)
		blood_splatter(T, src, 1)
		return

	W = W.resolve()
	if(istype(W, /mob/living/carbon/human))
		blood_splatter(T, src, 1)

	else if(istype(W, /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		if (M.mind && M.mind.vampire)
			if(M.dna.unique_enzymes == data["blood_DNA"]) //so vampires can't drink their own blood
				return
			M.mind.vampire.blood_usable += removed
			to_chat(M, "<span class='notice'>You have accumulated [M.mind.vampire.blood_usable] [M.mind.vampire.blood_usable > 1 ? "units" : "unit"] of usable blood. It tastes quite stale.</span>")
			return
	if(dose > 5)
		M.adjustToxLoss(removed)
	if(dose > 15)
		M.adjustToxLoss(removed)
	if(data && data["viruses"])
		for(var/datum/disease/D in data["viruses"])
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS)
				continue
			if(D.spread_type in list(CONTACT_FEET, CONTACT_HANDS, CONTACT_GENERAL))
				M.contract_disease(D)
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())

/datum/reagent/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_MACHINE)
		return
	if(data && data["viruses"])
		for(var/datum/disease/D in data["viruses"])
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS)
				continue
			if(D.spread_type in list(CONTACT_FEET, CONTACT_HANDS, CONTACT_GENERAL))
				M.contract_disease(D)
	if(data && data["virus2"])
		var/list/vlist = data["virus2"]
		if(vlist.len)
			for(var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]
				if(V.spreadtype == "Contact")
					infect_virus2(M, V.getcopy())
	if(data && data["antibodies"])
		M.antibodies |= data["antibodies"]

/datum/reagent/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.inject_blood(src, volume)
	remove_self(volume)

/datum/reagent/blood/proc/get_diseases()
	. = list()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/D = thing
			. += D

/datum/reagent/vaccine
	name = "Vaccine"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#C81040"
	taste_description = "slime"
	fallback_specific_heat = 1.2

/datum/reagent/vaccine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(data)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == data)
					D.cure()
			else
				if(D.type == data)
					D.cure()

		M.resistances += data
	return

// pure concentrated antibodies
/datum/reagent/antibodies
	data = list("antibodies"=list())
	name = "Antibodies"
	id = "antibodies"
	reagent_state = LIQUID
	color = "#0050F0"
	taste_description = "slime"
	fallback_specific_heat = 1.5

/datum/reagent/antibodies/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(src.data)
		M.antibodies |= src.data["antibodies"]
	..()

#define WATER_LATENT_HEAT 19000 // How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
/datum/reagent/water
	name = "Water"
	id = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = LIQUID
	color = "#0064C877"
	metabolism = REM * 2
	ingest_met = REM * 10
	touch_met = REM * 30
	taste_description = "water"

	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."

	unaffected_species = IS_MACHINE

	specific_heat = 1.541

	germ_adjust = 0.05 // i mean, i guess you could try...

/datum/reagent/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(!istype(M))
		return
	M.adjustHydrationLoss(-6*removed)

/datum/reagent/water/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(lowertemp.temperature-2000, lowertemp.temperature / 2, T0C)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		T.wet_floor(WET_TYPE_WATER,volume)

/datum/reagent/water/touch_obj(var/obj/O)
	if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		var/obj/item/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/datum/reagent/water/touch_mob(var/mob/M, var/amount)
	. = ..()
	if(istype(M) && isliving(M))
		var/mob/living/L = M
		var/needed = min(L.fire_stacks, amount)
		L.ExtinguishMob(needed)
		remove_self(needed)

	if(istype(M) && !istype(M, /mob/abstract))
		M.color = initial(M.color)

/datum/reagent/water/affect_touch(var/mob/living/carbon/slime/S, var/alien, var/removed)
	if(istype(S))
		S.adjustToxLoss( volume * (removed/REM) * 0.23 )
		if(!S.client)
			if(S.target) // Like cats
				S.target = null
				++S.discipline
		if(dose == removed)
			S.visible_message(span("warning", "[S]'s flesh sizzles where the water touches it!"), span("danger", "Your flesh burns in the water!"))


/datum/reagent/water/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/slime))
		var/mob/living/carbon/slime/S = M
		S.adjustToxLoss(12 * removed) // A slime having water forced down its throat would cause much more damage then being splashed on it
		if(!S.client && S.target)
			S.target = null
			++S.discipline


/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flammable."
	reagent_state = LIQUID
	color = "#660000"
	touch_met = 5
	taste_description = "gross metal"

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

	fallback_specific_heat = 0.605

/datum/reagent/fuel/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/fuel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/obj/item/organ/internal/augment/fuel_cell/aug = M.internal_organs_by_name[BP_AUG_FUEL_CELL]
	if(aug && !aug.is_broken())
		M.adjustNutritionLoss(-8 * removed)
	else
		M.adjustToxLoss(2 * removed)

/datum/reagent/fuel/touch_mob(var/mob/living/L, var/amount)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
