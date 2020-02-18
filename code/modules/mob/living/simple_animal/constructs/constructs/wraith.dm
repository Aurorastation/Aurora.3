/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 100
	health_prefix = "wraith"
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	speed = -1
	environment_smash = TRUE
	see_in_dark = 7
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift)

	flying = TRUE
