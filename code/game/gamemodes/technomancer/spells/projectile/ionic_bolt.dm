/datum/technomancer/spell/ionic_bolt
	name = "Ionic Bolt"
	desc = "Shoots a bolt of ion energy at the target.  If it hits something, it will generally drain energy, corrupt electronics, \
	or otherwise ruin complex machinery."
	cost = 50
	obj_path = /obj/item/spell/projectile/ionic_bolt
	category = OFFENSIVE_SPELLS

/obj/item/spell/projectile/ionic_bolt
	name = "ionic bolt"
	icon_state = "ionic bolt"
	desc = "For those pesky security units."
	cast_methods = CAST_RANGED
	aspect = ASPECT_EMP
	spell_projectile = /obj/item/projectile/ion
	energy_cost_per_shot = 500
	instability_per_shot = 6
	cooldown = 10
	pre_shot_delay = 0
	fire_sound = 'sound/effects/supermatter.ogg'