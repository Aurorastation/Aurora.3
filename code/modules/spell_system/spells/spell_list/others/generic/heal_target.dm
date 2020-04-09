/spell/targeted/heal_target
	name = "Cure Light Wounds"
	desc = "A rudimentary spell used mainly by wizards to heal papercuts."
	feedback = "CL"
	school = "cleric"
	charge_max = 200
	spell_flags = INCLUDEUSER | SELECTABLE
	invocation = "Di'Nath"
	invocation_type = SpI_SHOUT
	range = 2
	max_targets = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 2)
	cast_sound = 'sound/magic/Staff_Healing.ogg'

	cooldown_reduc = 50
	hud_state = "heal_minor"

	amt_dam_brute = -15
	amt_dam_fire = -15

	message = "You feel a pleasant rush of heat move through your body."

/spell/targeted/heal_target/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 5
	amt_dam_fire -= 5

	return "[src] will now heal more."