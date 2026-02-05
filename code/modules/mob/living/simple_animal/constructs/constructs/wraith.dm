/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 250
	health_prefix = "wraith"
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	organ_names = list("core", "right arm", "left arm")
	speed = -1
	environment_smash = TRUE
	natural_armor = list(
		MELEE = ARMOR_MELEE_KEVLAR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED
	)
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift)

	flying = TRUE
