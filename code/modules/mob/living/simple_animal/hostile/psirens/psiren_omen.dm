/**
 * Psiren "Omen", a ranged support-caster type enemy.
 * Their attacks deal almost no physical damage at all, but very high psychic damage.
 * Relatively squishy for a medium enemy, they can react exactly once per being shot with a cloud of violet smoke.
 */
/mob/living/simple_animal/hostile/psiren/omen
	name = "psiren omen"
	icon_state = "psiren_omen"
	icon_living = "psiren_omen"
	icon_dead = "psiren_omen_dead"
	health = 120
	maxhealth = 120
	ranged = TRUE
	projectilesound = 'sound/weapons/wave.ogg'
	projectiletype = /obj/projectile/bullet/pistol/psiren/omen
	var/has_ink = TRUE

/mob/living/simple_animal/hostile/psiren/omen/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if (. == BULLET_ACT_BLOCK || !has_ink)
		return

	var/datum/effect/effect/system/smoke_spread/psiren/S = new/datum/effect/effect/system/smoke_spread/psiren()
	S.set_up(5, 0, loc, null)
	S.start()
	has_ink = FALSE
