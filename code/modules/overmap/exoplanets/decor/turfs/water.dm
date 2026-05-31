/turf/simulated/floor/exoplanet/water
	name = "water"
	gender = PLURAL
	icon = 'icons/misc/beach.dmi'
	icon_state = "seadeep"
	desc = "It is wet."
	footstep_sound = SFX_FOOTSTEP_WATER
	movement_cost = 4
	has_resources = FALSE
	///How many objects are currently on this turf? Used to stop empty water turfs from processing.
	var/numobjects = 0
	///Is this water deep enough to drown in?
	var/deep = TRUE
	///The overlay used to make it look like atoms on the turf are underwater.
	var/obj/effect/water_effect/water_overlay

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
	create_reagents(4)

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
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, src)
	if(lattice)
		return
	START_PROCESSING(SSprocessing, src)
	if(isobj(AM))
		numobjects += 1
	else if(isliving(AM))
		numobjects += 1
		var/mob/living/L = AM
		if(!istype(oldloc, /turf/simulated/floor/exoplanet/water))
			to_chat(L, SPAN_WARNING("You get drenched in water from entering \the [src]!"))
		wash(L)
	..()

/turf/simulated/floor/exoplanet/water/Exited(atom/movable/AM, atom/newloc)
	if(!SSATOMS_IS_PROBABLY_DONE)
		return
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, src)
	if(lattice)
		return
	if(isobj(AM) && numobjects)
		numobjects -= 1
	else if(isliving(AM))
		if(numobjects)
			numobjects -= 1
		var/mob/living/L = AM
		var/new_turf = get_step(src, newloc)
		if(!istype(new_turf, src))
			to_chat(L, SPAN_WARNING("You climb out of \the [src]."))
	..()

/turf/simulated/floor/exoplanet/water/process()
	for(var/mob/living/L in src)
		var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, src)
		if(!lattice)
			wash(L)
	if(!numobjects)
		STOP_PROCESSING(SSprocessing, src)

/turf/simulated/floor/exoplanet/water/konyang
	name = "deep glistening water"
	desc = "Water, dense with algae and lustrous greenery. It maintains an almost glowing sea-blue sheen nonetheless."
	icon_state = "unsmooth"
	base_icon_state = "unsmooth"
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_deep_water.dmi'
	smoothing_flags = SMOOTH_TRUE

/turf/simulated/floor/exoplanet/water/shallow
	name = "shallow water"
	desc = "Some water shallow enough to wade through."
	icon = 'icons/misc/beach.dmi'
	icon_state = "seashallow"
	footstep_sound = SFX_FOOTSTEP_WATER
	deep = FALSE
	var/reagent_type = /singleton/reagent/water

/turf/simulated/floor/exoplanet/water/shallow/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/reagent_containers/RG = attacking_item
	if (reagent_type && istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent(reagent_type, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(SPAN_NOTICE("[user] fills \the [RG] from \the [src]."),SPAN_NOTICE("You fill \the [RG] from \the [src]."))
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

/turf/simulated/floor/exoplanet/water/shallow/sewage/process()
	. = ..()
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, src) //you're not gonna get covered in disgusting sewer water if you have a grate/lattice over it
	if(lattice)
		return
	for(var/mob/living/carbon/human/H in src) // Sewage is poisonous.
		if(!H.reagents.has_reagent(/singleton/reagent/toxin, 10))
			H.reagents.add_reagent(/singleton/reagent/toxin, 1)
		if(!H.reagents.has_reagent(/singleton/reagent/ammonia, 10))
			H.reagents.add_reagent(/singleton/reagent/ammonia, 1)
		for(var/A in H.organs)
			var/obj/item/organ/external/E = A
			if(BP_IS_ROBOTIC(E))
				continue
			for(var/datum/wound/W as anything in E.wounds)
				if(W.germ_level < INFECTION_LEVEL_ONE)
					W.germ_level = INFECTION_LEVEL_ONE
				W.germ_level += rand(10, 50)

/turf/simulated/floor/exoplanet/water/shallow/moghes
	icon = 'icons/turf/flooring/exoplanet/moghes.dmi'
	icon_state = "water"

/turf/simulated/floor/exoplanet/water/proc/wash(atom/movable/O)

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

///////////// OVERLAY EFFECTS /////////////
/obj/effect/overlay/water
	icon = 'icons/turf/newwater.dmi'
	icon_state = "bottom"
	density = FALSE
	mouse_opacity = FALSE
	layer = DECAL_LAYER
	anchored = TRUE

/obj/effect/overlay/water/top
	icon_state = "top"

/turf/simulated/floor/exoplanet/water/smooth
	gender = PLURAL
	name = "water"
	icon = 'icons/turf/newwater.dmi'
	icon_state = "together"
	deep = FALSE
	footstep_sound = SFX_FOOTSTEP_WATER
	var/base_turf_icon = "together"
	var/obj/effect/overlay/water/water_bottom_overlay
	var/obj/effect/overlay/water/top/water_top_overlay
	smoothing_flags = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	var/water_color = "#6a9295"
	var/water_level = 2
	/// Whether the turf has a lattice on it or not, handled in initialize.
	var/has_lattice = FALSE
	/// Types we ignore when we update the overlay layer.
	var/static/list/ignored_types = typecacheof(list(
		/obj/structure/platform,
		/obj/structure/platform_deco,
		/obj/structure/bed/stool/chair/office/hover,
		/obj/structure/bed/stool/hover,
		/obj/structure/arch,
		/obj/structure/flora
	))

/turf/simulated/floor/exoplanet/water/smooth/Initialize()
	.  = ..()
	icon_state = base_turf_icon
	water_bottom_overlay = new(src)
	water_top_overlay = new(src)
	// bottom overlay
	water_bottom_overlay.color = water_color
	water_bottom_overlay.icon_state = "bottom[water_level]"
	// top overlay
	water_top_overlay.color = water_color
	water_top_overlay.icon_state = "top[water_level]"

	var/object_found
	for(var/obj/structure/thing in src)
		if(istype(thing, /obj/structure/lattice))
			has_lattice = TRUE
			movement_cost = 0
			return // no need to check further if there was an object in our turf initially, since lattice will block

		if(!is_type_in_typecache(thing, ignored_types))
			object_found = TRUE

	if(object_found) // if there is an object, start with adjusted layer
		water_bottom_overlay.layer = ABOVE_HUMAN_LAYER

/turf/simulated/floor/exoplanet/water/smooth/proc/update_overlay_layer(atom/movable/AM, entered = FALSE)
	if(!AM || AM.throwing || isghost(AM))
		return

	if(entered)
		// entered
		water_bottom_overlay?.layer = ABOVE_HUMAN_LAYER
	else
		// exited
		for(var/obj/structure/found_thing in src) // check if there's anything left in this turf that we care about, if so don't change the layer
			if(!is_type_in_typecache(found_thing, ignored_types))
				return

		water_bottom_overlay?.layer = BELOW_DOOR_LAYER

/turf/simulated/floor/exoplanet/water/smooth/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(has_lattice)
		return

	update_overlay_layer(AM, TRUE)

/turf/simulated/floor/exoplanet/water/smooth/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(has_lattice)
		return

	update_overlay_layer(AM)

/turf/simulated/floor/exoplanet/water/smooth/swamp
	name = "murk"
	desc = "Weeds and algae cover the surface of the water."
	water_color = "#705a43"
