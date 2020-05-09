/spell/aoe_turf/conjure/grove/gestalt
	name = "Convert Gestalt"
	desc = "Converts the surrounding area into a Dionaea gestalt."

	school = "conjuration"
	spell_flags = 0
	invocation_type = SpI_EMOTE
	invocation = "rumbles as green alien plants grow quickly along the floor."

	charge_type = Sp_HOLDVAR

	spell_flags = Z2NOCAST | IGNOREPREV | IGNOREDENSE
	summon_type = list(/turf/simulated/floor/diona)
	seed_type = /datum/seed/diona

	hud_state = "wiz_diona"