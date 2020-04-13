/spell/targeted/shapeshift/baleful_polymorph
	name = "Baleful Polymorth"
	desc = "This spell transforms its target into a small, furry animal. Those practiced in the high arcane arts can block this spell with ease, however."
	feedback = "BP"
	possible_transformations = list(/mob/living/simple_animal/lizard,/mob/living/simple_animal/rat,/mob/living/simple_animal/corgi, /mob/living/simple_animal/cat)

	share_damage = 0
	invocation = "Yo'balada!"
	invocation_type = SpI_SHOUT
	spell_flags = NEEDSCLOTHES | SELECTABLE
	range = 3
	duration = 150 //15 seconds.
	cooldown_min = 300 //30 seconds

	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 2)

	newVars = list("health" = 50, "maxHealth" = 50)

	protected_roles = list("Wizard")

	hud_state = "wiz_poly"


/spell/targeted/shapeshift/baleful_polymorph/empower_spell()
	if(!..())
		return 0

	duration += 50

	return "Your target will now stay in their polymorphed form for [duration/10] seconds."