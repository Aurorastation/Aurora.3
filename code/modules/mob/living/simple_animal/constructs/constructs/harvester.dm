/mob/living/simple_animal/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	desc = "The promised reward of those who follow Nar'Sie, obtained by offering their bodies to the Geometer of Blood."
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 150
	health_prefix = "harvester"
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "violently stabbed"
	speed = -1
	environment_smash = 1
	see_in_dark = 7
	attack_sound = 'sound/weapons/pierce.ogg'
	can_repair = TRUE
	construct_spells = list(
			/spell/aoe_turf/cultify_area,
			/spell/targeted/harvest,
			/spell/aoe_turf/knock/harvester,
			/spell/rune_write,
			/spell/aoe_turf/conjure/construct/lesser,
			/spell/aoe_turf/conjure/wall,
			/spell/aoe_turf/conjure/floor,
			/spell/aoe_turf/conjure/soulstone,
			/spell/aoe_turf/conjure/altar,
			/spell/aoe_turf/conjure/forge,
			/spell/aoe_turf/conjure/pylon,
			/spell/aoe_turf/conjure/forcewall/lesser
		)
	//Harvesters are endgame stuff, no harm giving them construct spells

	flying = TRUE
