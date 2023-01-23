/spell/aoe_turf/conjure/floor
	name = "Create Floor"
	desc = "This spell constructs a cult floor."

	charge_max = 20
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/floor/cult)

	hud_state = "const_floor"

/spell/aoe_turf/conjure/floor/conjure_animation(var/atom/movable/overlay/animation, var/turf/target)
	animation.icon_state = "cultfloor"
	flick("cultfloor", animation)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, animation), 10)