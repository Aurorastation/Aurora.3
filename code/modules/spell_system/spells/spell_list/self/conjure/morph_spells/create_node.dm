/spell/aoe_turf/conjure/node
	name = "Create Node"
	desc = "This spell creates a node beneath you."

	charge_max = 1800
	spell_flags = Z2NOCAST
	override_base = "const"
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/obj/structure/gore/tendrils/node)
	cast_sound = 'sound/effects/attackblob.ogg'

	hud_state = "tendril_node"
