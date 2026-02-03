/mob/living/simple_animal/construct/armored
	name = "Juggernaut"
	real_name = "Juggernaut"
	desc = "A possessed suit of armor driven by the will of the restless dead."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 350 // Slow, melee only and can't sprint. So needs to be a beefcake.
	health_prefix = "juggernaut"
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	armor_penetration = 40
	attacktext = "smashed their armored gauntlet into"
	organ_names = list("core", "right arm", "left arm")
	mob_size = MOB_LARGE
	speed = 3
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	natural_armor = list(
		MELEE = ARMOR_MELEE_VERY_HIGH, // Shouldnt crowbar these guys
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED
	)
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)

/mob/living/simple_animal/construct/armored/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if(istype(hitting_projectile, /obj/projectile/energy) || istype(hitting_projectile, /obj/projectile/beam))
		var/reflectchance = 80 - round(hitting_projectile.damage / 3)
		if(prob(reflectchance))
			adjustBruteLoss(hitting_projectile.damage * 0.3)
			visible_message(SPAN_DANGER("\The [hitting_projectile.name] gets reflected by \the [src]'s shell!"), \
							SPAN_DANGER("\The [hitting_projectile.name] gets reflected by \the [src]'s shell!"))

			// Find a turf near or on the original location to bounce to
			if(hitting_projectile.starting)
				var/new_x = hitting_projectile.starting.x + text2num(pickweight(list("0" = 1, "1" = 1, "2" = 3, "3" = 2))) * pick(1, -1)
				var/new_y = hitting_projectile.starting.y + text2num(pickweight(list("0" = 1, "1" = 1, "2" = 3, "3" = 2))) * pick(1, -1)

				// redirect the projectile
				hitting_projectile.firer = src
				hitting_projectile.old_style_target(locate(new_x, new_y, hitting_projectile.z))

			return BULLET_ACT_FORCE_PIERCE // complete projectile permutation
