/spell/targeted/heal_target/area
	name = "Cure Area"
	desc = "This spell heals everyone in an area."
	feedback = "HA"
	charge_max = 600
	spell_flags = INCLUDEUSER
	invocation = "Nal Di'Nath"
	range = 2
	max_targets = 0
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 300
	hud_state = "heal_area"

	amt_dam_brute = -10
	amt_dam_fire = -10

/spell/targeted/heal_target/area/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 5
	amt_dam_fire -= 5
	range += 2

	return "[src] now heals more in a wider area."