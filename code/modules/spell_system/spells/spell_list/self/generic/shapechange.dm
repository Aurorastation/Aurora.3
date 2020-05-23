/spell/targeted/shapeshift/shapechange
	name = "Shapechange"
	desc = "This spell transforms the wizard into an animal."
	feedback = "AV"

	invocation = "Animalio!"
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