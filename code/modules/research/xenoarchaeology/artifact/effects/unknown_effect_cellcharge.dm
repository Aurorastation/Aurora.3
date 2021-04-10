
//todo
/datum/artifact_effect/cellcharge
	effecttype = "cellcharge"
	effect_type = 3
	var/last_message
	var/is_looping = FALSE

/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/living/user)
	var/obj/item/cell/C = user.get_cell()
	if(C)
		C.charge = min(C.maxcharge, C.charge + (rand(50, 150)))
		to_chat(user, SPAN_NOTICE("Diagnostics Alert: Large energy boost detected!"))
		return TRUE

#define SLEEP_AND_STOP \
if (TICK_CHECK) { \
	stoplag(); \
	if (QDELETED(src)) { \
		return 1; \
	} else { \
		T = get_turf(holder); \
	} \
}

/datum/artifact_effect/cellcharge/DoEffectAura()
	set background = 1

	if(holder)
		if (is_looping)
			return TRUE
		is_looping = TRUE

		var/turf/T = get_turf(holder)

		for (var/atom/P in range(effectrange, T))
			SLEEP_AND_STOP

			if (istype(P, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/apc = P
				if (apc.cell)
					apc.cell.charge += 25
			else if (istype(P, /obj/machinery/power/smes))
				var/obj/machinery/power/smes/smes = P
				smes.charge += 25
			else if(isliving(P))
				var/mob/living/M = P
				if (get_dist(T, M) <= effectrange)
					var/obj/item/cell/D = M.get_cell()
					if(D)
						D.charge = min(D.maxcharge, D.charge + 25)
						if(world.time - last_message > 200)
							to_chat(M, SPAN_NOTICE("Diagnostics Alert: Large energy boost detected!"))
							last_message = world.time

		is_looping = FALSE
		return TRUE

#undef SLEEP_AND_STOP

/datum/artifact_effect/cellcharge/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (effectrange,src))
			S.charge += 250
		for(var/mob/living/M in range(100, T))
			var/obj/item/cell/D = M.get_cell()
			if(D)
				D.charge = min(D.maxcharge, D.charge + rand(0, 100))
				if(world.time - last_message > 200)
					to_chat(M, SPAN_NOTICE("Diagnostics Alert: Energy boost detected!"))
					last_message = world.time
		return 1
