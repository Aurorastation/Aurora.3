/turf/simulated/floor/exoplanet/water
	does_footprint = FALSE
	footstep_sound = /singleton/sound_category/water_footstep
	var/deep = TRUE //too deep to keep your head above it?
	var/obj/effect/water_effect/water_overlay
	movement_cost = 4

/turf/simulated/floor/exoplanet/water/update_icon()
	return

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty

/turf/simulated/floor/exoplanet/water/Initialize()
	. = ..()
	if(deep)
		var/obj/effect/water_effect/W = new /obj/effect/water_effect(src)
		W.icon = icon
		W.icon_state = icon_state
		water_overlay = W
		W.alpha = 128

/turf/simulated/floor/exoplanet/water/Destroy()
	if(water_overlay)
		qdel(water_overlay)
		water_overlay = null
	return ..()

/turf/simulated/floor/exoplanet/water/return_air_for_internal_lifeform(var/mob/living/carbon/L)
	if(!L)
		return
	if(L.lying || deep) //are they lying down/is the water deep enough to keep their head above it?
		if(water_overlay && L.layer > water_overlay.layer) //are they on a vehicle or something else that physically puts them above the water?
			return return_air()
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
	return return_air()

/turf/simulated/floor/exoplanet/water/Entered(atom/movable/AM, atom/oldloc)
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

/turf/simulated/floor/exoplanet/water/Exited(atom/movable/AM, atom/newloc)
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

/turf/simulated/floor/exoplanet/water/konyang
	name = "deep glistening water"
	desc = "Water, dense with algae and lustrous greenery. It maintains an almost glowing sea-blue sheen nonetheless."
	icon_state = "unsmooth"
	base_icon_state = "unsmooth"
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_deep_water.dmi'
	smoothing_flags = SMOOTH_TRUE

/turf/simulated/floor/exoplanet/water/shallow
	name = "shallow water"
	icon = 'icons/misc/beach.dmi'
	icon_state = "seashallow"
	footstep_sound = /singleton/sound_category/water_footstep
	deep = FALSE
	var/reagent_type = /singleton/reagent/water

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/O, var/mob/living/user)
	var/obj/item/reagent_containers/RG = O
	if (reagent_type && istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent(reagent_type, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] from \the [src].</span>","<span class='notice'>You fill \the [RG] from \the [src].</span>")
	else
		return ..()

/turf/simulated/floor/exoplanet/water/shallow/konyang
	name = "shallow glistening water"
	desc = "Water, dense with algae and lustrous greenery. It maintains an almost glowing sea-blue sheen nonetheless."
	icon_state = "unsmooth"
	base_icon_state = "unsmooth"
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_smooth_water.dmi'
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	canSmoothWith = list(/turf/simulated/floor/exoplanet/water/shallow/konyang, /turf/simulated/floor/exoplanet/water/konyang, /turf/simulated/floor/exoplanet/water/shallow/konyang/beach)

/turf/simulated/floor/exoplanet/water/shallow/konyang/no_smooth
	smoothing_flags = SMOOTH_FALSE

/turf/simulated/floor/exoplanet/water/shallow/konyang/beach
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_beach.dmi'
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	canSmoothWith = list(/turf/simulated/floor/exoplanet/water/shallow/konyang, /turf/simulated/floor/exoplanet/water/konyang, /turf/simulated/floor/exoplanet/water/shallow/konyang/beach)

/turf/simulated/floor/exoplanet/water/shallow/sewage//What horror.
	name = "putrid sewage"
	desc = "This is utterly vile."
	color = "#9ea844"//Ew
