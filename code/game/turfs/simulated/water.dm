/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/simulated/floor/beach/sand
	name = "sand"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	footstep_sound = /singleton/sound_category/water_footstep

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"
	footstep_sound = /singleton/sound_category/water_footstep
	movement_cost = 2
	var/watertype = "water5"
	var/obj/effect/water_effect/water_overlay
	var/numobjects = 0

/turf/simulated/floor/beach/water/alt
	name = "water"
	icon_state = "seadeep"
	watertype = "poolwater"

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

/obj/effect/water_effect
	name = "water"
	icon = 'icons/misc/beach.dmi'
	layer = MOB_LAYER+0.1
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	unacidable = TRUE

/turf/simulated/floor/beach/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/beach/water/Initialize()
	. = ..()
	var/obj/effect/water_effect/W = new /obj/effect/water_effect(src)
	W.icon_state = watertype
	water_overlay = W
	create_reagents(2)

/turf/simulated/floor/beach/water/Destroy()
	if(water_overlay)
		qdel(water_overlay)
		water_overlay = null
	return ..()

/turf/simulated/floor/beach/water/return_air_for_internal_lifeform(var/mob/living/carbon/L)
	if(L && L.lying)
		if(L.can_breathe_water() || (istype(L.wear_mask, /obj/item/clothing/mask/snorkel)))
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			var/amount = 300
			water_breath.adjust_gas(GAS_OXYGEN, amount) // Assuming water breathes just extract the oxygen directly from the water.
			water_breath.temperature = above_air.temperature
			return water_breath
		else
			var/gasid = GAS_CO2
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.species && H.species.exhale_type)
					gasid = H.species.exhale_type
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			water_breath.adjust_gas(gasid, ONE_ATMOSPHERE) // this will cause them to suffocate, but not pop their lung
			water_breath.temperature = above_air.temperature
			return water_breath
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/beach/water/Entered(atom/movable/AM, atom/oldloc)
	if(!(SSATOMS_IS_PROBABLY_DONE))
		return
	reagents.add_reagent(/singleton/reagent/water, 2)
	clean(src)
	START_PROCESSING(SSprocessing, src)
	if(istype(AM, /obj))
		numobjects += 1
	else if(istype(AM, /mob/living))
		numobjects += 1
		var/mob/living/L = AM
		if(!istype(oldloc, /turf/simulated/floor/beach/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
		wash(L)
	..()

/turf/simulated/floor/beach/water/Exited(atom/movable/AM, atom/newloc)
	if(!SSATOMS_IS_PROBABLY_DONE)
		return
	reagents.add_reagent(/singleton/reagent/water, 2)
	clean(src)
	if(istype(AM, /obj) && numobjects)
		numobjects -= 1
	else if(istype(AM, /mob/living))
		if(numobjects)
			numobjects -= 1
		var/mob/living/L = AM
		if(!istype(newloc, /turf/simulated/floor/beach/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/beach/water/process()
	reagents.add_reagent(/singleton/reagent/water, 2)
	clean(src)
	for(var/mob/living/L in src)
		wash(L)
	if(!numobjects)
		STOP_PROCESSING(SSprocessing, src)

/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/carbon/human/can_breathe_water()
	if(species)
		return species.can_breathe_water()
	return ..()

// Taken from shower
/turf/simulated/floor/beach/water/proc/wash(atom/movable/O as obj|mob)

	var/obj/effect/effect/water/W = new(O)
	W.create_reagents(100)
	W.reagents.add_reagent(/singleton/reagent/water, 100)
	W.set_up(O, 100)

	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		H.wash()

	if(isobj(O))
		var/obj/object = O
		object.clean()

	if(isturf(loc))
		var/turf/tile = loc
		tile.clean_blood()
		tile.remove_cleanables()
