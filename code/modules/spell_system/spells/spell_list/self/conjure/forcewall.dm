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

/obj/effect/forcefield/bullet_act(var/obj/item/projectile/Proj, var/def_zone)
	var/turf/T = get_turf(src.loc)
	if(T)
		for(var/mob/M in T)
			Proj.on_hit(M,M.bullet_act(Proj, def_zone))
	return

/obj/effect/forcefield/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/nullrod))
		to_chat(user, "<span class='notice'>\the [src] dissipates at the touch of the \the [I].</span>")
		qdel(src)

/obj/effect/forcefield/cultify()
	new /obj/effect/forcefield/cult(get_turf(src))
	qdel(src)
	return
