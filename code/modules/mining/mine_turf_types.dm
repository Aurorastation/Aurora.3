// These are pricey, but damn do they look nice.
/turf/simulated/lava
	name = "lava"
	desc = "Liquid rock; it can melt flesh from bone in seconds."
	icon = 'icons/turf/smooth/lava.dmi'
	icon_state = "smooth"
	gender = PLURAL
	smoothing_flags = SMOOTH_TRUE | SMOOTH_BORDER
	light_color = LIGHT_COLOR_LAVA
	light_range = 2
	canSmoothWith = list(
			/turf/simulated/lava,
			/turf/simulated/mineral
	)
	openspace_override_type = /turf/simulated/open/chasm/airless
	movement_cost = 4	//moving on lava should slows you down

// Custom behavior here - we want smoothed turfs to show basalt underneath, not lava.
/turf/simulated/lava/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/basalt.dmi'
	underlay_appearance.icon_state = "basalt"
	if(prob(20))
		underlay_appearance.icon_state += "[rand(0,12)]"
	return TRUE

/turf/simulated/lava/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(locate(/obj/structure/lattice/catwalk, src))	//should be safe to walk upon
			return TRUE
		if(!istype(oldloc,/turf/simulated/lava))
			to_chat(L, SPAN_WARNING("You are covered by fire and heat from entering \the [src]!"))
		if(isanimal(L))
			var/mob/living/simple_animal/H = L
			if(H.flying) //flying mobs will ignore the lava
				return TRUE
			else
				L.bodytemperature = min(L.bodytemperature + 150, 1000)
		else
			var/target_zone
			if(L.lying)
				target_zone = pick(BP_ALL_LIMBS)
			else
				target_zone = pick(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG)

	//Try to apply the damage
			var/success = L.apply_damage(50, DAMAGE_BURN, target_zone, used_weapon = src, armor_pen = 50)
	//Apply weakness, so the victim doesn't walk into more lava
			L.Weaken(10)
			L.IgniteMob(3)

	//If successfully applied, give the message
			if(success)
				if(!ishuman(L))
					L.visible_message(SPAN_DANGER("[L] falls into \the [src]!"))
					return

				var/mob/living/carbon/human/human = L
				var/obj/item/organ/organ = human.get_organ(target_zone)

				if(isipc(L) || isrobot(L))
					playsound(src, 'sound/weapons/smash.ogg', 100, TRUE)
				else
					playsound(src, 'sound/effects/meatsizzle.ogg', 100, TRUE)

				human.visible_message(SPAN_DANGER("\The [human] slams into \the [src]!"),
										SPAN_WARNING(FONT_LARGE(SPAN_DANGER("You step on \the [src], feel instant pain, and the skin on your [organ.name] begins to burn away!"))),
										SPAN_WARNING("<b>You instant pain, and the skin on your [organ.name] begins to burn away!</b>"))
		return TRUE
	..()

/turf/simulated/lava/Exited(atom/movable/AM, atom/newloc)
	if(locate(/obj/structure/lattice/catwalk, src))	//should prevent people in lava from seeing messages about exiting lava
		return TRUE

	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(!istype(newloc, /turf/simulated/lava))
			to_chat(L, SPAN_WARNING("You climb out of \the [src]."))
	..()

/turf/simulated/lava/airless
	initial_gas = null

/turf/simulated/floor/exoplanet/basalt
	name = "basalt"
	icon = 'icons/turf/basalt.dmi'
	icon_state = "basalt"
	desc = "Dark volcanic rock."
	base_name = "basalt"
	base_desc = "Dark volcanic rock."
	base_icon = 'icons/turf/basalt.dmi'
	base_icon_state = "basalt"
	light_color = LIGHT_COLOR_LAVA
	smoothing_flags = SMOOTH_FALSE
	canSmoothWith = null
	openspace_override_type = /turf/simulated/open/chasm/airless

	footstep_sound = SFX_FOOTSTEP_ASTEROID

/turf/simulated/floor/exoplanet/basalt/airless
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/exoplanet/basalt/cave
	name = "dense basalt"

/turf/simulated/floor/exoplanet/basalt/cave/Initialize() // to make these tiles dark even on daytime exoplanets
	. = ..()
	set_light(0)
	footprint_color = null
	update_icon(1)

/turf/simulated/floor/exoplanet/basalt/crystal
	color = "#a9d8e0"

// Special asteroid variant that goes with lava better.
/turf/simulated/floor/exoplanet/asteroid/basalt
	name = "basalt"
	icon = 'icons/turf/basalt.dmi'
	icon_state = "basalt"
	desc = "Dark volcanic rock."
	base_name = "basalt"
	base_desc = "Dark volcanic rock."
	base_icon = 'icons/turf/basalt.dmi'
	base_icon_state = "basalt"
	light_color = LIGHT_COLOR_LAVA
	smoothing_flags = SMOOTH_FALSE
	canSmoothWith = null
	openspace_override_type = /turf/simulated/open/chasm/airless

	footstep_sound = SFX_FOOTSTEP_ASTEROID

/turf/simulated/floor/exoplanet/asteroid/basalt/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = icon
	underlay_appearance.icon_state = "basalt"
	if (prob(20))
		underlay_appearance.icon_state += "[rand(0,12)]"
	return TRUE

/turf/simulated/floor/exoplanet/asteroid/basalt/Initialize(mapload)
	if (prob(20))
		var/variant = rand(0,12)
		icon_state = "basalt[variant]"
		switch (variant)
			if (1, 2, 3)	// fair bit of lava visible, less weak light
				light_power = 0.75
				light_range = 2
			if (5, 9)	// Not much lava visible, weak light
				light_power = 0.5
				light_range = 2
	. = ..()

/turf/simulated/floor/exoplanet/asteroid/ReplaceWithLattice()
	ChangeTurf(baseturf)
	new /obj/structure/lattice(src)

/turf/simulated/floor/exoplanet/asteroid/basalt/air
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)

/turf/simulated/floor/exoplanet/asteroid/ash
	name = "ash"
	icon_state = "ash"
	desc = "A fine grey ash. Looks pretty tightly packed."
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	base_icon = 'icons/turf/smooth/ash.dmi'
	base_icon_state = "ash"
	footstep_sound = SFX_FOOTSTEP_SAND
	does_footprint = TRUE
	footprint_color = COLOR_ASH
	track_distance = 6

/turf/simulated/floor/exoplanet/asteroid/ash/Initialize()
	. = ..()
	if (prob(20))
		AddOverlays("asteroid[rand(0, 9)]", TRUE)

/turf/simulated/floor/exoplanet/asteroid/ash/rocky
	name = "rocky ash"
	icon_state = "rockyash"
	base_icon_state = "rockyash"
	base_icon = 'icons/turf/smooth/rocky_ash.dmi'
	desc = "A fine grey ash. Seems to contain medium-sized rocks."

