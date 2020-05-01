/spell/aoe_turf/conjure/forge
	name = "Create Daemon Forge"
	desc = "This spell creates a Daemon Forge, which allows followers of the occult to forge better weaponry."

	charge_max = 6000
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/forge)

	hud_state = "const_forge"
	override_base = "const"