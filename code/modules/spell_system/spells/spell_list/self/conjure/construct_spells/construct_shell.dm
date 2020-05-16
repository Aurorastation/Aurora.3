/spell/aoe_turf/conjure/construct
	name = "Create Empty Shell"
	desc = "This spell conjures a construct which may be controlled by Shades"

	school = "conjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/constructshell)

	hud_state = "artificer"

/spell/aoe_turf/conjure/construct/lesser
	charge_max = 1800
	summon_type = list(/obj/structure/constructshell/cult)
	hud_state = "const_shell"
	override_base = "const"