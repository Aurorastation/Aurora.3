/spell/targeted/projectile/dumbfire/fireball
	name = "Fireball"
	desc = "This spell fires a fireball at a target and does not require wizard garb."

	proj_type = /obj/item/projectile/spell_projectile/fireball

	school = "evocation"
	charge_max = 100
	spell_flags = 0
	invocation = "ONI SOMA"
	invocation_type = SpI_SHOUT
	range = 20
	cooldown_min = 20 //10 deciseconds reduction per rank
	cast_sound = 'sound/magic/Fireball.ogg'

	spell_flags = 0

	duration = 20
	proj_step_delay = 1

	amt_dam_brute = 20
	amt_dam_fire = 35

	hud_state = "wiz_fireball"

/spell/targeted/projectile/dumbfire/fireball/prox_cast(var/list/targets, spell_holder)
	for(var/mob/living/M in targets)
		apply_spell_damage(M)
		M.IgniteMob(2)
	var/explosion_ogg = pick('sound/effects/Explosion1.ogg', 'sound/effects/Explosion2.ogg')
	playsound(get_turf(spell_holder), explosion_ogg, 75, TRUE, 3)
	var/datum/effect/system/explosion/E = new /datum/effect/system/explosion()
	E.set_up(get_turf(spell_holder))
	E.start()

//PROJECTILE

/obj/item/projectile/spell_projectile/fireball
	name = "fireball"
	icon_state = "fireball"