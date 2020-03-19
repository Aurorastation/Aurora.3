/spell/targeted/heal_target/sacrifice
	name = "Sacrifice"
	desc = "This spell heals immensily. For a price."
	feedback = "SF"
	spell_flags = SELECTABLE
	invocation = "Ei'Nath Borv Di'Nath"
	charge_type = Sp_HOLDVAR
	holder_var_type = "bruteloss"
	holder_var_amount = 75
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)

	amt_dam_brute = -50
	amt_dam_fire = -50
	amt_dam_oxy = -50
	amt_dam_tox = -50

	hud_state = "gen_dissolve"

/spell/targeted/heal_target/sacrifice/empower_spell()
	if(!..())
		return 0

	holder_var_amount *= 2

	amt_dam_brute *= 2
	amt_dam_fire *= 2
	amt_dam_oxy *= 2
	amt_dam_tox *= 2

	return "You will now heal twice as much, but take twice as much damage. It will probably kill you."