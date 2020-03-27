/spell/targeted/shapeshift/avian
	name = "Polymorph"
	desc = "This spell transforms the wizard into the common parrot."
	feedback = "AV"
	possible_transformations = list(/mob/living/simple_animal/parrot)

	invocation = "Poli'crakata!"
	invocation_type = SpI_SHOUT
	drop_items = 0
	share_damage = 0
	spell_flags = INCLUDEUSER
	range = -1
	duration = 150
	charge_max = 600
	cooldown_min = 300
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 0)
	hud_state = "wiz_parrot"

	newVars = list("maxHealth" = 50, "health" = 50)