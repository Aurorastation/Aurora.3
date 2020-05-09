/spell/aoe_turf/conjure/carp
	name = "Summon Carp"
	desc = "This spell conjures a simple carp."
	feedback = "CA"
	school = "conjuration"
	charge_max = 1200
	spell_flags = NEEDSCLOTHES
	invocation = "NOUK FHUNMM SACP RISSKA"
	invocation_type = SpI_SHOUT
	range = 1
	cast_sound = 'sound/magic/Summon_Karp.ogg'
	summon_type = list(/mob/living/simple_animal/hostile/carp)

	hud_state = "wiz_carp"

/spell/aoe_turf/conjure/carp/empower_spell()
	if(!..())
		return 0

	summon_amt++

	return "You now summon [summon_amt] carps per spellcast."