/obj/aura/personal_shield
	name = "personal shield"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield"

/obj/aura/personal_shield/handle_bullet_act(datum/source, obj/projectile/projectile)
	user.visible_message(SPAN_WARNING("\The [user]'s [src.name] flashes before \the [projectile] can hit them!"))

	flick("shield_impact", src)
	playsound(user, 'sound/effects/basscannon.ogg', 35, TRUE)

	return COMPONENT_BULLET_BLOCKED

/obj/aura/personal_shield/added_to(mob/living/L)
	..()
	playsound(user, 'sound/weapons/flash.ogg', 35, 1)
	to_chat(user, SPAN_NOTICE("You feel your body prickle as \the [src] comes online."))

/obj/aura/personal_shield/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	SHOULD_CALL_PARENT(FALSE) //Ancient coders deserve the rope

	user.visible_message(SPAN_WARNING("\The [user]'s [src.name] flashes before \the [hitting_projectile] can hit them!"))

	flick("shield_impact", src)
	playsound(user, 'sound/effects/basscannon.ogg', 35, TRUE)
	return AURA_FALSE|AURA_CANCEL

/obj/aura/personal_shield/removed()
	to_chat(user, SPAN_WARNING("\The [src] goes offline!"))
	playsound(user, 'sound/mecha/internaldmgalarm.ogg', 25, TRUE)
	..()

/obj/aura/personal_shield/device
	var/obj/item/device/personal_shield/shield

/obj/aura/personal_shield/device/bullet_act()
	. = ..()
	if(shield)
		shield.take_charge()

/obj/aura/personal_shield/device/proc/set_shield(var/user_shield)
	shield = user_shield

/obj/aura/personal_shield/device/Destroy()
	shield = null
	return ..()
