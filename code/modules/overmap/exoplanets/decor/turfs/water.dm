/turf/simulated/floor/exoplanet/water
	does_footprint = FALSE

/turf/simulated/floor/exoplanet/water/update_icon()
	return

/turf/simulated/floor/exoplanet/water/update_dirt()
	return	// Water doesn't become dirty

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
