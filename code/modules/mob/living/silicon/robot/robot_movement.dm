/mob/living/silicon/robot/slip_chance(var/prob_slip)
	if(module?.no_slip)
		return FALSE
	..(prob_slip)

/mob/living/silicon/robot/Allow_Spacemove()
	if(module)
		for(var/obj/item/tank/jetpack/J in module.modules)
			if(J?.allow_thrust(0.01, src))
				return TRUE
	. = ..()

// NEW: Different power usage depending on whether driving or jetpacking. space movement is easier
/mob/living/silicon/robot/SelfMove(turf/n, direct)
	if(istype(n, /turf/space))
		if(cell_use_power(jetpackComponent.active_usage))
			return ..()

	if(!is_component_functioning("actuator"))
		return FALSE

	if(cell_use_power(actuatorComponent.active_usage))
		return ..()

/mob/living/silicon/robot/Move()
	. = ..()

	if(module)
		if(module.type == /obj/item/robot_module/janitor)
			var/obj/item/robot_module/janitor/J = module
			var/turf/tile = get_turf(src)
			if(isturf(tile) && J.mopping)
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/S = tile
					S.dirt = FALSE
					S.color = null
				for(var/A in tile)
					if(istype(A, /obj/effect))
						if(istype(A, /obj/effect/decal/cleanable))
							qdel(A)
						if(istype(A, /obj/effect/overlay))
							var/obj/effect/overlay/O = A
							if(O.no_clean)
								continue
							qdel(O)
					else if(istype(A, /obj/item))
						var/obj/item/cleaned_item = A
						cleaned_item.clean_blood()
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							to_chat(cleaned_human, SPAN_WARNING("\The [src] runs its bottom mounted bristles all over you!"))

	if(client)
		var/turf/T = get_turf(src)
		var/turf/B = GET_TURF_ABOVE(T)
		if(up_hint)
			up_hint.icon_state = "uphint[(B ? !!B.is_hole : 0)]"

/mob/living/silicon/robot/movement_delay()
	. = speed
	. += get_pulling_movement_delay()

/mob/living/silicon/robot/get_pulling_movement_delay()
	. = ..()

	if(ishuman(pulling))
		var/mob/living/carbon/human/H = pulling
		if(H.species.slowdown > speed)
			. += H.species.slowdown - speed
		. += H.ClothesSlowdown()
