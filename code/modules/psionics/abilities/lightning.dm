/singleton/psionic_power/lightning
	name = "Lightning"
	desc = "Fire a concentrated lightning bolt. Activate this spell in hand to switch to a second mode that hits living beings in a 4x3 area in front of you."
	icon_state = "tech_instabilitytapold"
	point_cost = 0
	ability_flags = PSI_FLAG_APEX
	minimum_rank = PSI_RANK_APEX
	spell_path = /obj/item/spell/projectile/psi_lightning

/obj/item/spell/projectile/psi_lightning
	name = "lightning"
	icon_state = "chain_lightning"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_PSIONIC
	spell_projectile = /obj/item/projectile/beam/psi_lightning
	fire_sound = 'sound/magic/LightningShock.ogg'
	cooldown = 10
	psi_cost = 15
	var/mode = 0

/obj/item/spell/projectile/psi_lightning/on_use_cast(mob/user, bypass_psi_check)
	. = ..(user, TRUE)
	mode = !mode
	if(mode)
		to_chat(user, SPAN_NOTICE("You will now fire area-of-effect lightning in a 4x3 area in front of you."))
		spell_projectile = /obj/item/projectile/beam/psi_lightning/wide

	else
		to_chat(user, SPAN_NOTICE("You will now fire a normal lightning bolt."))
		spell_projectile = /obj/item/projectile/beam/psi_lightning

/obj/item/projectile/beam/psi_lightning
	name = "psionic lightning"
	damage = 30
	armor_penetration = 30
	damage_type = DAMAGE_BURN
	pass_flags = PASSTABLE | PASSGRILLE | PASSRAILING
	range = 40
	accuracy = 100

	muzzle_type = /obj/effect/projectile/muzzle/tesla
	tracer_type = /obj/effect/projectile/tracer/tesla
	impact_type = /obj/effect/projectile/impact/tesla


/obj/item/projectile/beam/psi_lightning/pellet
	damage = 20
	armor_penetration = 20

/obj/item/projectile/beam/psi_lightning/wide
	damage = 20
	armor_penetration = 20

/obj/item/projectile/beam/psi_lightning/wide/Initialize()
	. = ..()
	for(var/i = 1 to 4)
		var/turf/new_turf = get_random_turf_in_range(get_turf(firer), i + rand(0, i), 0, TRUE, FALSE)
		var/obj/item/projectile/beam/psi_lightning/pellet/pellet = new type(new_turf)
		var/turf/front_turf = get_step(pellet, pellet.dir)
		INVOKE_ASYNC(pellet, TYPE_PROC_REF(/obj/item/projectile/beam/psi_lightning/pellet, launch_projectile), front_turf)
