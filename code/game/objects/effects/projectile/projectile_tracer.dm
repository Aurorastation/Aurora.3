/proc/generate_tracer_between_points(datum/point/starting, datum/point/ending, beam_type, color, qdel_in = 5)		//Do not pass z-crossing points as that will not be properly (and likely will never be properly until it's absolutely needed) supported!
	if(!istype(starting) || !istype(ending) || !ispath(beam_type))
		return
	if(starting.z != ending.z)
		crash_with("Projectile tracer generation of cross-Z beam detected. This feature is not supported!")			//Do it anyways though.
	var/datum/point/midpoint = point_midpoint_points(starting, ending)
	var/obj/effect/projectile/tracer/PB = new beam_type
	PB.apply_vars(angle_between_points(starting, ending), midpoint.return_px(), midpoint.return_py(), color, pixel_length_between_points(starting, ending) / world.icon_size, midpoint.return_turf(), 0)
	. = PB
	if(qdel_in)
		QDEL_IN(PB, qdel_in)

/obj/effect/projectile/tracer
	name = "beam"
	icon = 'icons/effects/projectiles/tracer.dmi'

/obj/effect/projectile/tracer/laser
	name = "laser"
	icon_state = "beam"

/obj/effect/projectile/tracer/laser/blue
	icon_state = "beam_blue"

/obj/effect/projectile/tracer/disabler
	name = "disabler"
	icon_state = "beam_omni"

/obj/effect/projectile/tracer/xray
	name = "xray laser"
	icon_state = "xray"

/obj/effect/projectile/tracer/pulse
	name = "pulse laser"
	icon_state = "u_laser"

/obj/effect/projectile/tracer/plasma_cutter
	name = "plasma blast"
	icon_state = "plasmacutter"

/obj/effect/projectile/tracer/stun
	name = "stun beam"
	icon_state = "stun"

/obj/effect/projectile/tracer/heavy_laser
	name = "heavy laser"
	icon_state = "beam_heavy"

/obj/effect/projectile/tracer/cult/heavy
	name = "heavy arcane beam"
	icon_state = "hcult"

/obj/effect/projectile/tracer/cult
	name = "arcane beam"
	icon_state = "cult"

/obj/effect/projectile/tracer/solar
	name = "solar energy"
	icon_state = "solar"

/obj/effect/projectile/tracer/eyelaser
	icon_state = "eye"

/obj/effect/projectile/tracer/emitter
	icon_state = "emitter"
