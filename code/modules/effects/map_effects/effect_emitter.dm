// Creates effects like smoke clouds every so often.
/obj/effect/map_effect/interval/effect_emitter
	var/datum/effect/effect/system/effect_system = null
	var/effect_system_type = null // Which effect system to attach.

	var/effect_amount = 10				// How many effect objects to create on each interval.  Note that there's a hard cap on certain effect_systems.
	var/effect_cardinals_only = FALSE	// If true, effects only move in GLOB.cardinal directions.
	var/effect_forced_dir = null		// If set, effects emitted will always move in this direction.

/obj/effect/map_effect/interval/effect_emitter/Initialize()
	effect_system = new effect_system_type()
	effect_system.attach(src)
	configure_effects()
	return ..()

/obj/effect/map_effect/interval/effect_emitter/interval/Destroy()
	QDEL_NULL(effect_system)
	return ..()

/obj/effect/map_effect/interval/effect_emitter/proc/configure_effects()
	effect_system.set_up(effect_amount, effect_cardinals_only, src.loc, effect_forced_dir)

/obj/effect/map_effect/interval/effect_emitter/trigger()
	configure_effects() // We do this every interval in case it changes.
	effect_system.start()
	..()

// Creates smoke clouds every so often.
/obj/effect/map_effect/interval/effect_emitter/smoke
	name = "smoke emitter"
	icon_state = "smoke_emitter"
	effect_system_type = /datum/effect/effect/system/smoke_spread

	interval_lower_bound = 1 SECOND
	interval_upper_bound = 1 SECOND
	effect_amount = 2

/obj/effect/map_effect/interval/effect_emitter/smoke/bad
	name = "bad smoke emitter"
	effect_system_type = /datum/effect/effect/system/smoke_spread/bad

// Makes sparks.
/obj/effect/map_effect/interval/effect_emitter/sparks
	name = "spark emitter"
	icon_state = "spark_emitter"
	effect_system_type = /datum/effect_system/sparks

	interval_lower_bound = 3 SECONDS
	interval_upper_bound = 7 SECONDS

/obj/effect/map_effect/interval/effect_emitter/sparks/frequent
	effect_amount = 4			// Otherwise it caps out fast.
	interval_lower_bound = 1
	interval_upper_bound = 3 SECONDS
