/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'
	footstep_sound = "sandstep"

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	footstep_sound = "waterstep"

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"
	footstep_sound = "waterstep"
	movement_cost = 2
	var/watertype = "water5"

/turf/simulated/floor/beach/water/pool
	name = "pool"
	icon_state = "pool"
	watertype = "poolwater"

/turf/simulated/floor/beach/water/ocean
	name = "ocean"
	icon_state = "seadeep"
	movement_cost = 4

/turf/simulated/floor/beach/water/ocean/abyss
	name = "abyss"
	icon_state = "abyss"
	watertype = "seadeep"

/turf/simulated/floor/beach/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="[watertype]","layer"=MOB_LAYER+0.1))

/turf/simulated/floor/beach/water/return_air_for_internal_lifeform(var/mob/living/carbon/L)
	if(L && L.lying)
		if(L.can_breathe_water() || (istype(L.wear_mask, /obj/item/clothing/mask/snorkel)))
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			var/amount = 300
			water_breath.adjust_gas("oxygen", amount) // Assuming water breathes just extract the oxygen directly from the water.
			water_breath.temperature = above_air.temperature
			return water_breath
		else
			var/gasid = "carbon_dioxide"
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.species && H.species.exhale_type)
					gasid = H.species.exhale_type
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			water_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
			water_breath.temperature = above_air.temperature
			return water_breath
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/beach/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(!istype(oldloc, /turf/simulated/floor/beach/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
	AM.water_act(5)
	..()

/turf/simulated/floor/beach/water/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(!istype(newloc, /turf/simulated/floor/beach/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/carbon/human/can_breathe_water()
	if(species)
		return species.can_breathe_water()
	return ..()

// Use this to have things react to having water applied to them.
/atom/movable/proc/water_act(amount)
	return

/mob/living/water_act(amount)
	adjust_fire_stacks(-amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)