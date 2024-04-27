/spell/aoe_turf/conjure/nest
	name = "Create Nest"
	desc = "This spell creates a nest beneath you."

	charge_max = 600
	spell_flags = Z2NOCAST
	override_base = "const"
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/obj/structure/bed/nest)
	cast_sound = 'sound/effects/attackblob.ogg'

	hud_state = "nest"
