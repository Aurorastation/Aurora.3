/spell/aoe_turf/conjure/forcewall
	name = "Forcewall"
	desc = "Create a wall of pure energy at your location."
	feedback = "FW"
	summon_type = list(/obj/effect/forcefield)
	duration = 300
	charge_max = 100
	spell_flags = 0
	range = 0
	cast_sound = 'sound/magic/ForceWall.ogg'

	hud_state = "wiz_shield"

/obj/effect/forcefield
	desc = "A strange wall that seems almost magical."
	name = "forcewall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield"
	anchored = 1.0
	opacity = 0
	density = 1
	unacidable = 1

/obj/effect/forcefield/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	var/turf/T = get_turf(src.loc)
	if(T)
		for(var/mob/M in T)
			hitting_projectile.on_hit(M,M.bullet_act(hitting_projectile, def_zone))

/obj/effect/forcefield/attackby(obj/item/attacking_item, mob/user)
	..()
	if(istype(attacking_item, /obj/item/nullrod))
		to_chat(user, SPAN_NOTICE("\the [src] dissipates at the touch of the \the [attacking_item]."))
		qdel(src)

/obj/effect/forcefield/cultify()
	new /obj/effect/forcefield/cult(get_turf(src))
	qdel(src)
	return
