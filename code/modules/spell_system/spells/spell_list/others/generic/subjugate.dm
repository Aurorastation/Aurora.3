/spell/targeted/subjugation
	name = "Mind Blast"
	desc = "This spell blasts a target's mind with distruptive forces, severely disorienting them. It does not require wizard garb."

	school = "transmutation"
	charge_max = 250
	spell_flags = 0
	invocation = "DII ODA BAJI"
	invocation_type = SpI_WHISPER
	message = "<span class='danger'>You feel your mind burn, and your limbs feel unsteady as your vision wobbles severely.</span>"

	max_targets = 1

	amt_dizziness = 150
	amt_confused = 100

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "wiz_subj"