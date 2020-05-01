/spell/aoe_turf/conjure/mirage
	name = "Summon Mirage"
	desc = "This spell summons a harmless carp mirage for a few seconds."
	feedback = "MR"
	school = "illusion"
	charge_max = 1200
	spell_flags = NEEDSCLOTHES
	invocation = "NOUK FHUNNM SACP RISSKA"
	invocation_type = SpI_SHOUT
	range = 1

	duration = 600
	cooldown_min = 600
	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 2, Sp_POWER = 3)
	cast_sound = 'sound/magic/Summon_Karp.ogg'
	summon_type = list(/mob/living/simple_animal/hostile/carp)

	hud_state = "wiz_carp"

	newVars = list("melee_damage_lower" = 0, "melee_damage_upper" = 0, "break_stuff_probability" = 0)

/spell/aoe_turf/conjure/mirage/empower_spell()
	if(!..())
		return 0

	summon_amt++

	return "You now summon [summon_amt] mirages per spellcast."