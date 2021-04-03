/datum/technomancer/spell/lightning
	name = "Lightning Strike"
	desc = "This uses a hidden electrolaser, which creates a laser beam to ionize the enviroment, allowing for ideal conditions \
	for a directed lightning strike to occur.  The lightning is very strong, however it requires a few seconds to prepare a \
	strike.  Lightning functions cannot miss due to distance."
	cost = 150
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
	fire_sound = 'sound/weapons/gaussrifle1.ogg'

/obj/item/projectile/beam/lightning
	name = "lightning"
	icon_state = "lightning"
	nodamage = 1
	damage_type = PAIN

	muzzle_type = /obj/effect/projectile/muzzle/tesla
	tracer_type = /obj/effect/projectile/tracer/tesla
	impact_type = /obj/effect/projectile/impact/tesla

	var/power = 60				//How hard it will hit for with electrocute_act().

/obj/item/projectile/beam/lightning/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_CHEST))
		H.electrocute_act(power, src, H.get_siemens_coefficient_organ(affected), BP_CHEST, 0)
	else
		target_mob.electrocute_act(power, src, 0.75, BP_CHEST)
	return 1