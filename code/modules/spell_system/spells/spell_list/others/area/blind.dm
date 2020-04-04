/spell/targeted/genetic/blind
	name = "Blind"
	desc = "This spell inflicts a target with temporary blindness."
	feedback = "BD"
	disabilities = 1
	duration = 300
	cast_sound = 'sound/magic/Blind.ogg'

	charge_max = 300

	spell_flags = 0
	invocation = "STI KALY"
	invocation_type = SpI_WHISPER
	message = "<span class='danger'>Your eyes cry out in pain!</span>"
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 1, Sp_POWER = 3)
	cooldown_min = 50

	range = 7
	max_targets = 0

	amt_eye_blind = 10
	amt_eye_blurry = 20

	hud_state = "wiz_blind"

/spell/targeted/genetic/blind/empower_spell()
	if(!..())
		return 0
	duration += 100

	return "[src] will now blind for a longer period of time."