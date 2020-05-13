/spell/targeted/heal_target/major
	name = "Cure Major Wounds"
	desc = "A spell used to fix others that cannot be fixed with regular medicine."
	feedback = "CM"
	charge_max = 300
	spell_flags = INCLUDEUSER | SELECTABLE | NEEDSCLOTHES
	invocation = "Borv Di'Nath"
	range = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 100
	hud_state = "heal_major"

	amt_dam_brute = -35
	amt_dam_fire  = -35

	message = "Your body feels like a furnace."

/spell/targeted/heal_target/major/empower_spell()
	if(!..())
		return 0
	amt_dam_tox = -20
	amt_dam_oxy = -20

	return "[src] now heals oxygen loss and toxic damage."