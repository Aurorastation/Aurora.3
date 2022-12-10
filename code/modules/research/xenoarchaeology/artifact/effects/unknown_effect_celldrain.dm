
//todo
/datum/artifact_effect/celldrain
	effecttype = "celldrain"
	effect_type = 3
	var/last_message

/datum/artifact_effect/celldrain/DoEffectTouch(var/mob/user)
	var/obj/item/cell/C = user.get_cell()
	if(C)
		C.charge = max(C.charge - rand(25, 100), 0)
		to_chat(user, SPAN_NOTICE("Diagnostics alert: Energy drain detected!"))
		return TRUE

/datum/artifact_effect/celldrain/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(40, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge = max(B.charge - 50,0)
		for (var/obj/machinery/power/smes/S in range(effectrange,src))
			S.charge = max(S.charge - 100,0)
		for(var/mob/living/M in range(20, T))
			var/obj/item/cell/D = M.get_cell()
			if(D)
				D.charge = max(D.charge - 50,0)
				if(world.time - last_message > 200)
					to_chat(M, SPAN_NOTICE("Diagnostics alert: Energy drain detected!"))
					last_message = world.time
		return TRUE

/datum/artifact_effect/celldrain/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/obj/machinery/power/apc/C in range(40, T))
			for (var/obj/item/cell/B in C.contents)
				B.charge = max(B.charge - rand() * 150,0)
		for (var/obj/machinery/power/smes/S in range(effectrange,src))
			S.charge = max(S.charge - 250,0)
		for (var/mob/living/M in range(30, T))
			var/obj/item/cell/D = M.get_cell()
			if(D)
				D.charge = max(D.charge - rand() * 150,0)
				if(world.time - last_message > 200)
					to_chat(M, SPAN_NOTICE("Diagnostics alert: Energy drain detected!"))
					last_message = world.time
		return TRUE
