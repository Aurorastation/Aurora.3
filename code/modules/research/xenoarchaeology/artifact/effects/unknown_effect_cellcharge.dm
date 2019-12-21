
//todo
/datum/artifact_effect/cellcharge
	effecttype = "cellcharge"
	effect_type = 3
	var/last_message
	var/is_looping = FALSE

/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				to_chat(R, "<span class='notice'>SYSTEM ALERT: Large energy boost detected!</span>")
			return 1

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
			return 1
		is_looping = TRUE

		var/turf/T = get_turf(holder)

		for (var/P in range(src.effectrange, T))
			SLEEP_AND_STOP

			if (istype(P, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/apc = P
				if (apc.cell)
					apc.cell.charge += 25
			else if (istype(P, /obj/machinery/power/smes))
				var/obj/machinery/power/smes/smes = P
				smes.charge += 25
			else if (isrobot(P))
				var/mob/living/silicon/robot/M = P
				if (get_dist(T, M) <= effectrange)
					if (M.cell)
						M.cell.charge += 25
						if(world.time - last_message > 200)
							to_chat(M, "<span class='notice'>SYSTEM ALERT: Energy boost detected!</span>")
							last_message = world.time

		is_looping = FALSE
		return 1

#undef SLEEP_AND_STOP

/datum/artifact_effect/cellcharge/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 250
		for (var/mob/living/silicon/robot/M in range(100, T))
			for (var/obj/item/cell/D in M.contents)
				D.charge += rand() * 100
				if(world.time - last_message > 200)
					to_chat(M, "<span class='notice'>SYSTEM ALERT: Energy boost detected!</span>")
					last_message = world.time
		return 1
