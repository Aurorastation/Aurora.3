/obj/projectile/spell_projectile
	name = "spell"
	icon = 'icons/obj/projectiles.dmi'

	damage = 0

	var/spell/targeted/projectile/carried

	penetrating = 0
	range = 10 //set by the duration of the spell

	var/proj_trail = 0 //if it leaves a trail
	var/proj_trail_lifespan = 0 //deciseconds
	var/proj_trail_icon = 'icons/obj/wizard.dmi'
	var/proj_trail_icon_state = "trail"
	var/list/trails = new()

/obj/projectile/spell_projectile/Destroy()
	for(var/trail in trails)
		qdel(trail)
	carried = null
	return ..()

/obj/projectile/spell_projectile/ex_act(var/severity = 2.0)
	return

// /obj/projectile/spell_projectile/before_move()
// 	if(proj_trail && src && src.loc) //pretty trails
// 		var/obj/effect/overlay/trail = new /obj/effect/overlay(src.loc)
// 		trails += trail
// 		trail.icon = proj_trail_icon
// 		trail.icon_state = proj_trail_icon_state
// 		trail.density = 0
// 		addtimer(CALLBACK(src, PROC_REF(post_trail), trail), proj_trail_lifespan)

/obj/projectile/spell_projectile/proc/post_trail(obj/effect/overlay/trail)
	trails -= trail
	qdel(trail)

/obj/projectile/spell_projectile/proc/prox_cast(var/list/targets)
	if(loc)
		carried.prox_cast(targets, src)
		qdel(src)
	return

/obj/projectile/spell_projectile/Collide(atom/A)
	if(loc && carried)
		prox_cast(carried.choose_prox_targets(user = carried.holder, spell_holder = src))
	return 1

/obj/projectile/spell_projectile/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(loc && carried)
		prox_cast(carried.choose_prox_targets(user = carried.holder, spell_holder = src))
	return 1

/obj/projectile/spell_projectile/seeking
	name = "seeking spell"
