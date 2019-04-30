/mob/living/simple_animal/hostile/geist
	name = "cavern geist"
	desc = "A monstrous creature that haunts the caverns of Adhomai."
	icon = 'icons/adhomai/geist.dmi'
	icon_state = "geist"
	icon_living = "geist"
	icon_dead = "geist_dead"
	pixel_x = -16

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	tameable = FALSE

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 400
	health = 400
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	mob_size = 25
	environment_smash = 2
	attacktext = "mauled"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	faction = "Geist"