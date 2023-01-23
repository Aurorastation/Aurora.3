/datum/effect_system/ion_trail
	var/turf/old_location
	var/fade_icon = "ion_fade"
	var/ion_trails_type = /obj/effect/effect/ion_trails

/datum/effect_system/ion_trail/New(atom/source_atom)
	if (source_atom)
		bind(source_atom)

	..(FALSE)

/datum/effect_system/ion_trail/process()
	. = ..()
	if (!location)
		return

	. = EFFECT_CONTINUE

	if (old_location != location)
		if (location.is_hole)	// openspace or space.
			var/obj/effect/effect/ion_trails/I = new ion_trails_type(old_location)
			if (holder)
				I.set_dir(holder.dir)
			if(fade_icon)
				flick(fade_icon, I)
				I.icon_state = "blank"
			animate(I, alpha = 0, time = 18, easing = SINE_EASING | EASE_IN)
			QDEL_IN(I, 20)

		old_location = location

/datum/effect_system/ion_trail/proc/start()
	QUEUE_EFFECT(src)

/datum/effect_system/ion_trail/proc/stop()
	STOP_EFFECT(src)
	old_location = null

/datum/effect_system/ion_trail/Destroy()
	old_location = null
	return ..()

/datum/effect_system/ion_trail/explosion
	fade_icon = null
	ion_trails_type = /obj/effect/effect/ion_trails/explosion

/obj/effect/effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = TRUE

/obj/effect/effect/ion_trails/explosion
	name = "combustion trails"
	icon_state = "explosion_particle"