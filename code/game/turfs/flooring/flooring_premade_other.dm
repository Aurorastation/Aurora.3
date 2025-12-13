
/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	desc = "Liquid rock; it can melt flesh from bone in seconds."

/turf/simulated/floor/airless/lava/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(locate(/obj/structure/lattice/catwalk, src))	//should be safe to walk upon
			return TRUE
		if(!istype(oldloc,/turf/simulated/floor/airless/lava))
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

/turf/simulated/floor/airless/lava/Exited(atom/movable/AM, atom/newloc)
	if(locate(/obj/structure/lattice/catwalk, src))	//should prevent people in lava from seeing messages about exiting lava
		return TRUE

	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(!istype(newloc, /turf/simulated/floor/airless/lava))
			to_chat(L, SPAN_WARNING("You climb out of \the [src]."))
	..()

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/airless/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"
	does_footprint = FALSE
	footprint_color = COLOR_SNOW
	footstep_sound = /singleton/sound_category/snow_footstep

/turf/simulated/floor/snow/Initialize()
	. = ..()
	icon_state = "snow[rand(0,2)]"

/turf/simulated/floor/snow/cold
	temperature = T0C - 10

/turf/simulated/floor/snow/extreme_cold
	temperature = TCMB

/turf/simulated/floor/plating/snow
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snowplating"
	footstep_sound = /singleton/sound_category/snow_footstep

/turf/simulated/floor/vaurca
	name = "alien floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "vaurca"

/turf/simulated/floor/foamedmetal
	name = "foamed metal"
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"

/turf/simulated/floor/foamedmetal/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(user))
		ChangeTurf(/turf/space)
		to_chat(user, SPAN_NOTICE("You clear away the metal foam."))

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /singleton/flooring/grass
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/grass/no_edge
	has_edge_icon = FALSE

/turf/simulated/floor/diona
	name = "biomass flooring"
	icon = 'icons/turf/flooring/diona.dmi'
	icon_state = "diona0"
	footstep_sound = /singleton/sound_category/grass_footstep
	initial_flooring = /singleton/flooring/diona

/turf/simulated/floor/diona/airless
	initial_gas = null
	temperature = TCMB
