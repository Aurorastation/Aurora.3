/turf/simulated/floor/exoplanet/water
	does_footprint = FALSE

/turf/simulated/floor/exoplanet/water/update_icon()
	return

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty

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
