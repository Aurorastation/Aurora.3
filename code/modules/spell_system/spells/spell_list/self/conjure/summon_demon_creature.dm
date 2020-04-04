/spell/aoe_turf/conjure/creature
	name = "Summon Creature Swarm"
	desc = "This spell tears the fabric of reality, allowing horrific daemons to spill forth."
	cast_sound = 'sound/magic/Summon_Karp.ogg'
	school = "conjuration"
	charge_max = 1200
	spell_flags = 0
	invocation = "IA IA"
	invocation_type = SpI_SHOUT
	summon_amt = 10
	range = 3

	summon_type = list(/mob/living/simple_animal/hostile/creature)

	hud_state = "wiz_creature"