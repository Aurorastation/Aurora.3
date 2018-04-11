/datum/reagent/secret
    nospawn = 1

/datum/reagent/secret/estus
	name = "liquid light"
	id = "estus"
	description = "This impossible substance slowly converts from a liquid into actual light."
	reagent_state = LIQUID
	color = "#ffff40"
	scannable = 1
	metabolism = REM * 0.25
	taste_description = "bottled fire"
	var/datum/modifier/modifier

/datum/reagent/secret/estus/affect_blood(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isskeleton(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/secret/estus/affect_ingest(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isskeleton(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/secret/estus/affect_touch(var/mob/living/carbon/M, var/removed)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/luminous, MODIFIER_REAGENT, src, _strength = 4, override = MODIFIER_OVERRIDE_STRENGTHEN)
	if(isskeleton(M))
		M.heal_organ_damage(10 * removed, 15 * removed)

/datum/reagent/secret/liquid_fire
	name = "Liquid Fire"
	id = "liquid_fire"
	description = "A dangerous flammable chemical, capable of causing fires when in contact with organic matter."
	reagent_state = LIQUID
	color = "#E25822"
	touch_met = 5
	taste_description = "metal"

/datum/reagent/secret/liquid_fire/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M))
		M.adjust_fire_stacks(10)
		M.IgniteMob()

/datum/reagent/secret/liquid_fire/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(10)
		L.IgniteMob()

/datum/reagent/secret/black_matter
	name = "Unstable Black Matter"
	id = "black_matter"
	description = "A pitch black blend of cosmic origins, handle with care."
	color = "#000000"
	taste_description = "emptyness"

/datum/reagent/secret/touch_turf(var/turf/T)
	var/obj/effect/portal/P = new /obj/effect/portal(T)
	P.creator = null
	P.icon = 'icons/obj/objects.dmi'
	P.failchance = 0
	P.icon_state = "anom"
	P.name = "wormhole"
	var/list/pick_turfs = list()
	for(var/turf/simulated/floor/exit in turfs)
		if(exit.z in current_map.station_levels)
			pick_turfs += exit
	P.target = pick(pick_turfs)
	QDEL_IN(P, rand(150,300))
	remove_self(volume)
	return

/datum/reagent/secret/bluespace_dust
	name = "Bluespace Dust"
	id = "bluespace_dust"
	description = "A dust composed of microscopic bluespace crystals."
	color = "#1f8999"
	taste_description = "fizzling blue"

/datum/reagent/secret/bluespace_dust/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(25))
		M.make_jittery(5)
		M << "<span class='warning'>You feel unstable...</span>"

	if(prob(10))
		do_teleport(M, get_turf(M), 5, asoundin = 'sound/effects/phasein.ogg')

/datum/reagent/secret/bluespace_dust/touch_mob(var/mob/living/L, var/amount)
	do_teleport(L, get_turf(L), amount, asoundin = 'sound/effects/phasein.ogg')

/datum/reagent/secret/philosopher_stone
	name = "Philosopher's Stone"
	id = "philosopher_stone"
	description = "A mythical compound, rumored to be the catalyst of fantastic reactions."
	color = "#f4c430"
	taste_description = "heavenly knowledge"

/datum/reagent/secret/elixir
	name = "Elixir of Life"
	id = "elixir_life"
	description = "A mythical substance, the cure for the ultimate illness."
	color = "#ffd700"
	affects_dead = 1
	taste_description = "eternal blissfulness"

/datum/reagent/secret/elixir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		if(M && M.stat == DEAD)
			M.adjustOxyLoss(-rand(15,20))
			M.visible_message("<span class='danger'>\The [M] shudders violently!</span>")
			M.stat = 0

/datum/reagent/secret/azoth
	name = "Azoth"
	id = "azoth"
	description = "Azoth is a miraculous medicine, capable of healing internal injuries."
	reagent_state = LIQUID
	color = "#BF0000"
	taste_description = "bitter metal"
	overdose = 5

/datum/reagent/secret/azoth/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/A in H.organs)
			var/obj/item/organ/external/E = A
			for (var/X in E.wounds)
				var/datum/wound/W = X
				if (W && W.internal)
					E.wounds -= W
					return 1

			if(E.status & ORGAN_BROKEN)
				E.status &= ~ORGAN_BROKEN
				E.stage = 0
				return 1

/datum/reagent/secret/azoth/overdose(var/mob/living/carbon/M, var/alien)
	M.adjustBruteLoss(5)

