/spell/targeted/genetic/mutate
	name = "Mutate"
	desc = "This spell causes you to turn into a hulk and gain laser vision for a short while."
	feedback = "MU"
	school = "transmutation"
	charge_max = 400
	spell_flags = Z2NOCAST | NEEDSCLOTHES | INCLUDEUSER
	invocation = "BIRUZ BENNAR"
	invocation_type = SpI_SHOUT
	message = "<span class='notice'>You feel strong! You feel a pressure building behind your eyes!</span>"
	range = 0
	max_targets = 1
	cast_sound = 'sound/magic/Mutate.ogg'

	mutations = list(LASER_EYES, HULK)
	duration = 300

	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 0)
	cooldown_min = 300

	hud_state = "wiz_hulk"