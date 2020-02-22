/mob/living/simple_animal/construct/armoured
	name = "Juggernaut"
	real_name = "Juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 400
	health_prefix = "juggernaut"
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "smashed their armoured gauntlet into"
	mob_size = MOB_LARGE
	speed = 3
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)

/mob/living/simple_animal/construct/armoured/bullet_act(var/obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflectchance = 80 - round(P.damage / 3)
		if(prob(reflectchance))
			adjustBruteLoss(P.damage * 0.3)
			visible_message(SPAN_DANGER("\The [P.name] gets reflected by \the [src]'s shell!"), \
							SPAN_DANGER("\The [P.name] gets reflected by \the [src]'s shell!"))

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + text2num(pickweight(list("0" = 1, "1" = 1, "2" = 3, "3" = 2))) * pick(1, -1)
				var/new_y = P.starting.y + text2num(pickweight(list("0" = 1, "1" = 1, "2" = 3, "3" = 2))) * pick(1, -1)

				// redirect the projectile
				P.firer = src
				P.old_style_target(locate(new_x, new_y, P.z))

			return -1 // complete projectile permutation

	return (..(P))
