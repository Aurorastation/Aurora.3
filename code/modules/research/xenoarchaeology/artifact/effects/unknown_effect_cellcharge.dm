
//todo
/datum/artifact_effect/cellcharge
	effecttype = "cellcharge"
	effect_type = 3
	var/last_message

/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
				D.charge += rand() * 100 + 50
				R << "<span class='notice'>SYSTEM ALERT: Large energy boost detected!</span>"
			return 1

/datum/artifact_effect/cellcharge/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
				B.charge += 25
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 25
		for (var/mob/living/silicon/robot/M in range(50, T))
				D.charge += 25
				if(world.time - last_message > 200)
					M << "<span class='notice'>SYSTEM ALERT: Energy boost detected!</span>"
					last_message = world.time
		return 1

/datum/artifact_effect/cellcharge/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(200, T))
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 250
		for (var/mob/living/silicon/robot/M in range(100, T))
				D.charge += rand() * 100
				if(world.time - last_message > 200)
					M << "<span class='notice'>SYSTEM ALERT: Energy boost detected!</span>"
					last_message = world.time
		return 1
