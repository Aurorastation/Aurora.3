/datum/technomancer/spell/lightning
	name = "Lightning Strike"
	desc = "This uses a hidden electrolaser, which creates a laser beam to ionize the enviroment, allowing for ideal conditions \
	for a directed lightning strike to occur.  The lightning is very strong, however it requires a few seconds to prepare a \
	strike.  Lightning functions cannot miss due to distance."
	cost = 150
	ability_icon_state = "tech_chain_lightning"
	obj_path = /obj/item/spell/projectile/lightning
	category = OFFENSIVE_SPELLS

/obj/item/spell/projectile/lightning
	name = "lightning strike"
	icon_state = "lightning_strike"
	desc = "Now you can feel like Zeus."
	cast_methods = CAST_RANGED
	aspect = ASPECT_SHOCK
	spell_projectile = /obj/item/projectile/beam/lightning
	energy_cost_per_shot = 2500
	instability_per_shot = 10
	cooldown = 20
	pre_shot_delay = 10
	fire_sound = 'sound/effects/psi/thunderstrike.ogg'

/obj/item/projectile/beam/lightning
	name = "lightning"
	icon_state = "lightning"
	damage = 25
	armor_penetration = 25
	damage_type = BURN

	muzzle_type = /obj/effect/projectile/muzzle/tesla
	tracer_type = /obj/effect/projectile/tracer/tesla
	impact_type = /obj/effect/projectile/impact/tesla

	var/power = 6000

/obj/item/projectile/beam/lightning/small
	name = "shock"
	damage = 15
	armor_penetration = 15

	power = 1000


/obj/item/projectile/beam/lightning/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	..()
	tesla_zap(target_mob, 3, power)
	return 1