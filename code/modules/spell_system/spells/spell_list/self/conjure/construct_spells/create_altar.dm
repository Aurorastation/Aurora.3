/spell/aoe_turf/conjure/altar
	name = "Create Altar"
	desc = "This spell creates a Altar, which allows followers of the occult to pray and heal from injury."

	charge_max = 6000
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/talisman)

	hud_state = "const_altar"
	override_base = "const"