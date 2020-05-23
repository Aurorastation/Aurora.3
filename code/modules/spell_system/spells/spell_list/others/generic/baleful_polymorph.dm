/spell/targeted/shapeshift/baleful_polymorph
	name = "Baleful Polymorth"
	desc = "This spell transforms its target into a mindless creature temporarily. There is a possibility that the creature may be dangerous to the caster, however. Those practiced in the high arcane arts can block this spell with ease, however."
	feedback = "BP"
	normal_transformations = list(/mob/living/simple_animal/lizard/wizard, /mob/living/simple_animal/crab/wizard, /mob/living/simple_animal/rat/wizard, /mob/living/simple_animal/corgi, /mob/living/simple_animal/chicken/wizard, /mob/living/simple_animal/cat/wizard)
	big_transformations = list(, /mob/living/simple_animal/hostile/giant_spider/wizard, /mob/living/simple_animal/hostile/carp/wizard)

	share_damage = 0
	invocation = "Yo'balada!"
	invocation_type = SpI_SHOUT
	spell_flags = NEEDSCLOTHES | SELECTABLE
	range = 3
	duration = 600 
	cooldown_min = 300 

	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 2, Sp_POWER = 4)

	newVars = list("health" = 150, "maxHealth" = 150)

	protected_roles = list("Wizard")

	hud_state = "wiz_poly"

/spell/targeted/shapeshift/baleful_polymorph/empower_spell()
	if(!..())
		return 0

	duration += 300

	return "Your target will now stay in their polymorphed form for [duration/10] seconds."