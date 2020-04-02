/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand"
	footstep_sound = "sand"

/turf/simulated/floor/beach/sand
	name = "sand"

/turf/simulated/floor/beach/sand/alt
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "sand_alt"

/turf/simulated/floor/beach/sand/desert
	icon_state = "desert"

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	footstep_sound = "water"

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"
	footstep_sound = "water"
	movement_cost = 2
	var/watertype = "water5"
	var/obj/effect/water_effect/water_overlay
	var/numobjects = 0

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
	if(!SSATOMS_IS_PROBABLY_DONE)
		return
	reagents.add_reagent("water", 2)
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
	reagents.add_reagent("water", 2)
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
	reagents.add_reagent("water", 2)
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
	W.reagents.add_reagent("water", 100)
	W.set_up(O, 100)

	if(iscarbon(O))
		var/mob/living/carbon/M = O
		if(M.r_hand)
			M.r_hand.clean_blood()
		if(M.l_hand)
			M.l_hand.clean_blood()
		if(M.back)
			if(M.back.clean_blood())
				M.update_inv_back(0)

		//flush away reagents on the skin
		if(M.touching)
			var/remove_amount = M.touching.maximum_volume * M.reagent_permeability() //take off your suit first
			M.touching.remove_any(remove_amount)

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/washgloves = 1
			var/washshoes = 1
			var/washmask = 1
			var/washears = 1
			var/washglasses = 1

			if(H.wear_suit)
				washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
				washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

			if(H.head)
				washmask = !(H.head.flags_inv & HIDEMASK)
				washglasses = !(H.head.flags_inv & HIDEEYES)
				washears = !(H.head.flags_inv & HIDEEARS)

			if(H.wear_mask)
				if (washears)
					washears = !(H.wear_mask.flags_inv & HIDEEARS)
				if (washglasses)
					washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head(0)
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit(0)
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform(0)
			if(H.gloves && washgloves)
				if(H.gloves.clean_blood())
					H.update_inv_gloves(0)
			if(H.shoes && washshoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes(0)
			if(H.wear_mask && washmask)
				if(H.wear_mask.clean_blood())
					H.update_inv_wear_mask(0)
			if(H.glasses && washglasses)
				if(H.glasses.clean_blood())
					H.update_inv_glasses(0)
			if(H.l_ear && washears)
				if(H.l_ear.clean_blood())
					H.update_inv_ears(0)
			if(H.r_ear && washears)
				if(H.r_ear.clean_blood())
					H.update_inv_ears(0)
			if(H.belt)
				if(H.belt.clean_blood())
					H.update_inv_belt(0)
			H.clean_blood(washshoes)
		else
			if(M.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
				if(M.wear_mask.clean_blood())
					M.update_inv_wear_mask(0)
			M.clean_blood()
	else
		O.clean_blood()

	if(istype(O, /obj/item/light))
		var/obj/item/light/L = O
		L.brightness_color = initial(L.brightness_color)
		L.update()
	else if(istype(O, /obj/machinery/light))
		var/obj/machinery/light/L = O
		L.brightness_color = initial(L.brightness_color)
		L.update()

	O.color = initial(O.color)

	if(isturf(loc))
		var/turf/tile = loc
		loc.clean_blood()
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/rune) || istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				qdel(E)
