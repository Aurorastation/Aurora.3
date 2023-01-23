/decl/reagent/blood
	name = "Blood"
	reagent_state = LIQUID
	metabolism = REM * 5
	color = "#C80000"
	taste_description = "iron"
	taste_mult = 1.3

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

	fallback_specific_heat = 3.617

/decl/reagent/blood/initialize_data(newdata, datum/reagents/holder)
	. = ..()
	if(.)
		LAZYINITLIST(.["trace_chem"])

/decl/reagent/blood/proc/handle_trace_chems(var/datum/reagents/holder)
	var/list/trace_chems = holder.reagent_data[type]["trace_chem"]
	for(var/chem in trace_chems)
		var/decl/reagent/R = decls_repository.get_decl(chem)
		trace_chems[chem] = trace_chems[chem] - (R.metabolism / 10) // work your way out of the body but at 10th the speed
		if(trace_chems[chem] < 0)
			trace_chems -= chem
	holder.reagent_data[type]["trace_chem"] = trace_chems

/decl/reagent/blood/mix_data(var/list/newdata, var/newamount, var/datum/reagents/holder)
	var/list/data = ..()
	if(LAZYACCESS(newdata, "trace_chem"))
		var/list/other_chems = LAZYACCESS(newdata, "trace_chem")
		if(!data)
			data = newdata.Copy()
		else if(!length(data["trace_chem"]))
			data["trace_chem"] = other_chems.Copy()
		else
			var/list/my_chems = data["trace_chem"]
			for(var/chem in other_chems)
				my_chems[chem] = my_chems[chem] + other_chems[chem]
	var/datum/weakref/W = LAZYACCESS(data, "donor")
	var/mob/living/carbon/self = W?.resolve()
	if(!(MODE_VAMPIRE in self?.mind?.antag_datums) && blood_incompatible(LAZYACCESS(newdata, "blood_type"), LAZYACCESS(data, "blood_type"), LAZYACCESS(newdata, "species"), LAZYACCESS(data, "species")))
		remove_self(newamount * 0.5, holder) // So the blood isn't *entirely* useless
		var/mob/living/carbon/human/recipient = holder.my_atom
		if(istype(recipient) && holder == recipient.vessel)
			recipient.reagents.add_reagent(/decl/reagent/toxin/coagulated_blood, newamount * 0.5)
			// it has no effect if added to the vessel
		else
			holder.add_reagent(/decl/reagent/toxin/coagulated_blood, newamount * 0.5)
	. = data

/decl/reagent/blood/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)

	if(!istype(T) || amount < 3)
		return
	var/list/rdata = REAGENT_DATA(holder, type)
	if(isemptylist(rdata))
		return
	var/datum/weakref/W = rdata["donor"]
	var/mob/living/carbon/C = W?.resolve()
	if (!C || istype(C, /mob/living/carbon/human))
		blood_splatter(T, src, 1)
		return

	else if(istype(C, /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/decl/reagent/blood/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		if (M.mind && (MODE_VAMPIRE in M.mind.antag_datums))
			if(LAZYLEN(REAGENT_DATA(holder, type) && M.dna.unique_enzymes == LAZYACCESS(holder.reagent_data[type], "blood_DNA"))) //so vampires can't drink their own blood
				return
			var/datum/vampire/vampire = M.mind.antag_datums[MODE_VAMPIRE]
			vampire.blood_usable += removed
			to_chat(M, "<span class='notice'>You have accumulated [vampire.blood_usable] unit\s of usable blood. It tastes quite stale.</span>")
			return
	var/dose = M.chem_doses[type]
	if(dose > 15)
		M.adjustToxLoss(removed * 2)
	else if(dose > 5)
		M.adjustToxLoss(removed)

/decl/reagent/blood/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_MACHINE)
		return

/decl/reagent/blood/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.inject_blood(REAGENT_VOLUME(holder, type), holder)
	remove_self(REAGENT_VOLUME(holder, type), holder)

#define WATER_LATENT_HEAT 19000 // How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
/decl/reagent/water
	name = "Water"
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

/decl/reagent/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return
	M.adjustHydrationLoss(-6*removed)

/decl/reagent/water/touch_turf(var/turf/simulated/T, var/amount, var/datum/reagents/holder)
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
		var/removed_heat = between(0, amount * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(amount >= 10)
		T.wet_floor(WET_TYPE_WATER,amount)

/decl/reagent/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		var/obj/item/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/decl/reagent/water/touch_mob(var/mob/M, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(M) && isliving(M))
		var/mob/living/L = M
		var/needed = min(L.fire_stacks, amount)
		L.ExtinguishMob(needed)
		remove_self(needed, holder)

	if(istype(M) && !istype(M, /mob/abstract))
		M.color = initial(M.color)

/decl/reagent/water/affect_touch(var/mob/living/carbon/slime/S, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(S))
		S.adjustToxLoss( REAGENT_VOLUME(holder, type) * (removed/REM) * 0.23 )
		if(!S.client)
			if(S.target) // Like cats
				S.target = null
				++S.discipline
		if(S.chem_doses[type] == removed)
			S.visible_message(SPAN_WARNING("[S]'s flesh sizzles where the water touches it!"), SPAN_DANGER("Your flesh burns in the water!"))


/decl/reagent/water/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(istype(M, /mob/living/carbon/slime))
		var/mob/living/carbon/slime/S = M
		S.adjustToxLoss(12 * removed) // A slime having water forced down its throat would cause much more damage then being splashed on it
		if(!S.client && S.target)
			S.target = null
			++S.discipline


/decl/reagent/fuel
	name = "Welding Fuel"
	description = "Required for welders. Flammable."
	reagent_state = LIQUID
	color = "#660000"
	touch_met = 5
	taste_description = "gross metal"

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

	fallback_specific_heat = 0.605

/decl/reagent/fuel/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	new /obj/effect/decal/cleanable/liquid_fuel(T, amount)
	remove_self(amount, holder)
	return

/decl/reagent/fuel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/obj/item/organ/internal/augment/fuel_cell/aug = M.internal_organs_by_name[BP_AUG_FUEL_CELL]
	if(aug && !aug.is_broken())
		M.adjustNutritionLoss(-8 * removed)
	else
		M.adjustToxLoss(2 * removed)

/decl/reagent/fuel/touch_mob(var/mob/living/L, var/amount, var/datum/reagents/holder)
	. = ..()
	if(istype(L))
		L.adjust_fire_stacks(amount / 10) // Splashing people with welding fuel to make them easy to ignite!
