/mob/living/simple_animal/construct/builder
	name = "Artificer"
	real_name = "Artificer"
	desc = "A bulbous construct dedicated to building and maintaining The Cult of Nar-Sie's armies."
	icon = 'icons/mob/mob.dmi'
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 50
	health_prefix = "artificer"
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "rammed"
	speed = 0
	environment_smash = TRUE
	attack_sound = 'sound/weapons/rapidslice.ogg'
	can_repair = TRUE
	construct_spells = list(/spell/aoe_turf/cultify_area,
							/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon,
							/spell/aoe_turf/conjure/forge,
							/spell/aoe_turf/conjure/altar
							)
